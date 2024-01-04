/*
	Original EXmem, swapped to a memory wrapped memory access with same base exmem module. 
*/
module exmem #(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10)
        (
	input [15:0] din1,
	input [15:0] din2,
	input [9:0] addr1,
	input [9:0] addr2,
	input wen1,wen2, clk,
	input [7:0] inputData,
	input [7:0] previousData,
	input inputDataClk,
	output [15:0] dout1,
	output [15:0] dout2,
	output [319:0] bitMap, 
	output [15:0] keyPress
        );

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0]; 

	// Variable to hold the read address
	reg [ADDR_WIDTH-1:0] addr_reg1;
	reg [ADDR_WIDTH-1:0] addr_reg2;
	integer i;
	initial
	begin
	// Fill memory with zeros.
//	begin
//		for(i=0;i<1024;i=i+1)
//			begin
//				ram[i] = 16'b0000000000000000; 
//			end
//	Test Program for test bench
//		ram[0]  = 16'h0251; //add r1, r2  R type instruction 8 cycles 
//		ram[1]  = 16'h5205; //addi 5, r2 8 cycles 
//		ram[2]  = 16'h0293; //sub r3, r2 8 cycles 
//		ram[3]  = 16'h9305; //subi 5, r3 8 cycles 
//		ram[4]  = 16'h04b3; // cmp r3, r4 ... r4 = orignal r4 and r3 == original r3 8 cycles 
//		ram[5]  = 16'hb405; //cmpi 5, r4 8 cycles 
//		ram[6]  = 16'h0111; //and r1, r1 8 cycles 
//		ram[7]  = 16'h1302; //andi 2, r3 8 cycles 
//		ram[8]  = 16'h0221; //or r1, r2 8 cycles 
//		ram[9]  = 16'h2101; //ori 1, r1 8 cycles 
//		ram[10] = 16'h0232; // xor r2, r2 8 cycles 
//		ram[11] = 16'h3302; //xori 2, r3 8 cycles 
//		ram[12] = 16'h03d1; // move r1, r3 8 cycles 
//		ram[13] = 16'hd201; // movi 1, r2 8 cycles 
//		ram[14] = 16'h8742; // lsh r2, r7 8 cycles 
//		ram[15] = 16'h8701; // lshi 1, r7 8 cycles 
//		ram[16] = 16'hf7ff; //lui 255, r7 8 cycles 
//		ram[17] = 16'hd97f; //movi 255 into r9 8 cycles 
//		ram[18] = 16'h4549; // store value in 5,(5) into address of r9(255) 8 cycles 
//		ram[19] = 16'h4709; //load value in addres r9(255) into register 7, this value should be 5 8 cycles 
//		ram[20] = 16'h1300; //andi 0, r3 8 cycles 
//		ram[21] = 16'h1200; //andi 0, r2 8 cycles 
//		ram[22] = 16'h02b3; // cmp r2, r3 8 cycles 
//		ram[23] = 16'hc002; //beq 2 8 cycles 
//		ram[24] = 16'h1100; //random instruction or instruction, should never execute 
//		ram[25] = 16'h1100; //Same as comment above
//		ram[26] = 16'h1400; //andi 0, r4; 8 cycles 
//		ram[27] = 16'h541e; //addi 30, r4 8 cycles 
//		ram[28] = 16'h40c4; //jeq r4; 7 cycles 
//		ram[29] = 16'h1100; //random instruction or instruction, should never execute
//		ram[30] = 16'h4184; //JAL r1, r4, jump to r4 and put next pc value into r1 7 cycles
		$display("Loading program file");
		$readmemh("C:/Users/samwi/Desktop/ECE3710/checkInput2.dat", ram);
		$display("done with program load");
	end
	
	always @ (negedge clk) begin
		  if(inputDataClk == 1)
					ram[1023] <= {8'h00, inputData}; 
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
	assign keyPress = ram[1023];
	assign bitMap = {ram[1022], ram[1021], ram[1020], ram[1019], ram[1018], ram[1017], ram[1016], ram[1015], ram[1014]
	, ram[1013], ram[1012], ram[1011], ram[1010], ram[1009], ram[1008], ram[1007], ram[1006], ram[1005], ram[1004],
	ram[1003]};
endmodule // exmem

