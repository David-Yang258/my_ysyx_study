ENTRY(_start)
/*
 * PHDRS { text PT_LOAD; data PT_LOAD; }
 */

MEMORY{
	FLASH : ORIGIN = 0x30000000, LENGTH = 64K 
	MROM  : ORIGIN = 0x20000000, LENGTH = 4K
	SRAM  : ORIGIN = 0x0f000000, LENGTH = 8K
	PSRAM : ORIGIN = 0x80000000, LENGTH = 512K
}

SECTIONS {
  /* _pmem_start and _entry_offset are defined in LDFLAGS */
  /*. = _pmem_start + _entry_offset;*/

  /*MROM is used for program strorage*/
  /*
  . = ORIGIN(MROM);
  */

  /*FLASH is used for program strorage*/
  . = ORIGIN(FLASH);


  /*Normal linker*/
  /*
   .text : {
    *(entry)
    *(.text*)
  } : text
  */

  /*MROM is used for program strorage*/
/*
  .text : {
	*(entry)
	*(.text*)
  } > MROM AT> MROM

  etext = .;
  _etext = .;
*/

  /*FLASH is used for program strorage*/
  .text : {
	*(entry)
	*(.text*)
  } > FLASH AT> FLASH

  etext = .;
  _etext = .;

  /*Normal linker*/
  /*
   	.rodata : {
    *(.rodata*)
  }: text
  */

  /*MROM is used for program strorage*/
/*
  .rodata : {
	*(.rodata*)
  } > MROM AT> MROM
*/

  /*FLASH is used for program strorage*/
  .rodata : {
	*(.rodata*)
  } > FLASH AT> FLASH

  /*Normal linker*/
  /*
  .data : {
    *(.data*)
  } : data
  */
  /*MROM is used for program strorage*/
/*
  .data : {
	_data_lma   = LOADADDR(.data);
	_data_start = . ;
	*(.data*)
	*(.sdata*)
	*(.sdata2*)
	. = ALIGN(4);
	_edata = .;
  } > SRAM AT>MROM
*/

  /*FLASH is used for program strorage*/
  .data : {
	_data_lma   = LOADADDR(.data);
	_data_start = . ;
	*(.data*)
	/*sdata!!!!!!!!!*/
	*(.sdata*)
	*(.sdata2*)
	. = ALIGN(4);
	_edata = .;
  } > PSRAM AT>FLASH

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
  } > PSRAM

  . = _psram_start;

  _stack_top = ALIGN(0x1000);
  . = _stack_top + 0x80000;
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
