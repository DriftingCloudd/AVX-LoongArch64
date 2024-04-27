#ifndef __KALLOC_H
#define __KALLOC_H

#include "types.h"
#include "param.h"

void*           kalloc(void);
void            kfree(void *);
void            kinit(void);
uint64          freemem_amount(void);
void freerange(void *pa_start, void *pa_end);

#endif