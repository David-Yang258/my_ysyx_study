module prior_coder8_3(
        input ena,
        input [7:0] data,
        output reg [2:0] res,
        output reg status
);
always@(*)begin
        if(ena)begin
                casez(data)
                        8'b0000000? : res = 3'b000;
                        8'b0000001? : res = 3'b001;
                        8'b000001?? : res = 3'b010;
                        8'b00001??? : res = 3'b011;
                        8'b0001???? : res = 3'b100;
                        8'b001????? : res = 3'b101;
                        8'b01?????? : res = 3'b110;
                        8'b1??????? : res = 3'b111;
                        default : res = 3'b000;
                endcase
		status = (data != 8'd0) ? 1'b1 : 1'b0;
        end
        else begin 
		res = 3'b000;
                status = 1'b0;
        end
end
endmodule
