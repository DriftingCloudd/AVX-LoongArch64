# 文件结构
这个文件介绍各个文件夹与文件的内容
## /doc
各种文档资源
## /kernel
kernel文件
- console.c 终端与UART之间的交互
- enrty.S 入口函数
- intr.c 中断栈式开启与关闭机制的实现
- main.c 主函数
- printf.c 实现终端中的标准输出
- proc.c 进程 cpu等数据结构的操作。目前只实现了cpu的操作
- spinlock.c 互斥锁相关函数的定义
- string.c 自实现的string操作
- uart.c uart的操作
### /kernel/include
kernel头文件 
- console.h console.c中的函数定义
- context.h 线程切换时的上下文数据结构定义
- intr.h intr.c中函数定义
- loongarchregs.h loongarch通用寄存器与一些常用的csr寄存器的定义
- loongarch.h loongarch寄存器操作等的宏定义。之后可能还会细分
- memlayout.h 地址段的映射
- param.h 硬件参数的设定
- printf.h printf.c中定义的函数
- spinlock.h spinlock数据结构定义 spinlock.c中函数定义
- string.h string.c中的函数定义
- types.h 数据类型的简化定义。一般使用内联函数的新式被其他函数引用
- uart.h 基于uart16650的宏定义 uart.c中的函数定义


# /user
用户工具,包括用户库等

# /target



Makefile
