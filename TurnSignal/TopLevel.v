module TopLevel(
	input [3:0] push_buttons, 
	input fast_clock,
	output [5:0] lights
	);
	
// Driven wires
wire slow_clock;
	
// instantiate each module ( .inside(outside) )
MyClockDivider clockDiv(.clock_in(fast_clock), .clock_out(slow_clock));
FSM fsm(.clock(fast_clock), .enable(slow_clock), .stimulus(push_buttons), .response(lights));
	
endmodule