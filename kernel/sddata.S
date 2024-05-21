    .align 4
    .section .data
    .section .data.sddata
    .global sddata_start
    .global sddata_end
sddata_start:
    # .incbin "./sdcard.img"
    .incbin "/home/byte/OCC/AVX-LoongArch64/kernel/sdcard.img"
sddata_end:
sddata_size:
    .long sddata_end - sddata_start