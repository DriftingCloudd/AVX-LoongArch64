#include "include/loongarch.h"
#include "include/loongarchregs.h"
#include "include/types.h"
#include "include/gdbdebug.h"

// pte_rt pte_gdb(pagetable_t pagetable,uint64 va){
//     pte_rt pte_info;
//     pte_info.pdir3 =(uint64) pagetable;

//     for (int level = 3; level > 0; level--) {
//       pte_t *pte = &pagetable[PX(level, va)];
//       if (*pte & PTE_V) {
//         // 内核转换为物理地址
//         pagetable = (pagetable_t)(PTE2PA(*pte) | DMWIN_MASK);
//       } else {
//         if (!alloc || (pagetable = (pde_t *)kalloc()) == NULL) {
//           // printf("walk: not valid\n");
//           return 0;
//         }
//         memset(pagetable, 0, PGSIZE);
//         *pte = PA2PTE(pagetable) | PTE_V | PTE_D |PTE_MAT | PTE_PLV | PTE_RPLV ;
//       }
//     }
//     pte_info.pdir2 = 
//     pte_info.pdir1 = 
//     pte_info.pte = 

//     return pte_info;

// }

extern csr_rt csr_info;

csr_rt reg_gdb() {
    csr_info.csr_crmd = r_csr_crmd1();
    csr_info.csr_prmd = r_csr_prmd1();
    csr_info.csr_ecfg = r_csr_ecfg1();
    csr_info.csr_era = r_csr_era1();
    csr_info.csr_eentry = r_csr_eentry1();
    csr_info.csr_pgd = r_csr_pgdl1();
    csr_info.csr_pgdl = r_csr_pgd1();
    csr_info.csr_estat = r_csr_estat();

    return csr_info;
}

csr_rt reg_gdb1() {
    csr_rt csr_info1 = {1,1,1,1,1,1,1,1};
    csr_info.csr_crmd = r_csr_crmd1();
    csr_info.csr_prmd = r_csr_prmd1();
    csr_info.csr_ecfg = r_csr_ecfg1();
    csr_info.csr_era = r_csr_era1();
    csr_info.csr_eentry = r_csr_eentry1();
    csr_info.csr_pgd = r_csr_pgdl1();
    csr_info.csr_pgdl = r_csr_pgd1();
    csr_info.csr_estat = r_csr_estat();

    return csr_info1;
}

uint32 r_csr_prmd1()
{
  uint32 x;
  asm volatile("csrrd %0, 0x1" : "=r" (x) );
  return x;
}

uint32 r_csr_crmd1()
{
  uint32 x;
  asm volatile("csrrd %0, 0x0" : "=r" (x) );
  return x;
}

uint32 r_csr_ecfg1()
{
  uint32 x;
  asm volatile("csrrd %0, 0x4" : "=r" (x) );
  return x;
}

uint64 r_csr_era1()
{
  uint64 x;
  asm volatile("csrrd %0, 0x6" : "=r" (x) );
  return x;
}

uint64 r_csr_eentry1()
{
  uint64 x;
  asm volatile("csrrd %0, 0xc" : "=r" (x) );
  return x;
}

uint64 r_csr_pgdl1()
{
  uint64 x;
  asm volatile("csrrd %0, 0x19" : "=r" (x) );
  return x;
}

uint64 r_csr_pgd1()
{
  uint64 x;
  asm volatile("csrrd %0, 0x1b" : "=r" (x) );
  return x;
}

uint32 r_csr_estat1()
{
  uint32 x;
  asm volatile("csrrd %0, 0x5" : "=r" (x) );
  return x;
}

int test(){
  return 1;
}