`include "bus_define.vh"
module uart_axi(
	input 								aclk,
	input 								arst_n,
	
	input 								arvalid,
	input 		[`MEM_ADDR_WIDTH-1:0] 	araddr,
	output reg 							arready,

	output reg  [`BUS_DATA_WIDTH-1:0]   rdata,
	output reg                          rvalid,
	output reg  [1:0]                   rresp,
	input                               rready,

	/*verilator lint_off UNUSEDSIGNAL*/
	input      	[`MEM_ADDR_WIDTH-1:0]   awaddr,
	input                               awvalid,
	output reg                          awready,

	input      	[`BUS_DATA_WIDTH-1:0]   wdata,
	input      	[3:0]                   wstrb,
	input                               wvalid,
	output reg                          wready,

	output reg 	[1:0]                   bresp,
	output reg                          bvalid,
	input                               bready	
);

import "DPI-C" function void uart_printf(input int wdata, input clk);

`define UART_MAX_DELAY 5'd5

localparam UART_IDLE = 3'b000;
localparam UART_RD_W = 3'b001;
localparam UART_RD_R = 3'b010;
localparam UART_WD_R = 3'b011;
localparam UART_WD_W = 3'b100;

reg [2:0] uart_state;
reg [4:0] delay;
reg [`BUS_DATA_WIDTH-1:0] araddr_lock;
reg [`BUS_DATA_WIDTH-1:0] awaddr_lock;

always@(posedge aclk or negedge arst_n) begin
if(!arst_n) begin
            delay    	<= 5'b0;
            uart_state 	<= UART_IDLE;
            rvalid  	<= 1'b0;
            arready 	<= 1'b0;
            awready  	<= 1'b0;
            wready   	<= 1'b0;
            bvalid   	<= 1'b0;
            rresp  	 	<= 2'b00;
            bresp    	<= 2'b00;
        end
        else begin
            case(uart_state)
                UART_IDLE: begin
                    rvalid <= 1'b0;
					wready <= 1'b0;
                    if(bready) bvalid <= 1'b0;
                    if(arvalid) begin
                        araddr_lock <= araddr;
                        if(arvalid) arready <= 1'b1;
                        uart_state    <= UART_RD_W;
                    end
                    else if(awvalid) begin
                        awaddr_lock  <= awaddr;
                        awready      <= 1'b1;
                        uart_state    <= UART_WD_W;
                    end
                end
                UART_RD_W: begin
                    arready <= 1'b0;
                    if(delay != `UART_MAX_DELAY) delay <= delay + 5'b1;
                    else uart_state <= UART_RD_R;
                end
				UART_RD_R: begin
                    rvalid  <= 1'b1;
                    rdata   <= 32'd1919810;
                    if(rready) uart_state<= UART_IDLE;
                    delay    <= 5'b0;
                end
                UART_WD_W: begin
                    awready  <= 1'b0;
                    if(delay != `UART_MAX_DELAY) delay <= delay + 5'b1;
                    else uart_state <= UART_WD_R;
                end	
				UART_WD_R: begin
                    if(wvalid) begin
                        wready   <= 1'b1;
                        bvalid   <= 1'b1;
                        uart_state<=UART_IDLE;
                    end
                   delay    <= 5'b0;
				   uart_printf(wdata, aclk);
               end
               default: ;
           endcase
       end
end


endmodule
