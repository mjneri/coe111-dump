`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:25 08/23/2018 
// Design Name: 
// Module Name:    updown 
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
module updown(
    input clk,
    input nrst,
    input dir,
    output reg [3:0] count
    );

	always@(posedge clk or negedge nrst) begin
		if (!nrst) begin
			count <= 0;
		end
		else begin
			case (dir)
				1'b1: count <= count + 1;
				default: count <= count - 1;
			endcase
		end
	end

endmodule