// This module uses the build in 50 MHz clock present on our DE10-Lite boards to implement a 1 Hz clock we 
// call "slowClock". To do this, simply use an accumulating variable ("accumulator") to track whenever 
// 1 Hertz has elapsed, then toggle the "slowClock" signal, and finally reset "accumulator" back to zero.
// Repeat forever but only on the positive edges of the clock.
module MyClockDivider(input clock_in, output reg clock_out);

reg [31:0] accumulator = 0;
reg started = 1'b0;

always@(posedge clock_in)
	begin
		if(started == 1'b0)
			begin
				started = 1'b1;
			end
		else
			begin
				if(accumulator == 12_000_000)
					begin
						accumulator = 0;
						clock_out = ~clock_out;
					end
				else
					begin
						accumulator = accumulator + 1;
					end
				end
	end
endmodule