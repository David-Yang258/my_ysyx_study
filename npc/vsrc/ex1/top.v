module top(
	input i_clk,
	input i_rst,
	input [7:0] sw,
	input ena,
	output [6:0] seg7,
	output [2:0] ledr,
	output status
);

wire [3:0] prc_out;
wire [6:0] hex0;

prior_coder8_3 prcdr1(
	.data	(sw),
	.ena	(ena),
	.res	(ledr),
	.status	(status)
);

assign prc_out = {{1'b0},ledr};

bcd7seg	my7seg(
	.b	(prc_out),
	.h	(hex0)
);

assign seg7 = hex0;


endmodule
