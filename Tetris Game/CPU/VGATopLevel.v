/*
	This is the top-level module for the VGA display.
	
	The "VGAtimer.v" module is the control that handles writing data onto a 640x480 pixel screen.
	
	The two "bitGen" modules determine what data gets displayed. There is a "bitGenSelector" input for this.
	
	inputs:
		- clk:
		- switches: Input controls for bitgen 1. They determine screen color.
		- buttons: Input controls for bitgen 2. They are the turn-signal inputs.
		- bitGenSelectore: determines which of the bit generator outputs will feed into the display.
		- power: turns the whole machine on or off. I just hard-coded this to 1.
	output:
		- VGA_HS: Horizontal synchronization signal. Negative edges indicate that a new row on the screen is starting.
		- VGA_VS: Veritical synchronization signal. Negative edges indicate the beginning of a new column.
		- VGA_CLK: a 25 MHz signal for the VGA display (it requires 25 MHz).
		- VGA_SYNC_N: When this active-low signal is inactive then we get continuous video without interruption.
		- VGA_BLANCK_N: Indicates that the current location on the display should be displayed.
		- VGA_R, G, and B: the RGB values encoding the color of the pixel at the current location.
		- LEDs: 6-bit output for the LEDs in the turn signal from bitgen2.
*/
module VGATopLevel(
	input clk, // 50 MHz from the board
	input reset,
	input [15:0] readMemory,
	output reg VGA_HS,
	output reg VGA_VS,
	output reg VGA_CLK,
	output reg VGA_SYNC_N,
	output reg VGA_BLANK_N, 
	output reg [9:0]Vcount,
	output reg [7:0] VGA_R,
	output reg [7:0] VGA_G,
	output reg [7:0] VGA_B
);


// Connecting wires between different modules
reg enable = 1'b0; // Generated 25 MHz signal
wire bright; // Indicates if the current pixel should be activated
wire [9:0] hcount;
wire [9:0] vcount;
wire hsync; 
wire vsync;
wire [7:0] r1;
wire [7:0] g1;
wire [7:0] b1;

always @ (*)
begin
 Vcount <= vcount;
end
// VGA_SYNC_N is active low and always inactive;
always VGA_SYNC_N <= 1'b1;

// Generate a 25 MHz enable signal from the input 50 MHz clock.
always@(posedge clk) begin
	if(!reset)
		enable <= 1'b0;
	else
		enable <= ~enable;
end

// Drive all the circuit outputs.
always@(*) begin
	VGA_CLK <= enable;
	VGA_HS <= hsync;
	VGA_VS <= vsync;
	
	// The bitgen selector determines if the output color is driven by bitgen 1 or 2.
	// If bitgen 2 is not selected then the LEDs are also kept off.
	VGA_R <= r1;
	VGA_G <= g1;
	VGA_B <= b1;
	
	if(~bright)
		VGA_BLANK_N <= 0;
	else
		VGA_BLANK_N <= 1; 
	
end


// Instantiate the submodules
VGAtimer  control(.clk(enable), .clear(1'b1), .hsync(hsync), .vsync(vsync), .bright(bright), 
	.hcount(hcount), .vcount(vcount));
	
//Create the bitgen	
bitgen bg1(
	 .bright(bright),
	.hcount(hcount),
	.vcount(vcount),
	.currLine(readMemory),
	.VGA_R(r1),
	.VGA_G(g1),
	.VGA_B(b1)
);
endmodule
