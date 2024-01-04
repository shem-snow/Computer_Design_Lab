/*
	Top Levle module that interacts with the VGA, PS2 and clock and reset buttons. Connects the memory, datapath, FSM, PS2, and VGATimer
*/
module cpu (input clk, input reset, input PS2Clk, input PS2Data, 	output  VGA_HS,
	output  VGA_VS,
	output  VGA_CLK,
	output  VGA_SYNC_N,
	output  VGA_BLANK_N, 
	
	output  [7:0] VGA_R,
	output  [7:0] VGA_G,
	output  [7:0] VGA_B,
	output [7:0] keyPressInMem);

//top level

wire [15:0] alu_output;
wire [15:0] instruction_memory;
wire [15:0] currinstruction;
wire [15:0] data_memory;
wire [10:0] enable_signals;
wire [4:0] statusRegisters; 
wire [15:0] pc;
wire opcodebit;
wire psrbit;
wire signedIMM;
wire [4:0] savedStatusRegisters; 
wire [15:0] dataOut;
wire [7:0] inputData;
wire inputDataClk;
wire [15:0] currLine;
wire [9:0] Vcount;
wire [7:0] previousInputData;
wire [15:0] keyPress;
wire [15:0] outputLine;
wire jump;
wire rst;
assign rst = reset;

//Decoder for Jumping
cmpDecoder codes(.instruction(currinstruction), .psr(savedStatusRegisters), .jump(jump));

//FlipFlop for current instruction
bigflipflop flip(.clk(opcodebit), .rst(rst), .d(instruction_memory), .q(currinstruction));

//FlipFlop for PSR flags
flipflop2  statusRegister( .clk(psrbit), .rst(rst), .d(statusRegisters), .q(savedStatusRegisters));

//Data path 
datapath datapath
					( .clock(clk), .reset(reset),
					 .controlbits(enable_signals),
					 .instrMem(currinstruction), .dataMem(instruction_memory), .dataOut(dataOut),
					 .jump(jump),
					 .psr(statusRegisters), // processor status register (this just contains flags)
					 .output_alu_b(alu_output),
					 .pc_out(pc)
					);
//FSM			
FSM FSM (
	.clock(clk),
	 .reset(reset),
	 .opcode(currinstruction[15:12]),
	.imm_funct(currinstruction[7:4]),
	 .conditional(jump), .enable_signals(enable_signals),
	 .opcodebit(opcodebit),
	 .psrbit(psrbit)
);

//Memory warpper 
memory memIO (
	.dataIn(dataOut),
   .addr1(pc[9:0]),
	.opcodebit(opcodebit),
	.ps2data_clock(inputDataClk),
	.ps2data(inputData),
	.addr2(alu_output[9:0]),
	.wen1(enable_signals[10]), .wen2(1'b0), .clk(clk),
	.dout1(instruction_memory),
	.dout2(currLine),
	.vcount(Vcount),
	.keyPress(keyPressInMem),
	.reset(reset));
	
//PS2Handler for keyboard input	
PS2Handler PS2Handler(.clk(PS2Clk), .currentDataBit(PS2Data),.previousCompleteData(previousInputData), .data(inputData), .inputDataClk(inputDataClk));

//Vga top level module 
VGATopLevel VGATopLevel(
	.clk(clk), // 50 MHz from the board
	.reset(reset),
	.readMemory(currLine),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_CLK(VGA_CLK),
	.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_BLANK_N(VGA_BLANK_N),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
 .Vcount(Vcount)
);

endmodule



// Flip-flop Module
module bigflipflop (
input clk, // Clock signal
input rst, // Reset signal (active-low)
input [15:0] d, // Data input
output reg [15:0] q // Data output
);
// Flip-flop behavior
always @(posedge clk, negedge rst) begin
if (!rst) q <= 16'h0000; // If reset, output 0
else q <= d; // Otherwise, output the data input
end
endmodule


// Flip-flop Module
module flipflop2 (
input wire clk, // Clock signal
input wire rst, // Reset signal (active-low)
input wire [4:0] d, // Data input
output reg [4:0] q // Data output
);
// Flip-flop behavior
always @(posedge clk, negedge rst) begin
if (!rst) q <= 5'b00000; // If reset, output 0
else q <= d; // Otherwise, output the data input
end
endmodule

