#Tetris Program

.start
movi $0 r0
movi $0 r1
movi $0 r2
movi $0 r3
movi $0 r4
movi $0 r5
movi $0 r6
movi $0 r7
movi $0 r8
movi $0 r9
movi $0 r10
movi $0 r11
movi $0 r12
movi $0 r13
movi $0 r14
movi $0 r15
.clearBitMap
MOVW 1024 r5
cmp r5 r9
beq .checkInput
MOVW 1003 r9
stor r0 r9
addi $1 r9
buc .clearBitMap

.checkInput
MOVW 1023 r9
load r10 r9
cmpi $0 r10
beq .checkInput

.createNewPiece
#check for death 
MOVW 1023 r10
load r11 r10 #r11 top line 
subi $1 r10
load r12 r10 #r12 second from top line 
andi $48 r11
cmpi $16 r11 #anything greater than 16 means pieces there already
bge .start #death 
andi $48 r12
cmpi $16 r12
bge .start

#reset register pointers 
movi $5 r1
movi $20 r2
mov r3 r4
andi $12 r4

#determine what block next 
cmpi $0 r4
beq .spawnLeftL
cmpi $1 r4 
beq .spawnRightL
buc .spawnBlock

.spawnLeftL

#or with current lines to spawn 
ori $32 r11
ori $48 r12
MOVW 1022 r10
stor r12 r10
addi $1 r10
stor r11 r10
buc .gameLoop #TO DO: change to actual thing

.spawnRightL
#or with current lines to spawn 
ori $32 r11
ori $48 r12
MOVW 1022 r10
stor r12 r10
addi $1 r10
stor r11 r10
buc .gameLoop #TO DO: change to actual thing

.spawnBlock
#or with current lines to spawn 
ori $16 r11
ori $48 r12
MOVW 1022 r10
stor r12 r10
addi $1 r10
stor r11 r10
buc .gameLoop #TO DO: change to actual thing


.gameLoop
MOVW 1023 r9
load r10 r9
MOVW 0x001D r11 #W key press 
MOVW 0x001C r12 #A key Press
MOVW 0x0023 r13 #D key press
cmp r11 r10
beq .Rotate
cmp r12 r10 
beq .moveLeft
cmp r13 r10 
beq .moveRight
buc .checkCollision

.moveLeft 
movi $0 r1
buc .move

.moveRight 
movi $1 r1
buc .move

.Rotate
movi $1 r9
buc .rotate


.rotate 

MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1002 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece


#Two lines needed from map
LOAD r11 r5 #top line in map
SUBI $1 r5
LOAD r12 r5 #next line down


# If no rotation needs to occur then skip over the code for it.
CMPI $0 r9
beq .type_11

# Save the falling block's type into r4 and its permutation type into r5.
movi $3 r4 # r4 = --0011
AND r3 r4 # r4 <- r3_bits[1,0]

movi $12 r5 #  r5 = --1100
AND r3 r5 # r5 <- r3_bits[3,2]


# Determine the block type (r4) and permutation (r5). Then jump to the block of code that will set the coresponding result of rotation into registers r13 and r14.
CMPI $3 r4
bne .type_11

CMPI $2 r4
bne .type_10

CMPI $1 r4
bne .type_01

# Else this is a square

    # square
    .type_00
        MOVI $3 r13
        MOVI $3 r14
        buc .case_exit

    # three piece
    .type_01
        # Use a nested case statement to get the permutation (r5)
        CMPI $3 r5
        bne .three_perm_11

        CMPI $2 r5
        bne .three_perm_10

        CMPI $1 r5
        bne .three_perm_01


            .three_perm_00 # -> permutation_3

                # Write the result
		MOVI $3 r13
                MOVI $2 r14
		
		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_3 into bits[4:3]
		ANDI $12 r3
		
		buc .case_exit

            .three_perm_01 # -> permutation_0
                MOVI $2 r13 
                MOVI $3 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
                buc .case_exit

            .three_perm_10 # -> permutation_1
                MOVI $1 r13 
                MOVI $3 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_1 into bits[4:3]
		ANDI $4 r3

                buc .case_exit

            .three_perm_11 # -> permutation_2
                MOVI $3 r13 
                MOVI $1 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_2 into bits[4:3]
		ANDI $8 r3

                buc .case_exit
        

    

    # long block
    .type_10

        # Use a nested case statement to get the permutation (r5)
        CMPI $3 r5
        bne .long_perm_11

        CMPI $2 r5
        bne .long_perm_10

        CMPI $1 r5
        bne .long_perm_01


            .long_perm_00 # -> permutation_1
                MOVI $3 r13 
                MOVI $0 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_1 into bits[4:3]
		ANDI $4 r3

                buc .case_exit

            .long_perm_01 # -> permutation_2
                MOVI $1 r13 
                MOVI $1 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_2 into bits[4:3]
		ANDI $8 r3

                buc .case_exit

            .long_perm_10 # -> permutation_3
                MOVI $0 r13 
                MOVI $3 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_3 into bits[4:3]
		ANDI $12 r3

                buc .case_exit

            .long_perm_11 # -> permutation_0
                MOVI $2 r13 
                MOVI $2 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3

                buc .case_exit


    # We won't use this block type so I'll use this space for the case where there's not rotation
    .type_11
        MOV r11 r13 
        MOV r12 r14

 	buc .rotate_store

.case_exit
# Shift the result to its horizontal location.
LSH r1 r13
LSH r1 r14

# Obtain the the old rows (r11 and r12) without the falling block (replace the falling block with zeros).
MOVI $3 r7
LSH r1 r7
XORI $1 r7
AND r7 r11
AND r7 r12

# Overlay the new falling block into those rows.
OR r11 r13
OR r12 r14

# TODO: Check for collisions?

# Store the results into RAM
.rotate_store
MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1002 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece

STOR r13 r5
SUBI $1 r5
STOR r14 r5

buc .checkCollision


.move 

MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1002 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece


#Two lines needed from map
LOAD r11 r5 #top line in map
SUBI $1 r5
LOAD r12 r5 #next line down

# 2 - Save the number of ones that occur into r7 and r8 (using r13 as the mask and r14 as the Bool_result).

# r7
MOVI $0 r7 # accumulator/count/result

MOVI $1 r13 # mask
MOVI $0 r14 # Bool_result

# while (r13 != 0)
.move_step_two_loop_r7
CMPI $0 r13
beq .move_step_two_part_two
    MOV r13 r14
    AND r11 r14

    # if (r14 != 0)
    CMPI $0 r14
    beq .move_step_two_incr_r7
    
    ADDI $1 r7

.move_step_two_incr_r7
    LSHI $1 r13

    buc .move_step_two_loop_r7

# r8
.move_step_two_part_two
MOVI $0 r8 # accumulator/count/result

MOVI $1 r13 # mask
MOVI $0 r14 # Bool_result

# while (r13 != 0)
.move_step_two_loop_r8
CMPI $0 r13
beq .move_step_three

    MOV r13 r14
    AND r12 r14

    # if (r14 != 0)
    CMPI $0 r14
    beq .move_step_two_incr_r8

    ADDI $1 r8
    
.move_step_two_incr_r8
    LSHI $1 r13

    buc .move_step_two_loop_r8


# 3 - Save the falling block's type into r5 and permutation type into r6
.move_step_three
MOVI $3 r5
AND r3 r5 # r5 <- r3_bits[1:0]

MOVI $12 r6
AND r3 r6 # r6 <- r3_bits[3:2]

# 3 - Use case statements to obtain two rows in r13 and r14 that are all zero except where the falling block is (it starts at the right). 

CMPI $3 r5
beq .11_two_piece

CMPI $2 r5
beq .10_two_piece

CMPI $1 r5
beq .01_three_piece

# else default to 00_square
    .00_square
        MOVI $3 r13
        MOVI $3 r14
        buc .move_to_falling_block_position

    .01_three_piece
        
        CMPI $3 r6
        beq .three_piece_11

        CMPI $2 r6
        beq .three_piece_10

        CMPI $1 r6
        beq .three_piece_01
        
        # else default to .three_piece_00
            .three_piece_00
                MOVI $2 r13
                MOVI $3 r14
                buc .move_to_falling_block_position
            .three_piece_01
                MOVI $1 r13
                MOVI $3 r14
                buc .move_to_falling_block_position

            .three_piece_10
                MOVI $3 r13
                MOVI $1 r14
                buc .move_to_falling_block_position

            .three_piece_11
                MOVI $3 r13
                MOVI $2 r14
                buc .move_to_falling_block_position

    .10_two_piece 

        CMPI $3 r6
        beq .two_piece_11

        CMPI $2 r6
        beq .two_piece_10

        CMPI $1 r6
        beq .two_piece_01
        
        # else default to .two_piece_00
            .two_piece_00
                MOVI $2 r13
                MOVI $2 r14
                buc .move_to_falling_block_position

            .two_piece_01
                MOVI $3 r13
                MOVI $0 r14
                buc .move_to_falling_block_position

            .two_piece_10
                MOVI $1 r13
                MOVI $1 r14
                buc .move_to_falling_block_position

            .two_piece_11
                MOVI $0 r13
                MOVI $3 r14
                buc .move_to_falling_block_position

    .11_two_piece # unused


# 3 - Shift r13 and r14 to the horizontal position in r1
.move_to_falling_block_position
    LSH r1 r13
    LSH r1 r14

# 4 - Remove the falling block (in r13 and r14) from the board ( in r11 and r12).

    XORI $1 r13
    AND r13 r11

    XORI $1 r14
    AND r14 r12


# 5 - Check the move direction and shift r13 and r14 accordingly

    CMPI $0 r4
    bne .move_left

.move_right

    LSHI $-1 r13
    LSHI $-1 r14
    buc .place_new_x_position


.move_left
    LSHI $1 r13
    LSHI $1 r14

# 6 - XOR the old rows without the falling block (r11 and r12) with the new rows consisting only of the falling block (r13 and r14). Save the result into r13 and r14.
.place_new_x_position
    XOR r11 r13
    XOR r12 r14

# 7 - Count the number of 1s that occur in the result (using r5 as the mask and r6 as the Bool_result). Save them into r9 and r10.

#r9
MOVI $0 r9 # accumulator/count/result

MOVI $1 r5 # mask
MOVI $0 r6 # Bool_result

# while (r5 != 0)
.move_7_loop_r9
CMPI $0 r5
beq .move_step_sevon_part_two

    MOV r5 r6
    AND r13 r6

    # if (r6 != 0)
    CMPI $0 r6
    beq .move_7_incr_r9
    
    ADDI $1 r9
    
.move_7_incr_r9
    LSHI $1 r5

    buc .move_7_loop_r9

# r10
.move_step_sevon_part_two
MOVI $0 r10 # accumulator/count/result

MOVI $1 r5 # mask
MOVI $0 r6 # Bool_result

# while (r5 != 0)
.move_7_loop_r10
CMPI $0 r5
beq .move_step_8
    
    MOV r5 r6
    AND r14 r6

    # if(r6 != 0)
    CMPI $0 r6 
    beq .move_7_incr_r10

    ADDI $1 r10
    
.move_7_incr_r10
    LSHI $1 r5

    buc .move_7_loop_r10

# 8 - If the number of 1s before and after the shift are different then there was a collision. Abort all changes by immediately returning with no changes.
.move_step_8
CMP r7 r9
bne .checkCollision

CMP r8 r10
bne .checkCollision

# 9 - Otherwise the command was valid. The result is in r13 and r14. Increment or decrement r1 then store the results into memory.
MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1002 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece
STOR r13 r5
SUBI $1 r5
STOR r14 r5

buc .checkCollision


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

# Initialize positions and piece type
    MOVI $3 R4
    LSH R1 R4
    XORI $1 R4
    AND R4 R8
    AND R4 R9
    STOR
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

LSH R1 R13
LSH R1 r14

XOR R13 R9
XOR R14 R10

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

########################################################
#Check collision and line check
#collide?
#no -> fall and done
#yes -> full line?

#full line?
#no -> restart
#yes -> remove line and fall then restart

#First Need to check collision
.checkCollision
CMPI $0 r2 #if at the bottom of the board then it collided
beq .collision 
MOV r1 r4   #r4 is the current horizontal of piece
MOVW 1007 r5 #current bottom piece location
ADD r2 r5   #r5 is the current vertical of piece


#Two lines needed from map
LOAD r8 r5 #top line in map 
SUBI $1 r5
LOAD r9 r5 #next line down

#Piece type and Orientation
MOV r3 r6    
ANDI $12 r6   #r6 = current shape
MOV r3 r7   
ANDI $3 r7   #r7 = orientation

# R6 -- 0 = block, 1 = L, 2 = I
# R7 -- Permutation.
#Use Piece, orientation, and Horizontal to get Piece (get piece/orientation then shift)

#GET TO COMP. of block type
cmpi $0 r6
beq .block 
cmpi $4 r6
beq .el
buc .line

#determine block
.block 
movi $3 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0 r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#determine EL 
.el
cmpi $0 r7
beq .jEl0 
cmpi $1 r7
beq .jEl1
cmpi $2 r7
beq .jEl2
buc .jEl3

#case 1 perm 0 
.jEl0
movi $2 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#case 2 perm 1
.jEl1
movi $3 r10
movi $2 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#case 3 perm 2
.jEl2
movi $3 r10
movi $1 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#case 4 perm 3
.jEl3
movi $1 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#determine Line 
.line
cmpi $0 r7
beq .jline0 
cmpi $1 r7
beq .jline1
cmpi $2 r7
beq .jline2
buc .jline3

#case 1 perm 0 
.jline0
movi $2 r10
movi $2 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#case 2 perm 1
.jline1
movi $3 r10
movi $0 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#case 3 perm 2
.jline2
movi $1 r10
movi $1 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#case 4 perm 3
.jline3
movi $0 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 #two sets of shifted mask
AND r8 r10
AND r9 r11 #if r10 or r11 are not zero then collision
cmpi $0 r11
bne .collision
cmpi $0, r10
bne .collision #if either are not zero then go collide 
buc .fall #else go to fall.

#Check if collide with AND or at bottom then see if it is equal to zero for both jump to either fall or line check
.collision
MOVW 1007 r5 #current bottom piece location
ADD r2 r5   #r5 reset r5

#Two lines needed from map of piece
LOAD r8 r5 #top line in map
ADDI $1 r5
LOAD r9 r5 #next line down
SUBI $1 r5

MOVW 65535 r13
xor r13 r8
xor r13 r9

movi $0 r13
or r8 r13
or r9 r13
cmpi $0 r13
mov r5 r12      #r12 shows which line was empty
beq .cleartwo   #if they are both zero then clear both
cmpi $0 r8       
beq .clearline   #if not zero then not full
cmpi $0 r9 
ADDI $1 r12
beq .clearline      #if not zero then not full
buc .createNewPiece 

#Line Check (store current piece then check both the top line and next line as used before)
.clearline #if i am here i have the line to start at in r12 and just need to replace until top 
mov r12 r13
addi $1 r13
load r14 r13  #load next line up
store r14 r12 #store it below
addi $1 r12
MOVW 1020 r10
cmp r10 r12 #if curr line is top of board then stop
beq .createNewPiece
buc .clearline

#two lines were cleared so move everything down two.
.cleartwo
mov r12 r13
addi $2 r13
load r14 r13
store r14 r12
addi $1 r12
MOVW 1019 r10
cmp r10 r12 #if it leaves the board then be done clearing
beq .createNewPiece
buc .cleartwo


########################################
