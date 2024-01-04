# Assumptions:
# R1 is the horizontal position, R2 is the vertical position, R3 is the block type
# R4 and R5 will be used for additional data handling
# GAME_BOARD_ADDR is the starting address of the game board in memory
# BIT_MASK, EXTRA_BLOCKS_MASK, and TOP_BIT_MASK are used for bitwise operations on the block
# LINE_1_ADDR, LINE_2_ADDR, LINE_3_ADDR are the addresses for lines 1, 2, and 3 on the game board
# Assuming LINE_1_ADDR, LINE_2_ADDR, and LINE_3_ADDR are consecutive in memory
# ZERO_REG is a register that holds the value 0
# FLAG_REG is a register used to hold flags for collision, etc.

.fall
# Load the state of lines 1, 2, and 3 from the game board
MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1002 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece

ADDI $1 r5

LOAD R10 r5
subi $1 r5 
LOAD R9 r5
subi $1 r5
LOAD R8 r5

# Piece type and Orientation
MOV R3 R6
ANDI $3 R6    
# R6 now holds the current shape
ANDI $12 R6    
MOV R7 R3  
# Determine the type in R6
CMPI $3 R6
BEQ fall_unused

CMPI $2 R6
BEQ fall_two_piece

CMPI $1 R6
BEQ fall_three_piece

.fall_square
    MOVI $3 R13
    MOVI $3 R14
    buc fall_case_end

.fall_two_piece 

        CMPI $12 R7
        beq .fall_two_piece_11

        CMP $8 R7
        beq .fall_two_piece_10

        CMP $4 R7
        beq .fall_two_piece_01
        
        # else default to .two_piece_00
            .fall_two_piece_00
                MOVI $2 r13
                MOVI $2 r14
                buc fall_case_end

            .fall_two_piece_01
                MOVI $3 r13
                MOVI $0 r14
                buc fall_case_end

            .fall_two_piece_10
                MOVI $1 r13
                MOVI $1 r14
                buc fall_case_end

            .fall_two_piece_11
                MOVI $0 r13
                MOVI $3 r14
                buc fall_case_end


.fall_three_piece 

        CMPI $12 R7
        beq .fall_three_piece_11

        CMP $8 R7
        beq .fall_three_piece_10

        CMP $4 R7
        beq .fall_three_piece_01
        
        # else default to .three_piece_00
            .fall_three_piece_00
                MOVI $2 r13
                MOVI $3 r14
                buc fall_case_end

            .fall_three_piece_01
                MOVI $1 r13
                MOVI $3 r14
                buc fall_case_end

            .fall_three_piece_10
                MOVI $3 r13
                MOVI $1 r14
                buc fall_case_end

            .fall_three_piece_11
                MOVI $3 r13
                MOVI $2 r14
                buc fall_case_end

    .fall_unused # unused
    
.fall_case_end 

# Shift the register containing only the falling block to the horizontal position
LSH R1 R13
LSH R1 r14

# Remove the old falling block from the current rows

// Top Row
MOV r13 r4
XORI $1 r4
AND r4 r8

// Bottom Row
MOV r14 r4
XOR $1 r4
AND r4 r9


# Place the falling block into its new rows.
XOR R13 R9 // Top
XOR R14 R10 // Bottom

MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1002 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece

ADDI $1 r5

LOAD R10 r5
LOAD R9 r5
LOAD R8 r5

STOR R10 r5  
subi $1 r5 
STOR R9 r5 
subi $1 r5 
STOR R8 r5  

.buc gameLoop

# # R7 now holds the orientation
# ANDI $3 R7 

# # R4 is the horizontal position
# MOV R4 R1    
# # R5 is the vertical position
# MOV R5 R2    
# # Adjust R5 to account for piece height (determines the bottom of the piece)
# ADDI $1003 R5          

# # Perform XOR with BIT_MASK for line 1
# XOR R8 BIT_MASK    
# STORE LINE_1_ADDR R8   

# # Perform XOR with BIT_MASK for line 2
# XOR R9 BIT_MASK    
# STORE LINE_2_ADDR R9  

# # Line 3 remains unchanged
# STORE LINE_3_ADDR R10 

# # Now we will replace the blocks with only extra blocks
# # This could mean isolating the falling piece from the game state
# # We'll use EXTRA_BLOCKS_MASK to perform this operation

# # Isolate extra blocks on line 1
# AND R8 EXTRA_BLOCKS_MASK
# # Replace line 1 with only the extra blocks
# STOR LINE_1_ADDR R8

# # Isolate extra blocks on line 2
# AND R9 EXTRA_BLOCKS_MASK
# # Replace line 2 with only the extra blocks
# STOR LINE_2_ADDR R9

# # Assuming LEFT_SHIFT_AMOUNT is the amount to shift to find the new falling point
# # Move the falling blocks down on line 1 by shifting
# LSH R8 LEFT_SHIFT_AMOUNT
# # Store the new position of the falling blocks on line 1
# STOR LINE_1_ADDR R8

# # Repeat for line 2
# LSH R9 LEFT_SHIFT_AMOUNT
# # Store the new position of the falling blocks on line 2
# STORE LINE_2_ADDR R9
