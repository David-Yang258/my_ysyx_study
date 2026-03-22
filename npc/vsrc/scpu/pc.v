module pc(
	input clk,
	input rst,
	input ena,
	input set,
	input [3:0] setbits,
	output reg [3:0] Q3_0

);
always@(posedge clk or posedge rst) begin
	if(rst) begin
		Q3_0 <= 4'b0;
	end
	else if(ena) begin
		 if(set) Q3_0 <= setbits;
		 else Q3_0 <= Q3_0 + 4'b1;
	end
	else Q3_0 <= Q3_0;
end

endmodule
