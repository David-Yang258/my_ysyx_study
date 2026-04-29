`include "bus_define.vh"
module exu (
	input 		[`BUS_DATA_WIDTH-1:0] 	imm,
	input 		[`BUS_DATA_WIDTH-1:0] 	rs1_src,
	input 		[`BUS_DATA_WIDTH-1:0] 	rs2_src,
	input 		[`BUS_DATA_WIDTH-1:0]  	csr_src,
	input 		[`BUS_DATA_WIDTH-1:0]  	pc,

	input 		[5:0] 					alu_op,
	input 		[1:0] 					alu_src2_sel,

	input 								jal,
	input 								jalr,
	input 								auipc,
	input 								branch,
	input 								ecall,
	input 								mret,
	input 		[3:0] 					branch_type,

	input 								csr_flag,

	input 		[`BUS_DATA_WIDTH-1:0]   mem_loaded_res,
	input 		[`BUS_DATA_WIDTH-1:0]   final_wb_res,

	input 		[1:0] 					forward_a,
	input 		[1:0] 					forward_b,

	output  							branch_taken,
	output 	    [`BUS_DATA_WIDTH-1:0]   branch_addr,
	output   	[`BUS_DATA_WIDTH-1:0]  	alu_result,
	output reg 	[`BUS_DATA_WIDTH-1:0] 	rd_wdata,
	output reg  [`BUS_DATA_WIDTH-1:0]  	csr_wdata1,
	output reg  [`BUS_DATA_WIDTH-1:0]  	csr_wdata2
);
//import "DPI-C" function void ecall();

`include "alu.vh"

wire  [`BUS_DATA_WIDTH-1:0] op1;
wire  [`BUS_DATA_WIDTH-1:0] op2;
wire  [`BUS_DATA_WIDTH-1:0] real_rs1_src;
wire  [`BUS_DATA_WIDTH-1:0] real_rs2_src;

assign real_rs1_src = (forward_a == 2'b01) ? mem_loaded_res :
				  (forward_a == 2'b10) ? final_wb_res 	: rs1_src;

assign real_rs2_src = (forward_b == 2'b01) ? mem_loaded_res :
				  (forward_b == 2'b10) ? final_wb_res 	: rs2_src;
//Forward passing
assign op1 = (jalr || jal || auipc) ? pc : real_rs1_src ;

assign op2 = (alu_src2_sel == `ALU_SRC2_RS2) ? real_rs2_src :
			 (alu_src2_sel == `ALU_SRC2_IMM) ? imm     :
			 (alu_src2_sel == `ALU_SRC2_CSR) ? csr_src :
			 (alu_src2_sel == `ALU_SRC2_PC4) ? 32'd4 : 32'b0;

alu inst_alu(
	.op1 	(op1),
	.op2 	(op2),
	.alu_op (alu_op),
	.result (alu_result)
);

branch_unit inst_branch_unit(
	.imm 		 (imm),
	.pc 		 (pc),
	.rs1_src 	 (rs1_src),
	.csr_src 	 (csr_src),
	.jal 		 (jal),
	.jalr 		 (jalr),
	.ecall 		 (ecall),
	.mret 		 (mret),
	.alu_result  (alu_result),
	.branch_type (branch_type),
	.branch 	 (branch),
	.branch_taken(branch_taken),
	.branch_addr (branch_addr)
);

always@(*) begin
	rd_wdata = alu_result;
	csr_wdata1 = 0;
	csr_wdata2 = 0;
	if(csr_flag) begin
		if(ecall) begin
			csr_wdata1 = pc;
			csr_wdata2 = rs1_src;
		end
		else begin
			rd_wdata = csr_src;
			csr_wdata1 = alu_result;
		end
	end
end

endmodule
