#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "loongarch.h"
#include "defs.h"

void extioi_init(void);

uint64
extioi_claim(void);

void extioi_complete(uint64 irq);