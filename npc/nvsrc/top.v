`include "bus_define.vh"
module top(
	input clk,
	input rst_n,
	output [`BUS_DATA_WIDTH-1:0] pc,
	output [`BUS_DATA_WIDTH-1:0] inst,
	output [2:0] o_ifu_state,
	output bus_error,
	output Ebreak
);

wire 						jmp_set;
wire 						stall;
wire 						ifu_mem_ready;
wire 						ifu_valid;
wire 						ifu_bus_error;
wire 	 				    ifu_mem_rcmd;
wire [`BUS_DATA_WIDTH-1:0]  jmp_addr;

wire [`MEM_ADDR_WIDTH-1:0]  ifu_mem_raddr;
wire [`BUS_DATA_WIDTH-1:0]  ifu_mem_rdata;

wire [`BUS_DATA_WIDTH-1:0]  instruction;

wire idu_ready;
wire idu_valid;
//wire mem_we;
wire idu_mem_re;
//wire csr_we1;
//wire csr_we2;
wire csr_flag;
wire ecall;
wire mret;
wire branch;
wire jal;
wire jalr;
wire auipc;
wire idu_bus_error;
wire [1:0] alu_src2_sel;
wire [2:0] ls_type;
wire [2:0] wb_sel;
wire [3:0] branch_type;
wire [5:0] alu_op;
wire [`BUS_DATA_WIDTH-1:0] idu_imm;
wire [`REG_ADDR_WIDTH-1:0] rd_addr;
wire [`REG_ADDR_WIDTH-1:0] rs1_addr;
wire [`REG_ADDR_WIDTH-1:0] rs2_addr;
wire [`CSR_ADDR_WIDTH-1:0] csr_raddr;
wire [`CSR_ADDR_WIDTH-1:0] csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] csr_waddr2;

wire exu_branch_taken;
wire exu_valid;
wire exu_bus_error;
wire [`BUS_DATA_WIDTH-1:0] rs1_src;
wire [`BUS_DATA_WIDTH-1:0] rs2_src;
wire [`BUS_DATA_WIDTH-1:0] csr_src;
wire [`BUS_DATA_WIDTH-1:0] exu_branch_addr;
wire [`BUS_DATA_WIDTH-1:0] exu_alu_result;
wire [`BUS_DATA_WIDTH-1:0] exu_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] exu_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] exu_csr_wdata2;
wire exu_ready;

wire 						lsu_mem_re;
//wire 						lsu_mem_we;
wire 						lsu_wcpl;
wire 						lsu_rcpl;
wire 						lsu_mem_ready;
//wire 						lsu_valid;
wire 						lsu_bus_error;
wire 						lsu_mem_re_qst;
wire  		  				lsu_mem_we_qst;
wire [3:0]	  				lsu_mem_be;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_addr;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_wdata;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_rdata;
wire [`BUS_DATA_WIDTH-1:0] 	mem2lsu_rdata;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_raddr;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_waddr;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_rdata;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_wdata;
//wire lsu_ready;

wire final_mem_we;
wire final_reg_we;
wire final_csr_we1;
wire final_csr_we2;
wire wbu_bus_error;
wire [`REG_ADDR_WIDTH-1:0] final_rd_waddr;
wire [`CSR_ADDR_WIDTH-1:0] final_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] final_csr_waddr2;
wire [`BUS_DATA_WIDTH-1:0] final_mem_waddr;
wire [`BUS_DATA_WIDTH-1:0] final_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] final_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] final_csr_wdata2;
wire [`BUS_DATA_WIDTH-1:0] final_mem_wdata;
wire wbu_ready;

wire mem_ready;

assign stall = 1'b0;
assign bus_error = ifu_bus_error | idu_bus_error | exu_bus_error | lsu_bus_error | wbu_bus_error;

assign lsu_mem_ready = mem_ready;
assign ifu_mem_ready = mem_ready;
assign lsu_mem_re 	 = idu_mem_re;
assign inst = instruction;
ifu inst_ifu(
	.clk 			(clk),
	.rst_n  		(rst_n),
	.branch_happen  (jmp_set),
	.branch_addr 	(jmp_addr),
	.stall 			(stall),
	.mem_ready 		(ifu_mem_ready),
	.mem_inst 		(ifu_mem_rdata),
	.mem_cmd 		(ifu_mem_rcmd),
	.mem_addr 		(ifu_mem_raddr),
	.pc 			(pc),
	.inst 			(instruction),
	.i_ready 		(idu_ready),
	.o_valid 		(ifu_valid),
	.bus_error 		(ifu_bus_error),
	.o_ifu_state 	(o_ifu_state)
);

idu inst_idu(
	.inst 			(instruction),
	.imm 			(idu_imm),
	.rd 			(rd_addr),
	.rs1 			(rs1_addr),
	.rs2 			(rs2_addr),
	.csr_raddr 		(csr_raddr),
	.csr_waddr1 	(csr_waddr1),
	.csr_waddr2 	(csr_waddr2),
	.alu_op 		(alu_op),
	.alu_src2_sel 	(alu_src2_sel),
	//.mem_we 		(mem_we),
	.mem_re 		(idu_mem_re),
	.ls_type 		(ls_type),
	.wb_sel 		(wb_sel),
	.branch 		(branch),
	.jal 			(jal),
	.jalr 			(jalr),
	.auipc 			(auipc),
	.branch_type 	(branch_type),
	//.csr_we1 		(csr_we1),
	//.csr_we2 		(csr_we2),
	.csr_flag 		(csr_flag),
	.ecall 			(ecall),
	.Ebreak 		(Ebreak),
	.mret 			(mret),
	.ifu_valid 		(ifu_valid),
	.idu_ready 		(idu_ready),
	.i_ready 		(exu_ready),
	.o_valid 		(idu_valid),
	.bus_error   	(idu_bus_error)
);

exu inst_exu(
	.imm 			(idu_imm),
	.rs1_src 		(rs1_src),
	.rs2_src 		(rs2_src),
	.csr_src 		(csr_src),
	.pc 			(pc),
	.alu_op 		(alu_op),
	.alu_src2_sel 	(alu_src2_sel),
	.jal 			(jal),
	.jalr 			(jalr),
	.auipc 			(auipc),
	.branch 		(branch),
	.ecall 			(ecall),
	.mret 			(mret),
	.branch_type 	(branch_type),
	.csr_flag 		(csr_flag),
	.idu_valid 		(idu_valid),
	.exu_ready 		(exu_ready),
	.branch_taken 	(exu_branch_taken),
	.branch_addr 	(exu_branch_addr),
	.alu_result 	(exu_alu_result),
	.rd_wdata 		(exu_rd_wdata),
	.csr_wdata1 	(exu_csr_wdata1),
	.csr_wdata2 	(exu_csr_wdata2),
	.i_ready 		(wbu_ready),
	.o_valid 		(exu_valid),
	.bus_error 		(exu_bus_error)
);

lsu inst_lsu(
	.clk 			(clk),
	.rst_n 			(rst_n),
	.mem_re 		(lsu_mem_re),
	.mem_we 		(final_mem_we),
	.ls_type 		(ls_type),
	.alu2lsu_raddr	(exu_alu_result),
	.wbu2lsu_waddr	(final_mem_waddr),
	.wbu2lsu_wdata 	(final_mem_wdata),
	.mem2lsu_rdata 	(mem2lsu_rdata),
	.stall 			(stall),
	.exu_valid 		(exu_valid),
	.mem_ready 		(lsu_mem_ready),
	.mem_re_qst 	(lsu_mem_re_qst),
	.mem_we_qst 	(lsu_mem_we_qst),
	.mem_be 		(lsu_mem_be),
	.lsu_wcpl 		(lsu_wcpl),
	.lsu_rcpl 		(lsu_rcpl),
	.mem_raddr 		(lsu_mem_raddr),
	.mem_waddr 		(lsu_mem_waddr),
	.mem_rdata 		(lsu_mem_rdata),
	.mem_wdata 		(lsu_mem_wdata),
	//.lsu_ready 		(lsu_ready),
	.i_ready 		(wbu_ready),
	//.o_valid 		(lsu_valid),
	.bus_error 		(lsu_bus_error)
);

wbu inst_wbu(
	.clk 			(clk),
	.rst_n 			(rst_n),
	.wb_sel 		(wb_sel),
	.branch_taken 	(exu_branch_taken),
	.rd_waddr 		(rd_addr),
	.csr_waddr1 	(csr_waddr1),
	.csr_waddr2 	(csr_waddr2),
	.rd_wdata 		(exu_rd_wdata),
	.csr_wdata1 	(exu_csr_wdata1),
	.csr_wdata2 	(exu_csr_wdata2),
	.branch_addr 	(exu_branch_addr),
	.mem_rdata 		(lsu_mem_rdata),
	.mem_wdata 		(rs2_src),
	.mem_waddr 		(exu_alu_result),
	.i_valid 		(exu_valid),
	.lsu_wcpl 		(lsu_wcpl),
	.lsu_rcpl 		(lsu_rcpl),
	.stall 			(stall),
	.bus_error 		(wbu_bus_error),
	.final_rd_waddr (final_rd_waddr),
	.final_csr_waddr1(final_csr_waddr1),
	.final_csr_waddr2(final_csr_waddr2),
	.final_mem_waddr(final_mem_waddr),
	.final_rd_wdata (final_rd_wdata),
	.final_csr_wdata1(final_csr_wdata1),
	.final_csr_wdata2(final_csr_wdata2),
	.final_mem_wdata(final_mem_wdata),
	.wbu_ready 		(wbu_ready),
	.jmp_addr 		(jmp_addr),
	.jmp_set 		(jmp_set),
	.final_mem_we 	(final_mem_we),
	.final_csr_we1 	(final_csr_we1),
	.final_csr_we2 	(final_csr_we2),
	.final_reg_we 	(final_reg_we)
);

gpr inst_gpr(
	.clk 			(clk),
	.wdata 			(final_rd_wdata),
	.waddr 			(final_rd_waddr),
	.wen 			(final_reg_we),
	.raddr1 		(rs1_addr),
	.raddr2 		(rs2_addr),
	.rdata1 		(rs1_src),
	.rdata2 		(rs2_src)
);

csr inst_csr(
	.clk 			(clk),
	.csr_wen1 		(final_csr_we1),
	.csr_wen2		(final_csr_we2),
	.csr_raddr 		(csr_raddr),
	.csr_waddr1 	(final_csr_waddr1),
	.csr_waddr2 	(final_csr_waddr2),
	.csr_wdata1 	(final_csr_wdata1),
	.csr_wdata2 	(final_csr_wdata2),
	.csr_rdata 		(csr_src)
);

mem inst_mem(
	.clk 			(clk),
	.rst_n 			(rst_n),
	.mem_raddr1 	(ifu_mem_raddr),
	.mem_raddr2 	(lsu_mem_raddr),
	.mem_waddr 		(lsu_mem_waddr),
	.mem_wdata 		(lsu_mem_wdata),
	.mem_re1 		(ifu_mem_rcmd),
	.mem_re2 		(lsu_mem_re_qst),
	.mem_we 		(lsu_mem_we_qst),
	.mem_be 		(lsu_mem_be),
	.mem_ready 		(mem_ready),
	.mem_rdata1 	(ifu_mem_rdata),
	.mem_rdata2 	(mem2lsu_rdata)
);
endmodule
