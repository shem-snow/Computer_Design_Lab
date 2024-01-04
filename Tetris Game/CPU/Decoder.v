// Module named 'Decoder' is declared here with input and output ports
module Decoder(
    input [7:0] opcode,  // 8-bit input named 'a'
    output reg [3:0] alucode  // 4-bit output named 'y'
);

// ALU opcode decoding
always@(*) begin
	
	casex(opcode)
	
		8'b00000101: alucode <= 4'b0000; //add
		8'b0101xxxx: alucode <= 4'b0000;
		
		8'b00001001: alucode <= 4'b0001; //sub
		8'b1001xxxx: alucode <= 4'b0001;
		
		8'b00001011: alucode <= 4'b0010; //cmp
		8'b1011xxxx: alucode <= 4'b0010;
		
		8'b00000001: alucode <= 4'b0011; //and
		8'b0001xxxx: alucode <= 4'b0011;
		
		8'b00000010: alucode <= 4'b0100; //or
		8'b0010xxxx: alucode <= 4'b0100;
		
		8'b00000011: alucode <= 4'b0101; //xor
		8'b0011xxxx: alucode <= 4'b0101;
		
		8'b00000100: alucode <= 4'b0110; //lsh
		8'b1000xxxx: alucode <= 4'b0110;
		
		8'b1111xxxx: alucode <= 4'b0111; //lui
		8'b1100xxxx: alucode <= 4'b1001; //branch condition
		8'b01001100: alucode <= 4'b1000; //jump condition
		
		default:  alucode <= 4'b1111; // Should never get here.
		
	endcase
	
end

endmodule
