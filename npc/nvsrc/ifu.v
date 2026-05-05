/*---------------------
*@port bus_interface: default bus interfaces
*@port branch_happen: branch state
*@port stall 		: pipeline stop
*@port ibus_cmd  	: ifu cmd to read from memory
*@port inst  		: instruction to IDU
*@function :Fetch inst from mem and transfer to IDU
*---------------------*/
`include "bus_define.vh"
module ifu(
	input 							  clk,
	input 							  rst_n,
	input 							  branch_happen,
	input  		[`BUS_DATA_WIDTH-1:0] branch_addr,
	input 							  stall,

	output reg 						  inst_valid,
	output reg 						  ifu_stall_rqst,

	output reg	[`MEM_ADDR_WIDTH-1:0] araddr,

	input  		[`BUS_DATA_WIDTH-1:0] rdata,
	/*verilator lint_off UNUSEDSIGNAL*/

	output reg 	[`BUS_DATA_WIDTH-1:0] pc,
	output reg 	[`BUS_DATA_WIDTH-1:0] inst,
	output reg  [`BUS_DATA_WIDTH-1:0] diff_npc_d1
);
reg [2:0]  				  ifu_state; 		 //IFU state

reg  					  need2fetch;


localparam IFU_IDLE 		= 3'b000;//IDLE
localparam IFU_GET_INST     = 3'b010;
//localparam IFU_WAIT_WBU 	= 3'b011;//Waiting for WBU to write
//localparam IFU_WRITE_BACK 	= 3'b100;//Waiting for WBU to write
localparam IFU_JMP			= 3'b101;//Handle branch if there is one 


reg flush_pending;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) flush_pending <= 1'b0;
	else if(branch_happen) flush_pending <= 1'b1;
	else if(ifu_state == IFU_GET_INST) flush_pending <= 1'b0;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin 
		araddr    <= `PC_ENTRY;
		ifu_state <= IFU_IDLE; 		//IDLE
		inst 	  <= 32'h00000013;  //NOP
 		need2fetch<= 1'b1;
		inst_valid<= 1'b0;
		ifu_stall_rqst<=1'b0;
	end
	else begin
		/* 
		* if IFU_IDLE ,check if there's a branch, if not, 
		* check whether there's a inst waiting 2 fetch or not.
		* IFU_IDLE -> IFU_REQUESTING -> IFU_WAIT
		*/
		case(ifu_state)
			IFU_IDLE: begin
				if(!stall && need2fetch) begin
					araddr 	 		<= pc;
					ifu_state 		<= IFU_GET_INST;
					ifu_stall_rqst  <= 1'b1;
					need2fetch 		<= 1'b0;
				end
			end
			IFU_GET_INST: begin
					if(flush_pending || branch_happen) begin
					   	inst 		<= 32'h00000013;
						inst_valid 	<= 1'b0;
					end
					else begin
					   	inst 	  	<= rdata;
						inst_valid 	<= 1'b1;
					end
					ifu_state 		<= IFU_JMP;
					ifu_stall_rqst  <= 1'b0;
					//ifu_state <= IFU_WAIT_WBU;
			end
			IFU_JMP:begin
				if(!stall) begin 
					ifu_state  <= IFU_IDLE;
					need2fetch <= 1'b1;
					inst_valid <= 1'b0;
				end
			end
			default:; 
		endcase;
	end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pc <= `PC_ENTRY;
	end
	else if(branch_happen) begin
		pc <= branch_addr;
	end
	else if(ifu_state == IFU_JMP && !stall) begin
		if(inst_valid)pc <= pc + 4;
	end
	diff_npc_d1 <= pc;
end
endmodule
