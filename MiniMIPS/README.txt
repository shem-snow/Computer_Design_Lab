*************************************************************************************************
Individual Submission for Shem Snow (u1058151)

Team name: EISS
Team members: Edison Yang, Isaac Kime, Sam Wimmer, Shem Snow
ECE 3710
Mini-MIPS Lab
*************************************************************************************************

Introduction:
In this lab, we were provided with a poorly-written (almost unreadable) Verilog implementation of a  MIPS processor and forced to read and understand it.
After that, we wrote an assembly program to calculate the first 14 Fibonacci numbers and store them into an array in memory then run a program that would 
constantly read the slide switches from the FPGA and use their value as an offset to the memory array. The data at that memory location was displayed on the
LEDs of the Cyclone V FPGA.

Learning Objectives:
The objective of this lab was for us to understand how a simple processor reads and writes to an FPGA's block memory (using \$readmemb or \$readmemh) by implementing
read and write to block memory on the Altera Cyclone V FPGA. The memory to read was the Fibonacci sequence script I wrote in MIPS and converted into machine code.
We used memory-mapped IO with the processor. This assignment mostly served as preparation for our final project where we would design our own CPU.
For this project, we just utilized the provided CPU to demonstrate our ability to load and run a program on the processor.

*********************************  Additional Files uploaded in this Submission: ********************************* 
*********************************  Results are described under each one ********************************* 

mips.v:
    The top-level module of the design. It interfaces with the board's clock, switches, LEDs, and a push button to implement a reset command.
    This model does no work but rather instantiates the CPU (mipscpu-orig.v) and external memory (exmem.v) that does all the work.

tb_mips.v:
    Testbench for the top-level mips.v file. Our objectives here were to load the program into the Cyclone V's memory as well as determine 
    whether or not our file is able to write to the LEDs.
    We just set the clock to always oscillate then waited enough time for the program to load. After that we set the switch input to an 
    arbitrary value (decimal 3) that could be observed in the Modelsim simulation. Simulation showed that the provided binary file was wrong
    and we needed to write our own.

exmem.v:
    A multi-bit flip-flop to hold the current state for the Finite State Machine in the CPU. It's purpose is to receive instructions from memory 
    on an input wire called "data" (because it's a flip flop) then decode the instruction to set the current read address (into a register called "addr_reg").

    Memory in this processor is split between 'regular' memory and input/output memory. Every instruction contains an encoding for indicating whether or not it interfaced
    with the IO memory.

    This module can be thought of as its own finite state machine that addresses three different concerns
    - The first is driving the outputs of the FSM. There are two outputs being driven, one is the LEDs on the Cyclone V board and the other is the flip-flop's output q which
        holds the completely decoded/raw data obtained from any operation.
    
    - The second is predicting the next state.
        The machine runs through two phases. The first is loading the program from memory and the second is running the program. In the first phase, the FSM is Moore-type and so the next state is just the next instruction in memory/RAM. In the second phase, the FSM becomes Mealy-type and so the next state depends on the board's slide
        switch values. The phase of the machine is indicated by the "IO" wire which is set after decoding the current instruction.

    - The third is next state progression
        This is done by setting the next read address.

tb_exmem.v:
    Testbench for the exmem.v file. Our only objectives here were to determine whether or not our external memory was able to load the
    program from memory as well as make sure the program did not 'runaway' and move into an unstable state. 
    We set the clock to always oscillate and assigned the input switches to receive zero. Since it took so much time to write the Fibonacci
    code, this testbench served as a quick immediate way to test a portion of our program to detect any bugs.


mipscpu-orig.v:
     - Provided file for the CPU. We were tasked with adding the addi functionality to this code. We did it by adding the parameter
    "ITYPEEX" and "ITYPEWR" as new state encodings. We also added the new "I" (immediate) instruction type with opcode 001000.


fib_assembly:
    The MARS assembly program I wrote for calculating and storing the Fibonacci numbers into block memory. It manually calculates and 
    stores the first two Fibonacci numbers into memory starting at location 128 then enters a loop to do the rest. A notable design decision
    here was to have a loop counter register ($t7) and a memory array offset register ($t6) rather than to have one register for both tasks.
    Using two separate registers made so the loop count would decrement instead of increment making for an assembly program with less instructions.


fib_hex.dat:
    The readable version of our binary file that we moved into memory using the $readmemh() function. It is organized in a little-endian structure 
    where when the computer reads each line and loads the instruction there into the 8 least significant unfilled bits of the current instruction.
    Each instruction received four of these lines. 

fib_machine:
    Since the MARS simulator assigns jump addresses according to some unknown logic, I ended up using brute force to manually convert 
    every single assembly instruction into binary and assigned relative addresses to each jump instruction.
    This file shows a snapshot of that process.

memory_of_Fib_Code:
    The state of memory after our "tb_mis.v" was ran. If you count manually from the end, you can see that the Fibanocci sequence that's 
    stored at the highlighted region starts at address 128 and there are exactly 14 items in it. The data at the end of the file is 
    the program's instructions/text. This can be verified by converting the instructions from fib_hex.dat into binary and adding the eight
    least most significant at a time to memory because this computer is little-endian.

WaveFormOfProvidedFibCode:
    The result of simulating the provided Fibanocci code in our tb_mips.v file. In this figure, notice how the displayed value shows a switch
    input of decimal 3 corresponding to the LED output of decimal 13. This shows that the provided Fibanocci code is incorrect because the 
    third Fibanocci number is not 13. This simulation made us aware that we needed to write our own Fibanocci code.

WaveFormFibCode:
    The result of simulating our own code in Modelsim. Notice how the displayed value shows a switch input of decimal 3 corresponding to an 
    LED outpu of decimal 1. This is the correct implementation because the third Fibanocci number is 1. During this simulation, we verified 
    the correctness of the Fibanocci code I wrote.



*********************************  Challenges we faced in this project ********************************* 

The biggest challenge I faced in this lab was reading somebody else's unreadable CPU code. Since I did so well in CS 3810 and 4400, I know 
how a general CPU works and was able to interface with the provided one pretty well. I was able to read and understand all the other provided
code. It's just the CPU that is still a little vague.

I also had a problem with github not saving the changes I made. I had completely finished this assignment and closed the file only to realize that 
a previous version had been pulled from github. I had to write this whole readme twice which was extremely frustrating.

The challenge that took most of my time was obtaining a binary file that contained the Fibanocci code. I had originally written a script in C that 
achieved this task but had trouble getting online compilers not to add extra unnessecary instructions and so I ended up abandoning the C code and 
just writing the program from scratch in the MARS simulator.

We were provided with a binary file that supposedly wrote the Fibanocci numbers to memory but it had the wrong implementation as shown in our 
simulation. I wish we hadn't have been provided that file because using it as a template caused my implemetation to be strange.
Specifically, my Fibanocci code iterates through the loop only half as much because in each iteration, it saves two numbers at a time into memory.

Even after all that work, the Fibanocci code I wrote had a bug that Isaac was able to detect and patch:
My assembly program assumed that at program startup, the switch input would already exist in the argument register $a1 and the LED
output would automatically be read from the return register $v0. It turns out that we needed to manually load and store the switch and 
LED values to and from those registers.


Eddison also made the mistake of setting the read address register "addr_reg" in exmem.v to the input RAM "data" instead of the encoded
address region "addr". The error here was mistaking the raw instructions from memory as the address to be decoded from it. 

Isaac and Sam didn't make any mistakes. They're perfect. 
