#include "loongarchregs.h"

.section .text
.global _entry
_entry:
        li.d        $t0, 0x8000000000000000   
        csrwr       $t0, LOONGARCH_CSR_DMWIN0
        li.d        $t0, 0x9000000000000000   
        csrwr       $t0, LOONGARCH_CSR_DMWIN1
        li.d        $t0, 0x0000000000000000
        csrwr       $t0, LOONGARCH_CSR_DMWIN2
        csrwr       $t0, LOONGARCH_CSR_DMWIN3
        csrwr       $t0, LOONGARCH_CSR_TLBRENTRY	

        li.w	    $t0, 0xb0		      # PLV=0, IE=0, PG=1
	csrwr	    $t0, LOONGARCH_CSR_CRMD
        li.w        $t0, 0x00
        csrwr       $t0, LOONGARCH_CSR_PRMD
        li.w        $t0, 0x00
        csrwr       $t0, LOONGARCH_CSR_EUEN

        invtlb      0x0,$zero,$zero
	# set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096)
     
        la          $sp, stack0
        li.d        $a0, 1024*4
	csrrd       $a1, LOONGARCH_CSR_CPUID
        addi.d      $tp, $a1, 0
        addi.d      $a1, $a1, 1
        mul.d       $a0, $a0, $a1
        add.d       $sp, $sp, $a0
	# jump to start() in start.c
        bl          main
spin:
        b           spin
