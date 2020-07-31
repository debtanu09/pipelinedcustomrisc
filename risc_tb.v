/*
MIT License

Copyright (c) 2020 Debtanu Mukherjee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

`include "risc.v"
module risc_tb;
reg clk, rst;

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, risc_tb);
end

risc top(clk, rst);

initial begin
	rst <= 1;
	clk <= 0;
	#7 rst <= 0;
end

initial repeat(400) #5 clk <= ~clk;



initial begin 
$display("R0\tR1\tR2\tR3\tR4\tR5\tR6\tR7\tTIME");
$monitor("%4h\t%4h\t%4h\t%4h\t%4h\t%4h\t%4h\t%4h\t%4d", top.rfuut.rfile[0], top.rfuut.rfile[1], top.rfuut.rfile[2], top.rfuut.rfile[3], top.rfuut.rfile[4], top.rfuut.rfile[5], top.rfuut.rfile[6], top.rfuut.rfile[7], $time);
end
endmodule


//start clock from 0
//end reset between a previous posedge and next negedge
//      _____       _____
//     |     |     |     |
//     |     |     |     |
//     |     |     |     |
//     |     |     |     |
//_____|<--->|_____|<--->|_____
////////RESET///////RESET//////
/////////OFF/////////OFF///////
////////AERA////////AREA///////
