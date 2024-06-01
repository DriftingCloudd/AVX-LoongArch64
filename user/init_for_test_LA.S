# Initial process that execs all.
# This code runs in user space.

#include "include/sysnum.S"

# exec(init, argv)
.globl start
start:
        li.d $a0, 2    # O_RDWR
        li.d   $a1, 1    # console
        li.d $a2, 0
        li.d $a7, SYS_dev
        syscall 0	# dev(O_RDWR, CONSOLE, 0);
        
        li.d $a0, 0
        li.d $a7, SYS_dup
        syscall 0	# dup(0);  #  stdout

        li.d $a0, 0
        li.d $a7, SYS_dup
        syscall 0	# dup(0);  #  stderr
# t_getpid
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_getpid
	la $a0, t_getpid
	la $a1, argv_gatpid
	li.d $a7, SYS_exec
	syscall 0
after_getpid:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_getpid2
	la $a0, t_getpid
	la $a1, argv_gatpid
	li.d $a7, SYS_exec
	syscall 0
after_getpid2:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# t_getppid
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_getppid
	la $a0, t_getppid
	la $a1, argv_getppid
	li.d $a7, SYS_exec
	syscall 0
after_getppid:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# t_gettimeofday
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_gettimeofday
	la $a0, t_gettimeofday
	la $a1, argv_gettimeofday
	li.d $a7, SYS_exec
	syscall 0
after_gettimeofday:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# t_sleep
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_sleep
	la $a0, t_sleep
	la $a1, argv_sleep
	li.d $a7, SYS_exec
	syscall 0
after_sleep:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# wait
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_wait
	la $a0, t_wait
	la $a1, argv_wait
	li.d $a7, SYS_exec
	syscall 0
after_wait:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# fork
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_fork
	la $a0, t_fork
	la $a1, argv_fork   
	li.d $a7, SYS_exec
	syscall 0
after_fork:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# write
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_write
	la $a0, t_write
	la $a1, argv_write
	li.d $a7, SYS_exec
	syscall 0
after_write:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# getcwd
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_getcwd
	la $a0, t_getcwd
	la $a1, argv_getcwd 
	li.d $a7, SYS_exec
	syscall 0
after_getcwd:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# chdir
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_chdir
	la $a0, t_chdir
	la $a1, argv_chdir
	li.d $a7, SYS_exec
	syscall 0
after_chdir:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# dup2
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_dup2
	la $a0, t_dup2
	la $a1, argv_dup2
	li.d $a7, SYS_exec
	syscall 0
after_dup2:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# dup
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_dup
	la $a0, t_dup
	la $a1, argv_dup
	li.d $a7, SYS_exec
	syscall 0
after_dup:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# fstat
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_fstat
	la $a0, t_fstat
	la $a1, argv_fstat  
	li.d $a7, SYS_exec
	syscall 0
after_fstat:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# close
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_close
	la $a0, t_close 
	la $a1, argv_close  
	li.d $a7, SYS_exec
	syscall 0
after_close:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# open
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_open  
	la $a0, t_open  
	la $a1, argv_open   
	li.d $a7, SYS_exec
	syscall 0
after_open:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# read
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_read
	la $a0, t_read
	la $a1, argv_read   
	li.d $a7, SYS_exec
	syscall 0
after_read:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# mkdir_
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_mkdir_
	la $a0, t_mkdir_
	la $a1, argv_mkdir_
	li.d $a7, SYS_exec
	syscall 0
after_mkdir_:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# mount
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_mount
	la $a0, t_mount
	la $a1, argv_mount
	li.d $a7, SYS_exec
	syscall 0
after_mount:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

#  umount
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_umount
	la $a0, t_umount
	la $a1, argv_umount
	li.d $a7, SYS_exec
	syscall 0
after_umount:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# yield
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_yield
	la $a0, t_yield
	la $a1, argv_yield
	li.d $a7, SYS_exec
	syscall 0
after_yield:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# openat
# 	li.d $a7, SYS_fork
# 	syscall 0
# 	bne $a0, $zero, after_openat
# 	la $a0, t_openat
# 	la $a1, argv_openat
# 	li.d $a7, SYS_exec
# 	syscall 0
# after_openat:
# 	li.d $a0, 0
# 	li.d $a7, SYS_wait
# 	syscall 0

# waitpid
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_waitpid
	la $a0, t_waitpid
	la $a1, argv_waitpid
	li.d $a7, SYS_exec
	syscall 0
after_waitpid:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# clone
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_clone
	la $a0, t_clone
	la $a1, argv_clone
	li.d $a7, SYS_exec
	syscall 0
after_clone:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# unlink
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_unlink
	la $a0, t_unlink
	la $a1, argv_unlink
	li.d $a7, SYS_exec
	syscall 0
after_unlink:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# exit
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_exit
	la $a0, t_exit
	la $a1, argv_exit
	li.d $a7, SYS_exec
	syscall 0
after_exit:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# times
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_times
	la $a0, t_times
	la $a1, argv_times
	li.d $a7, SYS_exec
	syscall 0
after_times:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# execve
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_execve
	la $a0, t_execve
	la $a1, argv_execve
	li.d $a7, SYS_exec
	syscall 0
after_execve:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# uname
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_uname
	la $a0, t_uname
	la $a1, argv_uname
	li.d $a7, SYS_exec
	syscall 0
after_uname:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# mmap
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_mmap
	la $a0, t_mmap
	la $a1, argv_mmap
	li.d $a7, SYS_exec
	syscall 0
after_mmap:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# brk
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_brk
	la $a0, t_brk
	la $a1, argv_brk
	li.d $a7, SYS_exec
	syscall 0
after_brk:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# munmap
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_munmap    
	la $a0, t_munmap
	la $a1, argv_munmap
	li.d $a7, SYS_exec
	syscall 0
after_munmap:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# pipe
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_pipe  
	la $a0, t_pipe  
	la $a1, argv_pipe
	li.d $a7, SYS_exec
	syscall 0
after_pipe:
	li.d $a0, 0
	li.d $a7, SYS_wait
	syscall 0

# getdents
	li.d $a7, SYS_fork
	syscall 0
	bne $a0, $zero, after_getdents
	la $a0, t_getdents  
	la $a1, argv_getdents
	li.d $a7, SYS_exec
	syscall 0
after_getdents:
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

# tests paraments
t_brk:
	.string "/brk\0"
argv_brk:
	.dword t_brk
	.dword 0

t_chdir:
	.string "/chdir\0"
argv_chdir:
	.dword t_chdir
	.dword 0

t_clone:
	.string "/clone\0"
argv_clone:
	.dword t_brk
	.dword 0

t_close:
    .string "/close\0"
argv_close:
    .dword t_close
    .dword 0

t_dup:
    .string "/dup\0"
argv_dup:
    .dword t_dup
    .dword 0

t_dup2:
    .string "/dup2\0"
argv_dup2:
    .dword t_dup2
    .dword 0

t_execve:
    .string "/execve\0"
argv_execve:
    .dword t_execve
    .dword 0

t_exit:
    .string "/exit\0"
argv_exit:
    .dword t_exit
    .dword 0    

t_fork:
    .string "/fork\0"
argv_fork:
    .dword t_fork
    .dword 0

t_fstat:
    .string "/fstat\0"
argv_fstat:
    .dword t_fstat
    .dword 0

t_getcwd:
    .string "/getcwd\0"
argv_getcwd:
    .dword t_getcwd
    .dword 0

t_getdents:
    .string "/getdents\0"
argv_getdents:
    .dword t_getdents
    .dword 0

t_getpid:
    .string "/getpid\0"
argv_gatpid:
    .dword t_getpid
    .dword 0

t_getppid:
    .string "/getppid\0"
argv_getppid:
    .dword t_getppid
    .dword 0

t_gettimeofday:
    .string "/gettimeofday\0"
argv_gettimeofday:
    .dword t_gettimeofday
    .dword 0

t_mkdir_:
    .string "/mkdir_\0"
argv_mkdir_:
    .dword t_mkdir_
    .dword 0

t_mmap:
    .string "/mmap\0"
argv_mmap:
    .dword t_mmap
    .dword 0

t_munmap:
    .string "/munmap\0"     
argv_munmap:    
    .dword t_munmap
    .dword 0

t_mount:
    .string "/mount\0"
argv_mount: 
    .dword t_mount
    .dword 0

t_open: 
    .string "/open\0"
argv_open:  
    .dword t_open
    .dword 0

t_openat:
    .string "/openat\0"
argv_openat:    
    .dword t_openat
    .dword 0

t_pipe:
    .string "/pipe\0"
argv_pipe:  
    .dword t_pipe
    .dword 0  

t_read: 
    .string "/read\0"
argv_read:
    .dword t_read
    .dword 0    

t_sleep:
    .string "/sleep\0"  
argv_sleep: 
    .dword t_sleep
    .dword 0

t_times:
    .string "/times\0"
argv_times:
    .dword t_times
    .dword 0

t_umount:
    .string "/umount\0"
argv_umount:
    .dword t_umount
    .dword 0


t_uname:
    .string "/uname\0"
argv_uname:
    .dword t_uname
    .dword 0

t_unlink:
    .string "/unlink\0"
argv_unlink:
    .dword t_unlink
    .dword 0

t_wait:
    .string "/wait\0"
argv_wait:
    .dword t_wait
    .dword 0

t_waitpid:
    .string "/waitpid\0"
argv_waitpid:
    .dword t_waitpid
    .dword 0

t_write:
    .string "/write\0"
argv_write:
    .dword t_write
    .dword 0    

t_yield:
    .string "/yield\0"
argv_yield: 
    .dword t_yield
    .dword 0





