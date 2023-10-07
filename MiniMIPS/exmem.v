/*
	A multi-bit flip-flop to hold the current state for the Finite State Machine in the CPU. It's purpose is to recieve instructions from memory on an input wire called "data" (because it's a flip flop) then decode the instruction to set the current read address (into a register called "addr_reg").

    Memory in this processor is split between 'regular' memory and input/output memory. Every instruction contains an encoding for indicating whether or not it interfaced
    with the IO memory.

    This module can be thought of as its own finite state machine that addresses three different concerns
    - The first is driving the outputs of the FSM. There are two outputs being driven, one is the LEDs on the Cyclone V board and the other is the flip-flop's output q which
        holds the completely decoded/raw data obtained from any operation.
    
    - The second is predicting the next state.
        The machine runs through two phases. The first is loading the program from memory and the second is running the program. In the first phase, the FSM is Moore-type and so the next state is just the next instruction in memory/RAM. In the second phase, the FSM becomes Mealy-type and so the next state depends on the board's slide
        switch values. The phase of the machine is indicated by the "IO" wire which is set after decoding the current instruction.

    - The third is next state progression
        This is done by setting the next read address.
*/
module exmem #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
        (
	input [(DATA_WIDTH-1):0] switches,
	input [(DATA_WIDTH-1):0] data, // An instruction read from memory. Named "data" because this module is a flip flop.
	input [(ADDR_WIDTH-1):0] addr, // A two-bit encoding for address region.
	input wen, clk, // Write enable, clock signal.
	output [(DATA_WIDTH-1):0] q,
	output reg [(DATA_WIDTH-1):0] LEDs
        );

	// Declare Wire IO
	wire IO;
	
	// Decode whether or not this is an IO instruction that reads to or writes from memory.
	assign IO = (addr[7:6] == 2'b11);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Variable to hold the read address
	reg [ADDR_WIDTH-1:0] addr_reg;

	// Load RAM data from an external file
	initial begin
		$display("Loading memory");
		$readmemh("C:/Users/shem/Documents/ECE3710/MipsLab/fib_hex.dat", ram); // This filepath is specific to my computer.
		$display("done loading");
	end

	always @ (negedge clk) begin

		if (wen) begin
			if (IO) 
				LEDs <= data;
			else
				ram[addr] <= data;
		end

		// update the read address to the next instruction
		addr_reg <= addr;
	end

	// Assign the output as either the switches or LEDs.
	assign q = IO ? switches : ram[addr_reg];

endmodule
