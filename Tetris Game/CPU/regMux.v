/*
	Simple 2 input mux
*/
module regMux #(parameter WIDTH = 16, REGBITS = 4)
					(input [15:0] in1, in2,
					 input control, 	// 0 pushes in1 and 1 pushes in2.
					 output reg [15:0] out
);
 
always@(*)
begin

if(control == 0) out <= in1;
else  			  out <= in2;

end


endmodule