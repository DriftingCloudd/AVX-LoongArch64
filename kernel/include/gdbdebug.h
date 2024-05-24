#ifndef __GDBDEBUG_H
#define __GDBDEBUG_H
#include "types.h"
#include "loongarch.h"
typedef struct pte_rt
{
    pagetable_t pdir3;
    pagetable_t pdir2;
    pagetable_t pdir1;
    pagetable_t pte;
}pte_rt;

typedef struct csr_tr
{
    uint32 csr_crmd;
    uint32 csr_prmd;
    uint32 csr_ecfg;
    uint64 csr_era;
    uint64 csr_eentry;
    uint64 csr_pgd;
    uint64 csr_pgdl;
    uint32 csr_estat;
}csr_rt;

csr_rt csr_info = {1,1,1,1,1,1,1,1};

csr_rt reg_gdb();
csr_rt reg_gdb1();
int test();
uint32 r_csr_prmd1();
uint32 r_csr_crmd1();
uint32 r_csr_ecfg1();
uint64 r_csr_era1();
uint64 r_csr_eentry1();
uint64 r_csr_pgdl1();
uint64 r_csr_pgd1();
uint32 r_csr_estat1();

#endif