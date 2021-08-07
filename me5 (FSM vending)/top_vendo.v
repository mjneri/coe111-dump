`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:49 09/20/2018 
// Design Name: 
// Module Name:    top_vendo 
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
module top_vendo(
    input clk,
    input nrst,
    input sel_A,
    input sel_B,
    input p_1,
    input p_5,
    output disp_A,
    output disp_B,
    output change,
	 output div_clkout
    );
	 
	//define wires
	wire div_clk;
	
	//instantiate blocks
	fdiv fdivblk(clk, nrst, div_clk);
	vendo vendoblk(div_clk, nrst, sel_A, sel_B, p_1, p_5, disp_A, disp_B, change);
	assign div_clkout = div_clk;

endmodule
