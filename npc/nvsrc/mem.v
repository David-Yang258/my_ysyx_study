module mem(
	`include "bus_define.vh"
	input 						 	 clk,

	input      [`BUS_DATA_WIDTH-1:0] araddr,

	output reg [`BUS_DATA_WIDTH-1:0] rdata,
	/*verilator lint_off UNUSEDSIGNAL*/

	input  	   [`BUS_DATA_WIDTH-1:0] awaddr,
	input 							 awvalid,

	input  	   [`BUS_DATA_WIDTH-1:0] wdata,
	input  	   [3:0] 				 wstrb
	/*verilator lint_on UNUSEDSIGNAL*/
	//output reg						 mem_ready
);

import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte mask, bit clk);


always@(*) begin
	rdata   = pmem_read(araddr);
	if(awvalid) begin
		case(wstrb)
			4'b0001: pmem_write(awaddr, wdata      , 8'h01, clk);
			4'b0010: pmem_write(awaddr, wdata << 8 , 8'h02, clk);
			4'b0100: pmem_write(awaddr, wdata << 16, 8'h04, clk);
			4'b1000: pmem_write(awaddr, wdata << 24, 8'h08, clk);
			4'b0011: pmem_write(awaddr, wdata 	   , 8'h03, clk);
			4'b0110: pmem_write(awaddr, wdata << 8 , 8'h06, clk);
			4'b1100: pmem_write(awaddr, wdata << 16, 8'h0c, clk);
			4'b1111: pmem_write(awaddr, wdata 	   , 8'h0f, clk);
			default: ;
		endcase
	end
end
endmodule
