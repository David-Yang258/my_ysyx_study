module inst_sep(
	input [7:0] inst,
	output reg [1:0] op,
	output reg [1:0] H2bits,
	output reg [1:0] M2bits,
	output reg [1:0] L2bits
);
	assign op = inst[7:6];
	assign H2bits = inst[5:4];
	assign M2bits = inst[3:2];
	assign L2bits = inst[1:0];
endmodule

