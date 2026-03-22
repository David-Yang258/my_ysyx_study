module top(
	input clk,
	input rst,
	output reg [7:0] serial,
	output [6:0] segl,
	output [6:0] segh
);

always @ (posedge clk or posedge rst) begin
	if(rst) begin
		serial <= 8'b0;
	end
	else if((|serial)) begin 
		serial <= {(serial[4])^(serial[3])^(serial[2])^(serial[0]),serial[7:1]};
	end
	else serial <= 8'b1;
end

bcd7seg inst_7seg_0(
	.b		(serial[7:4]),
	.h		(segl)
);

bcd7seg inst_7seg_1(
	.b		(serial[3:0]),
	.h		(segh)
);
endmodule
