# basic-kernel-V1.1
made by 袁良卿

## 总结：
打印字符串的实现 spinlock的实现 memlayout与para的设置 intr栈式中断的实现  cpu数据结构与函数的定义 uart16650的实现 终端的部分功能的实现

## 对以下的文件进行了移植与修改
- memlayout.h 部分移植
这个文件现阶段来说硬件映射没有问题

- para.h 完全移植
用于kernel的参数应该不需要修改多少

- printf.c printf.h   部分移植
printf()实现在终端打印字符（通过测试） panic()未进行测试 还有一些调试用的函数未进行移植。以后可以考虑完善
 
- spinlock.c spinlock.h  完全移植
完成移植。现阶段的测试未出现问题 spinlock.c中减少了include的文件，其余基本上没变

- intr.c intr.h 完全移植
完全移植。现阶段测试未出现问题。完成了栈式开关中断功能的实现。现阶段的测试未出现问题

- proc.c proc.h 部分移植
在proc.h中只对cpu的结构进行了定义 proc.c中只完成了mycpu()与cpuid()

- console.c  console.h 部分移植
定义了cons，作为console系统的控制器。完全实现了consputc()并进行了实现， consoleinit()完成了部分功能（有一些文件系统相关的初始化没完成） 其余的与文件系统 中断相关的内容未进行移植  

- uart.c uart.h 部分移植   
uart.c 定义了uartinit() void uartputc_sync(int c) int uartgetc(void) 定义了用于文件系统的锁和buffer 其他的没实现。即与文件系统和中断的函数没实现

## 备注
有这些文件的依赖关系图。有问题可以联系我