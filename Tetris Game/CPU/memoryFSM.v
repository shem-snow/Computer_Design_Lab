/*
	Memory fsm used to test the Data path and memory interaction. 
*/
module memoryFSM(input clk, reset, output  [3:0] LED1, output [3:0] LED2, output [15:0] dout1, output [15:0] dout2);

 reg [3:0] state, nextstate;       // state register and nextstate value
 wire slow_clk;
 reg [15:0] din1; reg [15:0] din2 ;reg  [9:0] addr1; reg [9:0] addr2; reg [3:0] switches1; reg [3:0]switches2;
 reg wen1, wen2;
 Clock_divider	divider( .clock_in(clk), .clock_out(slow_clk));
 
 exmem memory(
	din1,din2,addr1,addr2, wen1,wen2, slow_clk, dout1,dout2);
 
 always @(posedge slow_clk)
      if(~reset) state <= start;
      else state <= nextstate;
		
	parameter   start  =  2'b00;
	parameter   start2  =  2'b01;
	parameter   start3  =  2'b10;

	always @(*)
      begin
         case(state)
				start: nextstate <=start2;
				start2: nextstate <= start3;
				start3: nextstate <= start;
         endcase
      end		
always @(*)
	begin
		case(state)
				start: 
					begin
					wen1 <= 0; 
					wen2 <= 0;
					din1 <= 16'h0000;
					din2 <= 16'h0000;
					addr1 <= 10'h000;
					addr2 <= 10'h001;
					switches1 <= 4'b0000;
					switches2 <= 4'b0000;
					end
				start2: 
					begin
					wen1 <= 1; 
					wen2 <= 1;
					din1 <= 16'h0004;
					din2 <= 16'h0002;
					addr1 <= 10'h000;
					addr2 <= 10'h001;
					end
				start3: 
					begin
					wen1 <= 0; 
					wen2 <= 0;	
					din1 <= 16'h0004;
					din2 <= 16'h0002;
					addr1 <= 10'h000;
					addr2 <= 10'h001;
					end
			endcase
		end
endmodule

// fpga4student.com: FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Top level Verilog code for clock divider on FPGA
module Clock_divider(clock_in,clock_out
    );
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd2;
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(28'd50000000-1))
  counter <= 28'd0;
 clock_out <= (counter<28'd50000000/2)?1'b1:1'b0;
end
endmodule