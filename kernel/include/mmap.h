#ifndef _MMAP_H_
#define _MMAP_H_

#include "types.h"
#include "vma.h"

#define PROT_NONE		0
#define PROT_READ		1
#define PROT_WRITE		1<<1
#define PROT_EXEC		1<<2

#define PROT_GROWSDOWN	0x01000000
#define PROT_GROWSUP	0x02000000
#define PROT_ALL (PROT_READ|PROT_WRITE|PROT_EXEC|PROT_GROWSDOWN|PROT_GROWSUP)
// 映射关系
#define MAP_FILE		0
#define MAP_SHARED		0x01
#define MAP_PRIVATE		0x02
#define MAP_FIXED		0x10
#define MAP_ANONYMOUS		0x20
#define MAP_FAILED ((void *) -1)

#define MS_ASYNC	1
#define MS_INVALIDATE	2
#define MS_SYNC	4

typedef struct vma map_fix;

uint64 mmap(uint64 start, uint64 len,int prot,int flags,int fd, long int offset);
#endif
