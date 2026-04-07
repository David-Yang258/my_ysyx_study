module mem(
	`include "bus_define.vh"
	input 						 	 clk,
	input 							 rst_n,
	input      [`BUS_DATA_WIDTH-1:0] mem_raddr1,
	input      [`BUS_DATA_WIDTH-1:0] mem_raddr2,
	input  	   [`BUS_DATA_WIDTH-1:0] mem_waddr,
	input  	   [`BUS_DATA_WIDTH-1:0] mem_wdata,
	input 						 	 mem_re1,
	input 						 	 mem_re2,
	input 							 mem_we,
	input  	   [3:0] 				 mem_be,
	output reg						 mem_ready,
	output reg [`BUS_DATA_WIDTH-1:0] mem_rdata1,
	output reg [`BUS_DATA_WIDTH-1:0] mem_rdata2
);

import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte mask, bit clk);

`define MAX_DELAY 5'd0
reg [4:0] delay;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		delay <= 5'b0;
		mem_ready <= 1'b0;
	end
	else begin
		if(mem_re1 | mem_re2) begin
			if(delay != `MAX_DELAY) begin 
				delay <= delay + 5'b1;
				mem_ready<= 1'b0;
			end
			else begin
				mem_rdata1 <= pmem_read(mem_raddr1);
				mem_rdata2 <= pmem_read(mem_raddr2);	
				mem_ready  <= 1'b1;
				delay      <= 5'b0;
			end
		end
		else if(mem_we) begin
			if(delay != `MAX_DELAY) begin
				delay <= delay + 5'b1;
				mem_ready<= 1'b0;
			end
			else begin
				case(mem_be) 
					4'b0001: pmem_write(mem_waddr, mem_wdata      , 8'h01, clk);
					4'b0010: pmem_write(mem_waddr, mem_wdata << 8 , 8'h02, clk);
					4'b0100: pmem_write(mem_waddr, mem_wdata << 16, 8'h04, clk);
					4'b1000: pmem_write(mem_waddr, mem_wdata << 24, 8'h08, clk);
					4'b0011: pmem_write(mem_waddr, mem_wdata 	  , 8'h03, clk);
					4'b0110: pmem_write(mem_waddr, mem_wdata << 8 , 8'h06, clk);
					4'b1100: pmem_write(mem_waddr, mem_wdata << 16, 8'h0c, clk);
					4'b1111: pmem_write(mem_waddr, mem_wdata 	  , 8'h0f, clk);
				default: ;
				endcase
				mem_ready <= 1'b1;
				delay      <= 5'b0;
			end
		end
		else begin 
			delay <= 5'b0;
			mem_ready <= 1'b0;
		end
	end
end
endmodule
