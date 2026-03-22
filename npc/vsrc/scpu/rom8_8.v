module rom8_8(
	input [3:0] sel,
	output [7:0] inst
);

reg [7:0] myrom [8:0];
assign myrom[0] = 8'b10001010;
assign myrom[1] = 8'b10010000;
assign myrom[2] = 8'b10100000;
assign myrom[3] = 8'b10110001;
assign myrom[4] = 8'b00010111;
assign myrom[5] = 8'b00101001;
assign myrom[6] = 8'b11010001;
assign myrom[7] = 8'b01101111;
assign myrom[8] = 8'b11011111;

assign inst = myrom[sel];

endmodule
