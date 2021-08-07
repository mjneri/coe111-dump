`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:54 09/27/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input clk,
    input nrst,
    input [15:0] opA,
    input [15:0] opB,
    input [1:0] opcode,
    input en,
    output [31:0] res,
    output done,
	 output [4:0] cstate
    );

	//instantiate blocks? use control and datapath
	control cnt(clk, nrst, opcode, en, cstate, done);
	datapath data(nrst, opA, opB, opcode, cstate, res);
	
endmodule
