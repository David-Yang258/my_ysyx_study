`include "bus_define.vh"
`include "alu.vh"
module branch_unit(
	input 		[`BUS_DATA_WIDTH-1:0] imm,
	input 		[`BUS_DATA_WIDTH-1:0] pc,
	input 		[`BUS_DATA_WIDTH-1:0] rs1_src,
	input 		[`BUS_DATA_WIDTH-1:0] csr_src,

	input 							  jal,
	input 							  jalr,
	input 							  branch,
	input 							  ecall,
	input 							  mret,
	
	input 		[3:0] 				  branch_type,
	input 		[`BUS_DATA_WIDTH-1:0] alu_result,

	output reg 						  branch_taken,
	output reg  [`BUS_DATA_WIDTH-1:0] branch_addr

);

always@(*) begin
	if(jal || branch) 			branch_addr = pc + imm;
	else if(jalr) 				branch_addr = imm + rs1_src;
	else if(ecall || mret) 		branch_addr = csr_src;
	else 						branch_addr = 32'h7FFFFFFF;
end
 
always@(*)begin
	branch_taken = 1'b0;
	if (branch) begin 
		case(branch_type)
			`BRANCH_EQ : branch_taken = (alu_result == 0) ? 1'b1 : 1'b0;
			`BRANCH_NE : branch_taken = (alu_result != 0) ? 1'b1 : 1'b0;
			`BRANCH_LT : branch_taken = (alu_result == 1) ? 1'b1 : 1'b0;
			`BRANCH_GE : branch_taken = (alu_result == 0) ? 1'b1 : 1'b0;
			`BRANCH_LTU: branch_taken = (alu_result == 1) ? 1'b1 : 1'b0;
			`BRANCH_GEU: branch_taken = (alu_result == 0) ? 1'b1 : 1'b0;
			default: ;
		endcase
	end
	else if(jal || jalr || ecall || mret) branch_taken = 1'b1;
	else branch_taken = 1'b0;
end


endmodule
