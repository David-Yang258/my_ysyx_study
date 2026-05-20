`include "bus_define.vh"
module lsu(
	input 								clk,
	input 								reset,
	input 								mem_re,
	input 								mem_we,
	input 	[2:0] 						ls_type,
	input 	[`BUS_DATA_WIDTH-1:0] 		alu2lsu_raddr,
	input 	[`BUS_DATA_WIDTH-1:0] 		wbu2lsu_waddr,
	input 	[`BUS_DATA_WIDTH-1:0]   	wbu2lsu_wdata,

	/*verilator lint_off UNUSEDSIGNAL*/
	input 								stall,
	input  								exu_valid,

	output reg							arvalid,
	output reg	[`BUS_DATA_WIDTH-1:0]   araddr,
	input 								arready,

	input 		[`BUS_DATA_WIDTH-1:0] 	rdata, 
	input 		[1:0] 					rresp,
	input 								rvalid,
	output reg 							rready,

	output reg  [`BUS_DATA_WIDTH-1:0]   awaddr,
	output reg 							awvalid,
	input 								awready,

	output reg	[`BUS_DATA_WIDTH-1:0] 	wdata,
	output reg	[3:0]					wstrb,
	output reg 							wvalid,
	input 								wready,

	input 		[1:0] 					bresp,
	input 								bvalid,
	output reg  						bready,

	input 								i_ready,
	output reg 							bus_error,
	
	output reg 							lsu_wcpl,
	output reg 							lsu_rcpl,
	output reg	[`BUS_DATA_WIDTH-1:0] 	mem_rdata
	/*verilator lint_on UNUSEDSIGNAL*/
);

localparam MEM_IDLE  	= 3'b000;
localparam MEM_WAIT_AR  = 3'b001;
localparam MEM_WAIT_DR  = 3'b010;
localparam MEM_HANDLE  	= 3'b011;
localparam MEM_WAIT 	= 3'b100;

localparam MEM_RE   = 1'b0;
localparam MEM_WE   = 1'b1;
`include "alu.vh"

reg mem_rd_state;
reg  [2:0] mem_state;
wire [1:0] wbyte_sel;
wire [1:0] rbyte_sel;

// 【修复核心】：引入暂存器，在握手完成的瞬间精准捕获数据！
reg [`BUS_DATA_WIDTH-1:0] raw_rdata;

assign wbyte_sel = wbu2lsu_waddr[1:0];
assign rbyte_sel = alu2lsu_raddr[1:0];

always@(posedge clk) begin
	if(reset) begin
		mem_state   <= MEM_IDLE;
		arvalid  	<= 1'b0;
		rready 		<= 1'b0;
		awvalid  	<= 1'b0;
		wvalid 		<= 1'b0;
		bready 		<= 1'b0;
		wstrb  		<= 4'b0;
		mem_rd_state<= 1'b0;
		lsu_wcpl 	<= 1'b0;
		lsu_rcpl    <= 1'b0;
		bus_error   <= 1'b0;
        raw_rdata   <= 32'b0;
	end
	else begin
		case(mem_state)
			MEM_IDLE:begin
				if(mem_re && exu_valid && !stall) begin
					mem_rd_state<= MEM_RE;
					araddr   	<= alu2lsu_raddr;
					arvalid  	<= 1'b1;	
					rready    	<= 1'b1;
					mem_state   <= MEM_WAIT_AR;
					lsu_rcpl    <= 1'b0;
				end
				else if(mem_we && !stall) begin
					mem_rd_state<= MEM_WE;
					bready      <= 1'b0;
					lsu_wcpl    <= 1'b0;
					awaddr   	<= wbu2lsu_waddr;
					awvalid 	<= 1'b1;
					case(ls_type)
						`LS_TYPE_B: begin
							case(wbyte_sel)
								2'b00: begin wstrb <= 4'b0001; wdata <= wbu2lsu_wdata; end
								2'b01: begin wstrb <= 4'b0010; wdata <= wbu2lsu_wdata << 8; end
								2'b10: begin wstrb <= 4'b0100; wdata <= wbu2lsu_wdata << 16; end
								2'b11: begin wstrb <= 4'b1000; wdata <= wbu2lsu_wdata << 24; end
							endcase
						end	
						`LS_TYPE_H:begin
							case(wbyte_sel)
								2'b00: begin wstrb <= 4'b0011; wdata <= wbu2lsu_wdata; end
								2'b10: begin wstrb <= 4'b1100; wdata <= wbu2lsu_wdata << 16; end
								default: bus_error <= 1'b1;
							endcase
						end	
						`LS_TYPE_W: begin wstrb <= 4'b1111; wdata <= wbu2lsu_wdata; end
						default:  wstrb <= 4'b0; 
					endcase
					mem_state  <= MEM_WAIT_AR;
				end
				else begin
				   	mem_state  <= MEM_IDLE;
					lsu_wcpl   <= 1'b0;
					lsu_rcpl   <= 1'b0;
				end
			end
			MEM_WAIT_AR: begin
                // 【修复核心】：坚决去除 && !stall，总线握手不得被流水线停顿阻扰。
                // 且不能在此处将 rready 拉低，必须等数据到来！
				if(arready) begin 
					arvalid   <= 1'b0;
					mem_state <= MEM_WAIT_DR;
				end
				if(awready) begin
					awvalid    <= 1'b0;
					wvalid     <= 1'b1;
					mem_state  <= MEM_WAIT_DR;
				end
			end
			MEM_WAIT_DR: begin
                // 【修复核心】：拆分读写判断，在握手完成的第一拍立刻将 rdata 暂存在 raw_rdata 里面！
                if(mem_rd_state == MEM_RE) begin
                    if(rvalid) begin 
                        rready    <= 1'b0;
                        raw_rdata <= rdata; 
                        mem_state <= MEM_HANDLE;
                    end
                end else begin
                    if(wready) begin 
                        wvalid    <= 1'b0;
                        mem_state <= MEM_HANDLE;
                    end
                end
			end
			MEM_HANDLE:begin
				case(mem_rd_state)
					MEM_RE:begin
						case(ls_type)
                            // 【修复核心】：全部改用暂存的、绝对安全的 raw_rdata 进行解析！
							`LS_TYPE_B :  begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{24{raw_rdata[7]}} ,{raw_rdata[7:0]}};
									2'b01: mem_rdata <= {{24{raw_rdata[15]}},{raw_rdata[15:8]}};
									2'b10: mem_rdata <= {{24{raw_rdata[23]}},{raw_rdata[23:16]}};
									2'b11: mem_rdata <= {{24{raw_rdata[31]}},{raw_rdata[31:24]}};
								endcase
							end
							`LS_TYPE_BU:  begin
								case(rbyte_sel)
									2'b00: mem_rdata <= {{24{1'b0}},{raw_rdata[7:0]}};
									2'b01: mem_rdata <= {{24{1'b0}},{raw_rdata[15:8]}};
									2'b10: mem_rdata <= {{24{1'b0}},{raw_rdata[23:16]}};
									2'b11: mem_rdata <= {{24{1'b0}},{raw_rdata[31:24]}};
								endcase
							end	
							`LS_TYPE_H : begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{16{raw_rdata[15]}},{raw_rdata[15:0]}};
									2'b10: mem_rdata <= {{16{raw_rdata[31]}},{raw_rdata[31:16]}};
									default:bus_error<= 1'b1;
								endcase
							end	
							`LS_TYPE_HU: begin 
								case(rbyte_sel)
									2'b00: mem_rdata <= {{16{1'b0}},{raw_rdata[15:0]}};
									2'b10: mem_rdata <= {{16{1'b0}},{raw_rdata[31:16]}};
									default:bus_error<= 1'b1;
								endcase
							end
							`LS_TYPE_W : mem_rdata <= raw_rdata; 
							default    : mem_rdata <= 32'h7FDFDFDF;
						endcase
						lsu_rcpl <= 1'b1;
						mem_state<= MEM_WAIT;
					end	
					MEM_WE:begin
						bready    <= 1'b1;
						lsu_wcpl  <= 1'b1;
						mem_state <= MEM_WAIT;
					end
					default: ;
				endcase
				arvalid<= 1'b0;
				awvalid<= 1'b0;
				wstrb<= 4'b0;
			end
			MEM_WAIT: begin
				case(mem_rd_state)
					MEM_RE: begin	
                        // 等待流水线 Ready 时，数据安全的在 mem_rdata 里
						if(!stall && i_ready) begin
							mem_state <= MEM_IDLE;
						end
					end
					MEM_WE: begin
						if(bvalid) begin
							mem_state <= MEM_IDLE;
                            bready    <= 1'b0; // 【修复核心】：收到写响应后，关闭 bready
						end
					end
				endcase
			end
			default: bus_error <= 1'b1;
		endcase
	end
end
endmodule
