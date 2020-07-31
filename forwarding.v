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
module forwarding(validRREX, validEXMM, validMMWB,
		  waddrRREX, waddrEXMM, waddrMMWB, raddrIDRR,
		  opcodeRREX, opcodeEXMM, opcodeMMWB,
		  aluoutEX, extendedRREX,
		  aluoutEXMM, extendedEXMM, memrdMM,
		  aluoutMMWB, extendedMMWB, memrdMMWB,
		  flagEX, condRREX, flagEXMM, condEXMM, flagMMWB, condMMWB,
		  forward, data, stall);
		  
input 	      validRREX, validEXMM, validMMWB;		  
input  [ 2:0] raddrIDRR, waddrRREX, waddrEXMM, waddrMMWB;
input  [ 3:0] opcodeRREX, opcodeEXMM, opcodeMMWB;
input  [15:0] aluoutEX, extendedRREX, aluoutEXMM, extendedEXMM, memrdMM, aluoutMMWB, extendedMMWB, memrdMMWB;
input  [ 1:0] condRREX, condEXMM, condMMWB, flagEX, flagEXMM, flagMMWB;
output        forward, stall;
output [15:0] data;

wire 	      add_or_nandRREX, add_or_nandEXMM, add_or_nandMMWB, stage1, stage2, stage3, validstage1, validstage2, validstage3;    

assign add_or_nandRREX = ((opcodeRREX == `add || opcodeRREX == `ndu) && condRREX == 2'b00) ? 1'b1 : 1'bz;
assign add_or_nandRREX = ((opcodeRREX == `add || opcodeRREX == `ndu) && condRREX == 2'b10 && flagEX[1] == 1'b1) ? 1'b1 : 1'bz;
assign add_or_nandRREX = ((opcodeRREX == `add || opcodeRREX == `ndu) && condRREX == 2'b01 && flagEX[0] == 1'b1) ? 1'b1 : 1'bz;

assign add_or_nandEXMM = ((opcodeEXMM == `add || opcodeEXMM == `ndu) && condEXMM == 2'b00) ? 1'b1 : 1'bz;
assign add_or_nandEXMM = ((opcodeEXMM == `add || opcodeEXMM == `ndu) && condEXMM == 2'b10 && flagEXMM[1] == 1'b1) ? 1'b1 : 1'bz;
assign add_or_nandEXMM = ((opcodeEXMM == `add || opcodeEXMM == `ndu) && condEXMM == 2'b01 && flagEXMM[0] == 1'b1) ? 1'b1 : 1'bz;

assign add_or_nandMMWB = ((opcodeMMWB == `add || opcodeMMWB == `ndu) && condMMWB == 2'b00) ? 1'b1 : 1'bz;
assign add_or_nandMMWB = ((opcodeMMWB == `add || opcodeMMWB == `ndu) && condMMWB == 2'b10 && flagMMWB[1] == 1'b1) ? 1'b1 : 1'bz;
assign add_or_nandMMWB = ((opcodeMMWB == `add || opcodeMMWB == `ndu) && condMMWB == 2'b01 && flagMMWB[0] == 1'b1) ? 1'b1 : 1'bz;


assign stage1 = ((raddrIDRR == waddrRREX) && validRREX);
assign stage2 = ((raddrIDRR == waddrEXMM) && validEXMM);
assign stage3 = ((raddrIDRR == waddrMMWB) && validMMWB);

assign validstage1 = (stage1 && (add_or_nandRREX || opcodeRREX == `adi || opcodeRREX == `lhi));
assign validstage2 = (stage2 && (add_or_nandEXMM || opcodeEXMM == `adi || opcodeEXMM == `lhi || opcodeEXMM == `lw));
assign validstage3 = (stage3 && (add_or_nandMMWB || opcodeMMWB == `adi || opcodeMMWB == `lhi || opcodeMMWB == `lw));

assign forward = ((validstage1 || validstage2 || validstage3) && ~stall);

assign data = (validstage1 && (opcodeRREX == `add || opcodeRREX == `ndu || opcodeRREX == `adi)) ? aluoutEX : 16'bz;
assign data = (validstage1 && opcodeRREX == `lhi) ? extendedRREX : 16'bz;

assign data = (validstage2 && (opcodeEXMM == `add || opcodeEXMM == `ndu || opcodeEXMM == `adi)) ? aluoutEXMM : 16'bz;
assign data = (validstage2 && opcodeEXMM == `lhi) ? extendedEXMM : 16'bz;
assign data = (validstage2 && opcodeEXMM == `lw) ? memrdMM : 16'bz;

assign data = (validstage3 && (opcodeMMWB == `add || opcodeMMWB == `ndu || opcodeMMWB == `adi)) ? aluoutMMWB : 16'bz;
assign data = (validstage3 && opcodeMMWB == `lhi) ? extendedMMWB : 16'bz;
assign data = (validstage3 && opcodeMMWB == `lw) ? memrdMMWB : 16'bz;

assign stall = (stage1 && opcodeRREX == `lw) ? 1'b1 : 1'b0;

endmodule
