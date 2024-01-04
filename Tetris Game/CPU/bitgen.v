/*
	Bitgen based on a current line. We only want to use some of the board because tetris board is 10 long x 20 high. 
	Simply just checks the bit that corresponds to the horizontal block and if it is 1, draw white, otherwise just draw black 
*/
module bitgen(
	input bright,
	input [9:0] hcount,
	input [9:0] vcount,
	input [15:0] currLine,
	output reg[7:0] VGA_R,
	output reg[7:0] VGA_G,
	output  reg[7:0] VGA_B
);



always@(*)
begin
	if((hcount >= 220) && (hcount <= 460))
	begin
		if(hcount >= 220 && hcount <=244)
			begin 
			 if (currLine[0] == 1)
				begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
					end
			 else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else if ( hcount > 244 && hcount <= 268)
			begin 
			 if (currLine[1] == 1)
				begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
				end 
				else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else if ( hcount > 268 && hcount <= 292)
			begin 
			 if (currLine[2] == 1)
				begin 
				//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111; 
				end else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else if ( hcount > 292 && hcount <= 316)
			begin 
				 if (currLine[3] == 1)
					begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
					end else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
				end
		else if ( hcount > 316 && hcount <= 340)
			begin 
			 if (currLine[4] == 1)
				begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
				end else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else if ( hcount > 340 && hcount <= 364)
			begin 
			 if (currLine[5] == 1)
				begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111; 
				end 
				else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else if ( hcount > 364 && hcount <= 388) 
			begin 
				 if (currLine[6] == 1)
					begin 
						//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B<= 8'b11111111;
					end 
					else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end 
				end
		else if ( hcount > 388 && hcount <= 412)
			begin 
			 if (currLine[7] == 1)
				begin 
				//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
				end else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else if ( hcount > 412 && hcount <= 436) 
			begin 
			 if (currLine[8] == 1)
				begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
				end else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		else // last bit
			begin 
			 if (currLine[9] == 1)
				begin 
					//white 
					VGA_R <= 8'b11111111;
					VGA_G <= 8'b11111111;
					VGA_B <= 8'b11111111;
				end 
				else 
			 begin 
					VGA_R <= 8'b00000000;
					VGA_G <= 8'b00000000;
					VGA_B <= 8'b00000000;
			 end
			end
		end 
	else 
		begin 	// color is black
					VGA_R <= 8'b00111100;
					VGA_G <= 8'b00111100;
					VGA_B <= 8'b00111100;
		
       end
    end 

endmodule