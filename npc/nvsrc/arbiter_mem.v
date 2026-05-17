`include "bus_define.vh"
module arbiter_mem(
	input 							  	aclk,
	input 							  	reset,

	input                         		ifu_arvalid,
	input      [`MEM_ADDR_WIDTH-1:0] 	ifu_araddr,
	output                           	ifu_arready,

	output 	   [`BUS_DATA_WIDTH-1:0] 	ifu_rdata,
	output 	                            ifu_rvalid,
	output 	   [1:0]                	ifu_rresp,
	input                         		ifu_rready,

	/*verilator lint_off UNUSEDSIGNAL*/
	input      [`MEM_ADDR_WIDTH-1:0] 	ifu_awaddr,
	input                            	ifu_awvalid,
	output     	                        ifu_awready,

	input      [`BUS_DATA_WIDTH-1:0] 	ifu_wdata,
	input      [3:0]                 	ifu_wstrb,
	input                            	ifu_wvalid,
	output 	                            ifu_wready,

	output     [1:0]                	ifu_bresp,
	output                              ifu_bvalid,
	input                            	ifu_bready,	
	/*verilator lint_on UNUSEDSIGNAL*/


	input                         		lsu_arvalid,
	input      [`MEM_ADDR_WIDTH-1:0] 	lsu_araddr,
	output                           	lsu_arready,

	output     [`BUS_DATA_WIDTH-1:0] 	lsu_rdata,
	output 	                            lsu_rvalid,
	output     [1:0]               	 	lsu_rresp,
	input                         		lsu_rready,

	input      [`MEM_ADDR_WIDTH-1:0] 	lsu_awaddr,
	input                            	lsu_awvalid,
	output 	                            lsu_awready,

	input      [`BUS_DATA_WIDTH-1:0] 	lsu_wdata,
	input      [3:0]                 	lsu_wstrb,
	input                            	lsu_wvalid,
	output                              lsu_wready,

	output     [1:0]                	lsu_bresp,
	output                              lsu_bvalid,
	input                            	lsu_bready,	
		

	output                          	arb_arvalid,
	output 	   [`MEM_ADDR_WIDTH-1:0] 	arb_araddr,
	input 	                          	arb_arready,

	input 	   [`BUS_DATA_WIDTH-1:0] 	arb_rdata,
	input 	                          	arb_rvalid,
	input 	   [1:0]               	 	arb_rresp,
	output                          	arb_rready,

	output  	[`MEM_ADDR_WIDTH-1:0] 	arb_awaddr,
	output 	                            arb_awvalid,
	input 	                          	arb_awready,

	output  	[`BUS_DATA_WIDTH-1:0] 	arb_wdata,
	output  	[3:0]                 	arb_wstrb,
	output 	                            arb_wvalid,
	input 	                          	arb_wready,

	input 	   [1:0]                	arb_bresp,
	input 	                          	arb_bvalid,
	output 	                            arb_bready	
);

reg ifu_r_active;
reg lsu_r_active;
reg lsu_w_active;

wire ifu_r_start;
wire lsu_r_start;
wire ifu_r_done;
wire lsu_r_done;

wire lsu_w_start;
wire lsu_w_done;

//1.Work start & done
assign ifu_r_start = ifu_arvalid;
assign ifu_r_done  = arb_rvalid;

assign lsu_r_start = lsu_arvalid;
assign lsu_r_done  = arb_rvalid;

assign lsu_w_start = lsu_awvalid;
assign lsu_w_done  = arb_bvalid;

//2.Work active
always@(posedge aclk) begin
	if(reset) begin
		ifu_r_active <= 1'b0;
		lsu_r_active <= 1'b0;
		lsu_w_active <= 1'b0;
	end
	else begin
		//Priority: IFU > LSU
		//when these 2 units request simultaneously, and no unit is
		//at work, respond to ifu first,
		//then lsu_r, then lsu_w(though lsu_r and lsu_w won't happen at the
		//same time)
		if(ifu_r_start) begin
			if(!lsu_r_active & !lsu_w_active) ifu_r_active <= 1'b1;
		end
		else if(lsu_r_start) begin
			if(!ifu_r_active & !lsu_w_active) lsu_r_active <= 1'b1;
		end
		else if(lsu_w_start) begin
			if(!ifu_r_active & !lsu_r_active) lsu_w_active <= 1'b1;
		end

		if(ifu_r_active & ifu_r_done) ifu_r_active <= 1'b0;
		else if(lsu_r_active & lsu_r_done) lsu_r_active <= 1'b0;
		else if(lsu_w_active & lsu_w_done) lsu_w_active <= 1'b0;
	end
end

wire ifu_r_grant;
wire lsu_r_grant;
wire lsu_w_grant;

//3.Bus granted by priority
assign ifu_r_grant = ifu_r_active;
assign lsu_r_grant = lsu_r_active;
assign lsu_w_grant = lsu_w_active;

//4.Assign bus for each axi-lite interface
assign arb_arvalid = ifu_r_grant ? ifu_arvalid : (lsu_r_grant ? lsu_arvalid : 1'b0 );
assign arb_araddr  = ifu_r_grant ? ifu_araddr  : (lsu_r_grant ? lsu_araddr  : 32'b0);

assign ifu_arready = ifu_r_grant & arb_arready;
assign lsu_arready = lsu_r_grant & arb_arready;

assign ifu_rdata   = arb_rdata;
assign lsu_rdata   = arb_rdata;

assign ifu_rresp   = arb_rresp;
assign lsu_rresp   = arb_rresp;

//assign ifu_rvalid  = ifu_r_grant & arb_rvalid;
//assign lsu_rvalid  = lsu_r_grant & arb_rvalid;
assign ifu_rvalid  = arb_rvalid;
assign lsu_rvalid  = arb_rvalid;

assign arb_rready  = ifu_r_grant ? ifu_rready  : (lsu_r_grant ? lsu_rready  : 1'b0);

assign arb_awaddr  = lsu_w_grant ? lsu_awaddr : 32'b0;
assign arb_awvalid = lsu_w_grant ? lsu_awvalid: 1'b0;

assign lsu_awready = lsu_w_grant ? arb_awready: 1'b0;
assign ifu_awready = 1'b0;

assign arb_wdata   = lsu_wdata;
assign arb_wstrb   = lsu_wstrb;
assign arb_wvalid  = lsu_w_grant ? lsu_wvalid : 1'b0;

assign lsu_wready  = lsu_w_grant ? arb_wready : 1'b0;
assign ifu_wready  = 1'b0;

assign lsu_bresp   = lsu_w_grant ? arb_bresp  : 2'b11;
assign ifu_bresp   = 2'b00;

assign lsu_bvalid  = arb_bvalid;
assign ifu_bvalid  = 1'b0;

assign arb_bready  = lsu_bready;

endmodule
