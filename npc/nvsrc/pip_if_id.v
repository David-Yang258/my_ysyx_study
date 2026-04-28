`include "bus_define.vh"
module pip_if_id(
	input 							 clk,
	input 							 rst_n,
	input [`BUS_DATA_WIDTH-1:0]		 if_inst,
	input [`BUS_DATA_WIDTH-1:0]		 if_pc,
	input  							 stall,
	output reg [`BUS_DATA_WIDTH-1:0] if_id_pc,
	output reg [`BUS_DATA_WIDTH-1:0] if_id_inst
);

 
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		if_id_pc 	<= 32'b0;
		if_id_inst 	<= 32'h00000013;
	end
	else if (!stall) begin
		if_id_pc  	<= if_pc;
		if_id_inst  <= if_inst;
	end
end

endmodule
