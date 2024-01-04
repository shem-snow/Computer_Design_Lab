`timescale 1ps/1ps
module tb_bitGen2();


// Define the inputs as registers and outputs as wires.
reg bright;
reg [9:0] hcount;
reg [9:0] vcount;
reg [5:0] LEDs;


wire [7:0] VGA_R, VGA_G, VGA_B;


// Instantiate the unit under test.
 VGAtimer uut (
	.bright(bright),
	.hcount(hcount),
	.vcount(vcount),
	.LEDs(LEDs),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B)
 );
 

// Define conditions that help me identify locations on the screen. 
reg L5;
reg L4;
reg L3;
reg L2;
reg L1;
reg L0;
reg atAnyLightWidth;
reg atLightHeight;

// Constantly drive these conditions
always@(*) begin
	L5 <= (224 <= hcount && hcount < 264);
	L4 <= (304 <= hcount && hcount < 344);
	L3 <= (384 <= hcount && hcount < 424);
	L2 <= (504 <= hcount && hcount < 544);
	L1 <= (584 <= hcount && hcount < 624);
	L0 <= (664 <= hcount && hcount < 704);
	atAnyLightWidth <= (L5 | L4 | L3 | L2 | L1 | L0);
	atLightHeight <= (229 <= vcount && vcount < 260);
end


// Generate the inputs, and check the outputs. 		
initial begin
	
	// Make sure that when bright is low, nothing is displayed
	bright = 0;
	#5
	hcount = 155; // This is not on any lights.
	vcount = 256; // This is at the same height as the lights on the display.
	LEDs = 6'b011_000;
	
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
	
	// Change the value of hcount to inspect light locations too.
	#5
	hcount = 256; // On an inactive light
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
	#5
	hcount = 333; // On an active light
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
	#5
	hcount = 0; // outside of the display region.
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
	
	
	
	// Now set bright to true and watch the screen light up to the background color.
	#5
	bright = 1;
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
	
	// Now change to a spot where a light is off
	#5
	hcount = 256; // On an inactive light.
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
	
	// Now change to a spot where the lights are on
	#5
	hcount = 333; // On an active light
	$display("bright = %b\tLEDs = %b\tPosition: (%b, %b) = %b\t(R,G,B) = (%b, %b, %b)", bright, LEDs, hcount, vcount, VGA_R, VGA_G, VGA_B);
end
	
endmodule