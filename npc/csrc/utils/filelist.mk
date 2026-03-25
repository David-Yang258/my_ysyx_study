LIBCAPSTONE = $(abspath ~/ysyx/ysyx-workbench/npc/tools/capstone/repo/libcapstone.so.5)
CAPSTONE_CFLAGS += -I $(abspath ~/ysyx/ysyx-workbench/npc/tools/capstone/repo/include)
CSRC += csrc/utils/disasm.c
csrc/utils/disasm.c: $(LIBCAPSTONE)
$(LIBCAPSTONE):
	$(MAKE) -C tools/capstone

