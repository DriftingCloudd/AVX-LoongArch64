#ifndef __PARAM_H
#define __PARAM_H

// 进程和cpud 的最大数量
#define NPROC        50  // maximum number of processes
#define NCPU          2  // maximum number of CPUs
#define NOFILE       128  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  1000  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
#define FSSIZE       1000  // size of file system in blocks
#define MAXPATH      260   // maximum file path name
// #ifdef QEMU

// #define CLK_FREQ     10000000
// #else
// 根据确切时钟
#define CLK_FREQ     4000000
// #endif

//#define INTERVAL     (390000000 / 200) // timer interrupt interval
#define ticks_per_second 1
#define INTERVAL     CLK_FREQ / ticks_per_second // timer interrupt interval

#endif