#include "include/buf.h"
#include "include/printf.h"
#include "include/spinlock.h"
#include "include/string.h"
#include "include/types.h"
#include "include/sdcard.h"
#define NRAMDISKPAGES (sdcard_len * BSIZE / PGSIZE)

struct spinlock ramdisklock;
extern uchar sdcard[];
extern uint32 sdcard_len;
char *ramdisk;

void ramdisk_init(void) {
  initlock(&ramdisklock, "ramdisk lock");
  ramdisk = (char *)sdcard;
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