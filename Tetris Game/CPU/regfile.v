/* The register file is 16 bits wide, and 16 registers deep.
* 
* r0 = 0
* r1-14 are programable
* r15 = PC
*
* This will likely get compiled into a block RAM by 
* Quartus, so it can be initialized with a $readmemb function.
* In this case, all the values in the ram.dat file are 0
* to clear the registers to 0 on initialization
*/
module regfile #(parameter WIDTH = 16, REGBITS = 4)
                (input                clk,
                 input                regwrite, pc_wr,
                 input  [REGBITS-1:0] ra1, ra2,
                 input  [WIDTH-1:0]   writedata,
                 output reg [WIDTH-1:0]   rsrc, rtgt,
					  output  [WIDTH-1:0] pc);

   reg  [15:0] regs [15:0];
	
	initial begin
		$display("Loading register file");
		$readmemb("C:/Users/samwi/Desktop/ECE3710/reg.dat", regs); 
		$display("done with RF load"); 
	end
assign pc = regs[4'b1111];
   // On the positive clock edge, drive the specified registers to the outputs
   always @(posedge clk) begin
      rtgt <= regs[ra1];
		rsrc <= regs[ra2];
		
	end
	
	// On the negative clock edge, updata rdest (encoded by ra2) if "regwrite" is active.
	// Also update the pc if "pc_wr" is active.
	always@(posedge clk) begin
		if (regwrite) regs[ra2] <= writedata;
		if (pc_wr) regs[4'b1111] <= writedata;
	end
	
	
endmodule
