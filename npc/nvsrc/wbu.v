module wbu(
	`include "bus_define.vh"
	input 						 	  clk,
	input 						 	  rst_n,
	input  [2:0] 				 	  wb_sel,

	input  [`BUS_DATA_WIDTH-1:0] 	  wbu_pc,
	/*verilator lint_off UNUSEDSIGNAL*/
	input  [`BUS_DATA_WIDTH-1:0] 	  wbu_inst,
	/*verilator lint_on  UNUSEDSIGNAL*/
	input 							  wbu_inst_valid,

	input  [`REG_ADDR_WIDTH-1:0] 	  rd_waddr,
	input  [`CSR_ADDR_WIDTH-1:0] 	  csr_waddr1,
	input  [`CSR_ADDR_WIDTH-1:0] 	  csr_waddr2,

	input  [`BUS_DATA_WIDTH-1:0] 	  rd_wdata,
	input  [`BUS_DATA_WIDTH-1:0] 	  csr_wdata1,
	input  [`BUS_DATA_WIDTH-1:0] 	  csr_wdata2,

	input  [`BUS_DATA_WIDTH-1:0] 	  mem_rdata,

	input 							  lsu_reg_we,
	input 							  lsu_csr_we1,
	input 							  lsu_csr_we2,

	/*verilator lint_off UNUSEDSIGNAL*/
	
	output reg  [`REG_ADDR_WIDTH-1:0] final_rd_waddr,
	output reg  [`CSR_ADDR_WIDTH-1:0] final_csr_waddr1,
	output reg  [`CSR_ADDR_WIDTH-1:0] final_csr_waddr2,

	output reg  [`BUS_DATA_WIDTH-1:0] final_rd_wdata,
	output reg  [`BUS_DATA_WIDTH-1:0] final_csr_wdata1,
	output reg  [`BUS_DATA_WIDTH-1:0] final_csr_wdata2,

	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_diff_pc,
	output reg 	[`BUS_DATA_WIDTH-1:0] wbu_diff_inst,

	output reg 						  final_csr_we1,
	output reg 						  final_csr_we2,
	output reg 						  final_reg_we

	//output reg 						csr_jmp_set,
	//output reg [`BUS_DATA_WIDTH-1:0]  csr_jmp_addr
);
`include "alu.vh"
import "DPI-C" function void difftest_wbu_step(input int this_pc);  

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		final_csr_we1<=1'b0;
		final_csr_we2<=1'b0;
		final_reg_we <=1'b0;
	end
	else begin
		final_csr_we1 <= 1'b0;
		final_csr_we2 <= 1'b0;
		final_reg_we  <= 1'b0;
		if(wbu_inst_valid) begin
			case(wb_sel)
				`ALU_TO_REG: begin
					final_rd_waddr   <= rd_waddr;
					final_rd_wdata   <= rd_wdata;
					final_reg_we     <= lsu_reg_we;
				end
				`ALU_TO_MEM: begin
				end
				`ALU_TO_PC:begin
				end
				`ALU_TO_CSR:begin
					final_csr_waddr1 <= csr_waddr1;
					final_csr_wdata1 <= csr_wdata1;
					final_csr_we1    <= lsu_csr_we1;
				end
				`ALU_TO_CSR_PC:begin
					final_csr_waddr1 <= csr_waddr1;
					final_csr_waddr2 <= csr_waddr2;
					final_csr_wdata1 <= csr_wdata1;
					final_csr_wdata2 <= csr_wdata2;
					final_csr_we1    <= lsu_csr_we1;
					final_csr_we2    <= lsu_csr_we2;
					//csr_jmp_set 	 <= branch_taken;
					//csr_jmp_addr   <= branch_addr;
				end
				`ALU_TO_CSR_REG:begin
					final_csr_waddr1 <= csr_waddr1;
					final_csr_wdata1 <= csr_wdata1;
					final_rd_waddr   <= rd_waddr;
					final_rd_wdata   <= rd_wdata;
					final_csr_we1    <= lsu_csr_we1;
					final_reg_we     <= lsu_reg_we;
				end
				`ALU_TO_PC_REG:begin
					final_rd_waddr   <= rd_waddr;
					final_rd_wdata   <= rd_wdata;
					final_reg_we     <= lsu_reg_we;
				end
				`MEM_TO_REG:begin
					final_rd_waddr   <= rd_waddr;
					final_rd_wdata   <= mem_rdata;
					final_reg_we     <= lsu_reg_we;
				end
				default:; 
			endcase
		end
	end
end

localparam wbu_diff_idle  = 2'b00;
localparam wbu_ready4diff = 2'b01;
localparam wbu_indiff     = 2'b10;
reg [1:0] diff_state;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		diff_state <= wbu_diff_idle;
		wbu_diff_pc<= 32'b0;
	end
	else begin
		case(diff_state)
			wbu_diff_idle: begin
				if(wbu_inst_valid) begin 
					diff_state   <= wbu_ready4diff;
					wbu_diff_pc  <= wbu_pc;
					wbu_diff_inst<=wbu_inst;
				end
			end
			wbu_ready4diff: diff_state <= wbu_indiff;
			wbu_indiff: begin
				difftest_wbu_step(wbu_diff_pc);
				diff_state <= wbu_diff_idle;
			end
			default: diff_state <= wbu_diff_idle;
		endcase
	end
end


endmodule
