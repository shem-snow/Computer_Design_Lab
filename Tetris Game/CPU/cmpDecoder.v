// Module named 'Decoder' is declared here with input and output ports
module cmpDecoder(
    input wire [15:0] instruction,  // 8-bit input named 'a'
	 input wire [4:0] psr,
    output reg jump  // 1 == jump ;;;; 0 == no jump
);
//           4 3 2 1 0
// PSR ===== C L F Z N

// ALU opcode decoding
always@(*) begin
	if(instruction[15:12] == 4'b1100 || ((instruction[15:12] == 4'b0100) && (instruction[7:4] == 4'b1100))) //in jump or branch conditional op codes
	case(instruction[11:8])
			4'b0000: jump <= psr[1] ? 1'b1 : 1'b0; //equal
			4'b0001: jump <= ~psr[1]? 1'b1 : 1'b0 ; //not equal
			
			4'b1101: jump <= (psr[0] | psr[1]) ? 1'b1 : 1'b0; //   >=
			
			4'b0010:  jump <= (psr[4]) ? 1'b1 : 1'b0; //carry set
			4'b0011: jump <= (~psr[4]) ? 1'b1 : 1'b0; //carry clear
			
			4'b0100: jump <= (psr[3]) ? 1'b1 : 1'b0; //higher than
			4'b0101: jump <= (~psr[3]) ? 1'b1 : 1'b0; // lower than/ same as
			
			4'b1010: jump <= (~psr[3] & ~psr[1]) ? 1'b1 : 1'b0; //lower than
			4'b1011: jump <= (psr[3] | psr[1]) ? 1'b1 : 1'b0; //higher than // same as
			
			4'b0110: jump <= (psr[0]) ? 1'b1 : 1'b0; //greater than
			4'b0111: jump <= (~psr[0]) ? 1'b1 : 1'b0; // less than or equal
			
			4'b1000: jump <= (psr[2]) ? 1'b1 : 1'b0; //flag set
			4'b1001: jump <= (~psr[2]) ? 1'b1 : 1'b0; //flag clear
			
			4'b1100: jump <= (~psr[1] & ~psr[0]) ? 1'b1 : 1'b0; //less than 
			4'b1110: jump <= 1'b1; // unconditional
			
			default:  jump <= 1'b0; // Should never get here.
		
	endcase
	else
		jump <= 1'b0;
end

endmodule
