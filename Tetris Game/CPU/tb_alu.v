
module tb_alu;
  // inputs to the ALU (Device Under Test)
	 reg [15:0] a, b;
	 reg [3:0] alucode;
  //outputs from the ALU
	 wire [15:0] result;
	 wire [4:0] flags;
   
  
  //instantiate the hex to 7seg circuit
  Alu toaster (.a(a), .b(b), .alucode(alucode), .result(result), .flags(flags));
					
  // Generate the inputs, and check the outputs. 		
  initial begin
  #10 //add 
  a = 4'h0003;
  b = 4'h0001;
  alucode = 4'b0000; // Output should be 4
  $display("result:%b",result);
  
  #40 //sub
  a = 4'h0003;
  b = 4'h0001;
  alucode = 4'b0001; // Output should be 2
    $display("result:%b",result);
  
  #40 //cmp
  a = 4'h0003;
  b = 4'h0004;
  alucode = 4'b0010; // Output is 5'b00011 as a < b
    $display("flags:%b",flags);
	 
  #40 //cmp
  a = 4'h0001;
  b = 4'h0001;
  alucode = 4'b0010; // Output is 5'b10000 as a = b
    $display("flags:%b",flags);
  
  #40 //cmp
  a = 4'h0003;
  b = 4'h0001;
  alucode = 4'b0010; // Output is 5'b00000 as a > b
    $display("flags:%b",flags);
	 
  #40 //AND
  a = 4'h0001;
  b = 4'h0001;
  alucode = 4'b0011; // Output should be 1, as it's true
    $display("result:%b",result);
	 
  #40 //AND
  a = 4'h0000;
  b = 4'h0001;
  alucode = 4'b0011; // Output should be 0, as it's false
    $display("result:%b",result);
	 
  #40 //OR
  a = 4'h0001;
  b = 4'h0000;
  alucode = 4'b0100; // Output should be 1 as it's true
    $display("result:%b",result);
	 
  #40 //OR
  a = 4'h0000;
  b = 4'h0000;
  alucode = 4'b0100; // Output should be 0 as it's true
    
  #40 //XOR
  a = 4'h0001;
  b = 4'h0000;
  alucode = 4'b0101; // Output should be 1 as it's true
  
  #40 //XOR
  a = 4'h0001;
  b = 4'h0001;
  alucode = 4'b0101; // Output should be 0 as it's true
  
  #40 //LSH
  a = 4'b0101;
  b = 4'b0010;
  alucode = 4'b0110; // Output should be 4'b0100 as it's shifts by two
   
  #40 //LUI
  a = 16'h0f0f;
  b = 16'hFFFF;
  alucode = 4'b0111; // Output should be 16'h0000 
  
  #40 //Default
  a = 4'b0001;       // Ouput is 1 as result <= a
   
  $display("result:%b",result);
  
  
  

  end
	
endmodule
