`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:48 09/06/2018 
// Design Name: 
// Module Name:    mult 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mult(
    input [7:0] A,
    input [7:0] B,
    output [15:0] out
    );
	wire [7:0] opA, opB;

	reg [15:0] partsum;
	
	wire sign;
	
	//set signbit
	assign sign = (A[7])^(B[7]); //xor
	
	//negate the operands (if negative), else retain
	assign opA = A[7]? ((~A) + 8'b1) : A;
	assign opB = B[7]? ((~B) + 8'b1) : B;
			
	//generate partial sum + product
	always@(*)
		begin
			partsum = 0;
			partsum = opA[7]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[6]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[5]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[4]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[3]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[2]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[1]? (opB + partsum) : partsum;
			partsum = partsum << 1;
			partsum = opA[0]? (opB + partsum) : partsum;
		end
		
	assign out = sign? ((~partsum) + 16'b1) : partsum;
	
endmodule
