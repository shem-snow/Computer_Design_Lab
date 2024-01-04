//Three way mux. 
module threeMux #(parameter WIDTH = 16, REGBITS = 4)
					(input [15:0] in1, in2, in3,
					 input [1:0] control, 	// 0 pushes in1 and 1 pushes in2 and 2 pushes in3.
					 output reg [15:0] out
);
 
always@(*)
begin

if(control == 2'b00) out <= in1;
else if(control == 2'b01) out <= in2;
else if(control == 2'b10) out <= in3;
else out <= 4'bzzzz;

end



endmodule
