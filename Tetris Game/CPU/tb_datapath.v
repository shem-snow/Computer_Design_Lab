
module tb_datapath;
  // inputs to the ALU (Device Under Test)
	 reg [3:0] opcode;
	 reg [15:0] addr1, addr2;
	 reg wr;
  //outputs from the ALU
	 wire [4:0] psr;
	 wire [15:0] alu_result;
   
  
  //instantiate the hex to 7seg circuit
  datapath forest (.opcode(opcode), .addr1(addr1), .addr2(addr2), .wr(wr), .psr(psr), .alu_result(alu_result));
					
  // Generate the inputs, and check the outputs. 		
  initial begin
	 // ADD
    opcode = 4'b0000;  // some operation code
    addr1  = 16'b0000000000000010;  // some address for register 1
    addr2  = 16'b0000000000000011;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);

	 // SUB. 		
    opcode = 4'b0001;  // some operation code
    addr1  = 16'b0000000000000011;  // some address for register 1
    addr2  = 16'b0000000000000010;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);
	 
	 // CMP. // Flags is 5'b10000 		
    opcode = 4'b0010;  // some operation code
    addr1  = 16'b0000000000000001;  // some address for register 1
    addr2  = 16'b0000000000000001;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);
	 
	 // AND. 		
    opcode = 4'b0011;  // some operation code
    addr1  = 16'b0000000000000001;  // some address for register 1
    addr2  = 16'b0000000000000001;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result); 

	 // OR. 		
    opcode = 16'b0100;  // some operation code
    addr1  = 16'b0000000000000001;  // some address for register 1
    addr2  = 16'b0000000000000000;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);

	 // XOR. 		
    opcode = 4'b0101;  // some operation code
    addr1  = 16'b0000000000000001;  // some address for register 1
    addr2  = 16'b0000000000000001;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);

	 // LSH. 		// Output is 4'b1000
    opcode = 4'b0110;  // some operation code
    addr1  = 16'b0000000000000100;  // some address for register 1
    addr2  = 16'b0000000000000001;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);

	 // LUI. 		
    opcode = 4'b0111;  // some operation code
    addr1  = 16'h0f0f;  // some address for register 1
    addr2  = 16'hFFFF;  // some address for register 2
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);

	 // Default
    addr1  = 16'b0000000000000001;  // some address for register 1
    wr     = 1'b1;     // some write enable signal

    // Wait for some time to see the change in simulation
    #50;
    
    // Read and display the outputs
    $display("PSR: %b, ALU Result: %h", psr, alu_result);

  end
  
  
	
endmodule
