    .align 4
    .section .data
    .global initcode
    .global initcodesize
initcode:
    # .incbin "./user/initcode"
    #.incbin "./user/initcode"
    # .incbin "./user/init-for-test"
    .incbin "./user/init_for_test_LA"
    #.incbin "./xv6-user/busybox_test.bin"
codeend:

initcodesize:
    .long codeend-initcode




    