// Timer Interrupt handler
#include <string.h>
#include "include/timer.h"
// #include "include/defs.h"
#include "include/param.h"
#include "include/printf.h"
#include "include/proc.h"
#include "include/signal.h"
// #include "include/sbi.h"
#include "include/spinlock.h"
#include "include/loongarch.h"
#include "loongarchregs.h"
// #include "include/syscall.h"
#include "include/types.h"

#include "include/vm.h"
// 
extern struct proc proc[NPROC];

struct spinlock tickslock;
uint ticks;
// 定时器池
timer timers[NTIMERS];
int hastimer = 0;

void timerinit() {
  initlock(&tickslock, "time");
  memset(timers, 0, sizeof(timers));
  ticks = 0;
  hastimer = 0;
#ifdef DEBUG
  printf("timerinit\n");
#endif
}

// void set_next_timeout() {
//   // There is a very strange bug,
//   // if comment the `printf` line below
//   // the timer will not work.

//   // this bug seems to disappear automatically
//   // printf("");
//   sbi_set_timer(r_time() + INTERVAL);
// }

void countdown_timer_init(){
  #ifdef DEBUG
  printf("countdown_timer_init\n");
  #endif
  uint64 prcfg1_val;
  // 定时器有效位
  // prcfg1_val = r_csr_tcfg();
  prcfg1_val = r_csr_prcfg1();
  uint64 timerbits = FIELD_GET(prcfg1_val,PRCFG1_TIMERBITS_LEN,PRCFG1_TIMERBITS_SHIFT) + 1;
  if (timerbits <= 0 || timerbits >=64)
    panic("countdown_timer_init: timerbits is invalid");

  uint64 tcfg_val = FIELD_WRITE(1,TCFG_EN_LEN,TCFG_EN_SHIFT) | FIELD_WRITE(1,TCFG_RERIODIC_LEN,TCFG_RERIODIC_SHIFT) | FIELD_WRITE(INTERVAL,TCFG_INITVAL_LEN(timerbits),TCFG_INITVAL_SHIFT);
  // enable countdown_timer
  w_csr_tcfg(tcfg_val);
}


void timer_tick() {
  acquire(&tickslock);
  ticks++;
  #ifdef  DEBUG
  printf("timer_tick():tick++, now tick is %d\n\n",ticks);
  #endif
  wakeup(&ticks);
  release(&tickslock);

  // printf("ticks:%d\n",ticks);
  if (hastimer) {
    // printf("begin timer\n");
    for (int i = 0; i < NTIMERS; i++) {
      if (timers[i].pid == 0)
        continue;
      if (ticks - timers[i].ticks >= 80) {
        // printf("timer pid %d\n",timers[i].pid);
        kill(timers[i].pid, SIGALRM);
        timers[i].pid = 0;
        hastimer = 0;
      }
    }
  }
}

// 进程的时间统计信息
uint64 sys_times() {
  struct tms ptms;
  uint64 utms;
  argaddr(0, &utms);
  ptms.tms_utime = myproc()->utime;
  ptms.tms_stime = myproc()->ktime;
  ptms.tms_cstime = 1;
  ptms.tms_cutime = 1;
  struct proc *p;
  for (p = proc; p < proc + NPROC; p++) {
    acquire(&p->lock);
    if (p->parent == myproc()) {
      ptms.tms_cutime += p->utime;
      ptms.tms_cstime += p->ktime;
    }
    release(&p->lock);
  }
  copyout(myproc()->pagetable, utms, (char *)&ptms, sizeof(ptms));
  return 0;
}

uint64 setitimer(int which, const struct itimerval *value,
                 struct itimerval *ovalue) {
  int pid = myproc()->pid;
  struct timer *timer = NULL;
  for (int i = 0; i < NTIMERS; i++) {
    if (timers[i].pid == pid && timers[i].which == which) {
      timer = &timers[i];
      break;
    }
  }

  if (ovalue != NULL && timer != NULL) {
    copyout(myproc()->pagetable, (uint64)ovalue, (char *)&((timer->itimer)),
            sizeof(struct itimerval));    //may be bug since are all in kernel space
  }

  if (value != NULL) {
    if (value->it_value.tv_sec == 0 && value->it_value.tv_usec == 0 &&
        value->it_interval.tv_sec == 0 && value->it_interval.tv_usec == 0) {
      return 0;
    }
    if (timer == NULL) {
      for (int i = 0; i < NTIMERS; i++) {
        if (timers[i].pid == 0) {
          #ifdef DEBUG
          printf("set timer pid %d\n", pid);
          #endif
          timer = &timers[i];
          timer->pid = pid;
          timer->which = which;
          timer->ticks = ticks;
          break;
        }
      }
    } else {
      timer->itimer = *value;
      timer->which = which;
      timer->ticks = ticks;
      timer->pid = pid;
    }
    hastimer = 1;
  }
  return 0;
}

struct timeval get_timeval() {
  uint64 time = r_time();
  return (struct timeval){
      .tv_sec = time / (CLK_FREQ),
      .tv_usec = time / (CLK_FREQ / 1000),
  };
}