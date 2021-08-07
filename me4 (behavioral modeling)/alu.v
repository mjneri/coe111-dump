`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:25 09/06/2018 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [7:0] opA,
    input [7:0] opB,
    input opcode,
    output reg [15:0] res
    );
	
	//define wires
	reg[ 7:0] opA_add, opA_mult, opB_add, opB_mult;
	wire [15:0] add_out, mult_out;

	//demuxes
	always@(opA or opB or opcode)
	begin
		case(opcode)
			1'b0: begin
					opA_add <= opA;
					opB_add <= opB;
					end
			default: begin
						opA_mult <= opA;
						opB_mult <= opB;
						end
		endcase
	end
		
	//instantiate blocks
	adder add(opA_add, opB_add, add_out);
	mult mult(opA_mult, opB_mult, mult_out);
	
	//muxes
	always@(add_out or mult_out or opcode)
	begin
		case(opcode)
			1'b0: res <= add_out;
			default: res <= mult_out;
		endcase
	end
endmodule