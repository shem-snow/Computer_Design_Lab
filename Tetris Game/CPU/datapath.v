
module datapath #(parameter WIDTH = 16, REGBITS = 4)
					(input clock, reset,
					 input[10:0] controlbits,
					 input [15:0] instrMem, input [15:0]dataMem,
					 input jump,
					 output [4:0] psr, // processor status register (this just contains flags)
					 output [15:0] output_alu_b,
					 output [15:0]  pc_out,
					 output [15:0] dataOut
					);

		
// Define the wires in between submodules and muxes
wire [15:0] alu_result;

wire [15:0] alu_a;
wire [15:0] alu_b;

wire [15:0] between2muxs;

wire [15:0] extendedimm;
wire [15:0] r_tgt;
wire [15:0] pc;
wire [15:0] r_src;

wire [15:0] reg_write_data;

assign output_alu_b = alu_result;
assign dataOut = r_src;
//Set up registers
assign extendedimm =  {instrMem[7],instrMem[7],instrMem[7],instrMem[7],instrMem[7],instrMem[7],instrMem[7],instrMem[7],instrMem[7:0]};

assign pc_out = (reset ? pc : 16'h0000); //start at 15, which is 21 in decimal where we have our program starting
// Instantiate the submodules.
//-----------------------------------------------------------------
// Register File
regfile regfile(.clk(clock), .regwrite(controlbits[9]), .pc_wr(controlbits[8]), .ra1(instrMem[3:0]), .ra2(instrMem[11:8]), 
                .writedata(reg_write_data), .rsrc(r_src), .rtgt(r_tgt), .pc(pc));

// ALU
Alu alu( .a(alu_a), .b(alu_b), .alucode(controlbits[3:0]), .status(jump), .flags(psr), .result(alu_result));

//MUXES
//-----------------------------------------------------------------


// Mux before alu_a         0-> between mux above    1-> add 1 (for updating pc)
regMux  aluInput1(.in1(between2muxs), .in2(16'h0001), .control(controlbits[4]), .out(alu_a));

// First mux after regfile  0-> rtgt  1-> extended_imm
regMux  middleMux(.in1(r_tgt), .in2(extendedimm), .control(controlbits[5]), .out(between2muxs));

// Second mux after regfile 0-> rsrc 1-> pc
regMux  aluInput2(.in1(r_src), .in2(pc), .control(controlbits[6]), .out(alu_b));

// Mux befor regfile         0-> BUS/alu_result    1->dataMem     2->pc
regMux  reginput(.in1(alu_result), .in2(dataMem), .control(controlbits[7]), .out(reg_write_data));

endmodule
