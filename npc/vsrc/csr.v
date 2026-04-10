module csr #(ADDR_WIDRH = 12, DATA_WIDTH = 32)(
	input 						 clk,
	//input 						 rst_n,
	/* verilator lint_off UNUSEDSIGNAL*/
	input 						 csr_wen,
	input 		[ADDR_WIDRH-1:0] csr_raddr,
	input 		[DATA_WIDTH-1:0] csr_wdata1,
	input 		[ADDR_WIDRH-1:0] csr_waddr1,
	input 		[DATA_WIDTH-1:0] csr_wdata2,
	input 		[ADDR_WIDRH-1:0] csr_waddr2,
	/* verilator lint_on UNUSEDSIGNAL*/
	output reg  [DATA_WIDTH-1:0] csr_rdata//,
	//input 		[1:0] 				csr_op,
);

localparam CSR_MSTATUS 	= 12'h300;
//localparam CSR_MIE 		= 12'h304
//
localparam CSR_MCAUSE 	= 12'h342;
localparam CSR_MEPC 	= 12'h341;
localparam CSR_MTVEC 	= 12'h305;

localparam CSR_MCYCLE 	= 12'hB00;
localparam CSR_MCYCLEH	= 12'hB80;
localparam CSR_MARCHID  = 12'hF12;
localparam CSR_MVENDORTID = 12'hF11;

reg  [31:0] mcycle_l;
reg  [31:0] mcycle_h;
reg  [31:0] mcause;
reg  [31:0] mepc;
reg  [31:0] mtvec;
reg  [31:0] mstatus;
wire [31:0] mvendorid;
wire [31:0] marchid;

assign mvendorid = 32'h79737978;
assign marchid   = 32'd26030090;
assign mstatus   = 32'h1800;

always@(posedge clk /*or negedge rst_n*/)begin
	/*if(!rst_n) begin
		mcycle_h <= 32'b0;
		mcycle_l <= 32'b0;
	end
	else begin*/
		if(mcycle_h == 32'hFFFFFFFF) begin
			mcycle_l <= 32'b0;
			mcycle_h <= mcycle_h + 32'b1;
		end
		else mcycle_l <= mcycle_l + 32'b1;

	//end
end

always@(posedge clk) begin
	if(csr_wen) begin
		case(csr_waddr1)
			CSR_MCAUSE: mcause <= csr_wdata1;
			CSR_MEPC  : mepc   <= csr_wdata1;
			CSR_MTVEC : mtvec  <= csr_wdata1;
			CSR_MSTATUS:mstatus<= csr_wdata1;
			default   :;
		endcase
		case(csr_waddr2)
			CSR_MCAUSE: mcause <= csr_wdata2;
			CSR_MEPC  : mepc   <= csr_wdata2;
			CSR_MTVEC : mtvec  <= csr_wdata2;
			CSR_MSTATUS:mstatus<= csr_wdata1;
			default   :;
		endcase
	end
end

always@(*) begin
	case(csr_raddr)
		CSR_MCYCLE : csr_rdata = mcycle_l;
		CSR_MCYCLEH: csr_rdata = mcycle_h;
		CSR_MARCHID: csr_rdata = marchid;
		CSR_MCAUSE : csr_rdata = mcause;
		CSR_MEPC   : csr_rdata = mepc;
		CSR_MTVEC  : csr_rdata = mtvec;
		CSR_MSTATUS: csr_rdata = mstatus;
		CSR_MVENDORTID:csr_rdata=mvendorid;
		default: 	 csr_rdata = 32'h00114514;
	endcase
end

endmodule
