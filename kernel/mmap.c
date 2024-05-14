#include "include/mmap.h"
#include "include/kalloc.h"
#include "include/memlayout.h"
#include "include/printf.h"
#include "include/proc.h"
#include "include/loongarch.h"
#include "include/string.h"
#include "include/types.h"
#include "include/vm.h"
#include "include/vma.h"

// 通过访问内存来读取设备或文件
uint64 mmap(uint64 start, uint64 len, int prot, int flags, int fd,
            long int offset) {
  struct proc *p = myproc();
  if (offset < 0) {
    return -1;
  }
  int perm = PTE_PLV | PTE_MAT | PTE_D | PTE_NR | PTE_W | PTE_NX;

  if (prot & PROT_READ)
    //LA64  架构下，0表示可读
    perm &= ~PTE_NR;
  if (prot & PROT_WRITE)
    // 1 表示可写
    perm |= PTE_W;
    // 表示可以执行
  if (prot & PROT_EXEC){
    perm |= PTE_MAT | PTE_P;
    perm &= ~PTE_NX;
  }
    
    
  struct file *f = fd == -1 ? NULL : p->ofile[fd];
  if (fd != -1 && f == NULL)
    return -1;
  struct vma *vma = alloc_mmap_vma(p, flags, start, len, perm, fd, offset);
  if (!(flags & MAP_FIXED))
    start = vma->addr;
  if (NULL == vma) {
    return -1;
  }
  uint64 mmap_size = 0;
  if (-1 != fd) {
    // fat32: todo
    // mmap_size = f->ep->file_size - offset;
    // if (len < mmap_size)
    //   mmap_size = len;
    f->off = offset;
  } else {
    return start;
  }
  uint64 end_pagespace = mmap_size % PGSIZE;
  int page_n = PGROUNDUP(mmap_size) >> PGSHIFT;
  uint64 va = start;
  for (int i = 0; i < page_n; i++) {
    uint64 pa = experm(p->pagetable, va, perm);
    if (NULL == pa) {
      return -1;
    }
    if (i != page_n - 1)
      fileread(f, va, PGSIZE);
    else {
      fileread(f, va, end_pagespace);
      memset((void *)(pa + end_pagespace), 0, PGSIZE - end_pagespace);
    }
    va += PGSIZE;
  }
  //file.h
  filedup(f);
  return start;
}

// 按照进程需要的权限（PROC_WRITE）分配权限
// 在exec时调用，需要在新的pagetable上面操作
uint64 mmap_with_newpt(pagetable_t pagetable, uint64 start, uint64 len,
                       int prot, int flags, int fd, long int offset) {
  struct proc *p = myproc();
  if (offset < 0) {
    return -1;
  }
  int perm = PTE_PLV | PTE_MAT | PTE_D | PTE_NR | PTE_W | PTE_NX;

  if (prot & PROT_READ)
    perm &= ~PTE_NR;
  if (prot & PROT_WRITE)
    perm |= PTE_W;
  if (prot & PROT_EXEC){
    perm |= PTE_MAT;
    perm &= ~PTE_NX; 
  }
    
  struct file *f = fd == -1 ? NULL : p->ofile[fd];
  if (fd != -1 && f == NULL)
    return -1;
  struct vma *vma = alloc_mmap_vma(p, flags, start, len, perm, fd, offset);
  start = vma->addr;
  if (NULL == vma) {
    return -1;
  }
  uint64 mmap_size = 0;
  if (-1 != fd) {
//     mmap_size = f->ep->file_size - offset;
//     if (len < mmap_size)
//       mmap_size = len;
    f->off = offset;
  } else {
    return start;
  }
  uint64 end_pagespace = mmap_size % PGSIZE;
  int page_n = PGROUNDUP(mmap_size) >> PGSHIFT;
  uint64 va = start;
  for (int i = 0; i < page_n; i++) {
    uint64 pa = experm(p->pagetable, va, perm);
    if (NULL == pa) {
      return -1;
    }
    if (i != page_n - 1)
      fileread(f, va, PGSIZE);
    else {
      fileread(f, va, end_pagespace);
      memset((void *)(pa + end_pagespace), 0, PGSIZE - end_pagespace);
    }
    va += PGSIZE;
  }

  filedup(f);
  return start;
}