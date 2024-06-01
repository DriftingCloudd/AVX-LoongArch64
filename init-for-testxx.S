# Initial process that execs all.
# This code runs in user space.

#include "include/sysnum.h"

# exec(init, argv)
.globl start
start:
        li.d $a0, 2    //O_RDWR
        la $a1, 1    //console
        li.d $a2, 0
        li.d $a7, SYS_dev
        syscall 0	# dev(O_RDWR, CONSOLE, 0);
        
        li.d $a0, 0
        li.d $a7, SYS_dup
        syscall 0	# dup(0);  // stdout

        li.d $a0, 0
        li.d $a7, SYS_dup
        syscall 0	# dup(0);  // stderr
//运行time_test
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_time_test
	la $a0, time_test
	la $a1, argv_time_test
	li.d $a7, SYS_exec
	syscall 0
after_time_test:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

//输出echo "run busybox_testcode.sh"
//echo_run_busybox_testcode
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_echo_run_busybox_testcode
	la $a0, busybox
	la $a1, argv_echo_run_busybox_testcode
	li.d $a7, SYS_exec
	syscall 0
after_echo_run_busybox_testcode:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_0
	la $a0, busybox
	la $a1, argv_busybox_0
	li.d $a7, SYS_exec
	syscall 0
after_0:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_1
	la $a0, busybox
	la $a1, argv_busybox_1
	li.d $a7, SYS_exec
	syscall 0
after_1:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_2
	la $a0, busybox
	la $a1, argv_busybox_2
	li.d $a7, SYS_exec
	syscall 0
after_2:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_3
	la $a0, busybox
	la $a1, argv_busybox_3
	li.d $a7, SYS_exec
	syscall 0
after_3:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_4
	la $a0, busybox
	la $a1, argv_busybox_4
	li.d $a7, SYS_exec
	syscall 0
after_4:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_5
	la $a0, busybox
	la $a1, argv_busybox_5
	li.d $a7, SYS_exec
	syscall 0
after_5:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_6
	la $a0, busybox
	la $a1, argv_busybox_6
	li.d $a7, SYS_exec
	syscall 0
after_6:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_7
	la $a0, busybox
	la $a1, argv_busybox_7
	li.d $a7, SYS_exec
	syscall 0
after_7:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_8
	la $a0, busybox
	la $a1, argv_busybox_8
	li.d $a7, SYS_exec
	syscall 0
after_8:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_9
	la $a0, busybox
	la $a1, argv_busybox_9
	li.d $a7, SYS_exec
	syscall 0
after_9:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_10
	la $a0, busybox
	la $a1, argv_busybox_10
	li.d $a7, SYS_exec
	syscall 0
after_10:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_11
	la $a0, busybox
	la $a1, argv_busybox_11
	li.d $a7, SYS_exec
	syscall 0
after_11:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_12
	la $a0, busybox
	la $a1, argv_busybox_12
	li.d $a7, SYS_exec
	syscall 0
after_12:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_13
	la $a0, busybox
	la $a1, argv_busybox_13
	li.d $a7, SYS_exec
	syscall 0
after_13:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_14
	la $a0, busybox
	la $a1, argv_busybox_14
	li.d $a7, SYS_exec
	syscall 0
after_14:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_15
	la $a0, busybox
	la $a1, argv_busybox_15
	li.d $a7, SYS_exec
	syscall 0
after_15:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_16
	la $a0, busybox
	la $a1, argv_busybox_16
	li.d $a7, SYS_exec
	syscall 0
after_16:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_17
	la $a0, busybox
	la $a1, argv_busybox_17
	li.d $a7, SYS_exec
	syscall 0
after_17:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_18
	la $a0, busybox
	la $a1, argv_busybox_18
	li.d $a7, SYS_exec
	syscall 0
after_18:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_19
	la $a0, busybox
	la $a1, argv_busybox_19
	li.d $a7, SYS_exec
	syscall 0
after_19:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_20
	la $a0, busybox
	la $a1, argv_busybox_20
	li.d $a7, SYS_exec
	syscall 0
after_20:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_21
	la $a0, busybox
	la $a1, argv_busybox_21
	li.d $a7, SYS_exec
	syscall 0
after_21:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_22
	la $a0, busybox
	la $a1, argv_busybox_22
	li.d $a7, SYS_exec
	syscall 0
after_22:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_23
	la $a0, busybox
	la $a1, argv_busybox_23
	li.d $a7, SYS_exec
	syscall 0
after_23:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_24
	la $a0, busybox
	la $a1, argv_busybox_24
	li.d $a7, SYS_exec
	syscall 0
after_24:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_25
	la $a0, busybox
	la $a1, argv_busybox_25
	li.d $a7, SYS_exec
	syscall 0
after_25:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_26
	la $a0, busybox
	la $a1, argv_busybox_26
	li.d $a7, SYS_exec
	syscall 0
after_26:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_27
	la $a0, busybox
	la $a1, argv_busybox_27
	li.d $a7, SYS_exec
	syscall 0
after_27:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_28
	la $a0, busybox
	la $a1, argv_busybox_28
	li.d $a7, SYS_exec
	syscall 0
after_28:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_29
	la $a0, busybox
	la $a1, argv_busybox_29
	li.d $a7, SYS_exec
	syscall 0
after_29:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_30
	la $a0, busybox
	la $a1, argv_busybox_30
	li.d $a7, SYS_exec
	syscall 0
after_30:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_31
	la $a0, busybox
	la $a1, argv_busybox_31
	li.d $a7, SYS_exec
	syscall 0
after_31:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_32
	la $a0, busybox
	la $a1, argv_busybox_32
	li.d $a7, SYS_exec
	syscall 0
after_32:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_33
	la $a0, busybox
	la $a1, argv_busybox_33
	li.d $a7, SYS_exec
	syscall 0
after_33:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_34
	la $a0, busybox
	la $a1, argv_busybox_34
	li.d $a7, SYS_exec
	syscall 0
after_34:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_35
	la $a0, busybox
	la $a1, argv_busybox_35
	li.d $a7, SYS_exec
	syscall 0
after_35:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_36
	la $a0, busybox
	la $a1, argv_busybox_36
	li.d $a7, SYS_exec
	syscall 0
after_36:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_37
	la $a0, busybox
	la $a1, argv_busybox_37
	li.d $a7, SYS_exec
	syscall 0
after_37:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_38
	la $a0, busybox
	la $a1, argv_busybox_38
	li.d $a7, SYS_exec
	syscall 0
after_38:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_39
	la $a0, busybox
	la $a1, argv_busybox_39
	li.d $a7, SYS_exec
	syscall 0
after_39:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_40
	la $a0, busybox
	la $a1, argv_busybox_40
	li.d $a7, SYS_exec
	syscall 0
after_40:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_41
	la $a0, busybox
	la $a1, argv_busybox_41
	li.d $a7, SYS_exec
	syscall 0
after_41:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_42
	la $a0, busybox
	la $a1, argv_busybox_42
	li.d $a7, SYS_exec
	syscall 0
after_42:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_43
	la $a0, busybox
	la $a1, argv_busybox_43
	li.d $a7, SYS_exec
	syscall 0
after_43:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_44
	la $a0, busybox
	la $a1, argv_busybox_44
	li.d $a7, SYS_exec
	syscall 0
after_44:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_45
	la $a0, busybox
	la $a1, argv_busybox_45
	li.d $a7, SYS_exec
	syscall 0
after_45:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_46
	la $a0, busybox
	la $a1, argv_busybox_46
	li.d $a7, SYS_exec
	syscall 0
after_46:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_47
	la $a0, busybox
	la $a1, argv_busybox_47
	li.d $a7, SYS_exec
	syscall 0
after_47:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_48
	la $a0, busybox
	la $a1, argv_busybox_48
	li.d $a7, SYS_exec
	syscall 0
after_48:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_49
	la $a0, busybox
	la $a1, argv_busybox_49
	li.d $a7, SYS_exec
	syscall 0
after_49:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_50
	la $a0, busybox
	la $a1, argv_busybox_50
	li.d $a7, SYS_exec
	syscall 0
after_50:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_51
	la $a0, busybox
	la $a1, argv_busybox_51
	li.d $a7, SYS_exec
	syscall 0
after_51:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_52
	la $a0, busybox
	la $a1, argv_busybox_52
	li.d $a7, SYS_exec
	syscall 0
after_52:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_53
	la $a0, busybox
	la $a1, argv_busybox_53
	li.d $a7, SYS_exec
	syscall 0
after_53:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_54
	la $a0, busybox
	la $a1, argv_busybox_54
	li.d $a7, SYS_exec
	syscall 0
after_54:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

loop:
        bl loop

# for(;;) exit();
program_exit:
        li.d $a7, SYS_exit
        syscall 0
        bl program_exit

time_test:
	.string "/time-test\0"
argv_time_test:
	.quad time_test
	.quad 0

#echo "run busybox_testcode.sh"
param_busybox_testcode0:
	.string "echo\0"
param_busybox_testcode1:
	.string "busybox_testcode.sh\0"

argv_echo_run_busybox_testcode:
	.quad busybox
	.quad param_busybox_testcode0
	.quad param_busybox_testcode1
	.quad 0

busybox:
    .string "/busybox\0"
param00:
	.string "echo\0"
param01:
	.string "#### independent command test\0"
argv_busybox_0:
	.quad busybox
	.quad param00
	.quad param01
	.quad 0
param10:
	.string "ash\0"
param11:
	.string "-c\0"
param12:
	.string "exit\0"
argv_busybox_1:
	.quad busybox
	.quad param10
	.quad param11
	.quad param12
	.quad 0
param20:
	.string "sh\0"
param21:
	.string "-c\0"
param22:
	.string "exit\0"
argv_busybox_2:
	.quad busybox
	.quad param20
	.quad param21
	.quad param22
	.quad 0
param30:
	.string "basename\0"
param31:
	.string "/aaa/bbb\0"
argv_busybox_3:
	.quad busybox
	.quad param30
	.quad param31
	.quad 0
param40:
	.string "cal\0"
argv_busybox_4:
	.quad busybox
	.quad param40
	.quad 0
param50:
	.string "clear\0"
argv_busybox_5:
	.quad busybox
	.quad param50
	.quad 0
param60:
	.string "date\0"
argv_busybox_6:
	.quad busybox
	.quad param60
	.quad 0
param70:
	.string "df\0"
argv_busybox_7:
	.quad busybox
	.quad param70
	.quad 0
param80:
	.string "dirname\0"
param81:
	.string "/aaa/bbb\0"
argv_busybox_8:
	.quad busybox
	.quad param80
	.quad param81
	.quad 0
param90:
	.string "dmesg\0"
argv_busybox_9:
	.quad busybox
	.quad param90
	.quad 0
param100:
	.string "du\0"
argv_busybox_10:
	.quad busybox
	.quad param100
	.quad 0
param110:
	.string "expr\0"
param111:
	.string "1\0"
param112:
	.string "+\0"
param113:
	.string "1\0"
argv_busybox_11:
	.quad busybox
	.quad param110
	.quad param111
	.quad param112
	.quad param113
	.quad 0
param120:
	.string "false\0"
argv_busybox_12:
	.quad busybox
	.quad param120
	.quad 0
param130:
	.string "true\0"
argv_busybox_13:
	.quad busybox
	.quad param130
	.quad 0
param140:
	.string "which\0"
param141:
	.string "ls\0"
argv_busybox_14:
	.quad busybox
	.quad param140
	.quad param141
	.quad 0
param150:
	.string "uname\0"
argv_busybox_15:
	.quad busybox
	.quad param150
	.quad 0
param160:
	.string "uptime\0"
argv_busybox_16:
	.quad busybox
	.quad param160
	.quad 0
param170:
	.string "printf\0"
param171:
	.string "abc\n\0"
argv_busybox_17:
	.quad busybox
	.quad param170
	.quad param171
	.quad 0
param180:
	.string "ps\0"
argv_busybox_18:
	.quad busybox
	.quad param180
	.quad 0
param190:
	.string "pwd\0"
argv_busybox_19:
	.quad busybox
	.quad param190
	.quad 0
param200:
	.string "free\0"
argv_busybox_20:
	.quad busybox
	.quad param200
	.quad 0
param210:
	.string "hwclock\0"
argv_busybox_21:
	.quad busybox
	.quad param210
	.quad 0
param220:
	.string "kill\0"
param221:
	.string "10\0"
argv_busybox_22:
	.quad busybox
	.quad param220
	.quad param221
	.quad 0
param230:
	.string "ls\0"
argv_busybox_23:
	.quad busybox
	.quad param230
	.quad 0
param240:
	.string "sleep\0"
param241:
	.string "1\0"
argv_busybox_24:
	.quad busybox
	.quad param240
	.quad param241
	.quad 0
param250:
	.string "echo\0"
param251:
	.string "#### file opration test\0"
argv_busybox_25:
	.quad busybox
	.quad param250
	.quad param251
	.quad 0
param260:
	.string "touch\0"
param261:
	.string "test.txt\0"
argv_busybox_26:
	.quad busybox
	.quad param260
	.quad param261
	.quad 0
param270:
	.string "echo\0"
param271:
	.string "hello world\0"
param272:
	.string ">\0"
param273:
	.string "test.txt\0"
argv_busybox_27:
	.quad busybox
	.quad param270
	.quad param271
	.quad param272
	.quad param273
	.quad 0
param280:
	.string "cat\0"
param281:
	.string "test.txt\0"
argv_busybox_28:
	.quad busybox
	.quad param280
	.quad param281
	.quad 0
param290:
	.string "cut\0"
param291:
	.string "-c\0"
param292:
	.string "3\0"
param293:
	.string "test.txt\0"
argv_busybox_29:
	.quad busybox
	.quad param290
	.quad param291
	.quad param292
	.quad param293
	.quad 0
param300:
	.string "od\0"
param301:
	.string "test.txt\0"
argv_busybox_30:
	.quad busybox
	.quad param300
	.quad param301
	.quad 0
param310:
	.string "head\0"
param311:
	.string "test.txt\0"
argv_busybox_31:
	.quad busybox
	.quad param310
	.quad param311
	.quad 0
param320:
	.string "tail\0"
param321:
	.string "test.txt\0"
argv_busybox_32:
	.quad busybox
	.quad param320
	.quad param321
	.quad 0
param330:
	.string "hexdump\0"
param331:
	.string "-C\0"
param332:
	.string "test.txt\0"
argv_busybox_33:
	.quad busybox
	.quad param330
	.quad param331
	.quad param332
	.quad 0
param340:
	.string "md5sum\0"
param341:
	.string "test.txt\0"
argv_busybox_34:
	.quad busybox
	.quad param340
	.quad param341
	.quad 0
param350:
	.string "echo\0"
param351:
	.string "ccccccc\0"
param352:
	.string ">>\0"
param353:
	.string "test.txt\0"
argv_busybox_35:
	.quad busybox
	.quad param350
	.quad param351
	.quad param352
	.quad param353
	.quad 0
param360:
	.string "echo\0"
param361:
	.string "bbbbbbb\0"
param362:
	.string ">>\0"
param363:
	.string "test.txt\0"
argv_busybox_36:
	.quad busybox
	.quad param360
	.quad param361
	.quad param362
	.quad param363
	.quad 0
param370:
	.string "echo\0"
param371:
	.string "aaaaaaa\0"
param372:
	.string ">>\0"
param373:
	.string "test.txt\0"
argv_busybox_37:
	.quad busybox
	.quad param370
	.quad param371
	.quad param372
	.quad param373
	.quad 0
param380:
	.string "echo\0"
param381:
	.string "2222222\0"
param382:
	.string ">>\0"
param383:
	.string "test.txt\0"
argv_busybox_38:
	.quad busybox
	.quad param380
	.quad param381
	.quad param382
	.quad param383
	.quad 0
param390:
	.string "echo\0"
param391:
	.string "1111111\0"
param392:
	.string ">>\0"
param393:
	.string "test.txt\0"
argv_busybox_39:
	.quad busybox
	.quad param390
	.quad param391
	.quad param392
	.quad param393
	.quad 0
param400:
	.string "echo\0"
param401:
	.string "bbbbbbb\0"
param402:
	.string ">>\0"
param403:
	.string "test.txt\0"
argv_busybox_40:
	.quad busybox
	.quad param400
	.quad param401
	.quad param402
	.quad param403
	.quad 0
param410:
	.string "sort\0"
param411:
	.string "test.txt\0"
param412:
	.string "|\0"
param413:
	.string "./busybox\0"
param414:
	.string "uniq\0"
argv_busybox_41:
	.quad busybox
	.quad param410
	.quad param411
	.quad param412
	.quad param413
	.quad param414
	.quad 0
param420:
	.string "stat\0"
param421:
	.string "test.txt\0"
argv_busybox_42:
	.quad busybox
	.quad param420
	.quad param421
	.quad 0
param430:
	.string "strings\0"
param431:
	.string "test.txt\0"
argv_busybox_43:
	.quad busybox
	.quad param430
	.quad param431
	.quad 0
param440:
	.string "wc\0"
param441:
	.string "test.txt\0"
argv_busybox_44:
	.quad busybox
	.quad param440
	.quad param441
	.quad 0
param450:
	.string "[\0"
param451:
	.string "-f\0"
param452:
	.string "test.txt\0"
param453:
	.string "]\0"
argv_busybox_45:
	.quad busybox
	.quad param450
	.quad param451
	.quad param452
	.quad param453
	.quad 0
param460:
	.string "more\0"
param461:
	.string "test.txt\0"
argv_busybox_46:
	.quad busybox
	.quad param460
	.quad param461
	.quad 0
param470:
	.string "rm\0"
param471:
	.string "test.txt\0"
argv_busybox_47:
	.quad busybox
	.quad param470
	.quad param471
	.quad 0
param480:
	.string "mkdir\0"
param481:
	.string "test_dir\0"
argv_busybox_48:
	.quad busybox
	.quad param480
	.quad param481
	.quad 0
param490:
	.string "mv\0"
param491:
	.string "test_dir\0"
param492:
	.string "test\0"
argv_busybox_49:
	.quad busybox
	.quad param490
	.quad param491
	.quad param492
	.quad 0
param500:
	.string "rmdir\0"
param501:
	.string "test\0"
argv_busybox_50:
	.quad busybox
	.quad param500
	.quad param501
	.quad 0
param510:
	.string "grep\0"
param511:
	.string "hello\0"
param512:
	.string "busybox_cmd.txt\0"
argv_busybox_51:
	.quad busybox
	.quad param510
	.quad param511
	.quad param512
	.quad 0
param520:
	.string "cp\0"
param521:
	.string "busybox_cmd.txt\0"
param522:
	.string "busybox_cmd.bak\0"
argv_busybox_52:
	.quad busybox
	.quad param520
	.quad param521
	.quad param522
	.quad 0
param530:
	.string "rm\0"
param531:
	.string "busybox_cmd.bak\0"
argv_busybox_53:
	.quad busybox
	.quad param530
	.quad param531
	.quad 0
param540:
	.string "find\0"
param541:
	.string "-name\0"
param542:
	.string "busybox_cmd.txt\0"
argv_busybox_54:
	.quad busybox
	.quad param540
	.quad param541
	.quad param542
	.quad 0



