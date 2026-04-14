TOPNAME = ysyxSoCFull
WORK_DIR = ex7
NXDC_FILES = constr/top.nxdc
VH_INC_PATH = nvsrc/include
SOC_FULL_PATH = ../ysyxSoC/build/ysyxSoCFull.v
SOC_PERIP_PATH = ../ysyxSoC/perip
SOC_INC_PATH = $(abspath ../ysyxSoC/perip/uart16550/rtl) $(abspath ../ysyxSoC/perip/spi/rtl)
INC_PATH ?= include/

FILELIST_MK = $(shell find -L ./csrc -name "filelist.mk")
VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc  -Wall -trace-vcd -O2  

BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)


default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

LIBCAPSTONE = $(abspath tools/capstone/repo/libcapstone.so.5)
CAPSTONE_CFLAGS += -I $(abspath tools/capstone/repo/include)
# constraint file
#SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
#$(SRC_AUTO_BIND): $(NXDC_FILES)
#	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# project source
#VSRCS = $(shell find $(abspath ./vsrc/) -name "*.v")
CPU_VSRCS =  $(shell find $(abspath ./nvsrc/) -name "*.v")
SOC_VSRCS =  $(shell find $(abspath $(SOC_PERIP_PATH)) -name "*.v")
SOC_VSRCS += $(abspath $(SOC_FULL_PATH))
VSRCS += $(CPU_VSRCS)
VSRCS += $(SOC_VSRCS)
CSRCS = $(shell find $(abspath ./csrc/) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
#CSRCS += $(SRC_AUTO_BIND)

# rules for NVBoard
#include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INCFLAGS = $(addprefix -I, $(INC_PATH))
VH_INCFLAGS = $(addprefix -I, $(VH_INC_PATH))
VH_INCFLAGS += $(addprefix -I, $(SOC_INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\"" $(CAPSTONE_CFLAGS) 
LDFLAGS  += -lreadline $(LIBCAPSTONE) 

$(BIN): $(VSRCS) $(CSRCS) #$(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--timescale "1ns/1ns" --no-timing \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN)) \
		$(VH_INCFLAGS) \
		-Wno-PINCONNECTEMPTY -Wno-MODDUP -Wno-DECLFILENAME -Wno-DEFPARAM \
		-Wno-ASSIGNDLY -Wno-UNUSEDSIGNAL -Wno-UNDRIVEN -Wno-UNUSEDPARAM \
   		-Wno-PROCASSINIT -Wno-SYNCASYNCNET \
		--autoflush

all: default

run: $(BIN)
	@$^

clean:
	rm -rf $(BUILD_DIR)

.PHONY: default all clean run
