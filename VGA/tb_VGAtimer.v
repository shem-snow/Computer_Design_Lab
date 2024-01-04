`timescale 1ps/1ps
module tb_VGAtimer();

// Initialize the inputs as registers and outputs as wires
reg clock;
reg clear;

wire hsyn;
wire vsyn;
wire bright;

wire [9:0] hcount, vcount;


// instantiat the unit under test
VGAtimer UUT(
	.clk(clock),
	.clear(clear),
	.hsync(hsyn), 
	.vsync(vsyn),
	.bright(bright),
	.hcount(hcount),
	.vcount(vcount)
);

always #5 begin clock = ~clock; end
  initial begin 
	clock = 0;
	clear = 0;
	
	#20 
	clear = 1;
	#100_000
	$stop;
  end
	
endmodule