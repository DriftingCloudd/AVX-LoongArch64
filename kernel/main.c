// Copyright (c) 2006-2019 Frans Kaashoek, Robert Morris, Russ Cox,
//                         Massachusetts Institute of Technology

#include "include/loongarch.h"
#include "include/loongarchregs.h"
#include "include/buf.h"
#include "include/file.h"
#include "include/console.h"
#include "include/disk.h"
#include "include/kalloc.h"
#include "include/memlayout.h"
#include "include/param.h"
#include "include/printf.h"
#include "include/proc.h"
#include "include/apic.h"
#include "include/extioi.h"
// #include "include/sbi.h"
// #include "include/socket.h"
#include "include/sysinfo.h"
// #include "include/thread.h"
#include "include/timer.h"
#include "include/trap.h"
#include "include/types.h"
#include "include/vm.h"
// #ifndef QEMU
// #include "include/sd_final.h"
// #include "include/uart16500.h"
#include "include/uart.h"
// extern void _start(void);
// #endif
extern void _entry(void);


volatile static int started = 0;
// static int first = 0;
// extern void boot_stack(void);
// extern void boot_stack_top(void);
// extern void initlogbuffer(void);
// extern int tcp_start_listen;
void main() {
  if (r_tp() == 0) {
    int cpuid = r_tp();
//    tcp_start_listen = 0;
//    first = 1;
    cpuinit();
    consoleinit();
    printfinit(); // init a lock for printf

    // #ifdef DEBUG
    // printf("DEBUG:hart %d enter main()...\n", cpuid);
    // #endif
    printf("DEBUG:hart %d enter main()...\n", cpuid);

    // 内存映射 //
    kinit();        // physical page allocator
    kvminit();      // create kernel page table
    kvminithart();  // turn on paging
    // 
    timerinit();    // init a lock for timer
    trapinit(); // install kernel trap vector, including interrupt handler
    // threadInit();
    procinit();

    // apic_init();     // set up LS7A1000 interrupt controller
    // printf("apicinit\n");
    // extioi_init();   // extended I/O interrupt controller
    // plicinit();
    // plicinithart();
    // // sd_test();
    disk_init();
    // // init_socket();
    binit(); // buffer cache
    // initlogbuffer();
    fileinit(); // file table
    userinit(); // first user process
    // tcpip_init_with_loopback();
    printf("cpu %d init done\n", cpuid);


    __sync_synchronize();
    started = 1;
    
  } else {
    // other hart
    while (started == 0)
      ;
    __sync_synchronize();
    // kvminithart();
    // trapinit();
    // plicinithart(); // ask PLIC for device interrupts
    // debug_print("hart 1 init done\n");
    // printf("cpu 2\n");
    // while (1) {
    //   int c = uartgetc();
    //   if (-1 != c) {
    //     // uart8250_putc(c);
    //     consoleintr(c);
    //   }
    // }
  }
  scheduler();
}
