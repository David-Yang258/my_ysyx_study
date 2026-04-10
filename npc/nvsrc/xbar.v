`include "bus_define.vh"
module xbar(
	input 								aclk,
	input 								reset,
	input                               arb_arvalid,
	input      [`MEM_ADDR_WIDTH-1:0]    arb_araddr,
	output                              arb_arready,

	output     [`BUS_DATA_WIDTH-1:0]    arb_rdata,
	output                              arb_rvalid,
	output     [1:0]                    arb_rresp,
	input                               arb_rready,

	/*verilator lint_off UNUSEDSIGNAL*/
	input      [`MEM_ADDR_WIDTH-1:0]    arb_awaddr,
	input                               arb_awvalid,
	output                              arb_awready,

	input      [`BUS_DATA_WIDTH-1:0]    arb_wdata,
	input      [3:0]                    arb_wstrb,
	input                               arb_wvalid,
	output                              arb_wready,

	output     [1:0]                    arb_bresp,
	output                              arb_bvalid,
	input                               arb_bready,

	
	output                             	mem_arvalid,
	output     [`MEM_ADDR_WIDTH-1:0]   	mem_araddr,
	input                              	mem_arready,

	input      [`BUS_DATA_WIDTH-1:0]   	mem_rdata,
	input                              	mem_rvalid,
	input      [1:0]                   	mem_rresp,
	output                             	mem_rready,

	/*verilator lint_off UNUSEDSIGNAL*/
	output      [`MEM_ADDR_WIDTH-1:0]  	mem_awaddr,
	output                             	mem_awvalid,
	input                              	mem_awready,

	output      [`BUS_DATA_WIDTH-1:0]  	mem_wdata,
	output      [3:0]                  	mem_wstrb,
	output                             	mem_wvalid,
	input                              	mem_wready,

	input       [1:0]                  	mem_bresp,
	input                              	mem_bvalid,
	output                             	mem_bready,


	output                             	uart_arvalid,
	output     [`MEM_ADDR_WIDTH-1:0]   	uart_araddr,
	input                              	uart_arready,

	input      [`BUS_DATA_WIDTH-1:0]   	uart_rdata,
	input                              	uart_rvalid,
	input      [1:0]                   	uart_rresp,
	output                             	uart_rready,

	/*verilator lint_off UNUSEDSIGNAL*/
	output      [`MEM_ADDR_WIDTH-1:0]  	uart_awaddr,
	output                             	uart_awvalid,
	input                              	uart_awready,

	output      [`BUS_DATA_WIDTH-1:0]  	uart_wdata,
	output      [3:0]                  	uart_wstrb,
	output                             	uart_wvalid,
	input                              	uart_wready,

	input       [1:0]                  	uart_bresp,
	input                              	uart_bvalid,
	output                             	uart_bready
);

localparam uart_addr = 32'h87000000;

wire arb_r_start;
wire uart_r_done;
wire mem_r_done;
wire arb_w_start;
wire uart_w_done;
wire mem_w_done;

assign arb_r_start = arb_arvalid & arb_rready;
assign uart_r_done = uart_rvalid;
assign mem_r_done  = mem_rvalid;
assign arb_w_start = arb_awvalid & arb_wvalid;
assign uart_w_done = uart_bvalid;
assign mem_w_done  = mem_bvalid;

reg uart_r_active;
reg mem_r_active;
reg uart_w_active;
reg mem_w_active;
reg [`MEM_ADDR_WIDTH-1:0] arb_araddr_lock;
reg [`MEM_ADDR_WIDTH-1:0] arb_awaddr_lock;

always@(posedge aclk) begin
	if(reset) begin
		uart_r_active <= 1'b0;
		uart_w_active <= 1'b0;
		mem_r_active  <= 1'b0;
		mem_w_active  <= 1'b0;
	end
	else begin
		if(arb_r_start) begin
			casez(arb_araddr)
				uart_addr: uart_r_active <= 1'b1;
				default  : mem_r_active  <= 1'b1;
			endcase
		end
		else if(arb_w_start) begin
			casez(arb_awaddr)
				uart_addr: uart_w_active <= 1'b1;
				default  : mem_w_active  <= 1'b1;
			endcase
		end

		if(uart_r_active & uart_r_done) uart_r_active <= 1'b0;
		if(uart_w_active & uart_w_done) uart_w_active <= 1'b0;
		if(mem_r_active  & mem_r_done ) mem_r_active  <= 1'b0;
		if(mem_w_active  & mem_w_done ) mem_w_active  <= 1'b0;

	end
end

reg uart_r_grant;
reg uart_w_grant;
reg mem_r_grant;
reg mem_w_grant;

always@(posedge aclk) begin
	if(reset) begin
		 uart_r_grant <= 1'b0;
		 uart_w_grant <= 1'b0;
		 mem_r_grant  <= 1'b0;
		 mem_w_grant  <= 1'b0;
	end
	else begin
		 uart_r_grant <= uart_r_active;
		 uart_w_grant <= uart_w_active;
		 mem_r_grant  <= mem_r_active;
		 mem_w_grant  <= mem_w_active;
	end
end

//Assign port for each axi-lite interface
assign uart_araddr  = arb_araddr;
assign mem_araddr   = arb_araddr;

assign uart_arvalid = uart_r_grant ? arb_arvalid : 1'b0;
assign mem_arvalid  = mem_r_grant  ? arb_arvalid : 1'b0;

assign arb_arready  = uart_r_grant ? uart_arready : (mem_r_grant ? mem_arready : 1'b0);

assign arb_rdata    = uart_r_grant ? uart_rdata   : (mem_r_grant ? mem_rdata   : 32'b0);

assign arb_rresp    = uart_r_grant ? uart_rresp   : (mem_r_grant ? mem_rresp   : 2'b0);

assign arb_rvalid   = uart_r_grant ? uart_rvalid  : (mem_r_grant ? mem_rvalid  : 1'b0);

assign uart_rready  = uart_r_grant ? arb_rready   : 1'b0;
assign mem_rready   = mem_r_grant  ? arb_rready   : 1'b0;

assign uart_awaddr  = arb_awaddr;
assign mem_awaddr   = arb_awaddr;

assign uart_awvalid = uart_w_grant ? arb_awvalid  : 1'b0;
assign mem_awvalid  = mem_w_grant  ? arb_awvalid  : 1'b0;

assign arb_awready  = uart_w_grant ? uart_awready : (mem_w_grant ? mem_awready : 1'b0);

assign uart_wdata   = arb_wdata;
assign mem_wdata    = arb_wdata;

assign uart_wstrb   = arb_wstrb;
assign mem_wstrb    = arb_wstrb;

assign uart_wvalid  = uart_w_grant ? arb_wvalid : 1'b0;
assign mem_wvalid   = mem_w_grant  ? arb_wvalid : 1'b0;

assign arb_wready   = uart_w_grant ? uart_wready  : (mem_w_grant ? mem_wready  : 1'b0);

assign arb_bresp    = uart_w_grant ? uart_bresp   : (mem_w_grant ? mem_bresp   : 2'b0);

assign arb_bvalid   = uart_bvalid | mem_bvalid; 

assign uart_bready  = arb_bready;
assign mem_bready   = arb_bready;

endmodule
