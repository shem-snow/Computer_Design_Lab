/*
This module is a wrapper for memory. It takes in the same input as exmem inaddition to other inputs to help use memory IO. 
*/
module memory(
	input [15:0] dataIn,
	input [9:0] addr1,
	input [9:0] addr2,
	input wen1,wen2, clk, ps2data_clock,
	input opcodebit,
	input [9:0] vcount,
	input [7:0] ps2data,
	output [15:0] dout1,
	output [15:0] dout2,
	output [7:0]keyPress,
	input reset
	);
	reg [15:0] intData2;
	reg [9:0] intAddr1;
	reg [9:0] intAddr2;
	reg internalPS2Write; 
	wire [15:0] keyboardInput;
	wire [15:0] memoryOutput;
	reg [15:0] intDout1;
	reg outputMuxSignal; //1 is ps2, 0 is regular output
	
	//Holds the current key press input 
	ps2FlipFlop ps2FlipFlop(.clk(ps2data_clock), .rst(reset), .d({8'h00, ps2data}), .q(keyboardInput));
	
	//exmem module 
	exmem2 exmem (
	.din1(dataIn),
	.din2(intData2),
   .addr1(intAddr1),
	.addr2(intAddr2),
	.wen1(wen1), .wen2(wen2), .clk(clk),
	.dout1(memoryOutput),
	.dout2(dout2)
        );
		  
	//update at ever memory access what address we are using 
	always @(negedge clk) begin
	intData2 = 16'h0000; //always zero because we never write
	if(opcodebit)
	begin
	intAddr1 <= addr1; //grab pc address
	end
	else 
	begin 
	intAddr1 <= addr2; //or use the command
	end 
	
	//check if we trying to access input 
	if(addr2 == 16'd1023)
		outputMuxSignal = 1; 
	else 
		outputMuxSignal = 0;
		
	//grab the current line based on vcount 
	if(vcount<= 24)
		intAddr2 <= 10'd1022;
	else if ( 24 < vcount && vcount <= 48)
		intAddr2 <= 10'd1021;
	else if( 48 < vcount && vcount <= 72)
		intAddr2 <= 10'd1020;
	else if( 72 < vcount && vcount <= 96)
		intAddr2 <= 10'd1019;
	else if( 96 < vcount && vcount <= 120)
		intAddr2 <= 10'd1018;
	else if( 120 < vcount && vcount <= 144)
		intAddr2 <= 10'd1017;
	else if( 144< vcount && vcount <= 168)
		intAddr2 <= 10'd1016;
	else if( 168 < vcount && vcount <= 192)
		intAddr2 <= 10'd1015;
	else if( 192 < vcount && vcount <= 216)
		intAddr2 <= 10'd1014;
	else if( 216< vcount && vcount <= 240)
		intAddr2 <= 10'd1013;
	else if( 240< vcount && vcount <= 264)
		intAddr2 <= 10'd1012;
	else if( 264< vcount && vcount <= 288)
		intAddr2 <= 10'd1011;
	else if( 288< vcount && vcount <= 312)
		intAddr2 <= 10'd1010;
	else if( 312< vcount && vcount <= 336)
		intAddr2 <= 10'd1009;
	else if( 336< vcount && vcount <= 360)
		intAddr2 <= 10'd1008;
	else if( 360 < vcount && vcount <= 384)
		intAddr2 <= 10'd1007;
	else if( 384 < vcount && vcount <= 408)
		intAddr2 <= 10'd1006;
	else if( 408 < vcount && vcount <= 432)
		intAddr2 <= 10'd1005;
	else if( 432 < vcount && vcount <= 456)
		intAddr2 <= 10'd1004;
	else if( 456 < vcount && vcount <= 480)
		intAddr2 <= 10'd1003;
	else 
		intAddr2 <= 10'd1023;
	end 
	
//always assign dout to internal one
assign dout1 = intDout1;

//output the keypress to led for debuging
assign keyPress = keyboardInput[7:0];

//change dout depending on whether we are accessing memory or not 
always@ (*)
begin
if(outputMuxSignal)
	intDout1 = keyboardInput;
else 
	intDout1 = memoryOutput;
end
endmodule

// Flip-flop Module
module ps2FlipFlop (
input wire clk, // Clock signal
input wire rst, // Reset signal (active-low)
input wire [15:0] d, // Data input
output reg [15:0] q // Data output
);
// Flip-flop behavior
always @(posedge clk, negedge rst) begin
if (!rst) q <= 16'h00000; // If reset, output 0
else q <= d; // Otherwise, output the data input
end
endmodule
