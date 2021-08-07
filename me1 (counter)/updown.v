`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:22 08/16/2018 
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
    output reg [3:0] count
    );

	always@(posedge clk or negedge nrst) begin
		if (!nrst) begin
			count <= 0;
		end
		else begin
			count <= count + 1;
			/*case(count)
				4'b0: count <= 4'b1;
				4'b1: count <= 4'b11;
				4'b11: count <= 4'b10;
				4'b10: count <= 4'b110;
				4'b110: count <= 4'b111;
				4'b111: count <= 4'b101;
				4'b101: count <= 4'b100;
				4'b100: count <= 4'b1100;
				4'b1100: count <= 4'b1101;
				4'b1101: count <= 4'b1111;
				4'b1111: count <= 4'b1110;
				4'b1110: count <= 4'b1010;
				4'b1010: count <= 4'b1011;
				4'b1011: count <= 4'b1001;
				4'b1001: count <= 4'b1000;
				default: count<= 4'b0;
			endcase*/
		end
	end

endmodule
