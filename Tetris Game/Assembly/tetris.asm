//Assume 1002-1023 address are reserved for bitmap (1002-1022) and input 1023
//Whenever reading input, must store value then set to 0, to make sure we get a new input each time. 

//we need to have a register that is the bit of the center of each piece 
.setup
//Set all memory address from 1002-1022 to 0

//create infinite loop that breaks when address 1023 is not 0,
//Do this by moving value at addr[1023] into a value, moving 0 into addr[1023], then if it is not 0 break out, otherwise jump to gameplay loop.

.gameplay 
//NOTE: we might want to add a counter at the end so it does not do the this 50mhz a cycle because that will be very fast. 
//First thing is read input
//update current falling piece rotation
//then check if we are connect with any other pieces nearby, also check first if we are full, and we are in death condition and jump to game over
//if we are not connected, then update gravity piece then do gameplay loop again
//if we are connected
//first check for line clear,
//if we line clear, then shift the addr down by the number of lines we cleared with the piece placement

//Always  create new horizontal and vertical pointer to new piece, and create new piece if placed one

//then go back to gameplay loop


.gameover
//ideas: maybe have a game over flag and set it true here so it outputs in vga, 
//but simply wait for input then once it recieves one jump to setup again

