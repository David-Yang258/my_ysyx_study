module led(
	input clk,
	output reg o_led
);

always@(posedge clk) begin
	o_led <= ~o_led;
end
endmodule
