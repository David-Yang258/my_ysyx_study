#include "Vtop.h"
#include <nvboard.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME* );
/*
static void single_cycle() {
	int a = 0;	
}
*/
/*
static void reset(int n) {
  dut.i_rst = 1;
  while (n -- > 0) single_cycle();
  dut.i_rst = 0;
}
*/
int main() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  dut.eval();

  while(1) {
    nvboard_update();
    dut.eval();
  }
}
