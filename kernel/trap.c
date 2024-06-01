#include "include/trap.h"
#include "include/console.h"
#include "include/disk.h"
#include "include/memlayout.h"
#include "include/param.h"
// #include "include/plic.h"
#include "include/printf.h"
#include "include/proc.h"
#include "include/loongarch.h"
// #include "include/sbi.h"
#include "include/spinlock.h"
#include "include/syscall.h"
#include "include/timer.h"
#include "include/types.h"
#include "include/uart.h"
#include "include/vm.h"
#include "include/vma.h"
#include "include/extioi.h"
#include "include/apic.h"

// struct spinlock tickslock;
// uint ticks;

extern char trampoline[], uservec[]; 
void userret(uint64, uint64);

// in kernelvec.S, calls kerneltrap().
void kernelvec();
// void uservec();
void handle_tlbr();
void handle_merr();
// void userret(uint64, uint64);

extern int devintr();

void
trapinit(void)
{
  initlock(&tickslock, "time");

  // printf("estat & efcg: %p %p\n", r_csr_estat(), r_csr_ecfg());
  // uart_intr_init();
  // printf("estat & efcg: %p %p\n", r_csr_estat(), r_csr_ecfg());

  uint32 ecfg = ( 0U << CSR_ECFG_VS_SHIFT ) | HWI_VEC | TI_VEC;
  // uint64 tcfg = 0x1000000UL | CSR_TCFG_EN | CSR_TCFG_PER;
  w_csr_ecfg(ecfg);
  // w_csr_tcfg(tcfg);
  w_csr_eentry((uint64)kernelvec);
  // TLB重填exception
  w_csr_tlbrentry((uint64)handle_tlbr);
  // 机器exception
  w_csr_merrentry((uint64)handle_merr);
  // 倒计时定时器开始倒计时
  countdown_timer_init();
  intr_on();
  // printf("estat & efcg: %p %p\n", r_csr_estat(), r_csr_ecfg());
}

//
// handle an interrupt, exception, or system call from user space.
// called from uservec.S
//
void
usertrap(void)
{
  int which_dev = 0;

  if((r_csr_prmd() & PRMD_PPLV) == 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_csr_eentry((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->era = r_csr_era();

  #ifdef DEBUG
  printf("usertrap():handling exception\n");
  uint32 info = r_csr_crmd();
  printf ("usertrap(): crmd=%x\n", info);
  info = r_csr_prmd();
  printf ("usertrap(): prmd=%x\n", info);
  info = r_csr_estat();
  printf ("usertrap(): estat=%x\n", info);
  info = r_csr_era();
  printf ("usertrap(): era=%x\n", info);
  info = r_csr_ecfg();
  printf ("usertrap(): ecfg=%x\n", info);
  info = r_csr_badi();
  printf ("usertrap(): badi=%x\n", info);
  info = r_csr_badv();
  printf ("usertrap(): badv=%x\n\n", info);
  #endif
  
  if( ((r_csr_estat() & CSR_ESTAT_ECODE) >> 16) == 0xb){
    // 系统调用例外
    
    if(p->killed)
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->era += 4;

    // an interrupt will change crmd & prmd registers,
    // so don't enable until done with those registers.
    intr_on();
    #ifdef DEBUG
    printf("usertrap():handling syscall\n");
    #endif
    syscall();
  }else if(((r_csr_estat() & CSR_ESTAT_ECODE) >> 16 == 0x1 || (r_csr_estat() & CSR_ESTAT_ECODE) >> 16 == 0x2)
  && handle_stack_page_fault(myproc(), r_csr_badv()) == 0 ){
    // load page fault or store page fault
    // check if the page fault is caused by stack growth
    printf("usertrap():handle stack page fault\n");
    // panic("usertrap():handle stack page fault\n");
  } 
  else if((which_dev = devintr()) != 0){
    // ok
  } else {
    uint64 ir = 0;
    copyin(myproc()->pagetable, (char *)&ir, r_csr_era(), 8);
    printf("usertrap(): unexpected trapcause %x pid=%d\n", r_csr_estat(), p->pid);
    printf("            era=%p badi=%x\n", r_csr_era(), r_csr_badi());
    trapframedump(p->trapframe);
    p->killed = 1;
  }

  if(p->killed)
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2){
    yield();
    // uartintr();
    p->utime++;
  }
    

  usertrapret();
}

//
// return to user space
//
void
usertrapret(void)
{
  #ifdef DEBUG
  printf("usertrapret(): user trap returning.\n\n");
  #endif
  struct proc *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec.S
  w_csr_eentry((uint64)uservec);  //maybe todo

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_pgdl = r_csr_pgdl();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + KSTACKSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

  // set up the registers that uservec.S's ertn will use
  // to get to user space.
  
  // set Previous Privilege mode to User Privilege3.
  uint32 x = r_csr_prmd();
  x |= PRMD_PPLV; // set PPLV to 3 for user mode
  x |= PRMD_PIE; // enable interrupts in user mode
  w_csr_prmd(x);

  // set S Exception Program Counter to the saved user pc.
  
  #ifdef DEBUG
  printf("usertrapret(): era=%p\n", p->trapframe->era);
  #endif
  w_csr_era(p->trapframe->era);

  // tell uservec.S the user page table to switch to.
  volatile uint64 pgdl = (uint64)(p->pagetable);
  #ifdef DEBUG
  printf("usertrapret(): pgdl=%p\n", pgdl);
  #endif
  

  // jump to uservec.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with ertn.
  // uint64 fn = TRAMPOLINE + (userret - trampoline);
  // ((void (*)(uint64, uint64))fn)(TRAPFRAME, pgdl);
  userret(TRAPFRAME, pgdl);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
  #ifdef NDEBUG
  printf("kerneltrap():handling exception\n");
  uint32 info = r_csr_crmd();
  printf ("kerneltrap(): crmd=%x\n", info);
  info = r_csr_prmd();
  printf ("kerneltrap(): prmd=%x\n", info);
  info = r_csr_estat();
  printf ("kerneltrap(): estat=%x\n", info);
  info = r_csr_era();
  printf ("kerneltrap(): era=%x\n", info);
  info = r_csr_ecfg();
  printf ("kerneltrap(): ecfg=%x\n", info);
  info = r_csr_badi();
  printf ("kerneltrap(): badi=%x\n", info);
  info = r_csr_badv();
  printf ("kerneltrap(): badv=%x\n\n", info);
  #endif

  int which_dev = 0;
  // ERA寄存器：异常程序计数器，记录异常发生时的指令地址。
  uint64 era = r_csr_era();
  // PRMD寄存器：记录异常发生时的特权级别、中断使能、写使能。
  uint64 prmd = r_csr_prmd();
  
  if((prmd & PRMD_PPLV) != 0)
    panic("kerneltrap: not from privilege0");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    printf("estat %x\n", r_csr_estat());
    printf("era=%p eentry=%p\n", r_csr_era(), r_csr_eentry());
    panic("kerneltrap");
  }
  // printf ("which_dev=%d\n", which_dev);

  if (which_dev == 2 && myproc() != 0) {
    myproc()->ktime++;
  }
  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    yield();

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's instruction.
  w_csr_era(era);
  w_csr_prmd(prmd);
}

void 
machine_trap()
{
  panic("machine error");
}

void
clockintr()
{
  acquire(&tickslock);
  ticks++;
  wakeup(&ticks);
  release(&tickslock);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
  uint32 estat = r_csr_estat();
  uint32 ecfg = r_csr_ecfg();

  // printf("devintr():estat=%x, ecfg=%x\n", estat, ecfg);

  
  //CSR.ESTAT.IS & CSR.ECFG.LIE -> int_vec(13bits stand for irq type)
  if(estat & ecfg & HWI_VEC) {
    // this is a hardware interrupt, via IOCR.

    if(estat & ecfg & (1UL << UART0_IRQ)){
      uartintr();

    // tell the apic the device is
    // now allowed to interrupt again.


      // extioi_complete(1UL << UART0_IRQ);
    } else if(ecfg & estat){
       printf("unexpected interrupt estate %x, ecfg %x \n", estat, ecfg);   
    
      // apic_complete(irq); 
      // extioi_complete(irq);  
    }
    
    return 1;
  } else if(estat & ecfg & TI_VEC){
    //timer interrupt,

    if(cpuid() == 0){
      clockintr();
      uartintr();
      // timer_tick();
    }
    
    // acknowledge the timer interrupt by clearing
    // the TI bit in TICLR.
    w_csr_ticlr(r_csr_ticlr() | CSR_TICLR_CLR);

    return 2;
  } else {
    return 0;
  }
}

void trapframedump(struct trapframe *tf) {
  printf("a0: %p\t", tf->a0);
  printf("a1: %p\t", tf->a1);
  printf("a2: %p\t", tf->a2);
  printf("a3: %p\n", tf->a3);
  printf("a4: %p\t", tf->a4);
  printf("a5: %p\t", tf->a5);
  printf("a6: %p\t", tf->a6);
  printf("a7: %p\n", tf->a7);
  printf("t0: %p\t", tf->t0);
  printf("t1: %p\t", tf->t1);
  printf("t2: %p\t", tf->t2);
  printf("t3: %p\n", tf->t3);
  printf("t4: %p\t", tf->t4);
  printf("t5: %p\t", tf->t5);
  printf("t6: %p\t", tf->t6);
  printf("t7: %p\n", tf->t7);
  printf("t8: %p\t", tf->t8);
  printf("s0: %p\n", tf->s0);
  printf("s1: %p\t", tf->s1);
  printf("s2: %p\t", tf->s2);
  printf("s3: %p\t", tf->s3);
  printf("s4: %p\n", tf->s4);
  printf("s5: %p\t", tf->s5);
  printf("s6: %p\t", tf->s6);
  printf("s7: %p\t", tf->s7);
  printf("s8: %p\n", tf->s8);
  printf("ra: %p\n", tf->ra);
  printf("sp: %p\t", tf->sp);
  printf("tp: %p\t", tf->tp);
  printf("fp: %p\n", tf->fp);
  printf("r21: %p\n", tf->r21);
  printf("era: %p\n", tf->era);
}