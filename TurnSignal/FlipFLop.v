/**
* This is a flip-flop module that creates a DFF of the specified "size" parameter
*/
module FlipFLop(
    input wire clk,  // Clock signal
	 input wire enable,
    input wire reset,  // Reset signal (active-low)
    input wire [2:0] d,  // Data input
    output reg [2:0] q   // Data output
);

// Flip-flop behavior
always @(posedge clk, negedge reset) begin
    if (reset == 1'b0)
		q <= 3'b111;  // If reset, output 0
    else if(enable)
		q <= d;  // Otherwise, output the data input
end

endmodule