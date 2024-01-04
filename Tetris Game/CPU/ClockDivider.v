/* This module receives a fast clock and returns a slow clock signal. To do this, use an accumulating variable 
 that counts how often the fast clock cycles then after some hard-coded amount of time has elapsed, 
 toggle the slowclock signal and reset "accumulator" back to zero.
*/
module ClockDivider(input clock_in, output reg clock_out);

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