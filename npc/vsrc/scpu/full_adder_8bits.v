module full_adder_8bits(
	input [7:0] A,
	input [7:0] B,
	input cin,
	output[7:0] S,
	output cout
);
wire [7:0] C;
full_adder inst_fa0(
	.a		(A[0]),
	.b		(B[0]),
	.cin	(cin),
	.s		(S[0]),
	.cout	(C[0])
);
genvar i;
generate 
	for(i = 1;i<8;i = i+1)begin :gen_fulladder8
		full_adder inst_fa(
			.a		(A[i]),
			.b		(B[i]),
			.cin	(C[i-1]),
			.s		(S[i]),
			.cout	(C[i])
		);
	end
endgenerate
assign cout = C[7];
endmodule
