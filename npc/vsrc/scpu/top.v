module top(
	input clk,
	input rst,
	output [6:0] r3l,
	output [6:0] r3h,
	output [6:0] instl,
	output [6:0] insth,
	output [6:0] r2l,
	output [6:0] r2h,
	output [6:0] r1l,
	output [6:0] r1h,
	output cout
);

wire set;
wire [3:0] setbits;
wire [3:0] sel;
wire [1:0] op;
wire [1:0] H2bits;
wire [1:0] M2bits;
wire [1:0] L2bits;
wire [7:0] inst;
wire [3:0] PCout;

wire we;
wire re;

wire [7:0] wdata_8;
wire [7:0] add_data8;
wire [7:0] wdata_8gpr;
wire [1:0] rwaddr1;
wire [1:0] raddr2;
wire [7:0] rdata1;
wire [7:0] rdata2;

wire [7:0] r2;
wire [7:0] r1;
wire [7:0] r3;

assign wdata_8gpr = (op == 2'b10) ? wdata_8 : add_data8;
assign set = (rdata1 != rdata2) & (op == 2'b11);
assign setbits = wdata_8[3:0];
assign sel = PCout;

full_adder_8bits inst_fa8_0(
	.A		(rdata1),
	.B		(rdata2),
	.cin	(1'b0),
	.S		(add_data8),
	.cout	(cout)
);

rom8_8 ismyrom(
	.sel	(sel),
	.inst	(inst)
);

inst_sep inst_sp(
	.inst	(inst),
	.op		(op),
	.H2bits	(H2bits),
	.M2bits	(M2bits),
	.L2bits	(L2bits)
);

scpu myscpu(
	.op		(op),
	.H2bits	(H2bits),
	.M2bits	(M2bits),
	.L2bits	(L2bits),
	.we		(we),
	.re		(re),
	.wdata_8(wdata_8),
	.rwaddr1(rwaddr1),
	.raddr2	(raddr2)
);

gpr mygpr(
	.clk	(clk),
	.rst	(rst),
	.rwaddr1(rwaddr1),
	.raddr2	(raddr2),
	.wdata_8(wdata_8gpr),
	.we		(we),
	.re		(re),
	.QA7_0	(rdata1),
	.QB7_0	(rdata2),
	.r2		(r2),
	.r1		(r1),
	.r3		(r3)
);

pc spc(
	.clk	(clk),
	.rst	(rst),
	.ena	(1'b1),
	.set	(set),
	.setbits(setbits),
	.Q3_0	(PCout)
);

bcd7seg inst_bcd7seg_1(
	.b		(r2[3:0]),
	.h		(r2l)
);

bcd7seg inst_bcd7seg_2(
	.b		(r2[7:4]),
	.h		(r2h)
);

bcd7seg inst_bcd7seg_3(
	.b		(inst[7:4]),
	.h		(insth)
);

bcd7seg inst_bcd7seg_4(
	.b		(inst[3:0]),
	.h		(instl)
);

bcd7seg inst_bcd7seg_5(
	.b		(r1[7:4]),
	.h		(r1h)
);

bcd7seg inst_bcd7seg_6(
	.b		(r1[3:0]),
	.h		(r1l)
);

bcd7seg inst_bcd7seg_7(
	.b		(r3[7:4]),
	.h		(r3h)
);

bcd7seg inst_bcd7seg_8(
	.b		(r3[3:0]),
	.h		(r3l)
);
endmodule
