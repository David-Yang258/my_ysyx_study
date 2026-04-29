`include "bus_define.vh"
`include "alu.vh"
module pip_lsu_wbu(
	input 						 	  clk,
	input 							  rst_n,
	input 							  stall,

	input 		[`BUS_DATA_WIDTH-1:0] lsu_pc,
	input 		[`BUS_DATA_WIDTH-1:0] lsu_inst,
	input 							  lsu_inst_valid,

	input 		[2:0] 				  lsu_wb_sel,

	input 		[`REG_ADDR_WIDTH-1:0] lsu_rd_waddr,
	input 		[`CSR_ADDR_WIDTH-1:0] lsu_csr_waddr1,
	input 		[`CSR_ADDR_WIDTH-1:0] lsu_csr_waddr2,

	input 		[`BUS_DATA_WIDTH-1:0] lsu_rd_wdata,
	input 		[`BUS_DATA_WIDTH-1:0] lsu_csr_wdata1,
	input 		[`BUS_DATA_WIDTH-1:0] lsu_csr_wdata2,

	input 		[`BUS_DATA_WIDTH-1:0] lsu_mem_rdata,

	input 							  lsu_reg_we,
	input 							  lsu_csr_we1,
	input 							  lsu_csr_we2,

	output reg 	[2:0] 				  wbu_wb_sel,

	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_pc,
	output reg	[`BUS_DATA_WIDTH-1:0] wbu_inst,
	output reg						  wbu_inst_valid,

	output reg 	[`REG_ADDR_WIDTH-1:0] wbu_rd_waddr,
	output reg 	[`CSR_ADDR_WIDTH-1:0] wbu_csr_waddr1,
	output reg 	[`CSR_ADDR_WIDTH-1:0] wbu_csr_waddr2,

	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_rd_wdata,
	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_csr_wdata1,
	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_csr_wdata2,

	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_mem_rdata,
	
	output reg 						  wbu_reg_we,
	output reg 						  wbu_csr_we1,
	output reg 						  wbu_csr_we2

);

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wbu_pc 			<= 32'b0;
		wbu_inst 		<= 32'b0;
		wbu_inst_valid 	<= 1'b0;
		wbu_wb_sel 	 	<= `WBU_NOP;
		wbu_rd_waddr 	<= 5'b0;
		wbu_csr_waddr1 	<= 12'b0;
		wbu_csr_waddr2 	<= 12'b0;
		wbu_rd_wdata 	<= 32'b0;
		wbu_csr_wdata1 	<= 32'b0;
		wbu_csr_wdata2 	<= 32'b0;
		wbu_mem_rdata 	<= 32'b0;
		wbu_reg_we 		<= 1'b0;
		wbu_csr_we1 	<= 1'b0;
		wbu_csr_we2 	<= 1'b0;
	end	
	else if(!stall) begin
		wbu_pc 			<= lsu_pc;
		wbu_inst 		<= lsu_inst;
		wbu_inst_valid 	<= lsu_inst_valid;
		wbu_wb_sel 	 	<= lsu_wb_sel 	 	;
		wbu_rd_waddr 	<= lsu_rd_waddr 	;
		wbu_csr_waddr1 	<= lsu_csr_waddr1 	;
		wbu_csr_waddr2 	<= lsu_csr_waddr2 	;
		wbu_rd_wdata 	<= lsu_rd_wdata 	;
		wbu_csr_wdata1 	<= lsu_csr_wdata1 	;
		wbu_csr_wdata2 	<= lsu_csr_wdata2 	;
		wbu_mem_rdata 	<= lsu_mem_rdata 	;
		wbu_reg_we 		<= lsu_reg_we;
		wbu_csr_we1 	<= lsu_csr_we1;
		wbu_csr_we2 	<= lsu_csr_we2;
	end
end

endmodule
