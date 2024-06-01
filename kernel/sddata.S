    .align 4
    .section .data
    .section .data.sddata
    .global sdcard
    .global sdcard_end
sdcard:
    # .incbin "./sdcard.img"
    .incbin "./kernel/sdcard_loongarch/new_sdcard3.img"
sdcard_end:
sdcard_len:
    .long sdcard_end - sdcard