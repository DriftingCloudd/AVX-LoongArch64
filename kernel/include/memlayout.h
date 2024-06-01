#ifndef __MEMLAYOUT_H
#define __MEMLAYOUT_H
// Physical memory layout
// qemu -machine virt is set up like this,
// based on qemu's hw/riscv/virt.c:
//
// 00001000 -- boot ROM, provided by qemu
// 02000000 -- CLINT
// 0C000000 -- PLIC
// 10000000 -- uart0 
// 10001000 -- virtio disk 
// 80000000 -- boot ROM jumps here in machine mode
//             -kernel loads the kernel here
// unused RAM after 80000000.

// Virtual Memory Layout
// 0 - 2^48-1
// 9000(0） —— 9000(2^48-1）

// Physical Memory Layout
// 80000000 —— 2^48 -1

#ifdef QEMU
// virtio mmio interface
#define VIRTIO0                 0x10001000
#define VIRTIO0_V               (VIRTIO0  | DMWIN1_MASK)
#endif



// 低48位掩码
#define DMWIN_MASK 0x9000000000000000
#define DMWIN1_MASK 0x8000000000000000
// #define DMWIN_MASK 0x9 << 0x60
// by llh
// #define DMWIN_MASK ((__uint128_t)0x9 << 0x60)
// 地址转换模式 by wty
#define MAKE_DMWIN(pagetable) (DMWIN | (((uint64)pagetable) >> 12))

// 2k1000 puts UART registers here in virtual memory.
#define UART0 (0x1fe20000UL | DMWIN1_MASK)
#define UART0_IRQ 2
#define KEYBOARD_IRQ 3
#define MOUSE_IRQ 4

#define INTISR0 0x800000001fe01420
#define INTEN0  0x800000001fe01424
#define INTENSET0 0x800000001fe01428
#define INTENCLR0 0x800000001fe0142c
#define ENTRY0 0x800000001fe01400

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

#define TRAMPOLINE (MAXVA - PGSIZE)     // 3FFF FFFF F000 
#define TRAPFRAME (TRAMPOLINE - PGSIZE)   // 3FFF FFFF E000
#define SIGTRAMPOLINE (TRAPFRAME - PGSIZE)      // 3FFF FFFF D000

// map kernel stacks beneath the trampframe,
// each surrounded by invalid guard pages.

// STACKSZIE by wty
// 此处的VKSTACK 切换为MMIO地址
// from AVX
#define VKSTACK                 SIGTRAMPOLINE -PGSIZE// 3FFF FFFF C000
#define KSTACKSIZE              6 * PGSIZE
#define EXTRASIZE               2 * PGSIZE
#define PROCVKSTACK(paddrnum)        (VKSTACK - ((((paddrnum) + 1) % (NPROC + 1)) * (KSTACKSIZE + EXTRASIZE)) + EXTRASIZE)



// 1<< 32
// added by wty
#define MAXUVA                  0x80000000L
#define USER_MMAP_START (MAXUVA - 0x10000000 -(2 * PGSIZE))
// #define USER_STACK_BOTTOM (MAXUVA - (2*PGSIZE))
// 用户栈的起始终止范围
//注意，上面的user_stack_bottom定义不管他，目前用下面这个
#define USER_STACK_TOP MAXUVA - PGSIZE
#define USER_STACK_DOWN USER_MMAP_START + PGSIZE


#endif