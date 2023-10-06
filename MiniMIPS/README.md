*************************************************************************************************
Edison Yang, Isaac Kime, Sam Wimmer, Shem Snow
ECE 3710
Mini-MIPS Lab
*************************************************************************************************

Introduction:
In this lab, we were provided with a poorly-written (almost unreadable) Verilog implementation of a  MIPS processor and forced to read and understand it.
After that, we wrote an assembly program to calculate the first 14 Fibanocci numbers and store them into an array in memory then run a program that would 
constantly read the slide switches from the FPGA and use their value as an offset to the memory array. The data at that memory location was displayed on the
LEDs of the Cyclone V FPGA.

Learning Objectives:
The objective of this lab was for us to understand how a simple processor reads and writes to an FPGA's block memory (using \$readmemb or \$readmemh) by implementing
read and write to block memory on the Altera Cyclone V FPGA. The memory to read was the Fibanocci sequence script I wrote in MIPS and converted into machine code.
We used memory-mapped IO with the processor. This assignment mostly served as preparation for our final project where we would design our own CPU.
For this project, we just utilized the provided CPU to demonstrate our ability to load and run a program on the processor.

NOTE: On Provided Fib code waveform, the switch is at a value, but it does not affect
the provided code. The LED value is the output because at address 8'b11xxxxxx will make the led provide the data. 

*********************************  Additional Files in this Submission: ********************************* 

exmem - File where a flip-flop has been made & used for FSM
mipscpu-orig - Main file for MipsCPU, where all the cases & modules are
tb_mipscpu-orig - Testing the cpu made
mips - Created a top level for institating the mips and exmem.

Problems Encountered: 

Problems that we have encountered was the interaction of the fibonacci 
process. It was hard to decipher and write out our own assembly language 
code. Another conflict was the identifying how we name our variables, when 
trying to dix our errors, we realized how many various names were either
spelled wrong or capitalized in places we never expected, so we'll be 
careful in future projects on our naming skills. In addition, we had typos in our code
where we grabbed the wrong values, which lead to further confusion. These problems compounded,
because we were changing correct code, thinking it was wrong. This spiraled, but through our
teamwork and dedication we worked through it. 

Results:

The Fib.dat output was on par to what was expected based on the instructor.
We've also tested the processor on our FPGA and it is working as intented, 
as well as the wave output on MODELSIM, so everything should be good and
results are what we expected.

Comments to evaluator:

There shouldn't be any comments for this submission.


