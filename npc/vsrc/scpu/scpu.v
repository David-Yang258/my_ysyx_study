module scpu(
	input [1:0] op,
	input [1:0] H2bits,
	input [1:0] M2bits,
	input [1:0] L2bits,
	output we,
	output re,
	output [7:0] wdata_8,
	output [1:0] rwaddr1,
	output [1:0] raddr2
);

wire add, opout, li, bner0;

assign add 	 = (op == 2'b00) ? 1'b1 : 1'b0;
assign opout = (op == 2'b01) ? 1'b1 : 1'b0;
assign li	 = (op == 2'b10) ? 1'b1 : 1'b0;
assign bner0 = (op == 2'b11) ? 1'b1 : 1'b0;

wire [3:0] wdata;

assign wdata = (li == 1'b1) ? {M2bits, L2bits} : ((bner0 == 1) ? {H2bits, M2bits} : 4'b0);
assign rwaddr1 = (li == 1'b1) ? H2bits : ((add == 1'b1) ? M2bits : 2'b0);
assign raddr2 = (add == 1'b1) ? L2bits : ((bner0 == 1'b1) ? L2bits : ((opout == 1'b1) ? H2bits : 2'b0));

assign we = li | add;
assign re = bner0 | opout;
assign wdata_8 = {4'b0, wdata};

endmodule
