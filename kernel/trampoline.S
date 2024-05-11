	#
        # code to switch between user and kernel space.
        #
        # this code is mapped at the same virtual address
        # (TRAMPOLINE) in user and kernel space so that
        # it continues to work when it switches page tables.
	#
	# kernel.ld.d causes this to be aligned
        # to a page boundary.
        #
	.section trampsec
.globl trampoline
trampoline:
.align 4
.globl uservec
uservec:    
	#
        # trap.c sets stvec to point here, so
        # traps from user space start here,
        # in supervisor mode, but with a
        # user page table.
        #
        # sscratch points to where the process's p->trapframe is
        # mapped into user space, at TRAPFRAME.
        #
        
	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        # 交换a0 和 sscratch的位置，交换用户空间和内核空间
        // csrrw a0, sscratch, a0
        
        # save the user registers in TRAPFRAME
        st.d $ra, $a0, 40
        st.d $sp, $a0, 48
        st.d gp, 56(a0)
        st.d tp, 64(a0)
        st.d t0, 72(a0)
        st.d t1, 80(a0)
        st.d t2, 88(a0)
        st.d s0, 96(a0)
        st.d s1, 104(a0)
        st.d a1, 120(a0)
        st.d a2, 128(a0)
        st.d a3, 136(a0)
        st.d a4, 144(a0)
        st.d a5, 152(a0)
        st.d a6, 160(a0)
        st.d a7, 168(a0)
        st.d s2, 176(a0)
        st.d s3, 184(a0)
        st.d s4, 192(a0)
        st.d s5, 200(a0)
        st.d s6, 208(a0)
        st.d s7, 216(a0)
        st.d s8, 224(a0)
        st.d s9, 232(a0)
        st.d s10, 240(a0)
        st.d s11, 248(a0)
        st.d t3, 256(a0)
        st.d t4, 264(a0)
        st.d t5, 272(a0)
        st.d t6, 280(a0)

	# save the user a0 in p->trapframe->a0
        csrr t0, sscratch
        st.d t0, 112(a0)

        # restore kernel stack pointer from p->trapframe->kernel_sp
        ld.d sp, 8(a0)

        # make tp hold.d the current hartid, from p->trapframe->kernel_hartid
        ld.d tp, 32(a0)

        # load the address of usertrap(), p->trapframe->kernel_trap
        ld.d t0, 16(a0)

        # restore kernel page table from p->trapframe->kernel_satp
        ld.d t1, 0(a0)
        csrw satp, t1

        # sfence.vma zero, zero
        sfence.vma

        # a0 is no longer valid, since the kernel page
        # table does not specially map p->tf.

        # jump to usertrap(), which does not return
        jr t0

.globl userret
userret:
        # userret(TRAPFRAME, pagetable)
        # switch from kernel to user.
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.


        csrw satp, a1

        # sfence.vma zero, zero
        sfence.vma
        
        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld.d t0, 112(a0)
        csrw sscratch, t0

        # restore all but a0 from TRAPFRAME
        ld.d ra, 40(a0)
        ld.d sp, 48(a0)
        ld.d gp, 56(a0)
        ld.d tp, 64(a0)
        ld.d t0, 72(a0)
        ld.d t1, 80(a0)
        ld.d t2, 88(a0)
        ld.d s0, 96(a0)
        ld.d s1, 104(a0)
        ld.d a1, 120(a0)
        ld.d a2, 128(a0)
        ld.d a3, 136(a0)
        ld.d a4, 144(a0)
        ld.d a5, 152(a0)
        ld.d a6, 160(a0)
        ld.d a7, 168(a0)
        ld.d s2, 176(a0)
        ld.d s3, 184(a0)
        ld.d s4, 192(a0)
        ld.d s5, 200(a0)
        ld.d s6, 208(a0)
        ld.d s7, 216(a0)
        ld.d s8, 224(a0)
        ld.d s9, 232(a0)
        ld.d s10, 240(a0)
        ld.d s11, 248(a0)
        ld.d t3, 256(a0)
        ld.d t4, 264(a0)
        ld.d t5, 272(a0)
        ld.d t6, 280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
