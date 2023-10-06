module FSM(
	input clock,
	input enable,
	input [3:0] stimulus,
	output reg [5:0] response
	);

// Stimulus encodings
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
wire [2:0] next_state;
reg [2:0] unclocked_next_state;


// Instantiate a flip flop that holds the next state's value
FlipFLop dff(.clk(clock), .enable(enable), .reset(stimulus[1]), .d(unclocked_next_state), .q(next_state));

// always determine what the next state should be.
always@(*) begin
	
	case(stimulus)
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

// Always calculate the response/output for the current state (it's just a direct mapping).
always@(current_state) begin
		case(current_state)
			s0:	response <= 6'b111_000;
			s1:	response <= 6'b011_000;
			s2:	response <= 6'b001_000;
			s3:	response <= 6'b000_111;
			s4:	response <= 6'b000_110;
			s5:	response <= 6'b000_100;
			s6:	response <= 6'b111_111;
			s7:	response <= 6'b000_000;
		endcase
end

// Always progress to the next state.
always@(negedge enable, negedge stimulus[1]) begin
	if(!stimulus[1])
		current_state <= s7;
	else
		current_state <= next_state;
end
	
endmodule