module top(
	input clk,
	input rst_n,
	input ps2_clk,
	input ps2_data,
	output [6:0] seg0l,	
	output [6:0] seg0h,	
	output [6:0] seg1l,	
	output [6:0] seg1h,	
	output [6:0] seg2l,	
	output [6:0] seg2h	

);

wire ready;
wire overflow;
wire nextdata_n;
wire [7:0] key_code;


ps2_keyboard inst_ps2_kybd(
	.clk		(clk),
	.clrn		(rst_n),
	.ps2_clk	(ps2_clk),
	.ps2_data	(ps2_data),
	.nextdata_n	(nextdata_n),
	.data		(key_code),
	.ready		(ready),
	.overflow	(overflow)
);

key_proc inst_key_proc(
	.clk		(clk),
	.rst_n		(rst_n),
	.key_data	(key_code),
	.ready		(ready),
	.overflow	(overflow),
	.read_comp	(nextdata_n),
	.seg0l		(seg0l),
	.seg0h		(seg0h),
	.seg1l		(seg1l),
	.seg1h		(seg1h),
	.seg2l		(seg2l),
	.seg2h		(seg2h)
);

endmodule

