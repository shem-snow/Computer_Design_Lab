/*
	Simple PS2Handler. It ignores the parity and stop bit. Does stoer the previous complete data, but did not use it because
	we decided against storing that in the top 8 MSB of the 16 bit memory, instead just padding it with 0's. 
*/
module PS2Handler(input clk, input currentDataBit, output reg [7:0]previousCompleteData, output reg [7:0]data, output reg inputDataClk);

reg [3:0] count; 
reg [7:0] currentData;
reg[7:0] previousData;

initial begin 
currentData = 8'h00;
previousData = 8'h00;
count = 4'h0; 
end


always@ (negedge clk)
begin
	case(count)
	0: ;//start bit
	1: currentData[0] <= currentDataBit;
	2: currentData[1] <= currentDataBit;
	3: currentData[2] <= currentDataBit;
	4: currentData[3] <= currentDataBit;
	5: currentData[4] <= currentDataBit;
	6: currentData[5] <= currentDataBit;
	7: currentData[6] <= currentDataBit;
	8: currentData[7] <= currentDataBit;
	9: ;//parity bit
	10: ;//end bit
	endcase
	//increment count
	if(count < 4'd10)
	begin
		count <= count + 1'b1;
		inputDataClk <= 0;
	end
	//restart count 
	else if( count == 4'd10)
	begin
		count <= 0;
		inputDataClk <= 1;
	end
end




always@(*)
begin
//if we are at end, set the data 
if(count == 4'd10)
	begin
		previousCompleteData = data;
		data = previousData;
	end
else
	begin
	//otherwise update the data
		previousData = currentData;
		previousCompleteData = previousCompleteData;
	end
end
endmodule	