// Copyright (c) 2006-2019 Frans Kaashoek, Robert Morris, Russ Cox,
//                         Massachusetts Institute of Technology

#include "loongarch.h"
#include "loongarchregs.h"
/* #include "include/buf.h"
#include "include/console.h"
#include "include/disk.h"
#include "include/kalloc.h"
#include "include/memlayout.h"
#include "include/param.h"
#include "include/plic.h"
#include "include/printf.h"
#include "include/proc.h"
#include "include/riscv.h"
#include "include/sbi.h"
#include "include/socket.h"
#include "include/sysinfo.h"
#include "include/thread.h"
#include "include/timer.h"
#include "include/trap.h"
#include "include/types.h"
#include "include/vm.h"
#ifndef QEMU
#include "include/sd_final.h"
#include "include/uart8250.h"
extern void _start(void);
#endif
*/
extern void _entry(void);


volatile static int started = 0;
// static int first = 0;
extern void boot_stack(void);
extern void boot_stack_top(void);
// extern void initlogbuffer(void);
// extern int tcp_start_listen;
void main(unsigned long hartid, unsigned long dtb_pa) {
  if (r_tp() == 0) {
  //  tcp_start_listen = 0;
  //  first = 1;
    cpuinit();
    consoleinit();
    printfinit(); // init a lock for printf
    kinit();        // physical page allocator
    // kvminit();      // create kernel page table
    // kvminithart();  // turn on paging
    // timerinit();    // init a lock for timer
    // trapinithart(); // install kernel trap vector, including interrupt handler
    // threadInit();
    // procinit();
    // plicinit();
    // plicinithart();
    // // sd_test();
    // disk_init();
    // // init_socket();
    // binit(); // buffer cache
    // initlogbuffer();
    // fileinit(); // file table
    // userinit(); // first user process
    // tcpip_init_with_loopback();
    // debug_print("hart %d init done\n", hartid);


    // __sync_synchronize();
    // started = 1;
    while (1);
    
  } else {
    // other hart
    while (started == 0)
      ;
    // __sync_synchronize();
    // kvminithart();
    // trapinithart();
    // plicinithart(); // ask PLIC for device interrupts
    // debug_print("hart 1 init done\n");
    // printf("hart 2\n");
    // while (1) {
    //   int c = uart8250_getc();
    //   if (-1 != c) {
    //     // uart8250_putc(c);
    //     consoleintr(c);
    //   }
    // }
  }
  // scheduler();
}
