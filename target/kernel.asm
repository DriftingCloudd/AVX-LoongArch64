
target/kernel:     file format elf64-loongarch


Disassembly of section .text:

9000000008000000 <_entry>:
9000000008000000:	1c000043 	pcaddu12i	$r3,2(0x2)
9000000008000004:	28c02063 	ld.d	$r3,$r3,8(0x8)
9000000008000008:	14000024 	lu12i.w	$r4,1(0x1)
900000000800000c:	04008005 	csrrd	$r5,0x20
9000000008000010:	02c000a2 	addi.d	$r2,$r5,0
9000000008000014:	02c004a5 	addi.d	$r5,$r5,1(0x1)
9000000008000018:	001d9484 	mul.d	$r4,$r4,$r5
900000000800001c:	00109063 	add.d	$r3,$r3,$r4
9000000008000020:	54000800 	bl	8(0x8) # 9000000008000028 <main>

9000000008000024 <spin>:
9000000008000024:	50000000 	b	0 # 9000000008000024 <spin>

9000000008000028 <main>:
// static int first = 0;
extern void boot_stack(void);
extern void boot_stack_top(void);
// extern void initlogbuffer(void);
// extern int tcp_start_listen;
void main(unsigned long hartid, unsigned long dtb_pa) {
9000000008000028:	02ffc063 	addi.d	$r3,$r3,-16(0xff0)
900000000800002c:	29c02076 	st.d	$r22,$r3,8(0x8)
9000000008000030:	02c04076 	addi.d	$r22,$r3,16(0x10)

static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("addi.d %0, $tp, 0" : "=r" (x) );
9000000008000034:	02c0004c 	addi.d	$r12,$r2,0
    // started = 1;
    while (1);
    
  } else {
    // other hart
    while (started == 0)
9000000008000038:	1c00026d 	pcaddu12i	$r13,19(0x13)
900000000800003c:	02ff21ad 	addi.d	$r13,$r13,-56(0xfc8)
  if (r_tp() == 0) {
9000000008000040:	44000980 	bnez	$r12,8(0x8) # 9000000008000048 <main+0x20>
    while (1);
9000000008000044:	50000000 	b	0 # 9000000008000044 <main+0x1c>
    while (started == 0)
9000000008000048:	288001ac 	ld.w	$r12,$r13,0
900000000800004c:	43fffd9f 	beqz	$r12,-4(0x7ffffc) # 9000000008000048 <main+0x20>
    //     consoleintr(c);
    //   }
    // }
  }
  // scheduler();
}
9000000008000050:	28c02076 	ld.d	$r22,$r3,8(0x8)
9000000008000054:	02c04063 	addi.d	$r3,$r3,16(0x10)
9000000008000058:	4c000020 	jirl	$r0,$r1,0
	...
