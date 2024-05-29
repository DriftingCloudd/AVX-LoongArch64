#include "include/buf.h"
#include "include/printf.h"
#include "include/spinlock.h"
#include "include/string.h"
#include "include/types.h"
#include "include/new_sdcard.h"

#define NRAMDISKPAGES (new_sdcard_len * BSIZE / PGSIZE)

struct spinlock ramdisklock;
extern uchar new_sdcard[];
extern uint32 new_sdcard_len;
char *ramdisk;

void ramdisk_init(void) {
  initlock(&ramdisklock, "ramdisk lock");
  ramdisk = (char *)new_sdcard;
  printf("ramdiskinit ram start:%p\n", ramdisk);
}

void ramdisk_read(struct buf *b) {
  acquire(&ramdisklock);
  uint sectorno = b->sectorno;

  char *addr = ramdisk + sectorno * BSIZE;
  memmove(b->data, (void *)addr, BSIZE);
  release(&ramdisklock);
}

void ramdisk_write(struct buf *b) {
  acquire(&ramdisklock);
  uint sectorno = b->sectorno;

  char *addr = ramdisk + sectorno * BSIZE;
  memmove((void *)addr, b->data, BSIZE);
  release(&ramdisklock);
}