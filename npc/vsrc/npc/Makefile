.PHONY: sim clean
VFLAGS=-Wall --cc --exe --build

CPPTARGET := $(wildcard ./*.cpp)
VTARGET   := $(wildcard ./*.v)

include $(AM_HOME)/scripts/platform/npc.mk

sim:
	verilator -Wall --cc --trace $(VTARGET) --exe $(CPPTARGET) --top-module top --build 
	
		
clean:
	rm -rf obj_dir
