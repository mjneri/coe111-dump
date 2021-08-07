`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:45:32 11/28/2018 
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
	input rst,
	input rotA,
	input rotB,
	input rot_center,
	input btn_north,
	input btn_south,
	input btn_east,
	input btn_west,
	output [7:4] DB,
	output LCD_E,
	output LCD_RS,
	output LCD_RW
	);

	wire rotated, dir;
	wire dbcenter, dbnorth, dbsouth, dbeast, dbwest;
	
	wire buf_full;
	wire en, cmd;
	wire [7:0] data;
	wire init_done, busy;
	wire [7:0] buf_data;
	wire buf_cmd, buf_en;
	
	rot_decode u_decode(clk, rst, rotA, rotB, rotated, dir);
	btn_debounce u_debounce(clk, rst, rot_center, btn_north, btn_south, btn_east, btn_west, dbcenter, dbnorth, dbsouth, dbeast, dbwest);
	rot_interface u_interface(clk, rst, buf_full, rotated, dir, dbcenter, dbnorth, dbsouth, dbeast, dbwest, en, cmd, data);
	
	buffer u_buffer(clk, rst, data, cmd, en, init_done, busy, buf_data, buf_cmd, buf_en, buf_full);
	lcd_cont u_lcd(clk, rst, buf_en, buf_cmd, buf_data, DB, LCD_E, LCD_RS, LCD_RW, busy, init_done);
endmodule
