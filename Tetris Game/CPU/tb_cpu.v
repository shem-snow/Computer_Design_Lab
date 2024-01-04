/*
	Automatic self checking test bench. It requires the program in the exmem module to be hard coded, and the regfile to be hard coded to values.
	i.E r1 = 1, r2 =2, all the way up to r9. 
*/
`timescale 1ps/1ps 
module tb_cpu;
reg clock;
reg reset;
reg  PS2Clk, PS2Data;
wire VGA_HS, VGA_VS, VGA_CLK, VGA_SYNC_N, VGA_BLANK_N;
wire [7:0]VGA_R;
wire [7:0]VGA_G;
wire [7:0]VGA_B;
cpu uut( clock,  reset,  PS2Clk,  PS2Data, 	  VGA_HS,
	  VGA_VS,
	  VGA_CLK,
	  VGA_SYNC_N,
	  VGA_BLANK_N, 
	
	   VGA_R,
	   VGA_G,
	  VGA_B);


always #1 begin clock = ~clock; end
  initial begin 
	clock = 0;
	reset = 0;
	PS2Clk = 0;
	PS2Data = 0;
	#2
	reset = 1;
	#16
	$display("state, %5b", uut.FSM.current_state);
		if(uut.datapath.regfile.regs[15] == 2'h01 &&  uut.datapath.regfile.regs[2] == 2'h03)
		$display("pass add r1,r2: ");
	else
		$display("fail add r1, r2: result was %4h, pc: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);
	 //addi 5, r2 8 cycles 
	 #16
	 	if(uut.datapath.regfile.regs[15] == 16'h02 &&  uut.datapath.regfile.regs[2] == 16'h08)
		$display("pass addi 5,r2");
	else
		$display("fail addi 5, r2: result was %16h , PC: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);
	
	//sub r3, r2 8 cycles, r2 = 8 r3 = 3 
		#16
	 	if(uut.datapath.regfile.regs[15] == 16'h03 &&  uut.datapath.regfile.regs[2] == 16'h05)
		$display("pass sub r3,r2");
	else
		$display("fail sub r3,r2: result was %16h , PC: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);

	//subi 5, r3 8 cycles 
	#16
	 	if(uut.datapath.regfile.regs[15] == 16'h04 &&   uut.datapath.regfile.regs[3] == 16'b1111111111111110)
		$display("pass subi 5, r3");
	else
		$display("fail subi 5, r3: current status registers was %16h , PC: %4h", uut.datapath.regfile.regs[3], uut.datapath.regfile.regs[15]);

	// cmp r3, r4 ... r4 = orignal r4 and r3 == -2 r3 8 cycles 
		#16
	 	if(uut.datapath.regfile.regs[15] == 16'h05 && uut.statusRegisters == 5'b11000)//find out this status registers
		$display("pass cmp r3, r4");
			else 
		$display("fail cmp r3, r4: result was %5b , PC: %4h", uut.statusRegisters, uut.datapath.regfile.regs[15]);

	//cmpi 5, r4 8 cycles 
	#16
	if(uut.datapath.regfile.regs[15] == 16'h06 && uut.statusRegisters == 5'b11001) // status registers 
	$display("pass cmpi 5, r4 8");
		else 
	$display("fail cmpi 5, r4 8: result was %15b , PC:%4h ", uut.statusRegisters, uut.datapath.regfile.regs[15]);

	//and r1, r1 8 cycles 
	#16
		if(uut.datapath.regfile.regs[15] == 16'h07 && uut.datapath.regfile.regs[1] == 16'h0001) // status registers 
	$display("pass and r1, r1");
		else 
	$display("fail and r1, r1: result was %16h , PC: %4h", uut.datapath.regfile.regs[1], uut.datapath.regfile.regs[15]);

	//andi 2, r3 8 cycles 
		#16
		if(uut.datapath.regfile.regs[15] == 16'h08 && uut.datapath.regfile.regs[3] == 16'h0002) // status registers 
	$display("pass andi 2, r3");
		else 
	$display("fail andi 2, r3: result was %16h , PC: %4h", uut.datapath.regfile.regs[3], uut.datapath.regfile.regs[15]);

	//or r1, r2 8 cycles R2 == 5 r1 == 1 101, 001
	#16
		if(uut.datapath.regfile.regs[15] == 16'h09 && uut.datapath.regfile.regs[2] == 16'h0005) // status registers 
	$display("pass or r1, r2");
		else 
	$display("fail or r1, r2: result was %16h , PC: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);

	//ori 1, r1 8 cycles 
	#16
		if(uut.datapath.regfile.regs[15] == 16'h0a && uut.datapath.regfile.regs[1] == 16'h0001) // status registers 
	$display("pass ori 1, r1 ");
		else 
	$display("fail ori 1, r1: result was %16h , PC: %4h", uut.datapath.regfile.regs[1], uut.datapath.regfile.regs[15]);

	 // xor r2, r2 8 cycles 
		#16
		if(uut.datapath.regfile.regs[15] == 16'h0b && uut.datapath.regfile.regs[2] == 16'h0000) // status registers 
		$display("pass xor r2, r2");
			else 
		$display("fail xor r2, r2: result was %16h , PC: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);

	 //xori 2, r3 8 cycles  R3 = 2, 2 
	 	#16
		if(uut.datapath.regfile.regs[15] == 16'h0c && uut.datapath.regfile.regs[3] == 16'h0000) // status registers 
		$display("pass xori 2, r3");
			else 
		$display("fail xori 2, r3: result was %16h , PC: %4h", uut.datapath.regfile.regs[3], uut.datapath.regfile.regs[15]);

	 // move r1, r3 8 cycles 
		#16
		if(uut.datapath.regfile.regs[15] == 16'h0d && uut.datapath.regfile.regs[3] == 16'h0001) // status registers 
		$display("pass move r1, r3");
			else 
		$display("fail move r1, r3: result was %16h , PC: %4h", uut.datapath.regfile.regs[3], uut.datapath.regfile.regs[15]);

	 // movi 1, r2 8 cycles 	
	 #16
		if(uut.datapath.regfile.regs[15] == 16'h0e && uut.datapath.regfile.regs[2] == 16'h0001) // status registers 
		$display("pass movi 1, r2");
			else 
		$display("fail movi 1, r2: result was %16h , PC: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);

	 // lsh r2, r7 8 cycles r7 = 7 , r2 = 1 111 < 1, 1110 
	#16
		if(uut.datapath.regfile.regs[15] == 16'h0f && uut.datapath.regfile.regs[7] == 16'h000e) // status registers 
		$display("pass lsh r2, r7");
			else 
		$display("fail lsh r2, r7: result was %16h , PC: %4h", uut.datapath.regfile.regs[7], uut.datapath.regfile.regs[15]);

	 // lshi 1, r7 8 cycles 
	#16
		if(uut.datapath.regfile.regs[15] == 16'h10 && uut.datapath.regfile.regs[7] == 16'h001c) // status registers 
		$display("pass lshi 1, r7");
			else 
		$display("fail lshi 1, r7: result was %16h , PC: %4h", uut.datapath.regfile.regs[7], uut.datapath.regfile.regs[15]);

	//lui 255, r7 8 cycles 
	#16
		if(uut.datapath.regfile.regs[15] == 16'h11 && uut.datapath.regfile.regs[7] == 16'hff00) // status registers 
		$display("pass lui 255, r7");
			else 
		$display("fail lui 255, r7: result was %16h , PC: %4h", uut.datapath.regfile.regs[7], uut.datapath.regfile.regs[15]);

	 //movi 127, r9 8 cycles 
		#16
		if(uut.datapath.regfile.regs[15] == 16'h12 && uut.datapath.regfile.regs[9] == 16'h007f) // status registers 
		$display("pass movi, 127, r9");
			else 
		$display("fail movi, 127, r9: result was %16h , PC: %4h", uut.datapath.regfile.regs[9], uut.datapath.regfile.regs[15]);

	 // store value in 5,(5) into address of r9(127) 8 cycles stor r5, r9
		#16
		if(uut.datapath.regfile.regs[15] == 16'h13 && uut.exmem.ram[127] == 16'h0005) // status registers 
		$display("pass stor r5, r9");
			else 
		$display("fail stor r5, r9: memory at address r9 was %16h , PC: %4h", uut.exmem.ram[127], uut.datapath.regfile.regs[15]);

	 //load value in addres r9(127) into register 7, this value should be 5 8 cycles  load r7, r9
		#16
		if(uut.datapath.regfile.regs[15] == 16'h14 && uut.datapath.regfile.regs[7] == 127) // status registers 
		$display("pass load r7, r9");
			else 
		$display("fail load r7, r9: value loaded in register r7 was %16h , PC: %4h", uut.datapath.regfile.regs[7], uut.datapath.regfile.regs[15]);

	 //and 0, r3 8 cycles 
		#16
		if(uut.datapath.regfile.regs[15] == 16'h15 && uut.datapath.regfile.regs[3] == 16'h0000) // status registers 
		$display("pass and 0, r3");
			else 
		$display("fail and 0, r3: r3 is %16h , PC: %4h", uut.datapath.regfile.regs[3], uut.datapath.regfile.regs[15]);

	 //and 0, r2 8 cycles 
			#16
		if(uut.datapath.regfile.regs[15] == 16'h16 && uut.datapath.regfile.regs[2] == 16'h0000) // status registers 
		$display("pass and 0, r2");
			else 
		$display("fail and 0, r2: r2 is %16h , PC: %4h", uut.datapath.regfile.regs[2], uut.datapath.regfile.regs[15]);

	// cmp r2, r3 8 cycles 
			#16
		if(uut.datapath.regfile.regs[15] == 16'h17 &&  uut.statusRegisters == 5'b00010) // status registers 
		$display("pass cmp r2, r3");
			else 
		$display("fail cmp r2, r3: status register is %5b , PC: %4h",  uut.statusRegisters, uut.datapath.regfile.regs[15]);

	 //beq 2 8 cycles 
	#16
		if(uut.datapath.regfile.regs[15] == 16'h1a)  // status registers 
		$display("pass beq 2");
			else 
		$display("fail beq 2:  PC: %4h",  uut.datapath.regfile.regs[15]);

	//random instruction or instruction, should never execute 
	 //Same as comment above
	 //andi 0, r4; 8 cycles 
	 	#16
		if(uut.datapath.regfile.regs[15] == 16'h1b &&  uut.datapath.regfile.regs[4] == 16'h0000) // status registers 
		$display("pass andi 0, r4");
			else 
		$display("fail andi 0, r4: result is %16h , PC: %4h",   uut.datapath.regfile.regs[4], uut.datapath.regfile.regs[15]);

	 //addi 30, r4 8 cycles 
	 #16
		if(uut.datapath.regfile.regs[15] == 16'h1c &&  uut.datapath.regfile.regs[4] == 16'h001e) // status registers 
		$display("pass addi 30, r4");
			else 
		$display("fail addi 30, r4: result is %16h , PC: %4h",   uut.datapath.regfile.regs[4], uut.datapath.regfile.regs[15]);

	 //jeq r4; 7 cycles 
	 #14
		if(uut.datapath.regfile.regs[15] == 16'h001e ) // status registers 
		$display("pass jeq r4");
			else 
		$display("fail jeq r4:  PC: %4h",  uut.datapath.regfile.regs[15]);

	 //random instruction or instruction, should never execute
	 //JAL r1, r4, jump to r4 and put next pc value into r1 7 cycles
	 #14
		if(uut.datapath.regfile.regs[15] == 16'h001e &&  uut.datapath.regfile.regs[1] == 16'h001f) // status registers 
		$display("pass JAL r1, r4");
			else 
		$display("fail JAL r1, r4:  PC: %4h, LinkRegiser: ",  uut.datapath.regfile.regs[15], uut.datapath.regfile.regs[1]);
	 #15000000;
  end
	


endmodule 