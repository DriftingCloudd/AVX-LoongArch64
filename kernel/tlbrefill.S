#include "include/loongarchregs.S"

.section tlbrentry
.globl handle_tlbr
.align 0x4
handle_tlbr:
	csrwr	$t0, LOONGARCH_CSR_TLBRSAVE
	csrrd   $t0, LOONGARCH_CSR_ECFG
	csrrd   $t0, LOONGARCH_CSR_ESTAT
	csrrd   $t0, LOONGARCH_CSR_ERAISE
	csrrd   $t0, LOONGARCH_CSR_BADV 
	csrrd   $t0, LOONGARCH_CSR_BADI

	csrrd   $t0, LOONGARCH_CSR_STLBPS
	csrrd   $t0, LOONGARCH_CSR_PRCFG1
	csrrd	$t0, LOONGARCH_CSR_PRCFG2
	csrrd	$t0, LOONGARCH_CSR_PRCFG3

	csrrd   $t0, LOONGARCH_CSR_TLBRBADV
	csrrd   $t0, LOONGARCH_CSR_TLBRERA

	csrrd	$t0, LOONGARCH_CSR_PGD
	# lddir	$t0, $t0, 4
	# addi.d  $t0, $t0, -1
	lddir	$t0, $t0, 3
 	addi.d  $t0, $t0, -1
	lddir	$t0, $t0, 2
	addi.d  $t0, $t0, -1
	lddir   $t0, $t0, 1
	addi.d  $t0, $t0, -1
	ldpte	$t0, 0
	ldpte	$t0, 1
	tlbfill
	csrrd   $t0, LOONGARCH_CSR_TLBREHI
	csrrd   $t0, LOONGARCH_CSR_TLBRELO0
	csrrd   $t0, LOONGARCH_CSR_TLBRELO1
	csrrd	$t0, LOONGARCH_CSR_TLBRSAVE
	ertn
	
