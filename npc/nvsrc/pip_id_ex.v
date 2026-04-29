`include "bus_define.vh"
module pip_id_ex(
	input 						  	  clk,
	input 							  rst_n,

	input 		[`BUS_DATA_WIDTH-1:0] id_imm,
	input 		[`BUS_DATA_WIDTH-1:0] id_rs1_src,
	input 		[`BUS_DATA_WIDTH-1:0] id_rs2_src,
	input 		[`BUS_DATA_WIDTH-1:0] id_csr_src,
	input 		[`BUS_DATA_WIDTH-1:0] id_pc,
	input 		[`BUS_DATA_WIDTH-1:0] id_inst,
	input 							  id_inst_valid,
	
	input 		[5:0] 				  id_alu_op,
	input 		[1:0] 				  id_alu_src2_sel,

	input 							  id_mem_re,
	input 							  id_mem_we,
	input 							  id_reg_we,
	input 							  id_csr_we1,
	input 							  id_csr_we2,

	input 		[2:0] 				  id_ls_type,
	input 		[2:0] 				  id_wb_sel,

	input 							  id_branch,
	input 							  id_jal,
	input 							  id_jalr,
	input 							  id_auipc,
	input 							  id_ecall,
	input 							  id_mret,
	input 		[3:0] 				  id_branch_type,

	input 							  id_csr_flag,

	input 		[`REG_ADDR_WIDTH-1:0] id_rd,
	input 		[`REG_ADDR_WIDTH-1:0] id_rs1,
	input 		[`REG_ADDR_WIDTH-1:0] id_rs2,
	input 							  id_rs1_en,
	input 							  id_rs2_en,


	input 		[`CSR_ADDR_WIDTH-1:0] id_csr_raddr,
	input 		[`CSR_ADDR_WIDTH-1:0] id_csr_waddr1,
	input 		[`CSR_ADDR_WIDTH-1:0] id_csr_waddr2,

	input 							  flush,
	input 							  stall,

	output reg	[`BUS_DATA_WIDTH-1:0] ex_imm,
	output reg	[`BUS_DATA_WIDTH-1:0] ex_rs1_src,
	output reg	[`BUS_DATA_WIDTH-1:0] ex_rs2_src,
	output reg	[`BUS_DATA_WIDTH-1:0] ex_csr_src,
	output reg	[`BUS_DATA_WIDTH-1:0] ex_pc,
	output reg  [`BUS_DATA_WIDTH-1:0] ex_inst, 
	output reg 						  ex_inst_valid,
	
	output reg	[5:0] 				  ex_alu_op,
	output reg	[1:0] 				  ex_alu_src2_sel,

	output reg						  ex_mem_re,
	output reg 						  ex_mem_we,
	output reg 						  ex_reg_we,
	output reg 						  ex_csr_we1,
	output reg 						  ex_csr_we2,

	output reg	[2:0] 				  ex_ls_type,
	output reg	[2:0] 				  ex_wb_sel,

	output reg						  ex_branch,
	output reg						  ex_jal,
	output reg						  ex_jalr,
	output reg						  ex_auipc,
	output reg						  ex_ecall,
	output reg						  ex_mret,
	output reg	[3:0] 				  ex_branch_type,

	output reg						  ex_csr_flag,

	output reg	[`REG_ADDR_WIDTH-1:0] ex_rd,
	output reg	[`REG_ADDR_WIDTH-1:0] ex_rs1,
	output reg	[`REG_ADDR_WIDTH-1:0] ex_rs2,
	output reg 						  ex_rs1_en,
	output reg 						  ex_rs2_en,


	output reg	[`CSR_ADDR_WIDTH-1:0] ex_csr_raddr,
	output reg	[`CSR_ADDR_WIDTH-1:0] ex_csr_waddr1,
	output reg	[`CSR_ADDR_WIDTH-1:0] ex_csr_waddr2

);

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		ex_imm 			<= 32'b0;
		ex_rs1_src 		<= 32'b0;
		ex_rs2_src 		<= 32'b0;
		ex_csr_src  	<= 32'b0;
		ex_pc 			<= 32'b0;
		ex_inst 		<= 32'b0;
		ex_inst_valid 	<= 1'b0;
		ex_alu_op 		<= 6'b111111;
		ex_alu_src2_sel <= 2'b0;
		ex_mem_re 		<= 1'b0;
		ex_mem_we 		<= 1'b0;
		ex_reg_we 		<= 1'b0;
		ex_csr_we1 		<= 1'b0;
		ex_csr_we2 		<= 1'b0;
		ex_ls_type 		<= 3'b0;
		ex_wb_sel 		<= 3'b111;
		ex_jal 			<= 1'b0;
		ex_jalr 		<= 1'b0;
		ex_auipc 		<= 1'b0;
		ex_branch 		<= 1'b0;
		ex_ecall 		<= 1'b0;
		ex_mret     	<= 1'b0;
		ex_csr_flag 	<= 1'b0;
		ex_branch_type 	<= 4'b1111;
		ex_rd 			<= 5'b0;
		ex_rs1 			<= 5'b0;
		ex_rs2 			<= 5'b0;
		ex_rs1_en 		<= 1'b0;
		ex_rs2_en 		<= 1'b0;
		ex_csr_raddr 	<= 12'b0;
		ex_csr_waddr1 	<= 12'b0;
		ex_csr_waddr2 	<= 12'b0;
	end
	else if(flush) begin
		ex_imm 			<= 32'b0;
		ex_rs1_src 		<= 32'b0;
		ex_rs2_src 		<= 32'b0;
		ex_csr_src  	<= 32'b0;
		ex_pc 			<= 32'b0;
		ex_inst 		<= 32'b0;
		ex_inst_valid 	<= 1'b0;
		ex_alu_op 		<= 6'b111111;
		ex_alu_src2_sel <= 2'b0;
		ex_mem_re 		<= 1'b0;
		ex_mem_we 		<= 1'b0;
		ex_reg_we 		<= 1'b0;
		ex_csr_we1 		<= 1'b0;
		ex_csr_we2 		<= 1'b0;
		ex_ls_type 		<= 3'b0;
		ex_wb_sel 		<= 3'b111;
		ex_jal 			<= 1'b0;
		ex_jalr 		<= 1'b0;
		ex_auipc 		<= 1'b0;
		ex_branch 		<= 1'b0;
		ex_ecall 		<= 1'b0;
		ex_mret     	<= 1'b0;
		ex_csr_flag 	<= 1'b0;
		ex_branch_type 	<= 4'b1111;
		ex_rd 			<= 5'b0;
		ex_rs1 			<= 5'b0;
		ex_rs2 			<= 5'b0;
		ex_rs1_en 		<= 1'b0;
		ex_rs2_en 		<= 1'b0;
		ex_csr_raddr 	<= 12'b0;
		ex_csr_waddr1 	<= 12'b0;
		ex_csr_waddr2 	<= 12'b0;
	end
	else if(!stall) begin
		ex_imm 			<= id_imm;
		ex_rs1_src 		<= id_rs1_src;
		ex_rs2_src 		<= id_rs2_src;
		ex_csr_src 		<= id_csr_src;
		ex_pc 			<= id_pc;
		ex_inst 		<= id_inst;
		ex_inst_valid 	<= id_inst_valid;
		ex_alu_op 		<= id_alu_op;
		ex_alu_src2_sel <= id_alu_src2_sel;
		ex_mem_re 		<= id_mem_re;
		ex_mem_we 		<= id_mem_we;
		ex_reg_we 		<= id_reg_we;
		ex_csr_we1 		<= id_csr_we1;
		ex_csr_we2 		<= id_csr_we2;
		ex_ls_type 		<= id_ls_type;
		ex_wb_sel 		<= id_wb_sel;
		ex_jal 			<= id_jal;
		ex_jalr 		<= id_jalr;
		ex_auipc 		<= id_auipc;
		ex_branch 		<= id_branch;
		ex_ecall 		<= id_ecall;
		ex_mret 		<= id_mret;
		ex_csr_flag 	<= id_csr_flag;
		ex_branch_type 	<= id_branch_type;
		ex_rd 			<= id_rd;
		ex_rs1 			<= id_rs1;
		ex_rs2 			<= id_rs2;
		ex_rs1_en 		<= id_rs1_en;
		ex_rs2_en 		<= id_rs2_en;
		ex_csr_raddr 	<= id_csr_raddr;
		ex_csr_waddr1 	<= id_csr_waddr1;
		ex_csr_waddr2 	<= id_csr_waddr2;
		
	end
end
endmodule
