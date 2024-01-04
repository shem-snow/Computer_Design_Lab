# This is the MOVE method for the falling block.
# The procedure is to:
#   1 - Save the top and bottom rows of the current falling block into r11 and r12
#   2 - Count the number of ones that occur in each one (using r13 and r14). Save the counts into registers r7 and r8
#   3 - Determine the block type, permutation, and shift amount to obtain two rows (r13 and r14) that are all zero except where the falling block is.
#   4 - Remove the falling block from the board (r11 and r12).
#   5 - Shift the two rows consisting only of the falling block (r13 and r14) left or right depending on what the move command register (r4) is.
#   6 - XOR the old rows without the falling block (r11 and r12) with the new rows consisting only of the falling block (r13 and r14).
#        Save the result into r13 and r14.
#   7 - Count the number of 1s that occur in the result (using r5 and r6). Save them into r9 and r10.
#   8 - If the number of 1s before and after the shift are different then there was a collision. Abort all changes by immediately returning with now changes.
#   9 - Otherwise the command was valid. The result is in r13 and r14. Increment or decrement r1 then store the results into memory.
# 
# Caller agreement:
#   - This method is only called when a move command has occured.
#   - The procedure expects that the caller set r4 to hold 0 to indicate move left or a 1 to indicate move right.

# 1 - load the lines of the falling block into r11 and r12
LOAD r11 RAM(r2+1)
LOAD r12 RAM(r2)

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
MOV $3 r5
AND r3 r5 # r5 <- r3_bits[1:0]

MOV $12 r6
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
        
        CMPI $12 r6
        beq .three_piece_11

        CMPI $8 r6
        beq .three_piece_10

        CMPI $4 r6
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

        CMPI $12 r6
        beq .two_piece_11

        CMPI $8 r6
        beq .two_piece_10

        CMPI $4 r6
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
bne .exit_move

CMP r8 r10
bne .exit_move

# 9 - Otherwise the command was valid. The result is in r13 and r14. Increment or decrement r1 then store the results into memory.
STOR r13 RAM(r2+1)
STOR r14 RAM(r2)

.exit_move
