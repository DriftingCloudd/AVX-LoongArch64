# basic-kernel-V1.2
made by 袁良卿 driftingcloudd@outlook.com

## 总结

### 一 对以下文件进行了移植和修改
sleeplock.c sleeplock.h 完全移植，但不能使用
等待wakeup sleep的实现

proc.c proc.h 部分移植
定义了proc数据结构，仅仅只有int pid这一项；在.h中增加了对wakeup() sleep()引用，实际实现等待进程管理的移植；myproc()可以使用；

buf.h bio.c 完全移植，但不能使用
定义了buffer层的所有。等待sleeplock的完全使用

disk.c disk.h 完全移植
抽象的disk层。完全移植

ramdisk.c ramdisk.h 完全移植，但暂时无法使用
ramdisk层，针对ramdisk的完全移植。等待sleeplock的实现

sddata.S 未移植 
用于存储fat32文件系统镜像 **注意，由于github对大文件传输很麻烦，这里使用的磁盘镜像需要通过2k1000模拟器获得，并且未经过测试。等待后续文档说明**

fat32.c fat32.h 完全移植，等待bio.c与sleeplock的完成

fcntl.h 完全移植



## 二 机制设计

### 2.1 睡眠锁
``` C
struct sleeplock {
  uint locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};
```
在这段代码中，`acquire` 函数用于获取内部的自旋锁，这是为了保护 `sleeplock` 结构的一致性。

`sleeplock` 结构包含了一个标志 `locked` 和一个进程 ID `pid`，这两个字段在多线程环境中可能会被并发修改。为了防止这种情况，我们需要在修改这两个字段之前先获取一个锁，确保在修改过程中不会有其他线程来修改这两个字段。

这里使用的是自旋锁，因为我们只需要保护很短的代码段，这段代码的执行时间非常短，所以使用自旋锁的开销比较小。而且，自旋锁可以避免线程切换的开销，因为当锁被占用时，线程会一直忙等待，而不是被切换出去。

在 `acquiresleep`、`releasesleep` 和 `holdingsleep` 函数中，都是先调用 `acquire` 获取自旋锁，然后修改 `locked` 和 `pid` 字段，最后再调用 `release` 释放自旋锁。这样可以确保 `locked` 和 `pid` 字段的一致性，防止并发问题。



### 2.2 文件系统与磁盘层次结构设计
文件系统与磁盘层次结构设计如下
1. 磁盘驱动层。这一层负责与磁盘的交互。在这里是与ramdisk的交互。预计决赛可以写一个AHCI的SATA驱动
2. 抽象磁盘层。这一层将磁盘驱动层封装。将不同磁盘驱动的读写操作抽象成统一的磁盘读写操作，给上层提供统一的接口
3. 缓冲区层（buffer层）。这一层将磁盘内容缓存到内存中，加速访问速度
4. 文件系统层。这一层使用文件系统与buffer交互，管理组织buffer数据。这里采用fat32文件系统
5. 文件层。file数据结构的实现
下面依次介绍每层的功能，关键函数与数据结构。

#### 2.2.1 磁盘驱动层
可以有多种不同类型的磁盘驱动。下面介绍两种在本操作系统采用的驱动  
**AHCI硬盘控制器**  
在龙芯2k1000的设备树文件中发现以下节点
``` DTS
		sata: ahci@400e0000 {
			compatible = "snps,spear-ahci";
			reg = <0 0x400e0000 0 0x10000>;
			interrupt-parent = <&icu>;
			interrupts = <19>;
			dma-mask = <0x0 0xffffffff>;
			pinctrl-0 = <&ahci_default>;
			pinctrl-names = "default";
			status = "disabled";
		};
```
synopsys公司的AHCI兼容AHCI 1.3.在Intel官网上找到AHCI 1.3.1的mannal。可以根据此完成驱动。

**ramdisk**  
这种方法是目前操作系统采用的形式。将相应的磁盘镜像与操作系统的文件一起编译，形成一个elf文件，磁盘镜像就在elf文件的数据段中。这种形式称为ramdisk形式。这样做的好处是：磁盘驱动很简单，读写操作只需要访问相应的内存单元即可。

#### 2.2.2 磁盘抽象层
这一层将不同驱动的读写操作统一成一个操作，对上一层的缓冲区层提供统一的接口。接口函数如下:
``` C
void disk_init(void);
void disk_read(struct buf *b);
void disk_write(struct buf *b);
void disk_intr(void);
```

#### 2.2.3 缓冲层
这一层将此磁盘数据缓存在内存单元内，提高上层访问速度。  
管理磁盘在内存中的数据的基本单元是buf。数据结构如下：
``` C
struct buf {
  int valid;
  int disk;		// does disk "own" buf? 
  uint dev;
  uint sectorno;	// sector number 
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev;
  struct buf *next;
  uchar data[BSIZE];
};
```
管理所有磁盘在内存中的数据的数据结构如下所示：
```C
struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;
```
bache是一个双向链表，管理所有的buf。利用该数据结构，实现了使用LRU算法实现buf替换。  
缓冲层向上提供的接口函数如下：

```C

void            binit(void);
struct buf*     bread(uint, uint);
void            brelse(struct buf*);
void            bwrite(struct buf*);
```


#### 2.2.4 FAT32文件系统
待补充

#### 2.2.5 文件层
待补充