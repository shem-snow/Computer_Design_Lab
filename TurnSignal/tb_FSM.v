module tb_FSM();

	// Define and initialize the inputs and outputs.
	reg clock;
	reg enable;
	reg [3:0] stimulus;
	wire [5:0] response;
	
	// Instantiate the FSM
	FSM UUT(.clock(clock), .enable(enable), .stimulus(stimulus), .response(response));
	
	// Always oscillate the clock and display the state
	initial begin
		
		clock = 1'b0;
		forever begin
			#5	clock = ~clock;
			$display("stimulus = %b\tresponse = %b\tenable = %b", stimulus, response, enable);
		end
	end
	
	initial begin
		// it takes four times the clock cycle time to progress through each state change.
		enable = 1'b1;
		forever #20 enable = ~enable;
	end
	
	
	// Progress through each sequence by setting setting input and waiting sufficient time for them to pass.
	// The enable toggles every 20 ps so run twice as long to show that the machine does not progress when the
	// enable signal is low.
	initial begin
		
		// Reset
		stimulus = 4'b1101;
		
		// Hazard
		#40 stimulus = 4'b1011;
		
		// Left turn
		#60 stimulus = 4'b0111;
		
		// Right turn
		#240  stimulus = 4'b1110;
		
		// No input
		#240 stimulus = 4'b1111;
	end
endmodule