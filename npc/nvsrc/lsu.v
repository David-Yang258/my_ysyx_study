`include "bus_define.vh"
module lsu(
	input 								clk,
	input 								rst_n,

	input 								mem_re,
	input 								mem_we,

	input 		[2:0] 					ls_type,

	input 		[`BUS_DATA_WIDTH-1:0] 	ex_lsu_raddr,
	input 		[`BUS_DATA_WIDTH-1:0] 	ex_lsu_waddr,
	input 		[`BUS_DATA_WIDTH-1:0]   ex_lsu_wdata,

	output reg	[`BUS_DATA_WIDTH-1:0] 	mem_rdata,
	output 								lsu_stall_rqst,

	/*verilator lint_off UNUSEDSIGNAL*/

	output reg	[`BUS_DATA_WIDTH-1:0]   lsu_addr,

	input 		[`BUS_DATA_WIDTH-1:0] 	rdata, 

	output reg 							awvalid,

	output reg	[`BUS_DATA_WIDTH-1:0] 	wdata,
	output reg	[3:0]					wstrb
	
	/*verilator lint_on UNUSEDSIGNAL*/
);

localparam MEM_IDLE  	= 3'b000;
localparam MEM_HANDLE  	= 3'b011;
localparam MEM_DONE 	= 3'b100;

localparam MEM_RE   = 1'b0;
localparam MEM_WE   = 1'b1;
`include "alu.vh"

reg mem_rd_state;
//reg wait4mem;
reg  [2:0] mem_state;
wire [1:0] wbyte_sel;
wire [1:0] rbyte_sel;

assign wbyte_sel = ex_lsu_waddr[1:0];
assign rbyte_sel = ex_lsu_raddr[1:0];

assign lsu_stall_rqst = (mem_re || mem_we) && (mem_state != MEM_DONE);

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		mem_state   	<= MEM_IDLE;
		awvalid  		<= 1'b0;
		wstrb  			<= 4'b0;
		mem_rd_state 	<= 1'b0;
	end
	else begin
		case(mem_state)
			MEM_IDLE:begin
				if(mem_re) begin
					mem_rd_state 	<= MEM_RE;
					lsu_addr   		<= ex_lsu_raddr;
					mem_state  	 	<= MEM_HANDLE;
				end
				else if(mem_we) begin
					mem_rd_state 	<= MEM_WE;
					lsu_addr   		<= ex_lsu_waddr;
					wdata   		<= ex_lsu_wdata;
					awvalid 		<= 1'b1;
					case(ls_type)
						`LS_TYPE_B: begin
							case(wbyte_sel)
								2'b00: wstrb <= 4'b0001;
								2'b01: wstrb <= 4'b0010;
								2'b10: wstrb <= 4'b0100;
								2'b11: wstrb <= 4'b1000;
							endcase
						end	
						`LS_TYPE_H:begin
							case(wbyte_sel)
								2'b00: wstrb <= 4'b0011;
								2'b10: wstrb <= 4'b1100;
								default:; 
							endcase
						end	
						`LS_TYPE_W: wstrb <= 4'b1111; 
						default:  wstrb <= 4'b0; 
					endcase
					mem_state  <= MEM_HANDLE;
				end
				else begin
				   	mem_state  <= MEM_IDLE;
				end
			end
			MEM_HANDLE:begin
				case(mem_rd_state)
					MEM_RE:begin
						case(ls_type)
							`LS_TYPE_B :  begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{24{rdata[7]}},{rdata[7:0]}};
									2'b01: mem_rdata <= {{24{rdata[15]}},{rdata[15:8]}};
									2'b10: mem_rdata <= {{24{rdata[23]}},{rdata[23:16]}};
									2'b11: mem_rdata <= {{24{rdata[31]}},{rdata[31:24]}};
								endcase
							end
							`LS_TYPE_BU:  begin
								case(rbyte_sel)
									2'b00: mem_rdata <= {{24{1'b0}},{rdata[7:0]}};
									2'b01: mem_rdata <= {{24{1'b0}},{rdata[15:8]}};
									2'b10: mem_rdata <= {{24{1'b0}},{rdata[23:16]}};
									2'b11: mem_rdata <= {{24{1'b0}},{rdata[31:24]}};
								endcase
							end	
							`LS_TYPE_H : begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{16{rdata[15]}},{rdata[15:0]}};
									2'b10: mem_rdata <= {{16{rdata[31]}},{rdata[31:16]}};
									default:;
								endcase
							end	
							`LS_TYPE_HU: begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{16{1'b0}},{rdata[15:0]}};
									2'b10: mem_rdata <= {{16{1'b0}},{rdata[31:16]}};
									default:;
								endcase
							end
							`LS_TYPE_W : mem_rdata <= rdata; 
							default    : mem_rdata <= 32'h7FDFDFDF;
						endcase
						mem_state <= MEM_DONE;
					end	
					MEM_WE:begin
							mem_state <= MEM_DONE;
						end
					default: ;
				endcase
				awvalid 		<= 1'b0;
				wstrb  			<= 4'b0;
				end
			MEM_DONE: begin
				mem_state <= MEM_IDLE;
			end
			default:; 
		endcase

	end

end


endmodule
