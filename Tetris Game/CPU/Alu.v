module Alu #(parameter WIDTH = 16)(
	 input [WIDTH-1:0] a, b,
	 input [3:0] alucode,
	 input status,
	 output reg [WIDTH-1:0] result,
	 output reg [4:0] flags
);

	 
//	 reg [WIDTH-1:0] memory [0:65535]; // Assuming 16-bit data and 64K (65536) memory locations	 
//	 Why is this here ^ 
//           4 3 2 1 0
// PSR ===== C L F Z N
	 always @(*)
		 case (alucode)
		 		4'b0000: begin 
							result <= a + b;
							flags <= 5'b00000;
							end		// Reg ADD
				4'b0001: begin
							result <= b - a;
							flags <= 5'b00000;
							end// Reg SUB
				4'b0010:						  // Reg CMP
					begin
						result <= a;
					   flags[0] <= ($signed(b) < $signed(a)) ?  1'b1 :  1'b0;
						flags[1] <= a == b ?  1'b1 :  1'b0; 
						flags[2] <=(b[15] ^ a[15] && b[15] != 0)  ?  1'b1 :  1'b0;
						flags[3] <= b < a ?  1'b1 :  1'b0;
						flags[4] <= b < a ? 1'b1 :  1'b0;
					end
				4'b0011: begin
							result <= a & b;	
							flags <= 5'b00000;
							end		// Reg AND
							
				4'b0100: begin
							result <= a | b;		
							flags <= 5'b00000;
							end		// Reg OR
							
				4'b0101: begin 
							result <= a ^ b;		
							flags <= 5'b00000;
							end			// Reg XOR
							
				//4'b0110: result <= (a <= b);	// Reg MOV -- this just becomes default as move
				4'b0110: begin 
						flags<= 5'b00000;
						case(a[15])           
									1: result <= b >> (~a + 1'b1);
									0: result <= b  << a;
									endcase
						end 		   // Reg LSH
						
				4'b0111: begin
							result <= {a[7:0], b[7:0]};
							flags <= 5'b00000;
							end// LUI
				
				4'b1000:                             //JCond
			   begin	
						flags<= 5'b00000;
						case(status)           
							1: result <= a;
							0: result <= b + 1'b1;
						endcase 
				end 
				
			   4'b1001: 
				begin 
							flags<= 5'b00000;
							case(status)
							1: result <= b + a + 1'b1;
							0: result <= b + 1'b1;
							endcase
				end
				default: begin
				flags<= 5'b00000;
				result <= a; 				// Checks(everything else that just returns a)
				end
//				4'b1001: result <= a; // Load
//				4'b1010:							 // Store
//					begin
//						  // Store the value 'b' into memory at address 'a'
//				        a <= b;
//						  // Indicate a successful store operation
//						  result <= 16'b0000000000000000;
//					end
//				4'b1011:
//					begin									// BCond
//						if (a==1) // Replace 'condition' with your actual condition
//						  result <= result + b; //Branch taken
//						else
//						  result <= result + 1; // Branch not taken
//						end
//				4'b1100:						   // JCond
//						begin
//						if () //Replace 'condition' with your actual condition
//							result <= b; //Jump taken
//						else
//							result <= a; // Jump not taken
//						end
//				4'b1101:							// JAL
//					   begin
//						  // Save the address of the next instruction into the link register (R31)
//						  // Assuming that you have a dedicated link register (R31), you can do something like this:
//						  result <= a + 1; // Save the address of the next instruction				  
						//end
			endcase
endmodule