`timescale 1ns / 1ps

// 4-bit adder

module adder(
	A,
	B,
	res
    );

	input [7:0] A, B;
	output [15:0] res;
	
	wire [15:0] res, opA, opB;

	//sign extend A & B
	assign opA = { {8{A[7]}}, A};
	assign opB = { {8{B[7]}}, B};
	assign res = opA + opB;

endmodule