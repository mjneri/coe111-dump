`timescale 1ns / 1ps

// 4-bit adder

module adder(
	A,
	B,
	res
    );

	input [3:0] A, B;
	output [3:0] res;
	
	wire [3:0] res;

	assign res = A + B;

endmodule