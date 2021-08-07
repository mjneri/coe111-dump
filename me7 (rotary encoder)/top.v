`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:35:23 10/11/2018 
// Design Name: 
// Module Name:    top 
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
module top(
    input clk,
    input nrst,
	 input rotA,
	 input rotB,
    output [7:0] light
    );

	//instantiate modules
	wire /*div_clk,*/ rotated, dir;
	
	//fdiv U1(clk, 1'b1, div_clk);
	rot_decode U1(clk, nrst, rotA, rotB, rotated, dir);
	runlight_switch U2(clk, nrst, rotated, dir, light);

endmodule
