*************************************************************************************************
Isaac Kime, Sam Wimmer, Shem Snow, Edison Yang
ECE 3710
Tetris Final Project
*************************************************************************************************

In this project, we designed a 16-bit CPU with a MIPS-based ISA then we wrote the Tetris video game in our assembly language in order to test our design's validity.

Learning Objectives:
- Design and understand how an each component of the CPU works.
- Implement a CPU with the Van Neuman Architecture using Verilog.
- Write testbenches to test the validity of each module.
- Learn to interface with a VGA display.
- Write a non-trivial assembly language program (Tetris).
- Read and Write to block memory on the Altera Cyclone V FPGA.

Files in Repository:

- Assembly: All files concerning the development of the Tetris game (in assembly).
- CPU: All the verilog files for the actual project.
- Schematics: Hand-written designs we agreed upon while designing the CPU.
- Simulation/modelsim: auto-generated files.

Challenges Encountered: 


Results:
- We proved the validity of each instruction in the ISA via testbenches.
- We completed the game in assembly.
- We hard-coded a tetris block onto the board and got it to display on the VGA display (computer monitor). 
- The memory module did not update properly and so the game could not be displayed 

Future modifications:
