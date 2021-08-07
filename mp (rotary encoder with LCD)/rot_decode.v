`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:29 11/28/2018 
// Design Name: 
// Module Name:    rot_decode 
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
module rot_decode(
    input clk,
    input rst,
    input rotA,
    input rotB,
    output reg rotated,
    output reg dir
    );

	// dir = 0 -> left, dir = 1 -> right
	//when rotating cw, rotA goes first before rotB
	//when rotating ccw, rotB goes first before rotA
	
	//q1 indicates if switch was rotated. q2 indicates direction
	//q2 = 0 -> left/ccw || q2 = 1 -> right/cw
	
	//rotation is done when both rotA and rotB are asserted
	reg q1, q2, delay_q1;
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			q1 <= 0;
			q2 <= 0;
		end
		else begin
			case({rotA, rotB})
				2'b01: begin	//ccw: q2 = 0
							q1 <= q1;
							q2 <= 0;
						end
				2'b10: begin	//cw: q2 = 1
							q1 <= q1;
							q2 <= 1;
						end
				2'b11: begin
							q1 <= 1;
							q2 <= q2;
						end
				default: begin
							q1 <= 0;
							q2 <= q2;
						end
			endcase
		end
	end
	
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			rotated <= 0;
			dir <= 0;
			delay_q1 <= 0;
		end
		else begin
			delay_q1 <= q1;
			case({q1, delay_q1})
				2'b10: begin
							rotated <= 1;
							dir <= q2;
						 end
				default: begin
								rotated <= 0;
								dir <= dir;
							end
			endcase
		end
	end
endmodule
