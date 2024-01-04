/*
	This module displays the Tbird FSM lights onto a VGA display.

	The strategy was to use nested  conditional statements to distinguish different regions of the screen.
 	We found that partitioning the screen into 16 horizontal spaces arranged the lights pretty evenly accross.
 
 	Dividing by 16 gives each box a width of 40.
		width = (784 - 144)/16 = 40
		
 		|_5_| |_4_| |_3_|      |_2_| |_1_| |_0_|
	
 	As for box height, we just pick a height of 40 so the lights would be square and placed them at the center of the vertical range (480/2 = 240).
 */

module bitGen2(
	input bright,
	input [9:0] hcount,
	input [9:0] vcount,
	input [5:0] LEDs,
	output reg[7:0] VGA_R,
	output reg[7:0] VGA_G,
	output  reg[7:0] VGA_B
);

// Define the conditions for distinguishing different regions of the screen so I don't have to think about them later.
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


always@(*) begin
	
	// If the current pixel is in the 'active' part of the screen then figure out what color to display and display it.
	if(10'd144 <= hcount && hcount < 10'd783) begin

		// If it is at any light locations, check if that light is active or inactive and display the corresponding color.
		if(atLightHeight && atAnyLightWidth) begin
			
			// If the lights are "ON", make them yellow.
			if(L5 && LEDs[5]) begin
				VGA_R <= 8'b11111111;
				VGA_G <= 8'b11111111;
				VGA_B <= 8'b00000000;
			end
			else if(L4 && LEDs[4]) begin
				VGA_R <= 8'b11111111;
				VGA_G <= 8'b11111111;
				VGA_B <= 8'b00000000;
			end
			else if(L3 && LEDs[3]) begin
				VGA_R <= 8'b11111111;
				VGA_G <= 8'b11111111;
				VGA_B <= 8'b00000000;
			end
			else if(L2 && LEDs[2]) begin
				VGA_R <= 8'b11111111;
				VGA_G <= 8'b11111111;
				VGA_B <= 8'b00000000;
			end
			else if(L1 && LEDs[1]) begin
				VGA_R <= 8'b11111111;
				VGA_G <= 8'b11111111;
				VGA_B <= 8'b00000000;
			end
			else if(L0 && LEDs[0]) begin
				VGA_R <= 8'b11111111;
				VGA_G <= 8'b11111111;
				VGA_B <= 8'b00000000;
			end
			// Otherwise they are "OFF", make them grey.
			else begin
				VGA_R <= 10110010;
				VGA_G <= 10111110;
				VGA_B <= 10110101;
			end
		end
		// Draw the background color (blue)
		else begin
			VGA_R <= 8'b00000000;
			VGA_G <= 8'b00000000;
			VGA_B <= 8'b10000000;
		end
  	end
	// Otherwise leave the screen off (black)
	else begin
		VGA_R <= 8'b00000000;
		VGA_G <= 8'b00000000;
		VGA_B <= 8'b00000000;
	end
end
endmodule 		
				