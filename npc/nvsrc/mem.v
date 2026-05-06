module mem(
	`include "bus_define.vh"
	input 						 	 clk,

	input      [`BUS_DATA_WIDTH-1:0] araddr,

	output reg [`BUS_DATA_WIDTH-1:0] rdata,
	/*verilator lint_off UNUSEDSIGNAL*/

	input  	   [`BUS_DATA_WIDTH-1:0] awaddr,
	input 							 awvalid,

	input  	   [`BUS_DATA_WIDTH-1:0] wdata,
	input  	   [1:0] 				 wstrb
	/*verilator lint_on UNUSEDSIGNAL*/
	//output reg						 mem_ready
);

import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte mask, bit clk);


always@(*) begin
	rdata   = pmem_read(araddr);
	if(awvalid) begin
		case(wstrb)
			2'b00: pmem_write(awaddr, wdata      , 8'b00, clk);
			2'b01: pmem_write(awaddr, wdata  	 , 8'b01, clk);
			2'b10: pmem_write(awaddr, wdata  	 , 8'b10, clk);
			2'b11: ;
			default: ;
		endcase
	end
end
endmodule
