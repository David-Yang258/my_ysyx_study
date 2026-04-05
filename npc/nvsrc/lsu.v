`include "bus_define.vh"
module lsu(
	input 								clk,
	input 								rst_n,
	input 								mem_re,
	input 								mem_we,
	input 	[2:0] 						ls_type,
	input 	[`BUS_DATA_WIDTH-1:0] 		alu2lsu_raddr,
	input 	[`BUS_DATA_WIDTH-1:0] 		wbu2lsu_waddr,
	input 	[`BUS_DATA_WIDTH-1:0]   	wbu2lsu_wdata,

	input 	[`BUS_DATA_WIDTH-1:0] 		mem2lsu_rdata, 

	input 								stall,
	input  								exu_valid,
	input 								mem_ready,
	input 								i_ready,
	output reg 							bus_error,
	output reg							mem_re_qst,
	output reg							mem_we_qst,
	output reg	[3:0]					mem_be,
	
	//output reg							lsu_ready,
	output reg 							lsu_wcpl,
	output reg 							lsu_rcpl,
	output reg	[`BUS_DATA_WIDTH-1:0]   mem_raddr,
	output reg  [`BUS_DATA_WIDTH-1:0]   mem_waddr,
	output reg	[`BUS_DATA_WIDTH-1:0] 	mem_rdata,
	output reg	[`BUS_DATA_WIDTH-1:0] 	mem_wdata
);

localparam MEM_IDLE = 2'b00;
localparam MEM_REQ  = 2'b01;
localparam MEM_WAIT = 2'b10;

localparam MEM_RE   = 1'b0;
localparam MEM_WE   = 1'b1;
`include "alu.vh"

reg [1:0] mem_state;
reg mem_rd_state;
//reg wait4mem;
wire [1:0] wbyte_sel;
wire [1:0] rbyte_sel;

assign wbyte_sel = wbu2lsu_waddr[1:0];
assign rbyte_sel = alu2lsu_raddr[1:0];

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		mem_state   <= MEM_IDLE;
		//lsu_ready   <= 1'b1;
		mem_re_qst  <= 1'b0;
		mem_be  <= 4'b0;
		mem_rd_state<= 1'b0;
		lsu_wcpl 	<= 1'b0;
		lsu_rcpl    <= 1'b0;
		bus_error   <= 1'b0;
		//wait4mem    <= 1'b0;
		mem_we_qst  <= 1'b0;
	end
	else begin
		case(mem_state)
			MEM_IDLE:begin
				if(mem_re && exu_valid && !stall) begin
					mem_rd_state<= MEM_RE;
					mem_raddr   <= alu2lsu_raddr;
					mem_re_qst  <= 1'b1;	
					mem_state   <= MEM_REQ;
					//lsu_ready   <= 1'b0;
					//wait4mem 	<= 1'b1;
					lsu_rcpl    <= 1'b0;
				end
				else if(mem_we && !stall) begin
					mem_rd_state<= MEM_WE;
					lsu_wcpl    <= 1'b0;
					mem_waddr   <= wbu2lsu_waddr;
					mem_wdata   <= wbu2lsu_wdata;
					case(ls_type)
						`LS_TYPE_B: begin
							case(wbyte_sel)
								2'b00: mem_be <= 4'b0001;
								2'b01: mem_be <= 4'b0010;
								2'b10: mem_be <= 4'b0100;
								2'b11: mem_be <= 4'b1000;
							endcase
						end	
						`LS_TYPE_H:begin
							case(wbyte_sel)
								2'b00: mem_be <= 4'b0011;
								2'b10: mem_be <= 4'b1100;
								default: bus_error <= 1'b1;
							endcase
						end	
						`LS_TYPE_W: mem_be <= 4'b1111; 
						default:  mem_be <= 4'b0; 
					endcase
					mem_state  <= MEM_REQ;
					mem_we_qst <= 1'b1;
					//lsu_ready  <= 1'b0;
					//wait4mem   <= 1'b0;
				end
				else begin
				   	mem_state  <= MEM_IDLE;
					lsu_wcpl   <= 1'b0;
					lsu_rcpl   <= 1'b0;
					//lsu_ready  <= i_ready;
					//wait4mem   <= 1'b0;
				end
			end
			MEM_REQ: begin
				if(mem_ready && !stall) mem_state <= MEM_WAIT;
			end
			MEM_WAIT:begin
				case(mem_rd_state)
					MEM_RE:begin
						case(ls_type)
							`LS_TYPE_B :  begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{24{mem2lsu_rdata[7]}},{mem2lsu_rdata[7:0]}};
									2'b01: mem_rdata <= {{24{mem2lsu_rdata[15]}},{mem2lsu_rdata[15:8]}};
									2'b10: mem_rdata <= {{24{mem2lsu_rdata[23]}},{mem2lsu_rdata[23:16]}};
									2'b11: mem_rdata <= {{24{mem2lsu_rdata[31]}},{mem2lsu_rdata[31:24]}};
								endcase
							end
							`LS_TYPE_BU:  begin
								case(rbyte_sel)
									2'b00: mem_rdata <= {{24{1'b0}},{mem2lsu_rdata[7:0]}};
									2'b01: mem_rdata <= {{24{1'b0}},{mem2lsu_rdata[15:8]}};
									2'b10: mem_rdata <= {{24{1'b0}},{mem2lsu_rdata[23:16]}};
									2'b11: mem_rdata <= {{24{1'b0}},{mem2lsu_rdata[31:24]}};
								endcase
							end	
							`LS_TYPE_H : begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{16{mem2lsu_rdata[15]}},{mem2lsu_rdata[15:0]}};
									2'b10: mem_rdata <= {{16{mem2lsu_rdata[31]}},{mem2lsu_rdata[31:16]}};
									default:bus_error<= 1'b1;
								endcase
							end	
							`LS_TYPE_HU: begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{16{1'b0}},{mem2lsu_rdata[15:0]}};
									2'b10: mem_rdata <= {{16{1'b0}},{mem2lsu_rdata[31:16]}};
									default:bus_error<= 1'b1;
								endcase
							end
							`LS_TYPE_W : mem_rdata <= mem2lsu_rdata; 
							default   :  mem_rdata <= 32'h7FDFDFDF;
						endcase
						lsu_rcpl <= 1'b1;
						if(!stall && i_ready) begin
							mem_state <= MEM_IDLE;
							//lsu_ready <= 1'b1;
						end
					end	
					MEM_WE:begin
						lsu_wcpl  <= 1'b1;
						//lsu_ready <= 1'b1;
						mem_state <= MEM_IDLE;
					end
					default: ;
					endcase
					//wait4mem  <= 1'b0;
					mem_re_qst<= 1'b0;
					mem_we_qst<= 1'b0;
					mem_be<= 4'b0;
				end
			default: bus_error <= 1'b1;
		endcase

	end

end


endmodule
