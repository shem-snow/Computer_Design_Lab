/*
  Testbench for the exmem.v file: Our only goal when writing this was to determine whether or not our file is able to write to the LEDs.
*/
`timescale 1ps/1ps
module tb_exmem();

  reg clk;
  reg [7:0] switches;
  reg [7:0] data;
  reg [7:0] addr;
  reg wen;
  
  //outputs from the DUT
  wire [7:0] LEDs;
  wire [7:0] q;

  
  //instantiate the external memory.
  exmem UUT (switches, data, addr, wen, clk, q, LEDs);
	
  // oscillate the clock.
  always #5 begin clk = ~clk; end
  	
  initial begin
  
    // Pick some random inputs, and see if they appear at the outputs. 	
    switches = 8'b00000000;
    data = 8'b00010100;
    addr = 8'b11010100;
    clk = 1'b0;
    wen = 1'b1;

    $display("stimulus = %b\tresponse = %b\tenable = %b", stimulus, response, enable);
  end
	
endmodule
