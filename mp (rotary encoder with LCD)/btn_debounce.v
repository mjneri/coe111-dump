`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:41 11/28/2018 
// Design Name: 
// Module Name:    btn_debounce 
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
module btn_debounce(
    input clk,
    input rst,
    input rot_center,
    input btn_north,
    input btn_south,
    input btn_east,
    input btn_west,
    output reg dbcenter,
    output reg dbnorth,
    output reg dbsouth,
    output reg dbeast,
    output reg dbwest
    );

	// assume each input becomes stable after ~20ms
	
	reg [20:0] count;		// 21 bit count
	
	wire in;		// determine if there was an input
	assign in = |{rot_center, btn_north, btn_south, btn_east, btn_west};
	
	wire max;
	assign max = count[20];	// determine if first 20 bits exceeded max value (20ms passed)
	
	reg [1:0] cstate;		// state for fsm
	
	// counter behavior
	always@(posedge clk or posedge rst) begin
		if(rst)
			count <= 0;
		else
			case(cstate)
				2'b00: count <= 0;
				2'b01: count <= count + 1;
				default: count <= count;
			endcase
	end
	
	// output assignment & state transition
	always@(posedge clk or posedge rst) begin
		if(rst)
			cstate <= 0;
		else
			case(cstate)
				2'b00: cstate <= (in)? 2'b01 : 2'b00;
				2'b01: cstate <= (max)? 2'b10 : 2'b01;
				2'b10: cstate <= (in)? 2'b11 : 2'b00;
				default: cstate <= (in)? 2'b11 : 2'b00;
			endcase
	end
	
	// output, pulse only for one cycle
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			dbcenter <= 0;
			dbnorth <= 0;
			dbsouth <= 0;
			dbeast <= 0;
			dbwest <= 0;
		end
		else begin
			case(cstate)
				2'b10:
					begin
						dbcenter <= rot_center;
						dbnorth <= btn_north;
						dbsouth <= btn_south;
						dbeast <= btn_east;
						dbwest <= btn_west;
					end
					
				default:
					begin
						dbcenter <= 0;
						dbnorth <= 0;
						dbsouth <= 0;
						dbeast <= 0;
						dbwest <= 0;
					end
			endcase
		end
	end
	
endmodule
