# AVX-LoongArch64
AVX是华中科技大学在2023年参加操作系统能力大赛获得二等奖的作品。AVX-LA是基于AVX移植到LoongArch上的操作系统。



setenv ipaddr 10.0.2.15

setenv gatewayip 10.0.2.2

setenv serverip 192.168.200.130

env save

tftpboot 0x9000000008000000 192.168.200.130:kernel.bin

go 0x9000000008000000