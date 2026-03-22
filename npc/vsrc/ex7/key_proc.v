module key_proc(
	input clk,
	input rst_n,
	input [7:0] key_data,
	input ready,
	input overflow,
	output reg read_comp,
	output [6:0] seg0l,
	output [6:0] seg0h,
	output [6:0] seg1l,
	output [6:0] seg1h,
	output [6:0] seg2l,
	output [6:0] seg2h
); 

reg key_pressed;
reg  [7:0] key_count;
reg  [7:0] key_valid;
reg  [7:0] key_prev_data;
wire [7:0] key_ascii;
wire [7:0] key_code;

assign key_code = key_data;

rom2ascii inst_rom2ascii(
	.origin	(key_valid),
	.ascii	(key_ascii)
);

always @(posedge clk) begin
	if(rst_n == 0) begin
		key_count <= 8'b0;
		key_valid <= 8'b0;
	end
	else if(overflow); 
	else if(ready) begin
		if(key_code == 8'hF0)begin
			key_valid <= key_valid;
			key_pressed <= 1'b0;
		end	
		else if(key_prev_data == 8'hF0) begin
			key_count <= key_count + 8'b1;
			key_pressed <= 1'b0;
		end	
		else begin
			key_valid <= key_code;
			key_pressed <= 1'b1;
		end
		key_prev_data <= key_code;
		read_comp <= 1'b0;
	end
	else ;
end

bcd7seg inst_7seg_0(
	.ena	(key_pressed),
	.b		(key_valid[7:4]),
	.h		(seg0h)
);

bcd7seg inst_7seg_1(
	.ena	(key_pressed),
	.b		(key_valid[3:0]),
	.h		(seg0l)
);

bcd7seg inst_7seg_2(
	.ena	(key_pressed),
	.b		(key_ascii[7:4]),
	.h		(seg1h)
);

bcd7seg inst_7seg_3(
	.ena	(key_pressed),
	.b		(key_ascii[3:0]),
	.h		(seg1l)
);

bcd7seg inst_7seg_4(
	.ena	(1'b1),
	.b		(key_count[7:4]),
	.h		(seg2h)
);

bcd7seg inst_7seg_5(
	.ena	(1'b1),
	.b		(key_count[3:0]),
	.h		(seg2l)
);

endmodule




