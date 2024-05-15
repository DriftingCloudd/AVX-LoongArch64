# basic-kernel-V1.1
made by 袁良卿

## 总结：
打印字符串的实现 spinlock的实现 memlayout与para的设置 intr栈式中断的实现  cpu数据结构与函数的定义 uart16650的实现 终端的部分功能的实现

## 一 对以下的文件进行了移植与修改
- memlayout.h 部分移植
这个文件现阶段来说硬件映射没有问题

- para.h 完全移植
用于kernel的参数应该不需要修改多少

- printf.c printf.h   部分移植
printf()实现在终端打印字符（通过测试） panic()未进行测试 还有一些调试用的函数未进行移植。以后可以考虑完善
 
- spinlock.c spinlock.h  完全移植
完成移植。现阶段的测试未出现问题 spinlock.c中减少了include的文件，其余基本上没变

- intr.c intr.h 完全移植
完全移植。现阶段测试未出现问题。完成了栈式开关中断功能的实现。现阶段的测试未出现问题

- proc.c proc.h 部分移植
在proc.h中只对cpu的结构进行了定义 proc.c中只完成了mycpu()与cpuid()

- console.c  console.h 部分移植
定义了cons，作为console系统的控制器。完全实现了consputc()并进行了实现， consoleinit()完成了部分功能（有一些文件系统相关的初始化没完成） 其余的与文件系统 中断相关的内容未进行移植  

- uart.c uart.h 部分移植   
uart.c 定义了uartinit() void uartputc_sync(int c) int uartgetc(void) 定义了用于文件系统的锁和buffer 其他的没实现。即与文件系统和中断的函数没实现

## 二 机制设计
### 1 自旋锁设计
自旋锁的数据结构与相关函数的定义如下所示:
```C
// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
};
// Initialize a spinlock 
void initlock(struct spinlock*, char*);

// Acquire the spinlock
// Must be used with release()
void acquire(struct spinlock*);

// Release the spinlock 
// Must be used with acquire()
void release(struct spinlock*);

// Check whether this cpu is holding the lock 
// Interrupts must be off 
int holding(struct spinlock*);
```
当locked = 1 时锁是持有状态。
调用acquire()时，会使用GCC提供的内置函数__sync_lock_test_and_set（）。最关键的代码是
```C
  if (holding(lk))
    panic("acquire");
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    ;
```
为了防止deadlock，使用holding()检查这把锁是否被当前的CPU持有。  
__sync_lock_test_and_set函数接受两个参数：一个指向内存位置的指针和一个新值。它将内存位置的值设置为新值，并返回旧值。整个操作（读取旧值，设置新值）是原子性的，这意味着它保证在没有被其他线程中断的情况下完成。这意味着当前的cpu会不断尝试获取这把锁。

### 2 CPU设计
与CPU相关的数据结构与函数如下：
```C
// Per-CPU state.
struct cpu {
  struct proc *proc;          // The process running on this cpu, or null.
  struct context context;     // swtch() here to enter scheduler().
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};

extern struct cpu cpus[NCPU];

void            cpuinit(void);
int             cpuid(void);
struct cpu*     mycpu(void);
```
其中proc指向当前运行的进程， context用于进程调度时的上下文切换，noff与intena用于栈式中断开关机制。后文会涉及。
CPU模块中，使用cpus数组管理所有cpu。其中最关键的设计是：在每个CPU初始化时，cpu会将CPUID保存到线程寄存器tp中。而在我们的kernel中线程的实现基于其他的数据结构


### 3 栈式中断开关的设计
栈式中断开关的设计是用于处理有多个需要关闭中断的执行流（线程）的情况。
这种设计类似于栈：每当请求中断关闭时，当前cpu的noff+=1；每当请求中断开启时，noff-=1。当noff==0的情况下，则会根据intena的值决定开启或者关闭中断



## 备注
有这些文件的依赖关系图。有问题可以联系我