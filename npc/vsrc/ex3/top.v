module top(
	input [3:0] A,
	input [3:0] B,
	input [2:0] ctrl,
	output [6:0] segl,
	output [6:0] segh,
	output reg [3:0] result,
	output zero,
	output overflow,
	output carry
);

wire [3:0] t_no_cin;
wire [3:0] pm_result;
wire cin;

assign cin = (ctrl == 3'b001) ? 1'b1 : 0;

assign t_no_cin = {4{cin}} ^ B;
assign {carry, pm_result} = A + t_no_cin + cin;
assign overflow = (A[3] == t_no_cin[3]) && (pm_result [3] != A[3]);
assign zero = ~(|pm_result) ;

always @ (*) begin
	casez(ctrl)
		3'b00?: result = pm_result; 
		3'b010: result = ~A;
		3'b011: result = A & B;
		3'b100: result = A | B;
		3'b101: result = A ^ B;
		3'b110: result = {3'b0,(A[3] == B[3]) ? (A > B) : ((A[3] == 1) ? 1'b1 : 1'b0)};	
		3'b111:	result = (A == B) ? 4'b1 : 4'b0;
	endcase
end

bcd7seg inst_7seg_1(
	.b		((result[3] == 1'b1) ? (4'd15 - result + 4'b1) : result),
	.h		(segl)
);


bcd7seg inst_7seg_2(
	.b		({3'b0,result[3]}),
	.h		(segh)
);
endmodule
