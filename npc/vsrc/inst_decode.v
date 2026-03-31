module inst_decode (
	input 		[31:0] 	inst,
   	output reg 	[31:0] 	imm,
	output reg 	[4:0] 	rd,
	output reg 	[4:0] 	rs1,
	output reg 	[4:0] 	rs2,	
	output reg  [11:0]  csr_waddr1,
	output reg  [11:0]  csr_waddr2,
	output reg 	[4:0] 	shamt,
	output 		[6:0] 	funct7,
	output 		[2:0] 	funct3,
	output 		[6:0] 	opcode
);

localparam OPCODE_R_TYPE1= 7'b0010011;
localparam OPCODE_R_TYPE2= 7'b0110011;

localparam OPCODE_I_TYPE1= 7'b0000011;
localparam OPCODE_I_TYPE2= 7'b0010011;
localparam OPCODE_I_TYPE3= 7'b1100111;
localparam OPCODE_IC_TYPE= 7'b1110011;

localparam OPCODE_S_TYPE = 7'b0100011;
localparam OPCODE_B_TYPE = 7'b1100011;
localparam OPCODE_U_TYPE = 7'b0?10111;
localparam OPCODE_J_TYPE = 7'b1101111;

localparam FUNCT3_IGN = 3'b???;

localparam CSR_MCAUSE = 32'h342;
localparam CSR_MEPC   = 32'h341;
localparam CSR_MTVEC  = 32'h305;

localparam MCAUSE_REG = 5'd15;

localparam ECALL  = 32'b0000_0000_0000_00000_000_00000_1110011;
localparam MRET   = 32'b0011_0000_0010_00000_000_00000_1110011;
localparam EBREAK = 32'b0000_0000_0001_00000_000_00000_1110011;
import "DPI-C" function void ebreak();

wire [31:0] immU;
wire [31:0] immB;
wire [31:0] immI;
wire [31:0] immS;
wire [31:0] immJ;

assign funct7 = inst[31:25];
assign funct3 = inst[14:12];
assign opcode = inst[6:0]  ;

assign immU   = {inst[31:12],{12{1'b0}}};
assign immB   = {{19{inst[31]}},{inst[31]},{inst[7]},{inst[30:25]},{inst[11:8]},1'b0};
assign immI   = {{20{inst[31]}},{inst[31:20]}};
assign immS   = {{20{inst[31]}},{inst[31:25]},{inst[11:7]}};
assign immJ   = {{11{inst[31]}},{inst[31]},{inst[19:12]},{inst[20]},{inst[30:21]},1'b0};


always@(*) begin
	casez({opcode,funct3})
		{OPCODE_I_TYPE1,FUNCT3_IGN}: begin
		   	imm = immI; rs1 = inst[19:15];                      rd = inst[11:7];
		end
		{OPCODE_I_TYPE2,3'b??0}    : begin
		   	imm = immI; rs1 = inst[19:15];                      rd = inst[11:7];
		end
		{OPCODE_I_TYPE2,3'b?11}    : begin
		   	imm = immI; rs1 = inst[19:15];                      rd = inst[11:7];
		end
		{OPCODE_I_TYPE3,3'b000}    : begin
		   	imm = immI; rs1 = inst[19:15];                      rd = inst[11:7];
		end
		{OPCODE_IC_TYPE,3'b???}    : begin
		   	imm = immI; rs1 = inst[19:15]; rs2   = inst[24:20]; rd = inst[11:7];
			csr_waddr1 = imm[11:0];
		end
		{OPCODE_B_TYPE ,FUNCT3_IGN}: begin
		   	imm = immB; rs1 = inst[19:15]; rs2   = inst[24:20];
		end
		{OPCODE_U_TYPE ,FUNCT3_IGN}: begin
		   	imm = immU;                                         rd = inst[11:7];
		end
		{OPCODE_S_TYPE ,FUNCT3_IGN}: begin
		   	imm = immS; rs1 = inst[19:15]; rs2   = inst[24:20]; 
		end
		{OPCODE_R_TYPE1,3'b?01}    : begin
		   	            rs1 = inst[19:15]; shamt = inst[24:20]; rd = inst[11:7];
		end
		{OPCODE_R_TYPE2,FUNCT3_IGN}: begin
		   	            rs1 = inst[19:15]; rs2   = inst[24:20]; rd = inst[11:7];
		end
		{OPCODE_J_TYPE ,FUNCT3_IGN}: begin
		   	imm = immJ; rs1 = inst[19:15]; 					    rd = inst[11:7];
		end
		default: ;
	endcase
	case(inst)
		ECALL :	begin
			imm=CSR_MTVEC;rs1 = MCAUSE_REG;
			csr_waddr1=CSR_MEPC[11:0];csr_waddr2=CSR_MCAUSE[11:0];
		end		
		MRET  : begin
			imm=CSR_MEPC;	
		end	
		EBREAK: ebreak();
		default:;
	endcase
end
endmodule
