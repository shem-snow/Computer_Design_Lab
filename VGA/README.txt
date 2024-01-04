*************************************************************************************************
Edison Yang, Isaac Kime, Sam Wimmer, Shem Snow
ECE 3710
VGA Lab
*************************************************************************************************
Other Files Included in this submission:
-----------------------------------------
- topLevel.v:
	The top level module of this project that just instantiates all the other modules and their connections.
- design_picture.jpg:
	A drawing that illistrates the structure of our design.
- VGAtimer.v:
	The module that controlls HOW the display is written to.
- bitGen1.v:
- bitGen2.v:
	The two modules that control WHAT is displayed on the screen.
- tb_bitGen2:
	testbech to test that the proper pixels were being lit up.
- tb_VGAtimer:
	testbench we wrote to ensure the display was being driven properly.
- simulation.jpg:
	the resulting waveform from the testbench for the timer.

- ClockDivider.v:
- TbirdFSM
	Re-used code from the turn signal project. We settled on Shem's turn signal and edited it slightly for easy readability. 

Introdution and Objective:
-------------
In this lab, we learned how to use a VGA port to display images onto a screen. We did it in two steps:

1: Proof of concept: We used three input switchs to encode 2^3 = 8 different colors and just turned the entire screen that color.
2: Actual practice: We displayed our turn signal module on the screen. This required us to learn about horizontal and vertical 
synchronization on the FPGA.

Design Approach
---------------
The uploaded file "design_picture.jpg" shows what our code creates. Some notable things are:

- The "ClockDivider" that converts 50 MHz to 25 MHz is implemented using the always block at line 66 in the topLevel.v file.
	The code also considers the input power signal because if power is not turned on then the display should not light up.

- The "bitGenSelector" enabled us to complete both parts of the lab using only one module. We just assigned an extra switch to select 
	which of the two bit generators drove the output. The LEDs only light up if bitGen2 is selected.

The VGAtimer works by partitioning the screen into four horizontal regions: front porch, back porch, display, past_display.

- The Hsync signal pulses active at in the front porch then goes inactive outside of it.
- The screen is not partitioned into vertical sections so the VSync signal is always checked to see if the veritical position is at 
	the top of this screen. If it is then Vsync is pulsed active. Otherwise it is held active.
- Hsync and Vsync only travel in one direction so we only have to set the signals inactive once and assume that they will remain inactive
	until the next row or column begins.

bitGen1 is easy. Just map the input switches to pre-defined colors.
bitGen2 requires us to use shapes 
- The strategy was to use nested  conditional statements to distinguish different regions of the screen.
 	We found that partitioning the screen into 16 horizontal spaces arranged the lights pretty evenly accross.
 
 	Dividing by 16 gives each box a width of 40.
		width = (784 - 144)/16 = 40
		
 		|_5_| |_4_| |_3_|      |_2_| |_1_| |_0_|
	
- As for box height, we just pick a height of 40 so the lights would be square and placed them at the center of the vertical range (480/2 = 240).

- To simplify conditional statements, we created registers that were always driven by each condition. 

Testbech and Simulation
------------------------
We tested the BitGen2 by initializing the LEDs to an arbatrary value 011_000 and the "bright" signal to false.
---------------------
Then we changed hcount and vcount to move around the screen checking which lights were on/off. 

While "bright" is false then they were all off.

Then we switched "bright" to true and repeated changing hcount and vcount to inspect different regions of the screen.

We found that only the two correct LEDs were turned on. The background was blue, inactive lights were off.

We testest VGAtimer.v by initializing the values to start at the beginnning then letting it run for 100 nanoseconds.
----------------------
The file "simulation.jpg" shows the waveform that was generated. Since the screen is 640x480 pixels then the simulation ran forever. 
The wavform was huge.


Conclusion
-------------
Now we know how to draw shapes on a VGA display.
The hardest part of this lab was setting the horizontal and vertical synchronization signals properly as the hcount and vcount moved 
	through the display. 
Writing the testbench for bitgen2 was also really annoying. We simplified it by storing conditions into registers that were always driven.