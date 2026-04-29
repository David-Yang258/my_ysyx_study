/*
* @param inst 	:from ifu
* @param imm 	:immediate number output
* @param rd 	:dest reg addr
* @param rs1 	:source reg 1 addr
* @param rs2 	:source reg 2 addr
* @csr_raddr 	:csr read reg addr
* @csr_waddr1   :csr write reg 1 addr
* @csr_waddr2   :csr write reg 2 addr
* @alu_op 		:alu operation
* @alu_src2_sel :select the second sourc of alu,0:rs2, 1: imm
* //@mem_we 		:memory write enable
* @mem_re 		:memory read  enable
* @ls_type 		:load store type
* @wb_sel 		:write back dest seleciton 0:reg, 1:mem, 2:pc 3:csr 4:non
* @branch 		:normal branch (B operation)
* @jal 			:jal branch  flag
* @jalr 		:jalr branch flag
* @branch_type  :determine what type of branch it is
* @csr_we 		:csr write enable
* @csr_op 		:csr operation
* @ecall 		:ecall 
* @Ebreak 		:Ebreak intr
* @mret 		:ecall return
*/
`include "bus_define.vh"
module idu (
	input 		[`BUS_DATA_WIDTH-1:0] 	inst,

   	output reg 	[`BUS_DATA_WIDTH-1:0] 	imm,

	output reg 	[`REG_ADDR_WIDTH-1:0] 	rd,
	output reg 	[`REG_ADDR_WIDTH-1:0] 	rs1,
	output reg 	[`REG_ADDR_WIDTH-1:0] 	rs2,	
	output reg 							rs1_en,
	output reg 							rs2_en,

	output reg  [`CSR_ADDR_WIDTH-1:0]   csr_raddr,
	output reg  [`CSR_ADDR_WIDTH-1:0]   csr_waddr1,
	output reg  [`CSR_ADDR_WIDTH-1:0]   csr_waddr2,

	output reg  [5:0] 					alu_op,
	output reg 	[1:0]					alu_src2_sel,

	output reg 							mem_re,
	output reg 							mem_we,
	output reg 							reg_we,
	output reg 							csr_we1,
	output reg 							csr_we2,

	output reg  [2:0] 					ls_type,

	output reg  [2:0] 					wb_sel,

	output reg 							branch,
	output reg 							jal,
	output reg 							jalr,
	output reg 							auipc,

	output reg  [3:0] 					branch_type,

	output reg   						csr_flag,

	output reg 							ecall,
	output reg 							Ebreak,
	output reg 							mret,

	output reg 							predict_taken
);
`include "opcode.vh"
`include "alu.vh"

localparam CSR_MCAUSE = 32'h342;
localparam CSR_MEPC   = 32'h341;
localparam CSR_MTVEC  = 32'h305;

localparam MCAUSE_REG = 5'd15;

localparam EBREAK = 32'b0000_0000_0001_00000_000_00000_1110011;
import "DPI-C" function void ebreak();

wire [31:0] immU;
wire [31:0] immB;
wire [31:0] immI;
wire [31:0] immS;
wire [31:0] immJ;
wire [11:0] Efunct12;

wire [6:0]  funct7;
wire [2:0]  funct3;
wire [6:0]  opcode;

wire [`REG_ADDR_WIDTH-1:0] rd_dec;
wire [`REG_ADDR_WIDTH-1:0] rs1_dec;
wire [`REG_ADDR_WIDTH-1:0] rs2_dec;

assign rd_dec  = inst[11:7 ];
assign rs1_dec = inst[19:15];
assign rs2_dec = inst[24:20];

assign funct7 = inst[31:25];
assign funct3 = inst[14:12];
assign opcode = inst[6:0]  ;

assign immU   = {inst[31:12],{12{1'b0}}};
assign immB   = {{19{inst[31]}},{inst[31]},{inst[7]},{inst[30:25]},{inst[11:8]},1'b0};
assign immI   = {{20{inst[31]}},{inst[31:20]}};
assign immS   = {{20{inst[31]}},{inst[31:25]},{inst[11:7]}};
assign immJ   = {{11{inst[31]}},{inst[31]},{inst[19:12]},{inst[20]},{inst[30:21]},1'b0};
assign Efunct12 = inst[31:20];

always@(*) begin
	wb_sel = `ALU_TO_REG;
	alu_op = 6'b0;
	mem_re = 1'b0;
	mem_we = 1'b0;
	reg_we = 1'b0;
	branch = 1'b0;
	jal    = 1'b0;
	jalr   = 1'b0;
	auipc  = 1'b0;
	csr_flag = 1'b0;
	ecall  = 1'b0;
	Ebreak = 1'b0;
	mret   = 1'b0;
	rs1_en = 1'b0;
	rs2_en = 1'b0;
	
	casez(opcode)
		OPCODE_U_TYPE: begin
			imm = immU; 										rd = rd_dec;
			alu_src2_sel = `ALU_SRC2_IMM; 
			wb_sel = `ALU_TO_REG;
			reg_we = 1'b1;
			if(opcode == 7'b0110111) begin
				alu_op = `ALU_LUI;
			end	
			else begin
				alu_op = `ALU_ADD;
				auipc  = 1'b1;
			end
		end
		OPCODE_JALR  : begin
			imm = immI; rs1 = rs1_dec; 							rd = rd_dec;
			alu_src2_sel = `ALU_SRC2_PC4;
			wb_sel = `ALU_TO_PC_REG;
			reg_we = 1'b1;
			alu_op = `ALU_ADD;
			jalr   = 1'b1;
			rs1_en = 1'b1;
		end
		OPCODE_JAL   : begin 
			imm = immJ; 										rd = rd_dec;
			alu_src2_sel = `ALU_SRC2_PC4;
			wb_sel = `ALU_TO_PC_REG;
			reg_we = 1'b1;
			alu_op = `ALU_ADD;
			jal    = 1'b1;
		end
		OPCODE_B_TYPE:begin 
			imm = immB;	rs1 = rs1_dec; rs2 = rs2_dec;
			rs1_en = 1'b1;
			rs2_en = 1'b1;
			alu_src2_sel = `ALU_SRC2_RS2;
			wb_sel = `ALU_TO_PC;
			case(funct3)
				3'b000: begin 
					branch_type = `BRANCH_EQ ;
					alu_op = `ALU_SUB;
				end
				3'b001: begin 
					branch_type = `BRANCH_NE ;
					alu_op = `ALU_SUB;
				end
				3'b100: begin 
					branch_type = `BRANCH_LT ;
					alu_op = `ALU_SLT;
				end
				3'b101: begin 
					branch_type = `BRANCH_GE ;
					alu_op = `ALU_SLT;
				end
				3'b110: begin 
					branch_type = `BRANCH_LTU;
					alu_op = `ALU_SLTU;
				end
				3'b111: begin 
					branch_type = `BRANCH_GEU;
					alu_op = `ALU_SLTU;
				end
				default:; 
			endcase
			branch = 1'b1;
		end
		OPCODE_L_TYPE:begin
			imm = immI; rs1 = rs1_dec; 							rd = rd_dec;
			rs1_en = 1'b1;
			alu_src2_sel = `ALU_SRC2_IMM;
			wb_sel = `MEM_TO_REG;
			alu_op = `ALU_ADD;
			case(funct3)
				3'b000: ls_type = `LS_TYPE_B;
				3'b001: ls_type = `LS_TYPE_H;
				3'b010: ls_type = `LS_TYPE_W;
				3'b100: ls_type = `LS_TYPE_BU;
				3'b101: ls_type = `LS_TYPE_HU;
				default:; 
			endcase
			mem_re = 1'b1;
			reg_we = 1'b1;
		end
		OPCODE_S_TYPE:begin
			imm = immS; rs1 = rs1_dec; rs2 = rs2_dec;
			rs1_en = 1'b1;
			rs2_en = 1'b1;
			alu_src2_sel = `ALU_SRC2_IMM;
			wb_sel = `ALU_TO_MEM;
			alu_op = `ALU_ADD;
			case(funct3)
				3'b000: ls_type = `LS_TYPE_B;
				3'b001: ls_type = `LS_TYPE_H;
				3'b010: ls_type = `LS_TYPE_W;
				default: ; 
			endcase
			mem_we = 1'b1;
		end
		OPCODE_IR_TYPE:begin
			imm = immI; rs1 = rs1_dec; 							rd = rd_dec;
			rs1_en = 1'b1;
			alu_src2_sel = `ALU_SRC2_IMM;
			wb_sel = `ALU_TO_REG;
			reg_we = 1'b1;
			case(funct3)
				3'b000: alu_op = `ALU_ADD;
				3'b010: alu_op = `ALU_SLT;
				3'b011: alu_op = `ALU_SLTU;
				3'b100: alu_op = `ALU_XOR;
				3'b110: alu_op = `ALU_OR;
				3'b111: alu_op = `ALU_AND;
				3'b001: alu_op = `ALU_SLL;
				3'b101: begin
					if(funct7 == 7'b0) alu_op = `ALU_SRL;
					else alu_op = `ALU_SRA;
				end
				default:; 
			endcase
		end
		OPCODE_R_TYPE: begin
						rs1 = rs1_dec; rs2 = rs2_dec; 			rd = rd_dec;
			rs1_en = 1'b1;
			rs2_en = 1'b1;
			alu_src2_sel = `ALU_SRC2_RS2;
			wb_sel = `ALU_TO_REG;
			reg_we = 1'b1;
			case(funct3)
				3'b000: begin 
					if(funct7 == 7'b0) alu_op = `ALU_ADD;
					else alu_op = `ALU_SUB;
				end
				3'b001: alu_op = `ALU_SLL;
				3'b010: alu_op = `ALU_SLT;
				3'b011: alu_op = `ALU_SLTU;
				3'b100: alu_op = `ALU_XOR;
				3'b101: begin 
					if(funct7 == 7'b0) alu_op = `ALU_SRL;
					else alu_op = `ALU_SRA;
				end
				3'b110:alu_op = `ALU_OR;
				3'b111:alu_op = `ALU_AND;
				default:; 
			endcase
		end
		OPCODE_C_TYPE:begin
			imm = immI;	rs1 = rs1_dec; 							rd = rd_dec;
			alu_src2_sel = `ALU_SRC2_CSR;
			csr_flag = 1'b1;
			case(funct3)
				3'b000: begin
					if(Efunct12 == 12'h000) begin
						rs1        = MCAUSE_REG;
						csr_raddr  = CSR_MTVEC[11:0];
						csr_waddr1 = CSR_MEPC[11:0];
						csr_waddr2 = CSR_MCAUSE[11:0];
						wb_sel     = `ALU_TO_CSR_PC;
						csr_we1    = 1'b1;
						csr_we2    = 1'b1;
						ecall 	   = 1'b1;
					end
					else if(Efunct12 == 12'h001) begin 
						Ebreak = 1'b1;//UNDER CONSTRUCTION
						ebreak();
					end
					else begin
						wb_sel   = `ALU_TO_PC;
						csr_raddr= CSR_MEPC[11:0];
						mret     = 1'b1;
					end	
				end
				3'b001: begin
						csr_raddr  = imm[11:0];
						csr_waddr1 = imm[11:0];
						alu_op 	   = `ALU_OP_NON;
						wb_sel 	   = `ALU_TO_CSR_REG;
						csr_we1    = 1'b1;
						reg_we     = 1'b1;
				end
				3'b010:begin
						csr_raddr  = imm[11:0];
						csr_waddr1 = imm[11:0];
						alu_op 	   = `ALU_OR;
						wb_sel     = `ALU_TO_CSR_REG;
						csr_we1    = 1'b1;
						reg_we     = 1'b1;
				end
				3'b011:begin
						csr_raddr  = imm[11:0];
						csr_waddr1 = imm[11:0];
						alu_op 	   = `ALU_ANDN;
						wb_sel 	   = `ALU_TO_CSR_REG;
						csr_we1    = 1'b1;
						reg_we     = 1'b1;
				end
				default:; 
			endcase
		end
		default:; 
	endcase
	case(inst)
		EBREAK: ;//ebreak();
		default:;
	endcase
end

always @(*) begin
	predict_taken = 1'b0;
	//whenever there is a possible jmp, predict it as happening
	if(branch || jal || jalr) predict_taken = 1'b1;
end

endmodule
