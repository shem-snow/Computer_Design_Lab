module FSM(
	input clock,
	input reset,
	input [3:0] opcode,
	input [3:0] imm_funct,
	input conditional,
	output reg [10:0] enable_signals,
	output reg opcodebit,
	output reg psrbit
);

// State encodings
parameter start = 5'b00000; // Initial state that doesn't do anything.
parameter IF = 5'b00001; // Instruction Fetch
parameter Dec = 5'b00010; // Decode
parameter R = 5'b00011; // R-type
parameter I = 5'b00100; // I-type
parameter J = 5'b00101; // R-type
parameter Jcomp = 5'b00110; // J-type ALU computation
parameter Rcomp = 5'b00111; // R-type ALU computation
parameter Icomp = 5'b01000; // I-type ALU computation
parameter Load = 5'b01001; // RAM Load 
parameter Store = 5'b01010; // RAM Store
parameter JalStore = 5'b01011; // jal: store link address
parameter JalLoad = 5'b01100; // jal: load new $ra Register load (i-type)
parameter Jw = 5'b01101; // J-Type write back to register
parameter Rw = 5'b01110; // R-Type write back to register
parameter Iw = 5'b01111; // I-Type write back to register
parameter PC = 5'b10000; // Increment the PC by one word
parameter Ram = 5'b10001; // Ram State
parameter RLoad = 5'b10010; // R-Type register load
parameter ILoad = 5'b10011; // I-Type register load


// Decoder and wire for driving the decoded alu opcode.
wire [3:0] ALU_decoded;
Decoder dec(.opcode({opcode, imm_funct}), .alucode(ALU_decoded));

// State registers
reg [4:0]current_state;
reg [4:0] next_state;
reg [4:0] unclocked_next_state;

//// Flip-flop to hold the next state

// Update the current state based on the next_state
always @(posedge clock, negedge reset) begin
if (!reset) current_state <= start; 
else 
current_state <= next_state;
end

// Next state prediction
always@(*) begin
	case(current_state)
	
		start: next_state <= IF;
		IF: next_state <= Dec;
		
		// Decode
		Dec: begin
			case(opcode)
				
				// Multiple-typed opcodes
				4'b1000:
					case(imm_funct)
						4'b0100:
							next_state <= R; // R-type
						default
							next_state <= I; // I-type
					endcase
				
				4'b0100:
					case(imm_funct)
						4'b0000: next_state <= R;
						4'b0100: next_state <= R; // R-type
						4'b1100: next_state <= J;
						4'b1000: next_state <= J; // J-type
						default next_state <= PC; //this shouldn't happen
					endcase
				4'b0101: next_state <= I;
				// Same-type shared opcodes
				4'b0000: next_state <= R; // R-type
				
				// Unshared/unique opcodes
				4'b1100: next_state <= I; // BCOND.
				
				default: next_state <= I; //.
				
			endcase
		end
		
		J:
			case(imm_funct)
				
				// jal
				4'b1000: next_state <= JalStore; // Store link address in EXMEM
				
				// JCOND
				4'b1100: next_state <= Jcomp; // ALU_compute
				
				// Should be unreachable
				default: next_state <= PC;
				
			endcase
		JalStore: next_state <= JalLoad; // Load target address into $ra
		JalLoad: next_state <= PC;
		Ram:
			case(imm_funct)
			
				// load
				4'b0000: next_state <= Load;
				
				// store
				4'b0100: next_state <= Store;
				
				// Should be unreachable
				default: next_state <= PC;
				
			endcase
		
		R: 
			case(opcode)
			
				// Memory access (load and store)
				4'b0100: next_state <= Ram;
				
				// Register load
				default: next_state <= RLoad;
			endcase
			
		RLoad: next_state <= Rcomp;
		
		I: next_state <= ILoad;
		
		ILoad: next_state <= Icomp;
		
		Icomp: next_state <= Iw;
		
		Rcomp: next_state <= Rw;  // $pc++
		Rw: next_state <= PC;  // $pc++
		Iw: next_state <= PC;  // $pc++
		Jw: next_state <= PC; // $pc++
		Jcomp: next_state <= Jw;
		Load: next_state <= PC;
		Store: next_state <= PC;
		PC: next_state <= start;
		
		default: next_state <= PC; // This case should be unreachable
	endcase
end




// Output driving (enable signals for the datapath)
always@(*) 
begin
	
	case(current_state)
			
			// No work to be done because these states are part of instruction decoding.
			
			start: begin
					enable_signals <= 11'b000_0000_0000;
					opcodebit <= 0;
					psrbit <= 0;
				end
			IF: begin opcodebit <= 1; 
				enable_signals <= 11'b000_0000_0000;
					psrbit <= 0;
				end
			Dec:  begin
					enable_signals <= 11'b000_0000_0000;
					opcodebit <= 0;
					psrbit <= 0;
				end 
			R: begin enable_signals <= 11'b000_0000_0000; opcodebit <= 0;
					psrbit <= 0; end
			RLoad: begin enable_signals <= 11'b000_0000_0000;opcodebit <= 0;
					psrbit <= 0; end
	 
			// Check for a successful JCOND
			J: begin
				opcodebit <= 0;
				enable_signals <= 11'b000_0000_0000;
					psrbit <= 0;
			end
			
			// JAL sends the program through s4 & s5
			JalStore: begin opcodebit <= 0; enable_signals <= 11'b010_0101_0000; 
					psrbit <= 0;// Rdst = PC + 1 
			end
			JalLoad: begin opcodebit <= 0; enable_signals <= 11'b001_0000_0000;
					psrbit <= 0; // PC = Rtgt end
			end
			// s6 determines if load or store happens next
			Ram:
			 begin  
			opcodebit <= 0; 
			psrbit <= 0;
			if(imm_funct == 4'b0000)
				enable_signals  <= {7'b010_0000, ALU_decoded};
			else 
				enable_signals <= 11'b000_0000_0000;
			end
			Load: begin opcodebit <= 0; enable_signals <= {7'b010_1100, ALU_decoded};
					psrbit <= 0; end
			Store:begin opcodebit <= 0; enable_signals <= {7'b100_0000, ALU_decoded};
					psrbit <= 0; end
			
			// I-type instructions may branch
			I: begin 
			opcodebit <= 0;
					psrbit <= 0;
			if(opcode == 4'b1100) // BCOND
					enable_signals <= 11'b000_0110_0000; // cannot write to pc unless condition passes
				else // Not BCOND
					enable_signals <= 11'b000_0010_0000;
			end
			ILoad:begin 
			opcodebit <= 0;
					psrbit <= 0;
				if(opcode == 4'b1100) // BCOND
					enable_signals <= 11'b000_0110_0000; // cannot write to pc unless condition passes
				else // Not BCOND
					enable_signals <= 11'b000_0010_0000;
			end
			Jcomp: begin
			opcodebit <= 0;
					psrbit <= 0;
			 if(conditional)
				enable_signals <= 11'b000_0000_1111;
			  else
				enable_signals <= 11'b000_0000_0000;
			end
			Rcomp: begin opcodebit <= 0; enable_signals <= {7'b000_0000, ALU_decoded};
					psrbit <= 0;  end
			Icomp:begin 
			opcodebit <= 0; 
			psrbit <= 0;
			if(conditional && opcode == 4'b1100)
			begin 
				enable_signals <= {7'b000_0110, ALU_decoded};
				end
			else
			begin 
				enable_signals <= {7'b000_0010, ALU_decoded};
				end
			end  
			Jw: begin
				opcodebit <= 0;
					psrbit <= 0;
					
				if(conditional)
					enable_signals <= 11'b001_0000_0000;
				else 
					enable_signals <= 11'b000_0000_0000;
				end
			Iw: begin 
				opcodebit <= 0; 
					psrbit <= 1;
					
				if(conditional & opcode == 4'b1100)
				begin 
					enable_signals <= {7'b001_0110, ALU_decoded};
					end
				else //do typical I write 
				begin
					enable_signals <= {7'b010_0010, ALU_decoded}; 
					end
				end
			Rw: 
				begin 
				opcodebit <= 0;
					psrbit <= 1;
				enable_signals <= {7'b010_0000, ALU_decoded};
				end 
			// Increment the PC by one word
			PC:begin  //check if we are branch or jumping and true, then dont write
				opcodebit <= 0;
					psrbit <= 0;
				if(conditional)
					enable_signals <= 11'b000_0000_0000;
				else 
					enable_signals <= 11'b001_0101_0000;
				//otherwise we write 
				
			// Should never be reached
			end 
			default: begin opcodebit <= 0;
					psrbit <= 0; enable_signals <= 11'b000_1000_0000; end
	endcase

end


endmodule
