#include "loongarch.h"
struct file {
  // 文件类型
  enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
  // 文件复制
  int ref; // reference count
  char readable;
  char writable;
  // 文件类型
  struct pipe *pipe; // FD_PIPE
  struct inode *ip;  // FD_INODE and FD_DEVICE
  uint off;          // FD_INODE
  short major;       // FD_DEVICE
};
// 主设备号 -> 辅设备号
#define major(dev)  ((dev) >> 16 & 0xFFFF)
#define minor(dev)  ((dev) & 0xFFFF)
#define	mkdev(m,n)  ((uint)((m)<<16| (n)))

// in-memory copy of an inode
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
//   struct sleeplock lock; // protects everything below here
  int valid;          // inode has been read from disk?

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  // fs.h
  // uint addrs[NDIRECT+1];
};

// map major device number to device functions.
struct devsw {
  int (*read)(int, uint64, int);
  int (*write)(int, uint64, int);
};

// extern struct devsw devsw[];

#define CONSOLE 1

struct file* filedup(struct file *f);
void fileinit(void);
void fileclose(struct file *f);