module gpr(
	input clk,
	input rst,
	input [1:0] rwaddr1,
	input [1:0] raddr2,
	input [7:0] wdata_8,
	input we,
	input re,
	output [7:0] QA7_0,
	output [7:0] QB7_0,
	output [7:0] r2,
	output [7:0] r1,
	output [7:0] r3
);

reg [7:0] gpr48 [3:0];

assign r2 = gpr48[2];
assign r1 = gpr48[1];
assign r3 = gpr48[3];

assign QA7_0 = gpr48[rwaddr1];
assign QB7_0 = gpr48[raddr2];

always @ (posedge clk or posedge rst) begin
	if(rst) begin
		gpr48[0] <= 8'b0;
		gpr48[1] <= 8'b0;
		gpr48[2] <= 8'b0;
		gpr48[3] <= 8'b0;
	end
	else begin
		if((we == 1'b1) & (re == 1'b0)) gpr48[rwaddr1] <= wdata_8;
		else gpr48[rwaddr1] <= gpr48[rwaddr1];
	end
end
endmodule

