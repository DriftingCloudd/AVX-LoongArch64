# platform	:= visionfive
platform	:= ramdisk
mode 		:= 
# mode 		:= release

K=kernel
U=user
T=target
I=include
IMG=sdcard_loongarch
linker = ld/kernel.ld
initcode-ld = ld/initcode.ld

# this is for sdcard.h, not used in target all
imgname = new_sdcard.img
headername = sdcard.h
sdcard_img = $(K)/$(IMG)/$(imgname)
sdcard_h = $(K)/$(I)/$(headername)


OBJS += \
  $K/entry.o \
  $K/printf.o \
  $K/extioi.o \
  $K/console.o \
  $K/uart.o \
  $K/intr.o \
  $K/spinlock.o \
  $K/string.o \
  $K/main.o \
  $K/bin.o \
  $K/proc.o \
  $K/kalloc.o \
  $K/vm.o \
  $K/swtch.o \
  $K/apic.o \
  $K/uservec.o \
  $K/tlbrefill.o \
  $K/merror.o \
  $K/ring_buffer.o \
  $K/kernelvec.o \
  $K/file.o \
  $K/trap.o \
  $K/syscall.o \
  $K/sysproc.o \
  $K/sysfile.o \
  $K/exec.o \
  $K/pipe.o \
  $K/bio.o \
  $K/sleeplock.o \
  $K/disk.o \
  $K/fat32.o \
  $K/timer.o \
  $K/mmap.o \
  $K/vma.o \
  $K/signal.o \
  $K/syssig.o \
  $K/systime.o \
  $K/SignalTrampoline.o \
  $K/gdbdebug.o \

ifeq ($(platform), qemu)
OBJS += \
  $K/virtio_disk.o \
endif

TOOLPREFIX	:= loongarch64-linux-gnu-

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)as
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

ASFLAGS = -march=loongarch64 -mabi=lp64s
CFLAGS = -Wall  -O -fno-omit-frame-pointer -ggdb -g
CFLAGS += -MD
CFLAGS += -march=loongarch64 -mabi=lp64s
CFLAGS += -ffreestanding -fno-common -nostdlib
CFLAGS += -fno-pie -no-pie
CFLAGS += -fno-stack-protector
FLAGS += -I.
CFLAGS += -Ikernel/include
CFLAGS += -I.kernel -I.

ifeq ($(mode), debug) 
CFLAGS += -DDEBUG 
endif 

ifeq ($(platform), qemu)
CFLAGS += -D QEMU
else ifeq ($(platform), ramdisk)
OBJS += $K/ramdisk.o
OBJS += $K/sddata.o 
endif

LDFLAGS = -z max-page-size=4096 

all:
	@make build 

$T/kernel: $(OBJS) $(linker) 
	if [ ! -d "./target" ]; then mkdir target; fi
	$(LD) $(LDFLAGS) -T $(linker) -o $T/kernel $(OBJS)
	$(OBJDUMP) -S $T/kernel > $T/kernel.asm
	$(OBJDUMP) -t $T/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $T/kernel.sym
	$(OBJCOPY) -O binary $T/kernel ./kernel.bin


build: userprogs $T/kernel 
	$(OBJCOPY) $T/kernel --strip-all -O binary $(image)

image = $T/kernel.bin


$K/bin.S:$U/initcode $U/init-for-test $U/init_for_test_LA


$U/initcode: $U/initcode.S
	$(CC) $(CFLAGS) -nostdinc -I. -Ikernel -c $U/initcode.S -o $U/initcode.o
	$(LD) $(LDFLAGS) -N -e start -Ttext-segment 0 -T$(initcode-ld) -o $U/initcode.out $U/initcode.o
	$(OBJCOPY) -S -O binary $U/initcode.out $U/initcode
	$(OBJDUMP) -S $U/initcode.o > $U/initcode.asm

$U/init-for-test: $U/init-for-test.S
	$(CC) $(CFLAGS) -nostdinc -I. -Ikernel -c $U/init-for-test.S -o $U/init-for-test.o
	$(LD) $(LDFLAGS) -N -e start -Ttext-segment 0 -T$(initcode-ld) -o $U/init-for-test.out $U/init-for-test.o
	$(OBJCOPY) -S -O binary $U/init-for-test.out $U/init-for-test
	$(OBJDUMP) -S $U/init-for-test.o > $U/init-for-test.asm

$U/init_for_test_LA: $U/init_for_test_LA.S
	$(CC) $(CFLAGS) -nostdinc -I. -Ikernel -c $U/init_for_test_LA.S -o $U/init_for_test_LA.o
	$(LD) $(LDFLAGS) -N -e start -Ttext-segment 0 -T$(initcode-ld) -o $U/init_for_test_LA.out $U/init_for_test_LA.o
	$(OBJCOPY) -S -O binary $U/init_for_test_LA.out $U/init_for_test_LA
	$(OBJDUMP) -S $U/init_for_test_LA.o > $U/init_for_test_LA.asm


tags: $(OBJS) _init
	etags *.S *.c

ULIB = $U/ulib.o $U/usys.o $U/printf.o $U/umalloc.o

_%: %.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext-segment 0 -T$(initcode-ld) -o $@ $^
	$(OBJDUMP) -S $@ > $*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $*.sym

$U/usys.S : $U/usys.pl
	perl $U/usys.pl > $U/usys.S

$U/usys.o : $U/usys.S
	$(CC) $(CFLAGS) -c -o $U/usys.o $U/usys.S

$U/_forktest: $U/forktest.o $(ULIB)
	# forktest has less library code linked in - needs to be small
	# in order to be able to max out the proc table.
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $U/_forktest $U/forktest.o $U/ulib.o $U/usys.o
	$(OBJDUMP) -S $U/_forktest > $U/forktest.asm

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html


.PRECIOUS: %.o

UPROGS=\
	$U/_init\
	$U/_sh\
	$U/_cat\
	$U/_echo\
	$U/_grep\
	$U/_ls\
	$U/_kill\
	$U/_mkdir\
	$U/_xargs\
	$U/_sleep\
	$U/_find\
	$U/_rm\
	$U/_wc\
	$U/_test\
	$U/_usertests\
	$U/_strace\
	$U/_mv\
	$U/_busybox_test\

	# $U/_myDup3\
	# $U/_forktest\
	# $U/_ln\
	# $U/_stressfs\
	# $U/_grind\
	# $U/_zombie\

userprogs: $(UPROGS)
	@$(OBJCOPY) -S -O binary $U/_busybox_test $U/busybox_test.bin


sdcard-ram: 
	if [ -f $(sdcard_h) ]; then rm $(sdcard_h); fi
	xxd -i $(sdcard_img) > $(sdcard_h);
	sed -i 's/$(K)_$(IMG)_$(imgname)/sdcard/g' $(sdcard_h);
	sed -i 's/$(K)_$(IMG)_$(imgname)_len/sdcard_len/g' $(sdcard_h);

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*/*.o */*.d */*.asm */*.sym kernel-qemu kernel-qemu.asm kernel-qemu.bin kernel-qemu.sym \
	$T/* \
	$U/initcode $U/initcode.out \
	$U/init-for-test $U/init-for-test.out \
	$U/init_for_test_LA $U/init_for_test_LA.out \
	$U/busybox_test.bin \
	$U/*.bin \
	$K/kernel \
	.gdbinit \
	$U/usys.S \
	$(UPROGS) \
	os.bin \
	sdcard.img \
	$K/lwip/*/*.o \
	$K/lwip/*/*.d \
	$K/lwip/*/*/*.o \
	$K/lwip/*/*/*.d \
	$K/*.a \
	$(sdcard_h)\

