`include "bus_define.vh"
module ysyx_26030090(
	//clock
	input 				clock,
	input 				reset,
	/*verilator lint_off UNUSEDSIGNAL*/
	input 				io_interrupt,
	input             	io_master_awready,
	output           	io_slave_awready ,
    output            	io_master_awvalid,
	input            	io_slave_awvalid ,
    output  [31:0]  	io_master_awaddr ,
	input  	[31:0]  	io_slave_awaddr  ,
    output  [3:0]   	io_master_awid   ,
	input  	[3:0]   	io_slave_awid    ,
    output  [7:0]   	io_master_awlen  ,
	input  	[7:0]   	io_slave_awlen   ,
    output  [2:0]   	io_master_awsize ,
	input  	[2:0]   	io_slave_awsize  ,
    output  [1:0]   	io_master_awburst,
	input  	[1:0]   	io_slave_awburst ,
    input             	io_master_wready ,
	output           	io_slave_wready  ,
    output            	io_master_wvalid ,
	input            	io_slave_wvalid  ,
    output  [31:0]  	io_master_wdata  ,
	input  	[31:0]  	io_slave_wdata   ,
    output  [3:0]   	io_master_wstrb  ,
	input  	[3:0]   	io_slave_wstrb   ,
    output            	io_master_wlast  ,
	input            	io_slave_wlast   ,
    output            	io_master_bready ,
	input            	io_slave_bready  ,
    input             	io_master_bvalid ,
	output           	io_slave_bvalid  ,
    input   [1:0]   	io_master_bresp  ,
	output 	[1:0]   	io_slave_bresp   ,
    input   [3:0]   	io_master_bid    ,
	output 	[3:0]   	io_slave_bid     ,
    input             	io_master_arready,
	output           	io_slave_arready ,
    output            	io_master_arvalid,
	input            	io_slave_arvalid ,
    output  [31:0]  	io_master_araddr ,
	input  	[31:0]  	io_slave_araddr  ,
    output  [3:0]   	io_master_arid   ,
	input  	[3:0]   	io_slave_arid    ,
    output  [7:0]   	io_master_arlen  ,
	input  	[7:0]   	io_slave_arlen   ,
    output  [2:0]   	io_master_arsize ,
	input  	[2:0]   	io_slave_arsize  ,
    output  [1:0]   	io_master_arburst,
	input  	[1:0]   	io_slave_arburst ,
    output            	io_master_rready ,
	input            	io_slave_rready  ,
    input             	io_master_rvalid ,
	output           	io_slave_rvalid  ,
    input   [1:0]   	io_master_rresp  ,
	output 	[1:0]   	io_slave_rresp   ,
    input   [31:0]  	io_master_rdata  ,
	output 	[31:0]  	io_slave_rdata   ,
    input             	io_master_rlast  ,
	output           	io_slave_rlast   ,
    input   [3:0]   	io_master_rid    ,
	output 	[3:0]   	io_slave_rid     
	/*verilator lint_on UNUSEDSIGNAL*/

	//output [`BUS_DATA_WIDTH-1:0] pc,
	//output [`BUS_DATA_WIDTH-1:0] inst,
	//output [2:0] o_ifu_state,
	//output bus_error,
	//output Ebreak
);
/*verilator lint_off UNUSEDSIGNAL*/
wire ifu_bus_error;
wire idu_bus_error;
wire exu_bus_error;
wire lsu_bus_error;
wire wbu_bus_error;
wire Ebreak;
/*verilator lint_on UNUSEDSIGNAL*/
wire [`BUS_DATA_WIDTH-1:0]  pc;
wire 						jmp_set;
wire 						stall;
wire 						ifu_valid;
wire [`BUS_DATA_WIDTH-1:0]  jmp_addr;

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
//wire 						lsu_valid;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_addr;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_wdata;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_rdata;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_rdata;
//wire lsu_ready;

wire final_mem_we;
wire final_reg_we;
wire final_csr_we1;
wire final_csr_we2;
wire [`REG_ADDR_WIDTH-1:0] final_rd_waddr;
wire [`CSR_ADDR_WIDTH-1:0] final_csr_waddr1;
wire [`CSR_ADDR_WIDTH-1:0] final_csr_waddr2;
wire [`BUS_DATA_WIDTH-1:0] final_mem_waddr;
wire [`BUS_DATA_WIDTH-1:0] final_rd_wdata;
wire [`BUS_DATA_WIDTH-1:0] final_csr_wdata1;
wire [`BUS_DATA_WIDTH-1:0] final_csr_wdata2;
wire [`BUS_DATA_WIDTH-1:0] final_mem_wdata;
wire wbu_ready;


assign stall = 1'b0;

assign lsu_mem_re 	 = idu_mem_re;

wire ifu_arvalid;
wire [`MEM_ADDR_WIDTH-1:0] ifu_araddr;
wire ifu_arready;

wire [`BUS_DATA_WIDTH-1:0] ifu_rdata;
wire ifu_rvalid;
wire [1:0] ifu_rresp;
wire ifu_rready;
/*verilator lint_off UNUSEDSIGNAL*/
wire [`MEM_ADDR_WIDTH-1:0] ifu_awaddr;
wire ifu_awvalid;
wire ifu_awready;

wire [`BUS_DATA_WIDTH-1:0] ifu_wdata;
wire [3:0] ifu_wstrb;
wire ifu_wvalid;
wire ifu_wready;

wire [1:0] ifu_bresp;
wire ifu_bvalid;
wire ifu_bready;
/*verilator lint_on UNUSEDSIGNAL*/
assign ifu_awready = 1'b0;
assign ifu_wready  = 1'b0;
assign ifu_bresp   = 2'b00;
assign ifu_bvalid  = 1'b0;

wire oled;

ifu ysyx_26030090_ifu(
	.clk 			(clock),
	.reset  		(reset),
	.branch_happen  (jmp_set),
	.branch_addr 	(jmp_addr),
	.stall 			(stall),

	.arvalid 		(ifu_arvalid),
	.araddr 		(ifu_araddr),
	.arready 		(ifu_arready),

	.rdata 			(ifu_rdata),
	.rvalid 		(ifu_rvalid),
	.rresp 			(ifu_rresp),
	.rready 		(ifu_rready),

	.awaddr 		(ifu_awaddr),
	.awvalid 		(ifu_awvalid),
	.awready 		(ifu_awready),

	.wdata 			(ifu_wdata),
	.wstrb 			(ifu_wstrb),
	.wvalid 		(ifu_wvalid),
	.wready 		(ifu_wready),

	.bresp 			(ifu_bresp),
	.bvalid 		(ifu_bvalid),
	.bready 		(ifu_bready),

	.pc 			(pc),
	.inst 			(instruction),
	.i_ready 		(idu_ready),
	.o_valid 		(ifu_valid),
	.clked 			(oled),
	.bus_error 		(ifu_bus_error)
);

idu ysyx_26030090_idu(
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

exu ysyx_26030090_exu(
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

wire lsu_arvalid;
wire [`MEM_ADDR_WIDTH-1:0] lsu_araddr;
wire lsu_arready;

wire [`BUS_DATA_WIDTH-1:0] lsu_rdata;
wire lsu_rvalid;
wire [1:0] lsu_rresp;
wire lsu_rready;

wire [`MEM_ADDR_WIDTH-1:0] lsu_awaddr;
wire lsu_awvalid;
wire lsu_awready;

wire [`BUS_DATA_WIDTH-1:0] lsu_wdata;
wire [3:0] lsu_wstrb;
wire lsu_wvalid;
wire lsu_wready;

wire [1:0] lsu_bresp;
wire lsu_bvalid;
wire lsu_bready;

lsu ysyx_26030090_lsu(
	.clk 			(clock),
	.reset 			(reset),
	.mem_re 		(lsu_mem_re),
	.mem_we 		(final_mem_we),
	.ls_type 		(ls_type),
	.alu2lsu_raddr	(exu_alu_result),
	.wbu2lsu_waddr	(final_mem_waddr),
	.wbu2lsu_wdata 	(final_mem_wdata),
	.stall 			(stall),
	.exu_valid 		(exu_valid),
	.lsu_wcpl 		(lsu_wcpl),
	.lsu_rcpl 		(lsu_rcpl),
	.mem_rdata 		(lsu_mem_rdata),

	
	.arvalid 		(lsu_arvalid),
	.araddr 		(lsu_araddr),
	.arready 		(lsu_arready),

	.rdata 			(lsu_rdata),
	.rvalid 		(lsu_rvalid),
	.rresp 			(lsu_rresp),
	.rready 		(lsu_rready),

	.awaddr 		(lsu_awaddr),
	.awvalid 		(lsu_awvalid),
	.awready 		(lsu_awready),

	.wdata 			(lsu_wdata),
	.wstrb 			(lsu_wstrb),
	.wvalid 		(lsu_wvalid),
	.wready 		(lsu_wready),

	.bresp 			(lsu_bresp),
	.bvalid 		(lsu_bvalid),
	.bready 		(lsu_bready),
	//.lsu_ready 		(lsu_ready),
	.i_ready 		(wbu_ready),
	//.o_valid 		(lsu_valid),
	.bus_error 		(lsu_bus_error)
);

wbu ysyx_26030090_wbu(
	.clk 			(clock),
	.reset 			(reset),
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

gpr ysyx_26030090_gpr(
	.clk 			(clock),
	.wdata 			(final_rd_wdata),
	.waddr 			(final_rd_waddr),
	.wen 			(final_reg_we),
	.raddr1 		(rs1_addr),
	.raddr2 		(rs2_addr),
	.rdata1 		(rs1_src),
	.rdata2 		(rs2_src)
);

csr ysyx_26030090_csr(
	.clk 			(clock),
	.csr_wen1 		(final_csr_we1),
	.csr_wen2		(final_csr_we2),
	.csr_raddr 		(csr_raddr),
	.csr_waddr1 	(final_csr_waddr1),
	.csr_waddr2 	(final_csr_waddr2),
	.csr_wdata1 	(final_csr_wdata1),
	.csr_wdata2 	(final_csr_wdata2),
	.csr_rdata 		(csr_src)
);

wire arb_arvalid;
wire [`MEM_ADDR_WIDTH-1:0] arb_araddr;
wire arb_arready;

wire [`BUS_DATA_WIDTH-1:0] arb_rdata;
wire arb_rvalid;
wire [1:0] arb_rresp;
wire arb_rready;

wire [`MEM_ADDR_WIDTH-1:0] arb_awaddr;
wire arb_awvalid;
wire arb_awready;

wire [`BUS_DATA_WIDTH-1:0] arb_wdata;
wire [3:0] arb_wstrb;
wire arb_wvalid;
wire arb_wready;

wire [1:0] arb_bresp;
wire arb_bvalid;
wire arb_bready;

arbiter_mem ysyx_26030090_arbiter(
	.aclk 			(clock),
	.reset 		(reset),

	.ifu_arvalid 	(ifu_arvalid),
	.ifu_araddr 	(ifu_araddr),
	.ifu_arready    (ifu_arready),

	.ifu_rdata 		(ifu_rdata),
	.ifu_rvalid 	(ifu_rvalid),
	.ifu_rresp 		(ifu_rresp),
	.ifu_rready 	(ifu_rready),

	.ifu_awaddr 	(ifu_awaddr),
	.ifu_awvalid 	(ifu_awvalid),
	.ifu_awready 	(ifu_awready),

	.ifu_wdata 		(ifu_wdata),
	.ifu_wstrb 		(ifu_wstrb),
	.ifu_wvalid 	(ifu_wvalid),
	.ifu_wready 	(ifu_wready),

	.ifu_bresp 		(ifu_bresp),
	.ifu_bvalid 	(ifu_bvalid),
	.ifu_bready 	(ifu_bready),


	.lsu_arvalid 	(lsu_arvalid),
	.lsu_araddr 	(lsu_araddr),
	.lsu_arready    (lsu_arready),

	.lsu_rdata 		(lsu_rdata),
	.lsu_rvalid 	(lsu_rvalid),
	.lsu_rresp 		(lsu_rresp),
	.lsu_rready 	(lsu_rready),

	.lsu_awaddr 	(lsu_awaddr),
	.lsu_awvalid 	(lsu_awvalid),
	.lsu_awready 	(lsu_awready),

	.lsu_wdata 		(lsu_wdata),
	.lsu_wstrb 		(lsu_wstrb),
	.lsu_wvalid 	(lsu_wvalid),
	.lsu_wready 	(lsu_wready),

	.lsu_bresp 		(lsu_bresp),
	.lsu_bvalid 	(lsu_bvalid),
	.lsu_bready 	(lsu_bready),


	.arb_arvalid 	(arb_arvalid),
	.arb_araddr 	(arb_araddr),
	.arb_arready    (arb_arready),

	.arb_rdata 		(arb_rdata),
	.arb_rvalid 	(arb_rvalid),
	.arb_rresp 		(arb_rresp),
	.arb_rready 	(arb_rready),

	.arb_awaddr 	(arb_awaddr),
	.arb_awvalid 	(arb_awvalid),
	.arb_awready 	(arb_awready),

	.arb_wdata 		(arb_wdata),
	.arb_wstrb 		(arb_wstrb),
	.arb_wvalid 	(arb_wvalid),
	.arb_wready 	(arb_wready),

	.arb_bresp 		(arb_bresp),
	.arb_bvalid 	(arb_bvalid),
	.arb_bready 	(arb_bready)
);
//ASI
assign io_slave_rid = 0;
assign io_slave_rlast = 0;
assign io_slave_rdata = 0;
assign io_slave_rresp = 0;
assign io_slave_rvalid = 0;
assign io_slave_arready = 0;
assign io_slave_bid = 0;
assign io_slave_bresp = 0;
assign io_slave_bvalid = 0;
assign io_slave_wready = 0;
assign io_slave_awready = 0;

lite2full_bridge ysyx_26030090_bridge(
	.l_awvalid 		(arb_awvalid),
	.l_awready		(arb_awready),
	.l_awaddr		(arb_awaddr),
	   
	.l_wvalid		(arb_wvalid),
	.l_wready		(arb_wready),
	.l_wdata		(arb_wdata),
	.l_wstrb		(arb_wstrb),
	   
	.l_bvalid		(arb_bvalid),
	.l_bready		(arb_bready),
	.l_bresp		(arb_bresp),
	   
	.l_arvalid		(arb_arvalid),
	.l_arready		(arb_arready),
	.l_araddr		(arb_araddr),
	   
	.l_rvalid		(arb_rvalid),
	.l_rready		(arb_rready),
	.l_rdata		(arb_rdata),
	.l_rresp		(arb_rresp),
	   
	.f_awvalid		(io_master_awvalid),
	.f_awready		(io_master_awready),
	.f_awaddr		(io_master_awaddr),
	.f_awlen		(io_master_awlen),
	.f_awsize		(io_master_awsize),
	.f_awburst		(io_master_awburst),
	.f_awid			(io_master_awid),
	   
	.f_wvalid		(io_master_wvalid),
	.f_wready		(io_master_wready),
	.f_wdata		(io_master_wdata),
	.f_wstrb		(io_master_wstrb),
	.f_wlast		(io_master_wlast),
	   
	.f_bvalid		(io_master_bvalid),
	.f_bready		(io_master_bready),
	.f_bresp		(io_master_bresp),
	.f_bid			(io_master_bid),
	   
	.f_arvalid		(io_master_arvalid),
	.f_arready		(io_master_arready),
	.f_araddr		(io_master_araddr),
	.f_arlen		(io_master_arlen),
	.f_arsize		(io_master_arsize),
	.f_arburst		(io_master_arburst),
	.f_arid			(io_master_arid),
	   
	.f_rvalid		(io_master_rvalid),
	.f_rready		(io_master_rready),
	.f_rdata		(io_master_rdata),
	.f_rresp		(io_master_rresp),
	.f_rlast		(io_master_rlast), 
	.f_rid			(io_master_rid)
);

	/*----------------------------------------------------------------------
wire mem_arvalid;
wire [`MEM_ADDR_WIDTH-1:0] mem_araddr;
wire mem_arready;

wire [`BUS_DATA_WIDTH-1:0] mem_rdata;
wire mem_rvalid;
wire [1:0] mem_rresp;
wire mem_rready;

wire [`MEM_ADDR_WIDTH-1:0] mem_awaddr;
wire mem_awvalid;
wire mem_awready;

wire [`BUS_DATA_WIDTH-1:0] mem_wdata;
wire [3:0] mem_wstrb;
wire mem_wvalid;
wire mem_wready;

wire [1:0] mem_bresp;
wire mem_bvalid;
wire mem_bready;

wire uart_arvalid;
wire [`MEM_ADDR_WIDTH-1:0] uart_araddr;
wire uart_arready;

wire [`BUS_DATA_WIDTH-1:0] uart_rdata;
wire uart_rvalid;
wire [1:0] uart_rresp;
wire uart_rready;

wire [`MEM_ADDR_WIDTH-1:0] uart_awaddr;
wire uart_awvalid;
wire uart_awready;

wire [`BUS_DATA_WIDTH-1:0] uart_wdata;
wire [3:0] uart_wstrb;
wire uart_wvalid;
wire uart_wready;

wire [1:0] uart_bresp;
wire uart_bvalid;
wire uart_bready;
-----------------------------------------------------------------------*/
/*-------------------------------------------------------
xbar ysyx_26030090_xbar(
	.aclk            	(clock),
	.reset          	(reset),

	.arb_arvalid        (arb_arvalid),
	.arb_araddr         (arb_araddr),
	.arb_arready        (arb_arready),

	.arb_rdata          (arb_rdata),
	.arb_rvalid         (arb_rvalid),
	.arb_rresp          (arb_rresp),
	.arb_rready         (arb_rready),

	.arb_awaddr         (arb_awaddr),
	.arb_awvalid        (arb_awvalid),
	.arb_awready        (arb_awready),

	.arb_wdata          (arb_wdata),
	.arb_wstrb          (arb_wstrb),
	.arb_wvalid         (arb_wvalid),
	.arb_wready         (arb_wready),

	.arb_bresp          (arb_bresp),
	.arb_bvalid         (arb_bvalid),
	.arb_bready         (arb_bready),

	.mem_arvalid        (mem_arvalid),
	.mem_araddr         (mem_araddr),
	.mem_arready        (mem_arready),

	.mem_rdata          (mem_rdata),
	.mem_rvalid         (mem_rvalid),
	.mem_rresp          (mem_rresp),
	.mem_rready         (mem_rready),

	.mem_awaddr         (mem_awaddr),
	.mem_awvalid        (mem_awvalid),
	.mem_awready        (mem_awready),

	.mem_wdata          (mem_wdata),
	.mem_wstrb          (mem_wstrb),
	.mem_wvalid         (mem_wvalid),
	.mem_wready         (mem_wready),

	.mem_bresp          (mem_bresp),
	.mem_bvalid         (mem_bvalid),
	.mem_bready         (mem_bready),

	.uart_arvalid        (uart_arvalid),
	.uart_araddr         (uart_araddr),
	.uart_arready        (uart_arready),

	.uart_rdata          (uart_rdata),
	.uart_rvalid         (uart_rvalid),
	.uart_rresp          (uart_rresp),
	.uart_rready         (uart_rready),

	.uart_awaddr         (uart_awaddr),
	.uart_awvalid        (uart_awvalid),
	.uart_awready        (uart_awready),

	.uart_wdata          (uart_wdata),
	.uart_wstrb          (uart_wstrb),
	.uart_wvalid         (uart_wvalid),
	.uart_wready         (uart_wready),

	.uart_bresp          (uart_bresp),
	.uart_bvalid         (uart_bvalid),
	.uart_bready         (uart_bready)
);
--------------------------------------*/
/*------------------------------------------
uart_axi ysyx_26030090_uart(
	.aclk 			(clock),
	.reset 		(reset),

	.arvalid 		(uart_arvalid),
	.araddr 		(uart_araddr),
	.arready 		(uart_arready),

	.rdata 			(uart_rdata),
	.rvalid 		(uart_rvalid),
	.rresp 			(uart_rresp),
	.rready 		(uart_rready),

	.awaddr 		(uart_awaddr),
	.awvalid 		(uart_awvalid),
	.awready 		(uart_awready),

	.wdata 			(uart_wdata),
	.wstrb 			(uart_wstrb),
	.wvalid 		(uart_wvalid),
	.wready 		(uart_wready),

	.bresp 			(uart_bresp),
	.bvalid 		(uart_bvalid),
	.bready 		(uart_bready)
);
-------------------------------------------*/
/*-----------------------------------------
mem ysyx_26030090_mem(
	.clk 			(clock),
	.reset 			(reset),

	.arvalid 		(mem_arvalid),
	.araddr 		(mem_araddr),
	.arready 		(mem_arready),

	.rdata			(mem_rdata),
	.rvalid 		(mem_rvalid),
	.rresp 			(mem_rresp),
	.rready 		(mem_rready),

	.awaddr 		(mem_awaddr),
	.awvalid 		(mem_awvalid),
	.awready 		(mem_awready),

	.wdata 			(mem_wdata),
	.wstrb 			(mem_wstrb),
	.wvalid 		(mem_wvalid),
	.wready 		(mem_wready),

	.bresp 			(mem_bresp),
	.bvalid 		(mem_bvalid),
	.bready 		(mem_bready)
);
-----------------------------------------*/
endmodule
