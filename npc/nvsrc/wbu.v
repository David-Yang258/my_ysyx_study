module wbu(
	`include "bus_define.vh"
	input 						 	  clk,
	input 						 	  rst_n,
	input  [2:0] 				 	  wb_sel,

	input  [`REG_ADDR_WIDTH-1:0] 	  rd_waddr,
	input  [`CSR_ADDR_WIDTH-1:0] 	  csr_waddr1,
	input  [`CSR_ADDR_WIDTH-1:0] 	  csr_waddr2,

	input  [`BUS_DATA_WIDTH-1:0] 	  rd_wdata,
	input  [`BUS_DATA_WIDTH-1:0] 	  csr_wdata1,
	input  [`BUS_DATA_WIDTH-1:0] 	  csr_wdata2,

	input  [`BUS_DATA_WIDTH-1:0] 	  mem_rdata,

	/*verilator lint_off UNUSEDSIGNAL*/
	input 						 	  stall,

	
	output reg  [`REG_ADDR_WIDTH-1:0] final_rd_waddr,
	output reg  [`CSR_ADDR_WIDTH-1:0] final_csr_waddr1,
	output reg  [`CSR_ADDR_WIDTH-1:0] final_csr_waddr2,

	output reg  [`BUS_DATA_WIDTH-1:0] final_rd_wdata,
	output reg  [`BUS_DATA_WIDTH-1:0] final_csr_wdata1,
	output reg  [`BUS_DATA_WIDTH-1:0] final_csr_wdata2,

	output reg 						  final_csr_we1,
	output reg 						  final_csr_we2,
	output reg 						  final_reg_we

	//output reg 						csr_jmp_set,
	//output reg [`BUS_DATA_WIDTH-1:0]  csr_jmp_addr
);
`include "alu.vh"

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		final_csr_we1<=1'b0;
		final_csr_we2<=1'b0;
		final_reg_we <=1'b0;
	end
	else if(!stall) begin
		final_csr_we1 <= 1'b0;
		final_csr_we2 <= 1'b0;
		final_reg_we  <= 1'b0;
		case(wb_sel)
			`ALU_TO_REG: begin
				final_rd_waddr <= rd_waddr;
				final_rd_wdata <= rd_wdata;
				final_reg_we   <= 1'b1;
			end
			`ALU_TO_MEM: begin
			end
			`ALU_TO_PC:begin
			end
			`ALU_TO_CSR:begin
				final_csr_waddr1 <= csr_waddr1;
				final_csr_wdata1 <= csr_wdata1;
				final_csr_we1    <= 1'b1;
			end
			`ALU_TO_CSR_PC:begin
				final_csr_waddr1 <= csr_waddr1;
				final_csr_waddr2 <= csr_waddr2;
				final_csr_wdata1 <= csr_wdata1;
				final_csr_wdata2 <= csr_wdata2;
				final_csr_we1    <= 1'b1;
				final_csr_we2    <= 1'b1;
				//csr_jmp_set 	 <= branch_taken;
				//csr_jmp_addr   <= branch_addr;
			end
			`ALU_TO_CSR_REG:begin
				final_csr_waddr1 <= csr_waddr1;
				final_csr_wdata1 <= csr_wdata1;
				final_rd_waddr   <= rd_waddr;
				final_rd_wdata   <= rd_wdata;
				final_csr_we1    <= 1'b1;
				final_reg_we     <= 1'b1;
			end
			`ALU_TO_PC_REG:begin
				final_rd_waddr  <= rd_waddr;
				final_rd_wdata  <= rd_wdata;
				final_reg_we    <= 1'b1;
			end
			`MEM_TO_REG:begin
				final_rd_waddr <= rd_waddr;
				final_rd_wdata <= mem_rdata;
				final_reg_we   <= 1'b1;
			end
			default:; 
		endcase
	end

end



endmodule
