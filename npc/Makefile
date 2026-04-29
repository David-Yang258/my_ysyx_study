TOPNAME = top
WORK_DIR = ex7
NXDC_FILES = constr/top.nxdc
VH_INC_PATH = nvsrc/include
INC_PATH ?= include/

FILELIST_MK = $(shell find -L ./csrc -name "filelist.mk")
VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc  -Wall -trace -O2  

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
VSRCS = $(shell find $(abspath ./nvsrc/) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc/) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
#CSRCS += $(SRC_AUTO_BIND)

# rules for NVBoard
#include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INCFLAGS = $(addprefix -I, $(INC_PATH))
VH_INCFLAGS = $(addprefix -I, $(VH_INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\"" $(CAPSTONE_CFLAGS) 
LDFLAGS  += -lreadline $(LIBCAPSTONE) 

$(BIN): $(VSRCS) $(CSRCS) #$(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN)) \
		$(VH_INCFLAGS)

all: default

run: $(BIN)
	@$^

clean:
	rm -rf $(BUILD_DIR)

.PHONY: default all clean run
