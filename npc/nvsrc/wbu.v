module wbu(
	`include "bus_define.vh"
	input 						 clk,
	input 						 reset,
	input  [2:0] 				 wb_sel,
	input 						 branch_taken,

	input  [`REG_ADDR_WIDTH-1:0] rd_waddr,
	input  [`CSR_ADDR_WIDTH-1:0] csr_waddr1,
	input  [`CSR_ADDR_WIDTH-1:0] csr_waddr2,

	input  [`BUS_DATA_WIDTH-1:0] rd_wdata,
	input  [`BUS_DATA_WIDTH-1:0] csr_wdata1,
	input  [`BUS_DATA_WIDTH-1:0] csr_wdata2,

	input  [`BUS_DATA_WIDTH-1:0] branch_addr,
	input  [`BUS_DATA_WIDTH-1:0] mem_rdata,
	input  [`BUS_DATA_WIDTH-1:0] mem_wdata,
	//input  [`BUS_DATA_WIDTH-1:0] mem_raddr,
	input  [`BUS_DATA_WIDTH-1:0] mem_waddr,

	input 						 i_valid,
	input 						 lsu_wcpl,
	input 						 lsu_rcpl,
	/*verilator lint_off UNUSEDSIGNAL*/
	input 						 stall,

	
	output reg 						  bus_error,
	output reg  [`REG_ADDR_WIDTH-1:0] final_rd_waddr,
	output reg  [`CSR_ADDR_WIDTH-1:0] final_csr_waddr1,
	output reg  [`CSR_ADDR_WIDTH-1:0] final_csr_waddr2,
	output reg  [`BUS_DATA_WIDTH-1:0] final_mem_waddr,

	output reg  [`BUS_DATA_WIDTH-1:0] final_rd_wdata,
	output reg  [`BUS_DATA_WIDTH-1:0] final_csr_wdata1,
	output reg  [`BUS_DATA_WIDTH-1:0] final_csr_wdata2,
	output reg  [`BUS_DATA_WIDTH-1:0] final_mem_wdata,

	output reg 						 wbu_ready,
	output reg [`BUS_DATA_WIDTH-1:0] jmp_addr,
	output reg 						 jmp_set,
	output reg 						 final_mem_we,
	output reg 						 final_csr_we1,
	output reg 						 final_csr_we2,
	output reg 						 final_reg_we
);
`include "alu.vh"

localparam WBU_IDLE     = 2'b00;
localparam WBU_WAIT4MEM = 2'b01;

reg [1:0] wbu_state;
reg [2:0] wb_sel_lock;


always@(posedge clk)begin
	if(reset) begin
		wbu_ready <= 1'b1;
		wbu_state <= WBU_IDLE;
		jmp_set   <= 1'b0;
		jmp_addr  <= 32'b0;
		final_csr_we1<=1'b0;
		final_csr_we2<=1'b0;
		final_reg_we <=1'b0;
		final_mem_we <=1'b0;
	end
	else begin
		wb_sel_lock   <= wb_sel;
		jmp_set  	  <= 1'b0;
		final_csr_we1 <= 1'b0;
		final_csr_we2 <= 1'b0;
		final_reg_we  <= 1'b0;
		final_mem_we  <= 1'b0;
		case(wbu_state)
			WBU_IDLE:begin
				case(wb_sel)
					`ALU_TO_REG: begin
						final_rd_waddr <= rd_waddr;
						final_rd_wdata <= rd_wdata;
						if(i_valid)final_reg_we   <= 1'b1;
						wbu_ready      <= 1'b1;
					end
					`ALU_TO_MEM: begin
						final_mem_waddr<= mem_waddr;
						final_mem_wdata<= mem_wdata;
						if(i_valid) begin 
							final_mem_we   <= 1'b1;
							wbu_ready 	   <= 1'b0;
							wbu_state      <= WBU_WAIT4MEM;
						end
					end
					`ALU_TO_PC:begin
						jmp_set <= branch_taken;
						jmp_addr<= branch_addr;
						wbu_ready<=1'b1;
					end
					`ALU_TO_CSR:begin
						final_csr_waddr1 <= csr_waddr1;
						final_csr_wdata1 <= csr_wdata1;
						if(i_valid)final_csr_we1    <= 1'b1;
						wbu_ready 		 <= 1'b1;
					end
					`ALU_TO_CSR_PC:begin
						final_csr_waddr1 <= csr_waddr1;
						final_csr_waddr2 <= csr_waddr2;
						final_csr_wdata1 <= csr_wdata1;
						final_csr_wdata2 <= csr_wdata2;
						if(i_valid)final_csr_we1    <= 1'b1;
						if(i_valid)final_csr_we2    <= 1'b1;
						jmp_set 		 <= branch_taken;
						jmp_addr   		 <= branch_addr;
						wbu_ready 		 <= 1'b1;
					end
					`ALU_TO_CSR_REG:begin
						final_csr_waddr1 <= csr_waddr1;
						final_csr_wdata1 <= csr_wdata1;
						final_rd_waddr   <= rd_waddr;
						final_rd_wdata   <= rd_wdata;
						if(i_valid)final_csr_we1    <= 1'b1;
						if(i_valid)final_reg_we     <= 1'b1;
						wbu_ready    	 <= 1'b1;
					end
					`ALU_TO_PC_REG:begin
						final_rd_waddr  <= rd_waddr;
						final_rd_wdata  <= rd_wdata;
						if(i_valid)final_reg_we    <= 1'b1;
						jmp_set 		<= branch_taken;
						jmp_addr 		<= branch_addr;
						wbu_ready 		<= 1'b1;
					end
					`MEM_TO_REG:begin
						if(i_valid) begin
							wbu_state <= WBU_WAIT4MEM;
							wbu_ready <= 1'b0;
						end
					end
					default: bus_error <= 1'b1;
				endcase
			end
			WBU_WAIT4MEM: begin
				case(wb_sel_lock)
					`ALU_TO_MEM: begin
						if(lsu_wcpl) begin
							final_mem_we <= 1'b0;
							wbu_state <= WBU_IDLE;
							wbu_ready <= 1'b1;
						end
					end
					`MEM_TO_REG:begin
						if(lsu_rcpl)begin
							final_rd_waddr <= rd_waddr;
							final_rd_wdata <= mem_rdata;
							final_reg_we   <= 1'b1;
							wbu_state      <= WBU_IDLE;
							wbu_ready 	   <= 1'b1;
						end
					end
					default: bus_error <= 1'b1;
				endcase
			end
			default: bus_error <= 1'b1;
		endcase
	end

end



endmodule
