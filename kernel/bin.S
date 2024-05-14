    .align 4
    .section .data
    .global initcode
    .global initcodesize
initcode:
    # TODO:add the init code here
    # .incbin "./xv6-user/initcode"
    #.incbin "./xv6-user/init-for-test"
    #.incbin "./xv6-user/busybox_test.bin"
codeend:

initcodesize:
    .long codeend-initcode




    