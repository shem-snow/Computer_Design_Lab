.start
movi $0 r0
movi $14 r4
stor r0 r4
movi $18 r4
stor r0 r4
movi $20, r1
load r2 r1
cmpi $28 r2 
beq .AInput
cmpi $27 r2
beq .SInput
movi $1 r5

.loop
addi $1 r5
cmpi $255 r5
beq .start
buc .loop


.AInput
movi $170 r3
movi $14 r4
stor r3 r4
buc .start


.SInput
movi $170 r3
movi $18 r4
stor r3 r4
buc .start