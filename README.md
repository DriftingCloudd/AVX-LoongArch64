# AVX-LoongArch64
AVX是华中科技大学在2023年参加操作系统能力大赛获得二等奖的作品。AVX-LA是基于AVX在LoongArch上开发的操作系统。


## 开发以及调试环境
AVX-LA在操作系统能力大赛提供的[2k1000模拟器](https://github.com/LoongsonLab/2k1000-materials/releases/tag/qemu-static-20240526)上开发,LoongArch的交叉编译工具链则是基于gcc-13.2.0的[交叉编译工具](https://github.com/LoongsonLab/oscomp-toolchains-for-oskernel/releases/tag/gcc-13.2.0-loongarch64)

## 项目构建
```bash
make all
```
即可在target目录下生成相应的二进制文件与elf文件。详细的参数设定可见makefile文件

## 文档
doc目录下包含所有的文档，包括但不限于各种笔记、开发记录、[kernel介绍](doc/内核介绍/README.md)

**有疑问请联系driftingcloudd@outlook.com**