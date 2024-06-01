#include "include/futex.h"
#include "include/proc.h"
#include "include/thread.h"
#include "include/timer.h"
#include "include/trap.h"
#include "include/types.h"

typedef struct FutexQueue {
  // 虚拟地址
  uint64 addr;
  // 线程
  thread *thread; 
  uint8 valid;
} FutexQueue;

FutexQueue futexQueue[FUTEX_COUNT];

// 执行线程futex同步？
void futexWait(uint64 addr, thread *th, TimeSpec2 *ts) {
  for (int i = 0; i < FUTEX_COUNT; i++) {
    if (!futexQueue[i].valid) {
      // FUTEX_CLOCK_REALTIME
      futexQueue[i].valid = 1;
      futexQueue[i].addr = addr;
      futexQueue[i].thread = th;
      if (ts) {
        // 计数器
        // 选择传入表示线程计时
        th->awakeTime = ts->tv_sec * 1000000 + ts->tv_nsec / 1000;
        th->state = t_TIMING;
      } else {
        th->state = t_SLEEPING;
      }
      acquire(&th->p->lock);
      th->p->state = RUNNABLE;
      sched();
      release(&th->p->lock);
    }
  }
  panic("No futex Resource!\n");
}

// proc传入地址
void futexWake(uint64 addr, int n) {
  for (int i = 0; i < FUTEX_COUNT && n; i++) {
    if (futexQueue[i].valid && futexQueue[i].addr == addr) {
      // 调度的结果->等待
      futexQueue[i].thread->state = t_RUNNABLE;
      futexQueue[i].thread->trapframe->a0 = 0;
      futexQueue[i].valid = 0;
      n--;
    }
  }
}

void futexRequeue(uint64 addr, int n, uint64 newAddr) {
  for (int i = 0; i < FUTEX_COUNT && n; i++) {
    if (futexQueue[i].valid && futexQueue[i].addr == addr) {
      futexQueue[i].thread->state = t_RUNNABLE;
      futexQueue[i].thread->trapframe->a0 = 0;
      futexQueue[i].valid = 0;
      n--;
    }
  }
  for (int i = 0; i < FUTEX_COUNT; i++) {
    if (futexQueue[i].valid && futexQueue[i].addr == addr) {
      futexQueue[i].addr = newAddr;
    }
  }
}

void futexClear(thread *thread) {
  for (int i = 0; i < FUTEX_COUNT; i++) {
    if (futexQueue[i].valid && futexQueue[i].thread == thread) {
      futexQueue[i].valid = 0;
    }
  }
}