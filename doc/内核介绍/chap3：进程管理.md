# 进程管理
进程管理的模块主要分为：初始化、进程调用、进程切换等。

![](doc/内核介绍/picture/pic_1.jpg)
## 进程控制块
操作系统使用进程控制块将运行中的程序进行封装，利于操作系统的管理。进程控制块的结构如下所示。进程控制块存储进程的状态，是内核对进程进行管理的基本单元，同时，控制块的丰富程度反映了操作系统的复杂程度、交互能力和调度性能。
```c
struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state;        // Process state
  struct proc *parent;         // Parent process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  int xstate;                  // Exit status to be returned to parent's wait
  int pid;                     // Process ID
  int uid;                     // Process User ID
  int gid;                     // Process Group ID
  int pgid;
  
  uint64 filelimit;
  uint64 kstack;               // Virtual address of kernel stack
  uint64 sz;                   // Size of process memory (bytes)
  
  pagetable_t pagetable;       // User page table
  pagetable_t kpagetable;      // Kernel page table
  struct trapframe *trapframe; // data page for trampoline.S
  struct context context;      // swtch() here to run process
  struct file *ofile[NOFILE];  // Open files
  int *exec_close;             // Open files
  struct dirent *cwd;          // Current directory
  char name[16];               // Process name (debugging)
  int tmask;                    // trace mask
  struct vma *vma;
  int ktime;
  int utime;
};
```


## 进程状态
进程状态定义如下：
```c
enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
```
各状态解释如下：
- `UNUSED`：表示进程控制块没有对应的进程
- `USED`：表示进程控制块存在对应的进程
- `SLEEPING`：进程由于等待资源等原因没有运行
- `RUNNABLE`：进程进入等待资源调度的环节
- `RUNNING`：表示进程正在运行
- `ZOMBIE`：进程被杀死，但是资源没有回收，处于”僵死“状态


## 进程控制
具体介绍进程的分配、初始化和调度等执行模块。

### 进程分配
在avx-loongarch64 中，使用`allocproc`函数分配新的进程：
- 寻找一个`UNUSED`的进程控制块，如果找到则跳转到`found`标签进行后续的**初始化操作**，如果没有，则返回`NULL` 
- 初始化进程控制块：如果找到了一个没有使用的进程控制块，先调用`allocpid()`函数分配进程号，初始化其虚拟内存地址为空，设置其内核时间和用户时间为1
- 分配`trapframe`页面：通过调用`kalloc()`函数，为该进程的`trapframe` 分配相应的内存空间；如果分配失败返回`NULL`
- 创建用户页表和内核页表：成功分配`trapframe`页面后，函数将创建一个空的用户页面和一个内核页表，如果任意的页表创建失败，函数返回`NULL`并清空分配空间
- 设置进程的内核堆栈
- 设置新的进程上下文，设置返回地址寄存器为`forkret()` 函数的地址，将堆栈指针设置为内核堆栈的顶部。新的进程将从`forkret()`函数开始执行

### 进程初始化
内核启动过程中，除此`init`过程，其他进程都是通过`fork()` 和 `exec()` 的方式加载的。
初始化的执行过程如下：
- 从进程控制块的数组中寻找一个空闲的块
- 页表映射：avx-loongarch64 采用PALEN=48的虚拟内存模型。在此步骤中，操作系统会为程序的每个段进行页表映射。

原始的`init`进入无限的进程调度循环中，其他程序创建和执行的步骤正是：
- fork：创建新的进程
- exec：调用执行程序

将新建进程的状态进程初始化，设置进程控制块的个状态设置为默认值，代码如下所示：
```c
static struct proc *allocproc(void) {
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return NULL;

found:
  p->pid = allocpid();
  freemem_amount();
  printf("alloc proc:%d freemem_mount:%p\n", p->pid, freemem_amount());
  p->vma = NULL;
  p->filelimit = NOFILE;
  p->ktime = 1;
  p->utime = 1;
  p->uid = 0;
  p->gid = 0;
  p->pgid = 0;

  // 信号量

  if ((p->trapframe = (struct trapframe *)kalloc()) == NULL) {
    release(&p->lock);
    return NULL;
  // }
  // 用户页表和内核页表
  if ((p->pagetable = proc_pagetable(p)) == NULL ||
      (p->kpagetable = proc_pagetable(p)) == NULL) {
    freeproc(p);
    release(&p->lock);
    return NULL;
  }
  
  p->kstack = PROCVKSTACK(get_proc_addr_num(p));

  // p->exec_close = kalloc();
  // for (int fd = 0; fd < NOFILE; fd++)
  //   p->exec_close[fd] = 0;

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));

  // init 上下文和线程
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + KSTACKSIZE;

  return p;
  }
}
```

### 进程调度
目前，avx-loongarch系统的进程调度采用时间片均分的策略；所有进程不分优先级的在统一的队列中进行调度。
进程的调度是对cpu的占用，系统首先需要对cpu这一资源进行抽象：
```c
// Per-CPU state.
	struct cpu {
	struct proc *proc; // The process running on this cpu, or null.
	struct context context; // swtch() here to enter scheduler().
	int noff; // Depth of push_off() nesting.
	int intena; // Were interrupts enabled before push_off()?
};
```

其中作为资源抢占和调度保存的基本单位，`proc`和 上下文字段是最重要的。`proc`指向在当前cpu上执行的进程，context的字段保存进程切换时的上下文。context的定义如下所示：
```c
typedef struct context {
  uint64 ra; //0
  uint64 sp; //8

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  
  uint64 fp;
}context;

```

context结构体用于保存进程上下文信息，以便进程在下一次投入运行时从恢复上下文。当系统需要进行进程切换时，它会扫描所有进程，寻找状态为RUNNABLE 的进程。
这一调度过程是通过`yield`和`scheduler`函数联合实现的。

`yield`是对cpu资源的放弃，是将要退出的进程执行的最后一步：
```c
// // Give up the CPU for one scheduling round.

void yield(void) {
	struct proc *p = myproc();
	acquire(&p->lock);
	printf("pid %d yield\n, era: %p", p->pid, p->trapframe->era);
	p->state = RUNNABLE;
	// todo：线程部分
	// p->main_thread->state = t_RUNNABLE;
	// 行调度，以进程（线程）为基本单位
	sched();
	release(&p->lock);
}
```

一般是由调度函数调用来切换进程，`scheduler`的执行是：
- 从进程列表中选择一个状态为RUNNABLE的进程；获取进程后，获得该进程的锁防止其他进程同时修改**进程列表**
- 这个处于等待状态的进程的状态被修改为`RUNNING`，并且将其设置为当前CPU正在运行的进程。此时，函数将页表切换为当前进程的内核页表，更新地址空间；
- 然后，函数执行`swtch`操作进行上下文的切换。
- 在进程运行结束后，CPU会跳回`scheduler`函数中，并且将页表切换会内核页表，同时刷新地址空间。
- 最后，CPU将正在运行的进程状态设置为0,表示此时CPU中没有正在运行的进程，然后释放进程的锁，等待下次的进程调度过程

### 进程释放
进程释放过程是通过调用`freeproc()`函数实现的，该函数的实现如下：
```c
static void freeproc(struct proc *p) {
  if (p->trapframe)
    kfree((void *)p->trapframe);
    kfree((void *)p->exec_close);
  p->trapframe = 0;
  if (p->kpagetable) {
    kvmfree(p->kpagetable, 1, p);
  }

  p->kpagetable = 0;
  if (p->pagetable) {
    free_vma_list(p);
    proc_freepagetable(p->pagetable, p->sz);
  }
  // TODO: free threads
  freemem_amount();
  printf("free proc : %d freemem_mount:%p\n",p->pid, freemem_amount());
  p->pagetable = 0;
  p->vma = NULL;
  p->sz = 0;
  p->pid = 0;

  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}
```

下面解释该函数各步骤的实现过程：
- 释放`trapframe`：首先，如果trapframe存在则释放其占用的内存，然后将`trapframe`字段设置为0；
- 释放内核页表和用户页表
- 清空进程控制块的其他字段
- 设置进程状态为`UNUSED`，表示该进程控制块已经被清空，可以用于分配新的进程。

通过这样的步骤，`freeproc()`函数实现了对进程资源的回收，这些资源包括内存资源和进程控制块的各种字段。
