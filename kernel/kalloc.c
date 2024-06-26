// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "include/kalloc.h"
#include "include/memlayout.h"
#include "include/param.h"
#include "include/printf.h"
#include "include/loongarch.h"
#include "include/spinlock.h"
#include "include/string.h"
#include "include/types.h"

#ifndef DEBUG
#define DEBUG 1
#endif

void freerange(void *pa_start, void *pa_end);

extern char kernel_end[]; // first address after kernel.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;

  uint64 npage;
} kmem;

void kinit() {
  initlock(&kmem.lock, "kmem");
  kmem.freelist = 0;
  kmem.npage = 0;
  // RAMSTOP : 物理内存的上界
  // PHYSTOP->RAMSTOP, 内核使用物理内存的上界
  #if DEBUG
  printf("kernel_end: %p, RAMSTOP: %p\n", kernel_end, (void *)RAMSTOP);
  #endif
  freerange(kernel_end, (void *)RAMSTOP);
  printf("kernel_end: %p, RAMSTOP: %p\n", kernel_end, (void *)RAMSTOP);
//   debug_print("kinit\n");
}

void freerange(void *pa_start, void *pa_end) {

  #if DEBUG
  printf("freerange: pa_start: %p, pa_end: %p\n", pa_start, pa_end);
  #endif

  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; 
// see kinit above.)

void kfree(void *pa) {

  #if 0
  printf("kfree: pa: %p\n", pa);
  #endif

  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < kernel_end ||
      (uint64)pa >= RAMSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run *)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  kmem.npage++;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if (r) {
    // 自由链表块数量减少
    kmem.freelist = r->next;
    // 可用页数减少
    kmem.npage--;
  }
  release(&kmem.lock);

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
  else {
    printf("kalloc out of memory\n");
  }
  return (void *)r;
}
// 获取系统内可用的内存数量
uint64 freemem_amount(void) {
  uint64 amount = 0;
  // 内核内存锁
  acquire(&kmem.lock);
  amount = kmem.npage;
  release(&kmem.lock);
  // 将页转换为字节数
  // PGSHIFT = 12, size for mem = 4k
  return amount << PGSHIFT;
}
