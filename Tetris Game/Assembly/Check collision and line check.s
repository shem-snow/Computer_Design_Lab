;Check collision and line check

;collide?
;no -> fall and done
;yes -> full line?

;full line?
;no -> restart
;yes -> remove line and fall then restart


;First Need to check collision
MOV r1 r4   ;r4 is the current horizontal of piece
MOV r2 r5   ;r5 is the current vertical of piece
ADDI $1002 r5 ; current bottom piece location

;Two lines needed from map
LOAD r5 r8 ; top line in map
SUBI $1 r5
LOAD r5 r9 ; next line down

;Piece type and Orientation
MOV r3 r6    
ANDI $12 r6   ; r6 = current shape
MOV r3 r7   
ANDI $3 r7   ; r7 = orientation

; R6 -- 0 = block, 1 = L, 2 = I
; R7 -- Permutation.
;Use Piece, orientation, and Horizontal to get Piece (get piece/orientation then shift)

;GET TO COMP. of block type
cmpi $0 r6
beq block 
cmpi $1 r6
beq el
buc line

;;;;;;;;;;;;;;;;
;determine block
.block 
movi $3 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0, r11
bne collision
cmpi $0 r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.



;determine EL 
.el
cmpi $0 r7
beq jEl0 
cmpi $1 r7
beq jEl1
cmpi $2 r7
beq jEl2
buc jEl3

;case 1 perm 0 
.jEl0
movi $2 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;case 2 perm 1
.jEl1
movi $3 r10
movi $2 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;case 3 perm 2
.jEl2
movi $3 r10
movi $1 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;case 4 perm 3
.jEl3
movi $1 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;determine Line 
.line
cmpi $0 r7
beq jline0 
cmpi $1 r7
beq jline1
cmpi $2 r7
beq jline2
buc jline3

;case 1 perm 0 
.jline0
movi $2 r10
movi $2 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;case 2 perm 1
.jline1
movi $3 r10
movi $0 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;case 3 perm 2
.jline2
movi $1 r10
movi $1 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;case 4 perm 3
.jline3
movi $0 r10
movi $3 r11
LSH r4 r10
LSH r4 r11 ;two sets of shifted mask
AND r8 r10
AND r9 r11 ;if r10 or r11 are not zero then collision
cmpi $0 r11
bne collision
cmpi $0, r10
bne collision ;if either are not zero then go collide 
buc fall ;else go to fall.

;Check if collide with AND or at bottom then see if it is equal to zero for both jump to either fall or line check
.collision
MOVI r2 r5   ;r5 reset r5
ADDI $1002 r5 ; current bottom piece location

;Two lines needed from map of piece
LOAD r5 r8 ; top line in map
ADDI $1 r5
LOAD r5 r9 ; next line down
SUBI $1 r5

xori $65535 r8
xori $65535 r9

movi $0 r13
or r8 r13
or r9 r13
cmpi $0 r13
mov r5 r12      ;r12 shows which line was empty
beq .cleartwo   ;if they are both zero then clear both
cmpi $0 r8       
beq clearline   ;if not zero then not full
cmpi $0 r9 
ADDI $1 r12
beq clearline      ;if not zero then not full
buc start

;Line Check (store current piece then check both the top line and next line as used before)
.clearline ;if i am here i have the line to start at in r12 and just need to replace until top 
movi r12 r13
addi $1 r13
load r13 r14
store r14 r12
addi $1 r12
cmpi $1022, r12 ;if it leaves the board then be done clearing
beq .start
buc .clearline

;two lines were cleared so move everything down two.
.cleartwo
movi r12 r13
addi $2 r13
load r13 r14
store r14 r12
addi $1 r12
cmpi $1021, r12 ;if it leaves the board then be done clearing
beq .start
buc .cleartwo
