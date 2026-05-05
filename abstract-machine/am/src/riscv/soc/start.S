.section entry, "ax"
.globl _start
.type _start, @function

_start:
  /*bootloader----*/
  la t0, _data_lma
  la t1, _data_start
  la t2, _edata

1:
  bge t1, t2, 2f
  lw a0,0(t0)
  sw a0,0(t1)
  addi t0, t0, 4
  addi t1, t1, 4
  j 1b

2: 
  /*clean bss*/
  la t0, _bss_start
  la t1, _bss_end
3:
  bge t0, t1, 4f
  sw zero, 0(t0)
  addi t0, t0, 4
  j 3b
4:

  /*--------------*/
  mv s0, zero
  la sp, _stack_pointer
  call _trm_init

.size _start, . - _start
