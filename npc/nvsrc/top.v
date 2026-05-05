`include "bus_define.vh"
module top(
	input 	clk,
	input 	rst_n,
	output [`BUS_DATA_WIDTH-1:0] pc,
	output [`BUS_DATA_WIDTH-1:0] inst
);

wire [`BUS_DATA_WIDTH-1:0] inst_pc;
wire [`BUS_DATA_WIDTH-1:0] perip_addr;
wire [`BUS_DATA_WIDTH-1:0] perip_rdata;
wire [`BUS_DATA_WIDTH-1:0] perip_wdata;
wire 					   perip_wen;
wire [3:0] 				   perip_wstrb;

mycpu core_cpu(
	.clk 	 	(clk),
	.rst_n 	 	(rst_n),
	.pc 	 	(pc),
	.inst_pc 	(inst_pc),
	.inst 		(inst),
	.perip_addr (perip_addr),
	.perip_rdata(perip_rdata),
	.perip_wdata(perip_wdata),
	.perip_wen 	(perip_wen),
	.perip_wstrb(perip_wstrb)
);

mem ram_mem(
  .clk            (clk),
  
  .araddr         (perip_addr),
  
  .rdata          (perip_rdata),
  
  .awaddr         (perip_addr),
  .awvalid        (perip_wen),
  
  .wdata          (perip_wdata),
  .wstrb          (perip_wstrb)
  );
mem irom(
  .clk            (clk),
  
  .araddr         (inst_pc),
  .rdata          (inst),
  /*verilator lint_off PINCONNECTEMPTY*/
  .awaddr         (),
  .awvalid        (),
  .wdata          (),
  .wstrb          ()
  );

endmodule
