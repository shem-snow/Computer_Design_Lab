/*
* The top-level module of the design. It interfaces with the board's clock, switches, LEDs, and a push button to implement a reset command.
* This model does no work but rather instantiates the CPU (mipscpu-orig.v) and external memory (exmem.v) that does all the work.
*/
module mips(input clk, input rst, input [7:0] switches, output [7:0] leds);
wire memwrite;
wire [7:0] adr;
wire [7:0] writedata;
wire [7:0] readdata;

mipscpu cpu ( .clk(clk), .reset(rst),
 .memdata(readdata), .memwrite(memwrite), .adr(adr), .writedata(writedata));
exmem memory ( .switches(switches), .data(writedata),
 .addr(adr), .wen(memwrite), .clk(clk), .q(readdata), .LEDs(leds));

endmodule 