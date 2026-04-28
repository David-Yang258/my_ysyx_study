`include "bus_define.vh"
module pip_ex_lsu(
	input 								clk,
	input 							 	rst_n,
	
	input [`BUS_DATA_WIDTH-1:0]		 	ex_rd_wdata,
	input [`BUS_DATA_WIDTH-1:0]		 	ex_csr_wdata1,
	input [`BUS_DATA_WIDTH-1:0]		 	ex_csr_wdata2,
	input [`BUS_DATA_WIDTH-1:0]		 	ex_rs2_src,

	input [`REG_ADDR_WIDTH-1:0] 	 	ex_rd,
	input [`CSR_ADDR_WIDTH-1:0] 	 	ex_csr_waddr1,
	input [`CSR_ADDR_WIDTH-1:0] 		ex_csr_waddr2,

	input [`BUS_DATA_WIDTH-1:0] 	 	ex_mem_raddr,
	input [`BUS_DATA_WIDTH-1:0] 	 	ex_mem_waddr,

	input 							 	ex_mem_re,
	input 							 	ex_mem_we,
	input 								ex_reg_we,
	input 								ex_csr_we1,
	input 								ex_csr_we2,

	input [2:0]						 	ex_ls_type,
	input [2:0] 					 	ex_wb_sel,

	input 							 	stall,

	output reg [`BUS_DATA_WIDTH-1:0]	lsu_rd_wdata,
	output reg [`BUS_DATA_WIDTH-1:0]	lsu_csr_wdata1,
	output reg [`BUS_DATA_WIDTH-1:0]	lsu_csr_wdata2,
	output reg [`BUS_DATA_WIDTH-1:0]	lsu_rs2_src,

	output reg [`REG_ADDR_WIDTH-1:0] 	lsu_rd,
	output reg [`CSR_ADDR_WIDTH-1:0] 	lsu_csr_waddr1,
	output reg [`CSR_ADDR_WIDTH-1:0] 	lsu_csr_waddr2,

	output reg [`BUS_DATA_WIDTH-1:0] 	lsu_mem_raddr,
	output reg [`BUS_DATA_WIDTH-1:0] 	lsu_mem_waddr,

	output reg 							lsu_mem_re,
	output reg 							lsu_mem_we,
	output reg 							lsu_reg_we,
	output reg 							lsu_csr_we1,
	output reg 							lsu_csr_we2,
	
	output reg [2:0]					lsu_ls_type,
	output reg [2:0] 					lsu_wb_sel

);

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lsu_rd_wdata 	<= 32'b0;
		lsu_csr_wdata1 	<= 32'b0;
		lsu_csr_wdata2  <= 32'b0;
		lsu_rs2_src 	<= 32'b0;
		lsu_mem_raddr 	<= 32'b0;
		lsu_mem_waddr 	<= 32'b0;
		lsu_mem_we 		<= 1'b0;
		lsu_mem_re 		<= 1'b0;
		lsu_reg_we 		<= 1'b0;
		lsu_csr_we1 	<= 1'b0;
		lsu_csr_we2 	<= 1'b0;
		lsu_ls_type 	<= 3'b111;
		lsu_wb_sel 		<= 3'b111;
		lsu_rd 			<= 5'b0;
		lsu_csr_waddr1  <= 12'b0;
		lsu_csr_waddr2  <= 12'b0;
	end
	else if(!stall) begin
		lsu_rd_wdata 	<= ex_rd_wdata;
		lsu_csr_wdata1 	<= ex_csr_wdata1;
		lsu_csr_wdata2 	<= ex_csr_wdata2;
		lsu_rs2_src 	<= ex_rs2_src;
		lsu_mem_raddr 	<= ex_mem_raddr;
		lsu_mem_waddr 	<= ex_mem_waddr;
		lsu_mem_we 		<= ex_mem_we;
		lsu_mem_re 		<= ex_mem_re;
		lsu_reg_we 		<= ex_reg_we;
		lsu_csr_we1 	<= ex_csr_we1;
		lsu_csr_we2 	<= ex_csr_we2;
		lsu_ls_type 	<= ex_ls_type;
		lsu_wb_sel 		<= ex_wb_sel;
		lsu_rd 			<= ex_rd;
		lsu_csr_waddr1  <= ex_csr_waddr1;
		lsu_csr_waddr2  <= ex_csr_waddr2;
	end
end

endmodule
