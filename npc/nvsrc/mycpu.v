`include "bus_define.vh"
module mycpu(
	input clk,
	input rst_n,
	output [`BUS_DATA_WIDTH-1:0] pc,
	output [`BUS_DATA_WIDTH-1:0] inst_pc,
	input  [`BUS_DATA_WIDTH-1:0] inst,

	output [`BUS_DATA_WIDTH-1:0] perip_addr,
	input  [`BUS_DATA_WIDTH-1:0] perip_rdata,
	output [`BUS_DATA_WIDTH-1:0] perip_wdata,
	output 						 perip_wen,
	output [3:0] 				 perip_wstrb
	
);
/*verilator lint_off UNUSEDSIGNAL*/
wire [`BUS_DATA_WIDTH-1:0] wbu_diff_pc;
wire [`BUS_DATA_WIDTH-1:0] wbu_diff_npc;
wire [`BUS_DATA_WIDTH-1:0] wbu_diff_inst;
/*verilator lint_on UNUSEDSIGNAL*/

assign pc = wbu_diff_npc;
//wire [`BUS_DATA_WIDTH-1:0]  jmp_addr;

wire [`BUS_DATA_WIDTH-1:0]  instruction;

//wire mem_we;
wire 						id_mem_re;
wire 						id_mem_we;
wire 						id_reg_we;
wire  						id_csr_we1;
wire  						id_csr_we2;
//wire csr_we1;
//wire csr_we2;
wire 						id_csr_flag;
wire 						id_ecall;
wire 						id_mret;
wire 						id_branch;
wire 						id_jal;
wire 						id_jalr;
wire 						id_auipc;
wire [1:0] 					id_alu_src2_sel;
wire [2:0] 					id_ls_type;
wire [2:0] 					id_wb_sel;
wire [3:0] 					id_branch_type;
wire [5:0] 					id_alu_op;
wire [`BUS_DATA_WIDTH-1:0] 	id_imm;
wire [`REG_ADDR_WIDTH-1:0] 	id_rd_addr;
wire [`REG_ADDR_WIDTH-1:0] 	id_rs1_addr;
wire [`REG_ADDR_WIDTH-1:0] 	id_rs2_addr;
wire 						id_rs1_en;
wire 						id_rs2_en;
wire [`CSR_ADDR_WIDTH-1:0] 	id_csr_raddr;
wire [`CSR_ADDR_WIDTH-1:0] 	id_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] 	id_csr_waddr2;

wire 						exu_branch_taken;
wire [`BUS_DATA_WIDTH-1:0] 	id_rs1_src;
wire [`BUS_DATA_WIDTH-1:0] 	id_rs2_src;
wire [`BUS_DATA_WIDTH-1:0] 	id_csr_src;


wire [`BUS_DATA_WIDTH-1:0] 	exu_branch_addr;
wire [`BUS_DATA_WIDTH-1:0] 	exu_alu_result;
wire [`BUS_DATA_WIDTH-1:0] 	exu_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] 	exu_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] 	exu_csr_wdata2;

wire 						final_reg_we;
wire 						final_csr_we1;
wire 						final_csr_we2;
wire [`REG_ADDR_WIDTH-1:0] 	final_rd_waddr;
wire [`CSR_ADDR_WIDTH-1:0] 	final_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] 	final_csr_waddr2;
wire [`BUS_DATA_WIDTH-1:0] 	final_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] 	final_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] 	final_csr_wdata2;

wire ifu_stall_rqst, lsu_stall_rqst;

wire [`BUS_DATA_WIDTH-1:0]  ifu_pc;
wire [`BUS_DATA_WIDTH-1:0]  ifu_diff_npc_d1;
wire 						ifu_inst_valid;
wire [`MEM_ADDR_WIDTH-1:0] 	ifu_araddr;
wire [`BUS_DATA_WIDTH-1:0] 	ifu_rdata;
/*verilator lint_off UNUSEDSIGNAL*/
/*verilator lint_on UNUSEDSIGNAL*/

wire					hazard_stall_pc;
wire					hazard_stall_if_id;
wire					hazard_stall_id_ex;
wire					hazard_stall_ex_mem;
wire					hazard_stall_mem_wb;
wire					hazard_flush_if_id;
wire					hazard_flush_id_ex;
/*verilator lint_off UNUSEDSIGNAL*/
wire					hazard_flush_ex_mem;
wire					hazard_flush_mem_wb;
/*verilator lint_on UNUSEDSIGNAL*/
assign inst_pc = ifu_araddr;
assign ifu_rdata  = inst;

ifu inst_ifu(
	.clk 			(clk),
	.rst_n  		(rst_n),
	.branch_happen  (exu_branch_taken),
	.branch_addr 	(exu_branch_addr),
	.stall 			(hazard_stall_pc),
	.ifu_stall_rqst (ifu_stall_rqst),

	.araddr 		(ifu_araddr),
	.rdata 			(ifu_rdata),

	.pc 			(ifu_pc),
	.inst 			(instruction),
	.inst_valid 	(ifu_inst_valid),

	.diff_npc_d1 	(ifu_diff_npc_d1)
);

wire [`BUS_DATA_WIDTH-1:0] if_id_pc;
wire [`BUS_DATA_WIDTH-1:0] if_id_inst;
wire 					   if_id_inst_valid;
/*verilator lint_off UNUSEDSIGNAL*/
wire [`REG_ADDR_WIDTH-1:0] if_id_rd; 
/*verilator lint_on  UNUSEDSIGNAL*/
wire [`REG_ADDR_WIDTH-1:0] if_id_rs1; 
wire [`REG_ADDR_WIDTH-1:0] if_id_rs2; 

pip_if_id inst_pip_if_id(
	.clk 			(clk 		),
	.rst_n 			(rst_n 		),
	.if_inst 		(instruction),
	.if_inst_valid 	(ifu_inst_valid),
	.if_pc 			(ifu_pc 	),
	.stall 			(hazard_stall_if_id),
	.flush 			(hazard_flush_if_id),
	.if_id_rd 		(if_id_rd 	),
	.if_id_rs1 		(if_id_rs1 	),
	.if_id_rs2 		(if_id_rs2 	),
	.if_id_pc 		(if_id_pc 	),
	.if_id_inst 	(if_id_inst ),
	.if_id_inst_valid(if_id_inst_valid)
);

/*verilator lint_off UNUSEDSIGNAL*/
wire 				id_predict_taken;
/*verilator lint_on  UNUSEDSIGNAL*/

idu inst_idu(
	.inst 			(if_id_inst),

	.imm 			(id_imm),
	.rd 			(id_rd_addr),
	.rs1 			(id_rs1_addr),
	.rs2 			(id_rs2_addr),
	.rs1_en 		(id_rs1_en),
	.rs2_en 		(id_rs2_en),
	.csr_raddr 		(id_csr_raddr),
	.csr_waddr1 	(id_csr_waddr1),
	.csr_waddr2 	(id_csr_waddr2),
	.alu_op 		(id_alu_op),
	.alu_src2_sel 	(id_alu_src2_sel),
	.mem_we 		(id_mem_we),
	.mem_re 		(id_mem_re),
	.reg_we 		(id_reg_we),
	.csr_we1 		(id_csr_we1),
	.csr_we2 		(id_csr_we2),
	.ls_type 		(id_ls_type),
	.wb_sel 		(id_wb_sel),
	.branch 		(id_branch),
	.jal 			(id_jal),
	.jalr 			(id_jalr),
	.auipc 			(id_auipc),
	.branch_type 	(id_branch_type),
	//.csr_we1 		(csr_we1),
	//.csr_we2 		(csr_we2),
	.csr_flag 		(id_csr_flag),
	.ecall 			(id_ecall),
	.mret 			(id_mret),
	.predict_taken  (id_predict_taken)
);
wire [`BUS_DATA_WIDTH-1:0] 	id_ex_imm;
wire [`BUS_DATA_WIDTH-1:0] 	id_ex_rs1_src;
wire [`BUS_DATA_WIDTH-1:0] 	id_ex_rs2_src;
wire [`BUS_DATA_WIDTH-1:0] 	id_ex_csr_src;
wire [`BUS_DATA_WIDTH-1:0] 	id_ex_pc;
wire [`BUS_DATA_WIDTH-1:0] 	id_ex_inst;
wire 						id_ex_inst_valid;
wire [5:0] 				   	id_ex_alu_op;
wire [1:0] 				   	id_ex_alu_src2_sel;

wire						id_ex_mem_re;
wire						id_ex_mem_we;
wire 						id_ex_reg_we;
wire 						id_ex_csr_we1;
wire 						id_ex_csr_we2;

wire [2:0] 					id_ex_ls_type;
wire [2:0] 					id_ex_wb_sel;
wire						id_ex_branch;
wire						id_ex_jal;
wire						id_ex_jalr;
wire						id_ex_auipc;
wire						id_ex_ecall;
wire						id_ex_mret;
wire [3:0] 					id_ex_branch_type;
wire						id_ex_csr_flag;

wire [`REG_ADDR_WIDTH-1:0] 	id_ex_rd_addr;
wire [`REG_ADDR_WIDTH-1:0] 	id_ex_rs1_addr;
wire [`REG_ADDR_WIDTH-1:0] 	id_ex_rs2_addr;
wire 						id_ex_rs1_en;
wire 						id_ex_rs2_en;

/*verilator lint_off UNUSEDSIGNAL*/
wire [`CSR_ADDR_WIDTH-1:0] 	id_ex_csr_raddr;
/*verilator lint_on  UNUSEDSIGNAL*/
wire [`CSR_ADDR_WIDTH-1:0] 	id_ex_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] 	id_ex_csr_waddr2;


pip_id_ex inst_id_ex(
	.clk 			(clk),
	.rst_n 			(rst_n),

	.flush 			(hazard_flush_id_ex),
	.stall 			(hazard_stall_id_ex),

	.id_imm 		(id_imm),

	.id_rd 			(id_rd_addr),
	.id_rs1 		(id_rs1_addr),
	.id_rs2 		(id_rs2_addr),
	.id_rs1_en 		(id_rs1_en),
	.id_rs2_en 		(id_rs2_en),

	.id_csr_raddr 	(id_csr_raddr),
	.id_csr_waddr1 	(id_csr_waddr1),
	.id_csr_waddr2 	(id_csr_waddr2),

	.id_rs1_src 	(id_rs1_src),
	.id_rs2_src 	(id_rs2_src),
	.id_csr_src 	(id_csr_src),

	.id_pc 			(if_id_pc),
	.id_inst 		(if_id_inst),
	.id_inst_valid 	(if_id_inst_valid),

	.id_alu_op 		(id_alu_op),
	.id_alu_src2_sel(id_alu_src2_sel),

	.id_mem_re 		(id_mem_re),
	.id_mem_we 		(id_mem_we),
	.id_reg_we  	(id_reg_we),
	.id_csr_we1 	(id_csr_we1),
	.id_csr_we2 	(id_csr_we2),

	.id_ls_type 	(id_ls_type),
	.id_wb_sel 		(id_wb_sel),

	.id_branch 		(id_branch),
	.id_jal 		(id_jal),
	.id_jalr 		(id_jalr),
	.id_auipc 		(id_auipc),
	.id_ecall 		(id_ecall),
	.id_mret 		(id_mret),

	.id_branch_type (id_branch_type),
	.id_csr_flag 	(id_csr_flag),

	.ex_imm 		(id_ex_imm),
	.ex_rs1_src 	(id_ex_rs1_src),
	.ex_rs2_src 	(id_ex_rs2_src),
	.ex_csr_src 	(id_ex_csr_src),

	.ex_pc 			(id_ex_pc),
	.ex_inst 		(id_ex_inst),
	.ex_inst_valid 	(id_ex_inst_valid),
	.ex_alu_op 		(id_ex_alu_op),
	.ex_alu_src2_sel(id_ex_alu_src2_sel),

	.ex_mem_re 		(id_ex_mem_re),
	.ex_mem_we 		(id_ex_mem_we),
	.ex_reg_we 		(id_ex_reg_we),
	.ex_csr_we1 	(id_ex_csr_we1),
	.ex_csr_we2 	(id_ex_csr_we2),

	.ex_ls_type 	(id_ex_ls_type),
	.ex_wb_sel 		(id_ex_wb_sel),
	.ex_branch 		(id_ex_branch),
	.ex_jal 		(id_ex_jal),
	.ex_jalr 		(id_ex_jalr),
	.ex_auipc  		(id_ex_auipc),
	.ex_ecall 		(id_ex_ecall),
	.ex_mret 		(id_ex_mret),
	.ex_branch_type (id_ex_branch_type),
	.ex_csr_flag 	(id_ex_csr_flag),

	.ex_rd 			(id_ex_rd_addr),
	.ex_rs1 		(id_ex_rs1_addr),
	.ex_rs2 		(id_ex_rs2_addr),
	.ex_rs1_en 		(id_ex_rs1_en),
	.ex_rs2_en 		(id_ex_rs2_en),

	.ex_csr_raddr 	(id_ex_csr_raddr),
	.ex_csr_waddr1 	(id_ex_csr_waddr1),
	.ex_csr_waddr2 	(id_ex_csr_waddr2)
);

wire [1:0] 					hazard_forward_a;
wire [1:0] 					hazard_forward_b;
wire [`BUS_DATA_WIDTH-1:0] 	mem_forward_data;
wire [`BUS_DATA_WIDTH-1:0] 	wb_forward_data;
assign mem_forward_data = ex_lsu_rd_wdata;
`include "alu.vh"
assign wb_forward_data   = (lsu_wbu_wb_sel == `MEM_TO_REG) ? lsu_wbu_mem_rdata : lsu_wbu_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] forwarded_rs2_src;
assign forwarded_rs2_src = (hazard_forward_b == 2'b01) ? mem_forward_data :
							(hazard_forward_b == 2'b10) ? wb_forward_data :
							id_ex_rs2_src;

exu inst_exu(
	.imm 			(id_ex_imm),

	.rs1_src 		(id_ex_rs1_src),
	.rs2_src 		(id_ex_rs2_src),
	.csr_src 		(id_ex_csr_src),

	.pc 			(id_ex_pc),
	.alu_op 		(id_ex_alu_op),
	.alu_src2_sel 	(id_ex_alu_src2_sel),

	.jal 			(id_ex_jal),
	.jalr 			(id_ex_jalr),
	.auipc 			(id_ex_auipc),
	.branch 		(id_ex_branch),
	.ecall 			(id_ex_ecall),
	.mret 			(id_ex_mret),
	.branch_type 	(id_ex_branch_type),
	.csr_flag 		(id_ex_csr_flag),
	.branch_taken 	(exu_branch_taken),
	.branch_addr 	(exu_branch_addr),

	.alu_result 	(exu_alu_result),

	.mem_loaded_res (mem_forward_data),
	.final_wb_res 	(wb_forward_data),
 
	.forward_a 		(hazard_forward_a),
	.forward_b 		(hazard_forward_b),

	.rd_wdata 		(exu_rd_wdata),
	.csr_wdata1 	(exu_csr_wdata1),
	.csr_wdata2 	(exu_csr_wdata2)
);

wire [`BUS_DATA_WIDTH-1:0] 	ex_lsu_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] 	ex_lsu_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] 	ex_lsu_csr_wdata2;
wire [`BUS_DATA_WIDTH-1:0] 	ex_lsu_rs2_src;

wire [`REG_ADDR_WIDTH-1:0] 	ex_lsu_rd;
wire [`CSR_ADDR_WIDTH-1:0] 	ex_lsu_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] 	ex_lsu_csr_waddr2;

wire [`BUS_DATA_WIDTH-1:0] 	ex_lsu_mem_raddr;
wire [`BUS_DATA_WIDTH-1:0] 	ex_lsu_mem_waddr;

wire  						ex_lsu_mem_re;
wire 						ex_lsu_mem_we;
wire [2:0] 					ex_lsu_ls_type;
wire [2:0] 					ex_lsu_wb_sel;

wire 						ex_lsu_reg_we;
wire 						ex_lsu_csr_we1;
wire 						ex_lsu_csr_we2;

wire [`BUS_DATA_WIDTH-1:0]  ex_lsu_pc;
wire [`BUS_DATA_WIDTH-1:0]  ex_lsu_inst;
wire 						ex_lsu_inst_valid;

pip_ex_lsu inst_pip_ex_lsu(
	.clk 			(clk),
	.rst_n 			(rst_n),
	
	.ex_pc 			(id_ex_pc),
	.ex_inst 		(id_ex_inst),
	.ex_inst_valid 	(id_ex_inst_valid),

	.ex_rd_wdata 	(exu_rd_wdata),
	.ex_csr_wdata1  (exu_csr_wdata1),
	.ex_csr_wdata2  (exu_csr_wdata2),
	.ex_rs2_src 	(forwarded_rs2_src),

	.ex_rd 			(id_ex_rd_addr),
	.ex_csr_waddr1  (id_ex_csr_waddr1),
	.ex_csr_waddr2  (id_ex_csr_waddr2),

	.ex_mem_raddr  	(exu_alu_result),
	.ex_mem_waddr 	(exu_alu_result),

	.ex_mem_re 		(id_ex_mem_re),
	.ex_mem_we 		(id_ex_mem_we),
	.ex_reg_we 		(id_ex_reg_we),
	.ex_csr_we1 	(id_ex_csr_we1),
	.ex_csr_we2 	(id_ex_csr_we2),

	.ex_ls_type 	(id_ex_ls_type),
	.ex_wb_sel 		(id_ex_wb_sel),

	.stall 			(hazard_stall_ex_mem),

	.lsu_pc 		(ex_lsu_pc),
	.lsu_inst 		(ex_lsu_inst),
	.lsu_inst_valid (ex_lsu_inst_valid),

	.lsu_rd_wdata 	(ex_lsu_rd_wdata),
	.lsu_csr_wdata1 (ex_lsu_csr_wdata1),
	.lsu_csr_wdata2 (ex_lsu_csr_wdata2),
	.lsu_rs2_src 	(ex_lsu_rs2_src),

	.lsu_rd 		(ex_lsu_rd),
	.lsu_csr_waddr1 (ex_lsu_csr_waddr1),
	.lsu_csr_waddr2 (ex_lsu_csr_waddr2),

	.lsu_mem_raddr  (ex_lsu_mem_raddr),
	.lsu_mem_waddr  (ex_lsu_mem_waddr),

	.lsu_mem_re 	(ex_lsu_mem_re),
	.lsu_mem_we 	(ex_lsu_mem_we),
	.lsu_reg_we 	(ex_lsu_reg_we),
	.lsu_csr_we1 	(ex_lsu_csr_we1),
	.lsu_csr_we2 	(ex_lsu_csr_we2),

	.lsu_ls_type 	(ex_lsu_ls_type),
	.lsu_wb_sel 	(ex_lsu_wb_sel)

);

wire [`MEM_ADDR_WIDTH-1:0] 	lsu_mem_addr;

wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_rdata;
wire [`BUS_DATA_WIDTH-1:0] 	mem_rdata;

wire 						lsu_mem_awvalid;

wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_wdata;
wire [3:0] 					lsu_mem_wstrb;

assign perip_wen = lsu_mem_awvalid;
assign perip_addr=lsu_mem_addr;
assign lsu_mem_rdata=perip_rdata;
assign perip_wdata=lsu_mem_wdata;
assign perip_wstrb=lsu_mem_wstrb;

lsu inst_lsu(
	.clk 			(clk),
	.rst_n 			(rst_n),

	.mem_re 		(ex_lsu_mem_re),
	.mem_we 		(ex_lsu_mem_we),

	.ls_type 		(ex_lsu_ls_type),

	.ex_lsu_raddr	(ex_lsu_mem_raddr),
	.ex_lsu_waddr	(ex_lsu_mem_waddr),
	.ex_lsu_wdata 	(ex_lsu_rs2_src),

	.mem_rdata 		(mem_rdata),
	.lsu_stall_rqst (lsu_stall_rqst),

	.lsu_addr 		(lsu_mem_addr),

	.rdata 			(lsu_mem_rdata),

	.awvalid 		(lsu_mem_awvalid),

	.wdata 			(lsu_mem_wdata),
	.wstrb 			(lsu_mem_wstrb)
);


wire [2:0] 					lsu_wbu_wb_sel;
	
wire [`REG_ADDR_WIDTH-1:0]	lsu_wbu_rd;
wire [`CSR_ADDR_WIDTH-1:0]	lsu_wbu_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] 	lsu_wbu_csr_waddr2;

wire [`BUS_DATA_WIDTH-1:0] 	lsu_wbu_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_wbu_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_wbu_csr_wdata2;

wire [`BUS_DATA_WIDTH-1:0]  lsu_wbu_mem_rdata;

wire 						lsu_wbu_reg_we;
wire 						lsu_wbu_csr_we1;
wire 						lsu_wbu_csr_we2;

wire [`BUS_DATA_WIDTH-1:0] 	lsu_wbu_pc;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_wbu_inst;
wire 						lsu_wbu_inst_valid;

pip_lsu_wbu inst_pip_lsu_wbu(
	.clk 			(clk),
	.rst_n 			(rst_n),
	.stall 			(hazard_stall_mem_wb),

	.lsu_pc 		(ex_lsu_pc),
	.lsu_inst 		(ex_lsu_inst),
	.lsu_inst_valid (ex_lsu_inst_valid),

	.lsu_wb_sel 	(ex_lsu_wb_sel),
	
	.lsu_rd_waddr 	(ex_lsu_rd),
	.lsu_csr_waddr1 (ex_lsu_csr_waddr1),
	.lsu_csr_waddr2 (ex_lsu_csr_waddr2),

	.lsu_rd_wdata 	(ex_lsu_rd_wdata),
	.lsu_csr_wdata1 (ex_lsu_csr_wdata1),
	.lsu_csr_wdata2 (ex_lsu_csr_wdata2),

	.lsu_mem_rdata  (mem_rdata),

	.lsu_reg_we 	(ex_lsu_reg_we),
	.lsu_csr_we1 	(ex_lsu_csr_we1),
	.lsu_csr_we2 	(ex_lsu_csr_we2),

	.wbu_pc 		(lsu_wbu_pc),
	.wbu_inst 		(lsu_wbu_inst),
	.wbu_inst_valid (lsu_wbu_inst_valid),

	.wbu_wb_sel 	(lsu_wbu_wb_sel),
	
	.wbu_rd_waddr 	(lsu_wbu_rd),
	.wbu_csr_waddr1 (lsu_wbu_csr_waddr1),
	.wbu_csr_waddr2 (lsu_wbu_csr_waddr2),

	.wbu_rd_wdata 	(lsu_wbu_rd_wdata),
	.wbu_csr_wdata1 (lsu_wbu_csr_wdata1),
	.wbu_csr_wdata2 (lsu_wbu_csr_wdata2),

	.wbu_mem_rdata  (lsu_wbu_mem_rdata),

	.wbu_reg_we 	(lsu_wbu_reg_we),
	.wbu_csr_we1 	(lsu_wbu_csr_we1),
	.wbu_csr_we2 	(lsu_wbu_csr_we2)
);

wbu inst_wbu(
	.clk 			(clk),
	.rst_n 			(rst_n),

	.wb_sel 		(lsu_wbu_wb_sel),

	.wbu_pc 		(lsu_wbu_pc),
	.if_npc 		(ifu_diff_npc_d1),
	.wbu_inst 		(lsu_wbu_inst),
	.wbu_inst_valid (lsu_wbu_inst_valid),

	.rd_waddr 		(lsu_wbu_rd),
	.csr_waddr1 	(lsu_wbu_csr_waddr1),
	.csr_waddr2 	(lsu_wbu_csr_waddr2),

	.rd_wdata 		(lsu_wbu_rd_wdata),
	.csr_wdata1 	(lsu_wbu_csr_wdata1),
	.csr_wdata2 	(lsu_wbu_csr_wdata2),

	.mem_rdata 		(lsu_wbu_mem_rdata),

	.lsu_reg_we 	(lsu_wbu_reg_we),
	.lsu_csr_we1 	(lsu_wbu_csr_we1),
	.lsu_csr_we2 	(lsu_wbu_csr_we2),

	.final_rd_waddr (final_rd_waddr),
	.final_csr_waddr1(final_csr_waddr1),
	.final_csr_waddr2(final_csr_waddr2),
	.final_rd_wdata (final_rd_wdata),
	.final_csr_wdata1(final_csr_wdata1),
	.final_csr_wdata2(final_csr_wdata2),
	.final_csr_we1 	(final_csr_we1),
	.final_csr_we2 	(final_csr_we2),
	.final_reg_we 	(final_reg_we),
	.wbu_diff_pc 	(wbu_diff_pc),
	.wbu_diff_npc 	(wbu_diff_npc),
	.wbu_diff_inst 	(wbu_diff_inst)
);



hazard_unit inst_hazard_unit(
	.rs1_addr_id 	(if_id_rs1),
	.rs2_addr_id 	(if_id_rs2),

	.rs1_addr_ex 	(id_ex_rs1_addr),
	.rs2_addr_ex 	(id_ex_rs2_addr),
	.rd_addr_ex 	(id_ex_rd_addr),
	.rs1_ren_ex 	(id_ex_rs1_en),
	.rs2_ren_ex 	(id_ex_rs2_en),
	.mem_re_ex 		(id_ex_mem_re),

	.branch_taken_ex(exu_branch_taken),

	.rd_addr_mem 	(ex_lsu_rd),
	.reg_we_mem 	(ex_lsu_reg_we),

	.rd_addr_wb 	(lsu_wbu_rd),
	.reg_we_wb 		(lsu_wbu_reg_we),

	.ifu_stall_req 	(ifu_stall_rqst),
	.lsu_stall_req 	(lsu_stall_rqst),

	.stall_pc 		(hazard_stall_pc),
	.stall_if_id 	(hazard_stall_if_id),
	.stall_id_ex 	(hazard_stall_id_ex),
	.stall_ex_mem 	(hazard_stall_ex_mem),
	.stall_mem_wb 	(hazard_stall_mem_wb),
	.flush_if_id 	(hazard_flush_if_id),
	.flush_id_ex 	(hazard_flush_id_ex),
	.flush_ex_mem 	(hazard_flush_ex_mem),
	.flush_mem_wb 	(hazard_flush_mem_wb),

	.forward_a 		(hazard_forward_a),
	.forward_b 		(hazard_forward_b)
);

gpr inst_gpr(
	.clk 			(clk),
	.wdata 			(final_rd_wdata),
	.waddr 			(final_rd_waddr),
	.wen 			(final_reg_we),
	.raddr1 		(id_rs1_addr),
	.raddr2 		(id_rs2_addr),
	.rdata1 		(id_rs1_src),
	.rdata2 		(id_rs2_src)
);

csr inst_csr(
	.clk 			(clk),
	.csr_wen1 		(final_csr_we1),
	.csr_wen2		(final_csr_we2),
	.csr_raddr 		(id_csr_raddr),
	.csr_waddr1 	(final_csr_waddr1),
	.csr_waddr2 	(final_csr_waddr2),
	.csr_wdata1 	(final_csr_wdata1),
	.csr_wdata2 	(final_csr_wdata2),
	.csr_rdata 		(id_csr_src)
);
endmodule
