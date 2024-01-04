*************************************************************************************************
Isaac Kime, Sam Wimmer, Shem Snow, Edison Yang
ECE 3710
Tetris Final Project
*************************************************************************************************

In this project, we explore the intricate design and implementation of
the classic video game Tetris on a hardware level using Verilog for
the FPGA-based digital logic and CR-16 Assembly Language for
the microcontroller. The primary objective is to develop a system
that not only replicates similar gameplay dynamics of Tetris but
also leverages the unique capabilities of both Verilog and CR-16
architecture

Learning Objectives:

Design and understand how an each component of the CPU works, which will benefit for Final Project.
Implement and understand a digital design using the Verilog.
Write a testbench of the compoentnsusing the Verilog.
Implement Bitgens and PS2 Conrollers for Game Controller
Implement CR-16 Assembly Language to write out Tetris Game Operations
Read and Write to block memory on the Altera Cyclone V FPGA,

Files in Submission:

Assembly - File where the game logic is held.
CPU - All verilog component files, from ALU, VGA, etc...
MIPSLab - Files from the MipsLab Assigment for ECE 3710
Other_sources - Other files that we have used or took inspiration from that didn't end up in final project.
PreviousAssignments - All previous ECE 3710 Assignments that contributed towards the Final Project


Problems Encountered: 

Problems that we have encountered was the interaction towards the game logic with
our Verilog code. It was hard to decipher and write out our cases as we were trying to
write all the possible cases and had conflict with designing our CPU Components and getting our 
game to show towards the screen properly, but we were able to breakdown the ones we needed 
and worked from there. Another conflict was the not combining our code in time. When 
we started the project, we decided to seperate the ideas and create double the work and it led to 
serious errors in our output as we were all basing our work off of assumptions and ideas. 
We tried to fix our errors and soon realized how many various names were either
doing the same check, so we'll be careful in future projects on our variable skills.
In addition, we had typos in our codewhere we grabbed the wrong values, which lead 
to further confusion. These problems compounded, because we were changing correct code,
thinking it was wrong. This spiraled, but through our teamwork and dedication we worked 
through it. 

Results:

Our result is that we completed the game in assembly and working on modelsim. We then got the output to show
on the screen. We had to redo the memory at the end so we didn't get the whole game up and working but we got it
working enough to check off. We had assembly to show on the screen and we were able to read input. 

Comments to evaluator:

There shouldn't be any comments for this submission.


