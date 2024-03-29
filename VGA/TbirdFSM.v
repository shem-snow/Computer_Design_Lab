/*
	This FSM uses the "Three Process Methodology" for FSM design which just means that it 
	separates all the logic into three concerns.
	
	1: Next state prediction
	2: State Progression
	3: Output driving
*/
module TbirdFSM(
	input clock, // The fast clock from the board
	input enable, // The slow clock/enable signal
	input [3:0] buttons,
	output reg [5:0] LEDs
	);

// button encodings
parameter HAZARD = 4'b1011;
parameter LEFT = 4'b0111;
parameter RIGHT = 4'b1110;
parameter RESET = 4'b1101;


// State encodings
parameter s0 = 3'b000; // three left lights	6'b111_000
parameter s1 = 3'b001; // two left lights		6'b011_000
parameter s2 = 3'b010; // one left light		6'b001_000

parameter s3 = 3'b011; // three right lights	6'b000_111
parameter s4 = 3'b100; // two right lights	6'b000_110
parameter s5 = 3'b101; // one right light		6'b000_100

parameter s6 = 3'b110; // all lights on		6'b111_111
parameter s7 = 3'b111; // all lights off		6'b000_000


// Local memory
reg [2:0] current_state;
reg [2:0] next_state;
reg [2:0] unclocked_next_state;

// Concern 1: Next state prediction.
always@(*) begin
	
	case(buttons)
		
		// If hazard is active, alternate between all lights on (s6) and off (s7).
		HAZARD:
			unclocked_next_state <= (current_state == s6)? s7: s6;
		
		// Start or progress through the left-signal process.
		LEFT: begin
			if(current_state == s0)
				unclocked_next_state <= s7;
			else if(current_state == s1)
				unclocked_next_state <= s0;
			else if(current_state == s2)
				unclocked_next_state <= s1;
			else
				unclocked_next_state <= s2;
		end
	
		// Start or progress through the right-signal process.
		RIGHT: begin
			if(current_state == s3)
				unclocked_next_state <= s7;
			else if(current_state == s4)
				unclocked_next_state <= s3;
			else if(current_state == s5)
				unclocked_next_state <= s4;
			else
				unclocked_next_state <= s5;
		end
		
		// When reset is triggered.
		RESET:
			unclocked_next_state <= s7;
		
		// Let other states default to a latch.
		default: begin
			if(current_state == s2)
				unclocked_next_state <= s1;
			else if(current_state == s1)
				unclocked_next_state <= s0;
			else if(current_state == s0)
				unclocked_next_state <= s7;
			else if(current_state == s5)
				unclocked_next_state <= s4;
			else if(current_state == s4)
				unclocked_next_state <= s3;
			else if(current_state == s3)
				unclocked_next_state <= s7;
			else if(current_state != s7)
				unclocked_next_state <= s7;
		end
	endcase
end

// Concern 2: State progression.
always@(posedge enable) begin
	next_state <= unclocked_next_state;
end
always@(negedge enable, negedge buttons[1]) begin
	current_state <= (!buttons[1])? s7 : next_state;
end


// Concern 3: output driving.
always@(current_state) begin
		case(current_state)
			s0:	LEDs <= 6'b111_000;
			s1:	LEDs <= 6'b011_000;
			s2:	LEDs <= 6'b001_000;
			s3:	LEDs <= 6'b000_111;
			s4:	LEDs <= 6'b000_110;
			s5:	LEDs <= 6'b000_100;
			s6:	LEDs <= 6'b111_111;
			default:	LEDs <= 6'b000_000;
		endcase
end

endmodule