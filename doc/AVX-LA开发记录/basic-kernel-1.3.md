# basic-kernel-V1.3
made by 袁良卿 driftingcloudd@outlook.com
## 一 修改内容
proc.c 
注释了exit()对printf.c的checkup1()的调用

console.c console.h
增加了consoleread() consolewrite() ，完善consoleintr() 还未仔细检查代码

uart.c uart.h
增加uartputc() uartstart() uartintr() 还未仔细检查代码

file.c file.h
替换成了AVX对应的文件