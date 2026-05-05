AM_SRCS := riscv/soc/start.S \
		   riscv/soc/trm.c \
		   riscv/soc/ioe.c \
	       riscv/soc/timer.c \
		   riscv/soc/input.c \
		   riscv/soc/cte.c \
		   riscv/soc/trap.S \
		   platform/dummy/vme.c \
	  	   platform/dummy/mpe.c

CFLAGS    += -fdata-sections -ffunction-sections
LDSCRIPTS += $(AM_HOME)/scripts/linker.ld
LDFLAGS   += --defsym=_pmem_start=0x20000000 --defsym=_entry_offset=0x0 --defsym=_sram_start=0x0f000000
LDFLAGS   += --gc-sections -e _start

MAINARGS_MAX_LEN = 64
MAINARGS_PLACEHOLDER = the_insert-arg_rule_in_Makefile_will_insert_mainargs_here
CFLAGS += -DMAINARGS_MAX_LEN=$(MAINARGS_MAX_LEN) -DMAINARGS_PLACEHOLDER=$(MAINARGS_PLACEHOLDER)

DIFF_SO_FILE = /home/daviyang3182/ysyx/ysyx-workbench/npc/tools/nemu-diff/riscv32-nemu-interpreter-so

insert-arg: image
	@python $(AM_HOME)/tools/insert-arg.py $(IMAGE).bin $(MAINARGS_MAX_LEN) $(MAINARGS_PLACEHOLDER) "$(mainargs)"
	@hexdump -v -e '8/4 "%08x " "\n"' $(IMAGE).bin | \
			awk '{printf "%05x: %s\n", (NR-1)*8 + 0x08000000, $$0}' > $(IMAGE).hex

image: image-dep
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

run: insert-arg
	@echo "TODO: add command here to run simulation"
	#@$(MAKE) -C $(NPC_HOME) ISA=$(ISA) sim IMG=$(IMAGE).bin
	@$(NPC_HOME)/build/ysyxSoCFull --img $(IMAGE).hex -e $(IMAGE).elf -d $(DIFF_SO_FILE) -b
.PHONY: insert-arg
