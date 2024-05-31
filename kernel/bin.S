    .align 4
    .section .data
    .global initcode
    .global initcodesize
initcode:
    # .incbin "./user/initcode"
    #.incbin "./user/initcode"
    .incbin "./user/init-for-test"
    #.incbin "./xv6-user/busybox_test.bin"
codeend:

initcodesize:
    .long codeend-initcode




    