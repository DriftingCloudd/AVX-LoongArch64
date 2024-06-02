# 文件系统
## 介绍
AVX-Loongarch64 采用文件系统仍然是fat32文件系统，该文件系统在文件访问设计上较为简单，容易实现；缺点是fat32文件系统使用内存簇的设计，在初始化文件系统大小后难以扩展空间。
下面来介绍AVX-Loongarch64 中文件系统的设计。

## 分层
文件系统采用分层的设计，从低到高，文件系统实现如下的分层方式：
- 磁盘IO层：在IO栈中负责与下层磁盘的交互操作。当AVX-Loongarch64 运行在qemu模拟器时，通过虚拟io（`virtio`）和底层磁盘进行交互，在操作系统运行在实际板卡时，通过sdcardio 和sdcard进行交互。
- 抽象层：负责对底层读写进行抽象操作，通过传入参数宏选择实际访问类型，为无论是磁盘还是虚拟磁盘的读写提供统一的访问方式
- 磁盘缓冲：`buf`的设计起到减少文件系统向下写IO的次数，起到提高效率和演唱存储设备寿命的作用，以存储扇区为基本的读写单位，因此缓存的基本单位是**块**。一个缓存结构题记录了磁盘某个物理扇区的具体信息：

```c
struct buf{
	int valid;//有效
	int disk;//磁盘号
	uint dev;
	uint sectorno;
	struct sleeplock lock;
	uint refcnt;
	struct buf *prev, *next;
	uchar data[BSIZE];
}
```

其中，`sectorno`记录的是缓存对应的物理扇区号，`data`字段起到实际缓存底层数据的作用。实现缓存替换的方式采用lru（最长未使用）替换算法，并使用了双向链表实现这一算法。
通过缓存，使得上层在访问磁盘时，扇区读写的具体操作是透明的。只需要使用缓存向上提供的api，传递需要的逻辑块号即可。

- 文件系统层： 文件系统层依赖下层的buf透明读写的api，实现离散数据到文件系统的组织管理。
- 文件层：文件是文件系统的基本组织单位。在AVX-Loongarch64 中，将设备、管道和文件数据统一成文件。文件层的另一个作用，是在进程运行过程中为进程提供文件描述符。

```c
struct file{
	enum {FD_NONE, FD_PIPE, FD_ENTRY, FD_DEVICE} type;//文件类型
	int ref;
	char readable;
	char writeable;
	struct pipe *pipe;//管道
	struct dirent *ep;//文件目录
	uinit off;//文件入口偏移地址 FD_ENTRY
	short major;// FD_DEVICE
}
```

![](doc/内核介绍/picture/pic5.png)
