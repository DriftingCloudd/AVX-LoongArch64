ENTRY(start)

SECTIONS
{
  . = 0x0;
  .text : { *(.text) }

  . = ALIGN(4K);
  rodata_start = .;
  .rodata : {
      srodata = .;
      *(.rodata .rodata.*)
      erodata = .;
  }
  . = ALIGN(4K);
  data_start = .;
  .data : {
      sdata = .;
      *(.data .data.*)
      edata = .;
  }

  . = ALIGN(4K);
  bss_start = .;
  .bss : {
    *(.bss.stack)
      sbss_clear = .;
      *(.sbss .bss .bss.*)
      ebss_clear = .;
  }
}

