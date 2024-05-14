#ifndef __MEMLAYOUT_H
#define __MEMLAYOUT_H
// Physical memory layout

// 0x00200000 -- bios loads kernel here and jumps here
// 0x10000000 -- 
// 0x1c000000 -- reset address
// 0x1fe00000 -- I/O interrupt base address
// 0x1fe20000 -- uart16550 serial port
// 0x90000000 -- RAM used by user pages

// 低48位掩码
// #define DMWIN_MASK 0x9000000000000000
#define DMWIN_MASK 0x9 << 60
// 地址转换模式 by wty
#define MAKE_DMWIN(pagetable) (DMWIN | (((uint64)pagetable) >> 12))

// 2k1000 puts UART registers here in virtual memory.
#define UART0 (0x1fe20000UL | DMWIN_MASK)
#define UART0_IRQ 2

// 7段寄存器
/* ============== LS7A registers =============== */
#define LS7A_PCH_REG_BASE		(0x10000000UL | DMWIN_MASK)

#define LS7A_INT_MASK_REG		LS7A_PCH_REG_BASE + 0x020
#define LS7A_INT_EDGE_REG		LS7A_PCH_REG_BASE + 0x060
#define LS7A_INT_CLEAR_REG		LS7A_PCH_REG_BASE + 0x080
#define LS7A_INT_HTMSI_VEC_REG		LS7A_PCH_REG_BASE + 0x200
#define LS7A_INT_STATUS_REG		LS7A_PCH_REG_BASE + 0x3a0
#define LS7A_INT_POL_REG		LS7A_PCH_REG_BASE + 0x3e0

// the kernel expects there to be RAM
// for use by user pages
// from physical address 0x90000000 to PHYSTOP.
#define RAMBASE (0x90000000UL | DMWIN_MASK)
#define RAMSTOP (RAMBASE + 128*1024*1024)

// map kernel stacks beneath the trampframe,
// each surrounded by invalid guard pages.

#define KSTACK(p) (TRAPFRAME - ((p)+1)* 2*PGSIZE)
// STACKSZIE by wty
// 此处的VKSTACK 切换为MMIO地址
// from AVX
#define VKSTACK                 0x3EC0000000L //0x3E_C000_0000
#define KSTACKSIZE              6 * PGSIZE
#define EXTRASIZE               2 * PGSIZE
#define PROCVKSTACK(paddrnum)        (VKSTACK - ((((paddrnum) + 1) % NPROC) * (KSTACKSIZE + EXTRASIZE)) + EXTRASIZE)

// User memory layout.
// Address zero first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
//   ...
//   invalid guard page
//   KSRACK (used for kernel thread)
//   TRAPFRAME (p->trapframe, used by the uservec)
//   如果要trampoline的情况，应该是在trapframe上面一页的大小（xv6）

#define TRAMPOLINE (MAXVA - PGSIZE)
#define TRAPFRAME (TRAMPOLINE - PGSIZE)

// 1<< 32
// added by wty
#define MAXUVA                  0x80000000L
#define USER_STACK_BOTTOM (MAXUVA - (2*PGSIZE))
// 用户栈的起始终止范围
#define USER_MMAP_START (USER_STACK_BOTTOM - 0x10000000)
//注意，上面的user_stack_bottom定义不管他，目前用下面这个
#define USER_STACK_TOP MAXUVA - PGSIZE
#define USER_STACK_DOWN USER_MMAP_START + PGSIZE

#endif