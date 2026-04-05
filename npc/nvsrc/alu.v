`include "bus_define.vh"
module alu(
	input  		[`BUS_DATA_WIDTH-1:0] op1,
	input  		[`BUS_DATA_WIDTH-1:0] op2,
	input  		[5:0] 				  alu_op,
	output reg  [`BUS_DATA_WIDTH-1:0] result
);
`include "alu.vh"


always@(*) begin
	case(alu_op)
		`ALU_ADD: result = op1 + op2;
		`ALU_SUB: result = op1 - op2;
		`ALU_AND: result = op1 & op2;
		`ALU_ANDN:result = ~op1& op2;
		`ALU_OR : result = op1 | op2;
		`ALU_XOR: result = op1 ^ op2;
		`ALU_SLL: result = op1 			<< op2[4:0];
		`ALU_SRL: result = op1 			>> op2[4:0];
		`ALU_SRA: result = $signed(op1) >>> op2[4:0];
		`ALU_SLT: result = ($signed(op1) < $signed(op2)) ? 32'b1 : 32'b0;
		`ALU_SLTU:result = (op1 < op2) ? 32'b1 : 32'b0;
		`ALU_LUI: result = op2;
		`ALU_OP_NON: result = op1;
		default:  result = 32'h114514;
	endcase
end

endmodule
