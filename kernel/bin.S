    .align 4
    .section .data
    .global initcode
    .global initcodesize
initcode:

    # .incbin "./user/initcode"
    .incbin "/home/byte/OCC/AVX-LoongArch64/user/initcode"
    #.incbin "./xv6-user/init-for-test"
    #.incbin "./xv6-user/busybox_test.bin"
codeend:

initcodesize:
    .long codeend-initcode




    