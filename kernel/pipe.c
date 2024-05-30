
#include "include/pipe.h"
#include "include/file.h"
#include "include/kalloc.h"
#include "include/param.h"
#include "include/proc.h"
#include "include/loongarch.h"
#include "include/sleeplock.h"
#include "include/spinlock.h"
#include "include/types.h"
#include "include/vm.h"

int pipealloc(struct file **f0, struct file **f1) {
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
  if ((*f0 = filealloc()) == NULL || (*f1 = filealloc()) == NULL)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == NULL)
    goto bad;
  memset(pi, 0, sizeof(*pi));
  pi->readopen = 1;
  pi->writeopen = 1;
  pi->nwrite = 0;
  pi->nread = 0;
  initlock(&pi->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = pi;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = pi;
  return 0;

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    fileclose(*f0);
  if (*f1)
    fileclose(*f1);
  return -1;
}

void pipeclose(struct pipe *pi, int writable) {
  acquire(&pi->lock);
  if (writable) {
    pi->writeopen = 0;
    wakeup(&pi->nread);
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
}

int pipewrite(struct pipe *pi, int user, uint64 addr, int n) {
  int i;
  char ch;
  struct proc *pr = myproc();

  acquire(&pi->lock);
  for (i = 0; i < n; i++) {
    while (pi->nwrite == pi->nread + PIPESIZE) { // DOC: pipewrite-full
      if (pi->readopen == 0 || pr->killed) {
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    }
    // if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    // if(copyin2(&ch, addr + i, 1) == -1)
    //   break;
    if (either_copyin(&ch, user, addr + i, 1) == -1)
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}

int piperead(struct pipe *pi, int user, uint64 addr, int n) {
  int i;
  struct proc *pr = myproc();
  char ch;

  acquire(&pi->lock);
  while (pi->nread == pi->nwrite && pi->writeopen) { // DOC: pipe-empty
    if (pr->killed) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
  }
  for (i = 0; i < n; i++) { // DOC: piperead-copy
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    // if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    // if(copyout2(addr + i, &ch, 1) == -1)
    //   break;
    if (either_copyout(user, addr + i, &ch, 1) == -1)
      break;
  }
  wakeup(&pi->nwrite); // DOC: piperead-wakeup
  release(&pi->lock);
  return i;
}

int pipe_full(struct pipe *pi) {
  int ans = 0;
  acquire(&pi->lock);
  // int ans = __pipe_full(pi);
  if (pi->nwrite == pi->nread + PIPESIZE) {
    ans = 1;
  }

  release(&pi->lock);
  return ans;
}

int pipe_empty(struct pipe *pi) {
  int ans = 0;
  acquire(&pi->lock);
  // int ans = __pipe_empty(pi);
  if (pi->nread == pi->nwrite) {
    ans = 1;
  }
  release(&pi->lock);
  return ans;
}