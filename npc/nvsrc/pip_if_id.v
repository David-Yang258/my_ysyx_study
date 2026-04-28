`include "bus_define.vh"
module pip_if_id(
	input 							 clk,
	input 							 rst_n,
	input [`BUS_DATA_WIDTH-1:0]		 if_inst,
	input [`BUS_DATA_WIDTH-1:0]		 if_pc,
	input  							 stall,
	input 							 flush,

	output reg [`REG_ADDR_WIDTH-1:0] if_id_rd,
	output reg [`REG_ADDR_WIDTH-1:0] if_id_rs1,
	output reg [`REG_ADDR_WIDTH-1:0] if_id_rs2,
	output reg [`BUS_DATA_WIDTH-1:0] if_id_pc,
	output reg [`BUS_DATA_WIDTH-1:0] if_id_inst
);

 
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		if_id_pc 	<= 32'b0;
		if_id_inst 	<= 32'h00000013;
		if_id_rd 	<= 5'b0;
		if_id_rs1 	<= 5'b0;
		if_id_rs2 	<= 5'b0;
	end
	else if(flush) begin
		if_id_pc 	<= 32'b0;
		if_id_inst 	<= 32'h00000013;
		if_id_rd 	<= 5'b0;
		if_id_rs1 	<= 5'b0;
		if_id_rs2 	<= 5'b0;
	end
	else if (!stall) begin
		if_id_pc  	<= if_pc;
		if_id_inst  <= if_inst;
		if_id_rd 	<= if_inst[11:7];
		if_id_rs1 	<= if_inst[19:15];
		if_id_rs2 	<= if_inst[24:20];
	end
end

endmodule
