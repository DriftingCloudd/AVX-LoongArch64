	.section .signalTrampoline
    .globl signalTrampoline
    .align 12
signalTrampoline:
    li.d $a7, 139
    syscall 0