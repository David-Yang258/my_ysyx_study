/*-------
*@brief: convert lite signal 2 full signal
*@AxLEN should be 0;
*@Axburst should be 0
*@AxSize should be 0x2(32 bits)
*@AxID should be 0?
*@WLAST should be 1
*@punch-through the rest signals
--------*/
`include "bus_define.vh"
module lite2full_bridge(
	input 							l_awvalid,
	output 							l_awready,
	input   [`BUS_DATA_WIDTH-1:0] 	l_awaddr,

	input 							l_wvalid,
	output 							l_wready,
	input 	[`BUS_DATA_WIDTH-1:0]	l_wdata,
	input   [3:0] 					l_wstrb,
	
	output 							l_bvalid,
	input 							l_bready,
	output  [1:0]					l_bresp,

	input 							l_arvalid,
	output 							l_arready,
	input   [`BUS_DATA_WIDTH-1:0] 	l_araddr,

	output 							l_rvalid,
	input 							l_rready,
	output  [`BUS_DATA_WIDTH-1:0] 	l_rdata,
	output  [1:0] 					l_rresp,

	output         					f_awvalid,
    input          					f_awready,
    output  [`BUS_DATA_WIDTH-1:0] 	f_awaddr,
    output  [7:0]  					f_awlen,    
    output  [2:0]  					f_awsize,   
    output  [1:0]  					f_awburst,  
    output  [3:0]  					f_awid,     

    output         					f_wvalid,
    input          					f_wready,
    output  [`BUS_DATA_WIDTH-1:0] 	f_wdata,
    output  [3:0]  					f_wstrb,
    output         					f_wlast,    

    input          					f_bvalid,
    output         					f_bready,
    input   [1:0]  					f_bresp,
	/*verilator lint_off UNUSEDSIGNAL*/
    input   [3:0]  					f_bid,      

    output         					f_arvalid,
    input          					f_arready,
    output  [`BUS_DATA_WIDTH-1:0] 	f_araddr,
    output  [7:0]  					f_arlen,    
    output  [2:0]  					f_arsize,   
    output  [1:0]  					f_arburst,  
    output  [3:0]  					f_arid,     

    input          					f_rvalid,
    output         					f_rready,
    input   [`BUS_DATA_WIDTH-1:0] 	f_rdata,
    input   [1:0]  					f_rresp,
    input          					f_rlast,    
    input   [3:0]  					f_rid       
);

    assign f_awvalid  = l_awvalid;
    assign l_awready  = f_awready;
    assign f_awaddr   = l_awaddr;

    assign f_awlen    = 8'h00;        
    assign f_awsize   = 3'b010;       
    assign f_awburst  = 2'b01;        
    assign f_awid     = 4'h0;         

    assign f_wvalid   = l_wvalid;
    assign l_wready   = f_wready;
    assign f_wdata    = l_wdata;
    assign f_wstrb    = l_wstrb;
    assign f_wlast    = 1'b1;           

    assign l_bvalid   = f_bvalid;
    assign f_bready   = l_bready;
    assign l_bresp    = f_bresp;

    assign f_arvalid   = l_arvalid;
    assign l_arready   = f_arready;
    assign f_araddr    = l_araddr;

    assign f_arlen     = 8'h00;
    assign f_arsize    = 3'b010;
    assign f_arburst   = 2'b01;
    assign f_arid      = 4'h0;

    assign l_rvalid    = f_rvalid;
    assign f_rready    = l_rready;
    assign l_rdata     = f_rdata;
    assign l_rresp     = f_rresp;

endmodule

