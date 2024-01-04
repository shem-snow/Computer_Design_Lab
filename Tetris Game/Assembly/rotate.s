# This is the assembly code for the CLOCK-WISE rotation of a falling block.
# The procedure is to:
#   - Determine the falling block's type and permutation from r3 and write the block in registers r11 and r12.
#   - Predict the next permutation and write it into registers r13 and r14. Also update r3 to keep the old block type but hold the new permutation.
#   - Shift the result left by the horizontal amount specified in r1
#  
#  There are three case statements in here. The outer-most handles the block type (in r4)
#  The two nested ones handle the block permutation (in r5) for the long and 3-piece blocks.
#  
#  SPECIAL BEHAVIOR: Since we aren't using a block type for the 2'b11 case, I used that for the case when we should not rotate. 
# 
#  r1 and r2 hold the bottom left address (may or may not actually hold a piece) of the falling block
#  r4 and r5 will hold the block type and permutation
#  
#  r11 and r12 hold the falling block
#  r13 and r14 hold the result of rotation of the falling block (at the end of this method).
#  
#  r9 holds a Boolean that indicates if rotation will occur



# Load the lines of the falling block into r11 and r12 (maybe I can assume the caller will do this?)
LOAD r11 RAM(r2 + 1) # r11 <- top
LOAD r12 RAM(r2) # r12 <- bottom

# If no rotation needs to occur then skip over the code for it.
CMPI $0 r9
beq .type_11

# Save the falling block's type into r4 and its permutation type into r5.
MOV $3 r4 # r4 = --0011
AND r3 r4 # r4 <- r3_bits[1,0]

MOV $12 r5 #  r5 = --1100
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
        CMPI $12 r5
        bne .three_perm_11

        CMPI $8 r5
        bne .three_perm_10

        CMPI $4 r5
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
		ANDI 12 r3
		
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
		ANDI 4 r3

                buc .case_exit

            .three_perm_11 # -> permutation_2
                MOVI $3 r13 
                MOVI $1 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_2 into bits[4:3]
		ANDI 8 r3

                buc .case_exit
        

    

    # long block
    .type_10

        # Use a nested case statement to get the permutation (r5)
        CMPI $12 r5
        bne .long_perm_11

        CMPI $8 r5
        bne .long_perm_10

        CMPI $4 r5
        bne .long_perm_01


            .long_perm_00 # -> permutation_1
                MOVI $3 r13 
                MOVI $0 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_1 into bits[4:3]
		ANDI 4 r3

                buc .case_exit

            .long_perm_01 # -> permutation_2
                MOVI $1 r13 
                MOVI $1 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_2 into bits[4:3]
		ANDI 8 r3

                buc .case_exit

            .long_perm_10 # -> permutation_3
                MOVI $0 r13 
                MOVI $3 r14

		# Put zeros in the permutation bits of r3
		MOVI $12 r10
		XORI $1 r10
		AND r10 r3
		
		# Put permutation_3 into bits[4:3]
		ANDI 12 r3

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
STOR r13 RAM(r2+1)
STOR r14 RAM(r2)
