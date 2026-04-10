module top(
	input 				clk,
	input 				rst,
	input 		[31:0] 	inst,
	output reg 	[31:0] 	pc
);

wire 		jmp_set;
wire [31:0] setbits;

wire [31:0] imm;
wire [4:0 ] rd;
wire [4:0 ] rs1;
wire [4:0 ] rs2;
/* verilator lint_off UNUSEDSIGNAL */ wire [4:0 ] shamt; /* verilator lint_on UNUSEDSIGNAL */
wire [6:0 ] funct7;
wire [6:0 ] opcode;
wire [2:0 ] funct3;

wire [31:0] src1;
wire [31:0] src2;
wire [31:0] csr_rdata;
wire [31:0] rd_wdata;
wire [11:0] csr_waddr1;
wire [11:0] csr_waddr2;
wire [31:0] csr_wdata1;
wire [31:0] csr_wdata2;


wire 		reg_wen;
wire 		csr_wen;
/* verilator lint_off UNUSEDSIGNAL */wire 		mem_wen; /* verilator lint_on UNUSEDSIGNAL */

pc inst_pc(
	.clk 		(clk 	),
	.rst 		(rst 	),
	.jmp_set 	(jmp_set),
	.setbits 	(setbits),
	.inst_addr 	(pc 	)
);

inst_decode inst_inst_decode(
	.inst 		(inst 	),
	.imm 		(imm 	),
	.rd 		(rd  	),
	.rs1 		(rs1 	),
	.rs2 		(rs2 	),
	.csr_waddr1 (csr_waddr1),
	.csr_waddr2 (csr_waddr2),
	.shamt 		(shamt 	),
	.funct7 	(funct7 ),
	.funct3 	(funct3 ),
	.opcode 	(opcode )
);

inst_exec  inst_inst_exec(
	.clk 		(clk 	),
	.funct7 	(funct7 ),
	.rs2 		(rs2 	),
	.funct3 	(funct3 ),
	.rd 		(rd 	),
	.src1 		(src1 	),
	.src2 		(src2 	),
	.shamt 		(shamt 	),
	.imm 		(imm 	),
	.csr_src 	(csr_rdata),
	.opcode 	(opcode ),
	.pc 		(pc  	),
	.rd_wdata 	(rd_wdata),
	.csr_wdata1 (csr_wdata1),
	.csr_wdata2 (csr_wdata2),
	.reg2reg 	(reg_wen),
	.reg2mem 	(mem_wen),
	.mem2reg 	(reg_wen),
	.reg2csr 	(csr_wen),
	.setpc 		(jmp_set),
	.setbits 	(setbits)
);

gpr inst_gpr(
	.clk 		(clk 	),
	.wdata 		(rd_wdata),
	.waddr 		(rd 	),
	.wen 		(reg_wen),
	.raddr1 	(rs1 	),
	.raddr2 	(rs2 	),
	.rdata1 	(src1 	),
	.rdata2 	(src2 	)
);

csr inst_csr(
	.clk 		(clk 	  ),
	.csr_wen 	(csr_wen  ),
	.csr_raddr 	(imm[11:0]),
	.csr_rdata  (csr_rdata),
	.csr_waddr1 (csr_waddr1[11:0]),
	.csr_waddr2 (csr_waddr2[11:0]),
	.csr_wdata1 (csr_wdata1),
	.csr_wdata2 (csr_wdata2)
);
endmodule
