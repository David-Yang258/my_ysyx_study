module mem(
	`include "bus_define.vh"
	input 						 	 clk,
	input 							 reset,

	input      [`BUS_DATA_WIDTH-1:0] araddr,
	input 							 arvalid,
	output reg 						 arready,

	output reg [`BUS_DATA_WIDTH-1:0] rdata,
	/*verilator lint_off UNUSEDSIGNAL*/
	output reg [1:0] 				 rresp,
	output reg 						 rvalid,
	input 							 rready,

	input  	   [`BUS_DATA_WIDTH-1:0] awaddr,
	input 							 awvalid,
	output reg 						 awready,

	input  	   [`BUS_DATA_WIDTH-1:0] wdata,
	input  	   [3:0] 				 wstrb,
	input 							 wvalid,
	output reg 						 wready,

	output reg [1:0]			     bresp,
	output reg 						 bvalid,
	input 							 bready
	/*verilator lint_on UNUSEDSIGNAL*/
	//output reg						 mem_ready
);

import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte mask, bit clk);

`define MAX_DELAY 5'd5

localparam MEM_IDLE = 3'b000;

localparam MEM_RD_W = 3'b001;
localparam MEM_RD_R = 3'b010;

localparam MEM_WD_W = 3'b011;
localparam MEM_WD_R = 3'b100;

reg [2:0] 				  mem_state;
reg [4:0] 				  delay;
reg [`BUS_DATA_WIDTH-1:0] araddr_lock;
reg [`BUS_DATA_WIDTH-1:0] awaddr_lock;

always@(posedge clk) begin
	if(reset) begin
		delay 	 <= 5'b0;
		mem_state<= MEM_IDLE;
		rvalid  <= 1'b0;
		arready <= 1'b0;
		awready  <= 1'b0;
		wready   <= 1'b0;
		bvalid   <= 1'b0;
		rresp   <= 2'b00;
		bresp 	 <= 2'b00;
	end
	else begin
		case(mem_state) 
			MEM_IDLE: begin
				rvalid <= 1'b0;
				wready <= 1'b0;
				if(bready) bvalid <= 1'b0;
				if(arvalid) begin
					araddr_lock <= araddr;
					if(arvalid) arready <= 1'b1;
					mem_state 	 <= MEM_RD_W;
				end
				else if(awvalid) begin
					awaddr_lock  <= awaddr;
					awready 	 <= 1'b1;
					mem_state    <= MEM_WD_W;
				end
			end
			MEM_RD_W: begin
				arready <= 1'b0;
				if(delay != `MAX_DELAY) delay <= delay + 5'b1;
				else mem_state <= MEM_RD_R;
			end
			MEM_WD_W: begin
				awready  <= 1'b0;
				if(delay != `MAX_DELAY) delay <= delay + 5'b1;
				else mem_state <= MEM_WD_R;
			end
			MEM_RD_R: begin
				rvalid  <= 1'b1;
				rdata   <= pmem_read(araddr_lock);
				if(rready) mem_state<= MEM_IDLE;
				delay    <= 5'b0;
			end
			MEM_WD_R: begin
				if(wvalid) begin 
					wready   <= 1'b1;
					bvalid   <= 1'b1;
					mem_state<=MEM_IDLE;
				end
				delay 	 <= 5'b0;
				case(wstrb)
					4'b0001: pmem_write(awaddr_lock, wdata      , 8'h01, clk);
					4'b0010: pmem_write(awaddr_lock, wdata << 8 , 8'h02, clk);
					4'b0100: pmem_write(awaddr_lock, wdata << 16, 8'h04, clk);
					4'b1000: pmem_write(awaddr_lock, wdata << 24, 8'h08, clk);
					4'b0011: pmem_write(awaddr_lock, wdata 	   , 8'h03, clk);
					4'b0110: pmem_write(awaddr_lock, wdata << 8 , 8'h06, clk);
					4'b1100: pmem_write(awaddr_lock, wdata << 16, 8'h0c, clk);
					4'b1111: pmem_write(awaddr_lock, wdata 	   , 8'h0f, clk);
					default: ;
				endcase
			end
			default: ;
		endcase
	end
end
endmodule
