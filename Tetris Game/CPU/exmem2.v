/*
Two port read and write memory 
*/
module exmem2 #(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10)
        (
	input [15:0] din1,
	input [15:0] din2,
	input [9:0] addr1,
	input [9:0] addr2,
	input wen1,wen2, clk,

	output [15:0] dout1,
	output [15:0] dout2
        );

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0]; 

	// Variable to hold the read address
	reg [ADDR_WIDTH-1:0] addr_reg1;
	reg [ADDR_WIDTH-1:0] addr_reg2;
	
	initial
	begin
	//load ram 
		$display("Loading program file");
		$readmemh("C:/Users/samwi/Desktop/ECE3710/Assembly/test.dat", ram);
		$display("done with program load");
	end
	
	always @ (negedge clk) begin
		  if (wen2) begin
				 ram[addr2] <= din2;
				 end
			if (wen1) begin
				 ram[addr1] <= din1;
				 end
		addr_reg2 <= addr2;
		addr_reg1 <= addr1;
		
	end
	// Continuous assignment implies read returns NEW data
	assign dout1 =  ram[addr_reg1];
	assign dout2 =  ram[addr_reg2];
	
endmodule // exmem

