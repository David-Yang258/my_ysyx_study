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
wire 						ifu_valid;
wire 						ifu_bus_error;
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
//wire 						lsu_valid;
wire 						lsu_bus_error;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_addr;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_wdata;
//wire [`BUS_DATA_WIDTH-1:0] 	alu2lsu_rdata;
wire [`BUS_DATA_WIDTH-1:0] 	lsu_mem_rdata;
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


assign stall = 1'b0;
assign bus_error = ifu_bus_error | idu_bus_error | exu_bus_error | lsu_bus_error | wbu_bus_error;

assign lsu_mem_re 	 = idu_mem_re;
assign inst = instruction;

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

ifu inst_ifu(
	.clk 			(clk),
	.rst_n  		(rst_n),
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

lsu inst_lsu(
	.clk 			(clk),
	.rst_n 			(rst_n),
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

arbiter_mem inst_arbiter(
	.aclk 			(clk),
	.arst_n 		(rst_n),

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

xbar inst_xbar(
	.aclk            	(clk),
	.arst_n          	(rst_n),

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

uart_axi inst_uart(
	.aclk 			(clk),
	.arst_n 		(rst_n),

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

mem inst_mem(
	.clk 			(clk),
	.rst_n 			(rst_n),

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
endmodule
