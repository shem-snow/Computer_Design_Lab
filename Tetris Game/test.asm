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
MOVW 1019 r10
load r11 r10 #r11 top line 
subi $1 r10
load r12 r10 #r12 second from top line 
ori $255 r11
ori $121 r12
MOVW 1007 r10
stor r12 r10
addi $1 r10
stor r11 r10
addi $1 r10
stor r12 r10
addi $1 r10
stor r11 r10
addi $1 r10
stor r12 r10
addi $1 r10
stor r11 r10
addi $1 r10
stor r12 r10
addi $1 r10
stor r11 r10
addi $1 r10
stor r12 r10
addi $1 r10
stor r11 r10
addi $1 r10
stor r12 r10
addi $1 r10
stor r11 r10
addi $1 r10
stor r12 r10
addi $1 r10
stor r11 r10
buc .gameLoop

.gameLoop
movi $1 r4
cmpi $1 r4
beq .gameLoop
buc .gameLoop