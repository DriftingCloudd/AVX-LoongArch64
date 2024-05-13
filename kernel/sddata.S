    .align 4
    .section .data
    .section .data.sddata
    .global sddata_start
    .global sddata_end
sddata_start:
    .incbin "./2kfs.img"
sddata_end:
sddata_size:
    .long sddata_end - sddata_start