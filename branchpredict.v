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
`include "define.v"
module branchpredict(clk, rst, opcodeID, pcID, opcodeIDRR, rdata1, rdata2, branch, decision);

input 	   [15:0] pcID, rdata1, rdata2;
input	   [ 3:0] opcodeID, opcodeIDRR;
input		  rst, clk;
reg        [ 1:0] btable [0:15];
reg        [ 3:0] last;
output	          branch;
output     [ 1:0] decision;
integer           i;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		for(i=0; i<=15; i=i+1)
			btable[i] <= 2'b11;
		last <= 0;
	//	branch <= 0;
	//	decision <= 2'b11;
	end
	else if(opcodeID == `beq) begin
	//	branch <= btable[pcID[3:0]][1];
		last <= pcID[3:0];
	end
	else if(opcodeIDRR == `beq) begin
	//	branch <= 0;
		if(rdata1 == rdata2) begin
	//		if(btable[last][1] == 1)
	//			decision <= 2'b11;
	//		else
	//			decision <= 2'b01;
			if(btable[last] != 2'b11)
				btable[last] <= btable[last] + 1;
		end
		else if(rdata1 != rdata2) begin
	//		if(btable[last][1] == 1)
	//			decision <= 2'b10;
	//		else
	//			decision <= 2'b00;
			if(btable[last] != 2'b00)
				btable[last] <= btable[last] - 1;
		end
	end
	//else
	//	branch <= 0;
end


assign branch = (opcodeID == `beq) ? btable[pcID[3:0]][1] : 1'bz;
assign branch = (opcodeIDRR == `beq && decision == 2'b01) ? 1'b1 : 1'bz;
assign decision = (rst) ? 2'b11 : 2'bz;
assign decision = (~rst & opcodeIDRR == `beq & rdata1 == rdata2 & btable[last][1]) ? 2'b11 : 2'bz;
assign decision = (~rst & opcodeIDRR == `beq & rdata1 == rdata2 & ~btable[last][1]) ? 2'b01 : 2'bz;
assign decision = (~rst & opcodeIDRR == `beq & rdata1 != rdata2 & btable[last][1]) ? 2'b10 : 2'bz;
assign decision = (~rst & opcodeIDRR == `beq & rdata1 != rdata2 & ~btable[last][1]) ? 2'b00 : 2'bz;

endmodule
