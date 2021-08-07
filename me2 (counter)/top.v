`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:07:58 08/23/2018 
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
    input dir,
    output [3:0] count
    );

	//instatiate fdiv and updown
	wire div_clk_top;
	fdiv blk1(clk, nrst, div_clk_top);
	updown blk2(div_clk_top, nrst, dir, count);

endmodule
