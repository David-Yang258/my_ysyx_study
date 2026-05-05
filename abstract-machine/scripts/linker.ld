ENTRY(_start)
/*
 * PHDRS { text PT_LOAD; data PT_LOAD; }
 */

MEMORY{
	MROM : ORIGIN = 0x20000000, LENGTH = 4K
	SRAM : ORIGIN = 0x0f000000, LENGTH = 8K
}

SECTIONS {
  /* _pmem_start and _entry_offset are defined in LDFLAGS */
  /*. = _pmem_start + _entry_offset;*/

  . = ORIGIN(MROM);

  /*Normal linker*/
  /*
   .text : {
    *(entry)
    *(.text*)
  } : text
  */

  .text : {
	*(entry)
	*(.text*)
  } > MROM AT> MROM

  etext = .;
  _etext = .;

  /*Normal linker*/
  /*
   	.rodata : {
    *(.rodata*)
  }: text
  */

  .rodata : {
	*(.rodata*)
  } > MROM AT> MROM

  /*Normal linker*/
  /*
  .data : {
    *(.data*)
  } : data
  */
  .data : {
	_data_lma   = LOADADDR(.data);
	_data_start = . ;
	*(.data*)
	/*sdata!!!!!!!!!*/
	*(.sdata*)
	*(.sdata2*)
	. = ALIGN(4);
	_edata = .;
  } > SRAM AT>MROM


  /*Normal linker*/
  /*
  .bss : {
	_bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(.scommon)
  }
  */

  .bss : {
	. = ALIGN(4);
	_bss_start = .;
	*(.bss*)
	*(.sbss*)
	*(.scommon)
	. = ALIGN(4);
	_bss_end   = .;
  } > SRAM

  . = _sram_start;

  _stack_top = ALIGN(0x1000);
  . = _stack_top + 0x1000;
  _stack_pointer = .;

  end = .;
  _end = .;

  _heap_start = ALIGN(0x1000);
  
  /*
  . = _sram_start;
  _heap_start = ALIGN(0x1000);
  . = _heap_start + 0x1000;
  _heap_end = .;

  _stack_top = ALIGN(0x1000);
  . = _stack_top + 0x1000;
  _stack_pointer = .;

  end = .;
  _end = .;
  */

}
