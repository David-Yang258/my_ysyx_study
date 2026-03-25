module inst_exec (
	input 				clk,
	input 		[6:0 ] 	funct7,
	input 		[2:0 ] 	funct3,
	input 		[4:0 ]  rd,
	input 		[31:0] 	src1,
	input 		[31:0] 	src2,/* verilator lint_off UNUSEDSIGNAL */
	input       [4:0 ] 	shamt,/* verilator lint_on UNUSEDSIGNAL */
	input 		[31:0] 	imm,
	input 		[6:0 ] 	opcode,
	input 		[31:0]  pc,
	output reg 	[31:0] 	rd_wdata,
	output reg			reg2reg,
	output reg			reg2mem,
	output reg			mem2reg,
	output reg			setpc,
	output reg	[31:0]  setbits
);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte wmask, bit clk);
import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void trace_func_call(input int pc, input int dnpc, bit clk);

//localparam OPCODE_R_TYPE1= 7'b0010011;
localparam OPCODE_R_TYPE2= 7'b0110011;

localparam OPCODE_I_TYPE1= 7'b0000011;
localparam OPCODE_I_TYPE2= 7'b0010011;
localparam OPCODE_I_TYPE3= 7'b1100111;

localparam OPCODE_S_TYPE = 7'b0100011;
//localparam OPCODE_B_TYPE = 7'b1100011;
localparam   OPCODE_LUI    = 7'b0110111;
//localparam   OPCODE_AUIPC  = 7'b0010111;
//localparam OPCODE_J_TYPE = 7'b1101111;

//localparam FUNCT7_SLLI   = 7'b0000000;
//localparam FUNCT7_SRLI   = 7'b0000000;
//localparam FUNCT7_SRAI   = 7'b0100000;
localparam FUNCT7_ADD    = 7'b0000000;
//localparam FUNCT7_SUB    = 7'b0100000;
//localparam FUNCT7_SLL    = 7'b0000000;
//localparam FUNCT7_SLT    = 7'b0000000;
//localparam FUNCT7_SLTU   = 7'b0000000;
//localparam FUNCT7_XOR    = 7'b0000000;
//localparam FUNCT7_SRL    = 7'b0000000;
//localparam FUNCT7_SRA    = 7'b0100000;
//localparam FUNCT7_OR     = 7'b0000000;

localparam FUNCT7_IGN 	 = 7'b???????;
   
localparam FUNCT3_JALR = 3'b000;
   
//localparam FUNCT3_BEQ  = 3'b000;
//localparam FUNCT3_BNE  = 3'b001;
//localparam FUNCT3_BLT  = 3'b100;
//localparam FUNCT3_BGE  = 3'b101;
//localparam FUNCT3_BLTU = 3'b110;
//localparam FUNCT3_BGEU = 3'b111;
   
//localparam FUNCT3_LB   = 3'b000;
//localparam FUNCT3_LH   = 3'b001;
localparam FUNCT3_LW   = 3'b010;
localparam FUNCT3_LBU  = 3'b100;
//localparam FUNCT3_LHU  = 3'b101;
   
localparam FUNCT3_SB   = 3'b000;
//localparam FUNCT3_SH   = 3'b001;
localparam FUNCT3_SW   = 3'b010;
localparam FUNCT3_ADDI = 3'b000;
//localparam FUNCT3_SLTI = 3'b010;
//localparam FUNCT3_SLTIU= 3'b011;
//localparam FUNCT3_XORI = 3'b100;
//localparam FUNCT3_ORI  = 3'b110;
//localparam FUNCT3_ANDI = 3'b111;
   
//localparam FUNCT3_SLLI = 3'b001;
//localparam FUNCT3_SRLI = 3'b101;
//localparam FUNCT3_SRAI = 3'b101;
   
localparam FUNCT3_ADD  = 3'b000;
//localparam FUNCT3_SUB  = 3'b000;
   
//localparam FUNCT3_SLL  = 3'b001;
//localparam FUNCT3_SLT  = 3'b010;
//localparam FUNCT3_SLTU = 3'b011;
   
//localparam FUNCT3_XOR  = 3'b100;
//localparam FUNCT3_SRL  = 3'b101;
//localparam FUNCT3_SRA  = 3'b101;
//localparam FUNCT3_OR   = 3'b110;
//localparam FUNCT3_AND  = 3'b111;

localparam FUNCT3_IGN  = 3'b???;

reg [31:0] mem_raddr;
reg [31:0] mem_waddr;

always@(*) begin
	reg2reg = 1'b0;
	reg2mem = 1'b0;
	mem2reg = 1'b0;
	setpc   = 1'b0;
	rd_wdata= 32'b0;
	setbits = 32'b0;
	casez({funct3, funct7, opcode})
		{FUNCT3_ADDI, FUNCT7_IGN, OPCODE_I_TYPE2}: begin
			rd_wdata = src1 + imm;
			//rd_wdata = src1 - imm;
			reg2reg  = 1'b1;
		end
		{FUNCT3_JALR, FUNCT7_IGN, OPCODE_I_TYPE3}: begin 
			rd_wdata = pc + 4;
			setpc    = 1'b1;
			setbits  = imm + src1;
			if(rd == 5'd1) trace_func_call(pc, setbits, clk);
			reg2reg  = 1'b1;
		end
		{FUNCT3_ADD , FUNCT7_ADD, OPCODE_R_TYPE2}: begin 
			rd_wdata = src1 + src2;
			reg2reg  = 1'b1;
		end
		{FUNCT3_IGN , FUNCT7_IGN, OPCODE_LUI 	}: begin
			rd_wdata = imm;
			reg2reg  = 1'b1;
		end
		{FUNCT3_LW  , FUNCT7_IGN, OPCODE_I_TYPE1}: begin
			mem_raddr= src1 + imm;
			rd_wdata = pmem_read(mem_raddr);	
			mem2reg  = 1'b1;
		end
		{FUNCT3_SW  , FUNCT7_IGN, OPCODE_S_TYPE }: begin
			pmem_write(src1+imm, src2, 8'h0F, clk);
			reg2mem  = 1'b1;
		end
		{FUNCT3_LBU , FUNCT7_IGN, OPCODE_I_TYPE1}: begin
			mem_raddr= src1 + imm;
			rd_wdata = pmem_read(mem_raddr);
			case(mem_raddr[1:0])
				2'b00: rd_wdata =  rd_wdata        & 32'hFF;
				2'b01: rd_wdata = (rd_wdata >> 8 ) & 32'hFF;
				2'b10: rd_wdata = (rd_wdata >> 16) & 32'hFF;
				2'b11: rd_wdata = (rd_wdata >> 24) & 32'hFF;
				default:;
			endcase
			mem2reg  = 1'b1;
		end
		{FUNCT3_SB  , FUNCT7_IGN, OPCODE_S_TYPE }: begin
			mem_waddr= src1 + imm;
			case(mem_waddr[1:0])
				2'b00: pmem_write(mem_waddr, src2      , 8'h01, clk);
				2'b01: pmem_write(mem_waddr, src2 << 8 , 8'h02, clk);
				2'b10: pmem_write(mem_waddr, src2 << 16, 8'h04, clk);
				2'b11: pmem_write(mem_waddr, src2 << 24, 8'h08, clk);
				default;
			endcase
			reg2mem  = 1'b1;
		end
		default: ;
	endcase	
end


endmodule
