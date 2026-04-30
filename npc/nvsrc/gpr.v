module gpr #(ADDR_WIDTH = 5, DATA_WIDTH = 32) (
  input  clk,
  input  [DATA_WIDTH-1:0] wdata,
  input  [ADDR_WIDTH-1:0] waddr,
  input  wen,
  input  [ADDR_WIDTH-1:0] raddr1,
  input  [ADDR_WIDTH-1:0] raddr2,
  output [DATA_WIDTH-1:0] rdata1,
  output [DATA_WIDTH-1:0] rdata2

);
  reg  [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0];
  wire [DATA_WIDTH-1:0] rdata1_mux;
  wire [DATA_WIDTH-1:0] rdata2_mux;
  assign rdata1_mux = (raddr1 == 5'b0) ? {DATA_WIDTH{1'b0}} : 
	  				  ((wen && waddr == raddr1) ? wdata : rf[raddr1]);

  assign rdata2_mux = (raddr2 == 5'b0) ? {DATA_WIDTH{1'b0}} : 
	  				  ((wen && waddr == raddr2) ? wdata : rf[raddr2]);
  assign rdata1 = rdata1_mux;
  assign rdata2 = rdata2_mux;
  always @(posedge clk) begin
    if (wen) rf[waddr] <= wdata;
	rf[0] <= 32'b0;
  end
endmodule
