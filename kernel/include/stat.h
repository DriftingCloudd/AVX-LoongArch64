#ifndef __STAT_H
#define __STAT_H
#include "types.h"

#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device

#define STAT_MAX_NAME 32

struct stat {
  char name[STAT_MAX_NAME + 1];
  int dev;     // File system's disk device
  short type;  // Type of file
  uint64 size; // Size of file in bytes
};
struct kstat {
        uint64 st_dev;
        uint64 st_ino;
        unsigned int st_mode;
        uint32 st_nlink;
        uint32 st_uid;
        uint32 st_gid;
        uint64 st_rdev;
        unsigned long __pad;
        long int st_size;
        uint32 st_blksize;
        int __pad2;
        uint64 st_blocks;
        long st_atime_sec;
        long st_atime_nsec;
        long st_mtime_sec;
        long st_mtime_nsec;
        long st_ctime_sec;
        long st_ctime_nsec;
        unsigned __unused[2];
};


struct statx_timestamp {
    signed long long tv_sec;   // 秒
    uint32 tv_nsec;  // 纳秒
    signed int __reserved;
};

struct statx {
    uint32 stx_mask;        // 表示哪些字段有效的掩码
    uint32 stx_blksize;     // 优化I/O的块大小
    uint64 stx_attributes;  // 文件的属性
    uint32 stx_nlink;       // 硬链接数
    uint32 stx_uid;         // 所有者用户ID
    uint32 stx_gid;         // 所有者组ID
    uint16 stx_mode;        // 文件类型和模式
    uint16 __spare0[1];
    uint64 stx_ino;         // inode编号
    uint64 stx_size;        // 文件大小
    uint64 stx_blocks;      // 分配的块数
    uint64 stx_attributes_mask; // 表示哪些属性有效的掩码
    struct statx_timestamp stx_atime; // 上次访问时间
    struct statx_timestamp stx_btime; // 创建时间
    struct statx_timestamp stx_ctime; // 上次状态更改时间
    struct statx_timestamp stx_mtime; // 上次修改时间
    uint32 stx_rdev_major;  // 设备的主设备号
    uint32 stx_rdev_minor;  // 设备的次设备号
    uint32 stx_dev_major;   // 文件所在设备的主设备号
    uint32 stx_dev_minor;   // 文件所在设备的次设备号
    uint64 __spare2[14];    // 备用字段
};

// struct stat {
//   int dev;     // File system's disk device
//   uint ino;    // Inode number
//   short type;  // Type of file
//   short nlink; // Number of links to file
//   uint64 size; // Size of file in bytes
// };

#endif