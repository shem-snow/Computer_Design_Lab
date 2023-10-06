
module tb_mips;
  // inputs to the DUT (Device Under Test)
  reg clk, rst;
  reg [7:0] switches;
  //outputs from the DUT
  wire [7:0] leds;

  
  //instantiate the hex to 7seg circuit
  mips UUT (.clk(clk), .rst(rst), .leds(leds), .switches(switches)
                         );
					
always #5 begin clk = ~clk; end
  // Generate the inputs, and check the outputs. 		
  initial begin
  switches = 8'b00000000;
  clk = 1'b0;
  rst = 1'b0; 
  #40
  rst = 1'b1;
  
  #150
  switches = 8'b00000011;
  end
	
endmodule
