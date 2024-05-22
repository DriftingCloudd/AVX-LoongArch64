#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "loongarch.h"
// #include "defs.h"

//
// the loongarch 7A1000 I/O Interrupt Controller Registers.
//

void
apic_init(void);

// tell the apic we've served this IRQ.
void
apic_complete(uint64 irq);