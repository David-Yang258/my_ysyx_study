module pc #(PC_WIDTH = 32)(
	input clk,
	input rst,
	input jmp_set,
	input [PC_WIDTH-1:0] setbits,
	output [PC_WIDTH-1:0] inst_addr
);
reg [PC_WIDTH-1:0] pc_cnt; 
assign inst_addr = pc_cnt;
always@(posedge clk) begin
	if(rst) pc_cnt <= 32'h80000000;
	else begin
		if(jmp_set) pc_cnt <= setbits;
		else pc_cnt <= pc_cnt + 4; 
	end
end

endmodule
