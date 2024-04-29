# Context switch
#
#   void swtch(struct context *old.d, struct context *new);
# 
# Save current registers in old.d. Load from new.	

# The relevant registers have the same names
.globl swtch
swtch:
        sd.d $ra, 0(a0)
        sd.d $sp, 8(a0)
        sd.d $s0, 16(a0)
        sd.d $s1, 24(a0)
        sd.d $s2, 32(a0)
        sd.d $s3, 40(a0)
        sd.d $s4, 48(a0)
        sd.d $s5, 56(a0)
        sd.d $s6, 64(a0)
        sd.d $s7, 72(a0)
        sd.d $s8, 80(a0)
        sd.d $s9, 88(a0)
        sd.d $s10, 96(a0)
        sd.d $s11, 104(a0)

        ld.d $ra, 0(a1)
        ld.d $sp, 8(a1)
        ld.d $s0, 16(a1)
        ld.d $s1, 24(a1)
        ld.d $s2, 32(a1)
        ld.d $s3, 40(a1)
        ld.d $s4, 48(a1)
        ld.d $s5, 56(a1)
        ld.d $s6, 64(a1)
        ld.d $s7, 72(a1)
        ld.d $s8, 80(a1)
        ld.d $s9, 88(a1)
        ld.d $s10, 96(a1)
        ld.d $s11, 104(a1)
        ret

	
.globl threadstub
threadstub:
        add.d $a0, $sp, $zero
        call threadhelper