module bcd7seg(
		input ena,
        input [3:0] b,
        output reg [6:0] h
);

always@(*) begin
	if(ena) begin
        case(b)
                4'd0: h = 7'b0000001;
                4'd1: h = 7'b1001111;
                4'd2: h = 7'b0010010;
                4'd3: h = 7'b0000110;
                4'd4: h = 7'b1001100;
                4'd5: h = 7'b0100100;
                4'd6: h = 7'b0100000;
                4'd7: h = 7'b0001111;
                4'd8: h = 7'b0000000;
                4'd9: h = 7'b0000100;
				4'd10:h = 7'b0001000;
				4'd11:h = 7'b1100000;
				4'd12:h = 7'b0110001;
				4'd13:h = 7'b1000010;
				4'd14:h = 7'b0110000;
				4'd15:h = 7'b0111000;
                default: h = 7'b1111111;
        endcase
	end
	else h = 7'b1111111;
end
endmodule
