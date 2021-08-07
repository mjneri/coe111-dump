`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:19 09/27/2018 
// Design Name: 
// Module Name:    control 
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
module control(
    input clk,
    input nrst,
    input [1:0] opcode,
    input en,
    output reg [4:0] cstate,
    output reg done
    );
	// 0 = init state; 1-16 = mul & div states; 31 = add & compare state; 20 = "holding" state, waiting for new operation
	//Gray counter implementation (to avoid unexpected clocking of registers in the datapath)	
	reg [4:0] nstate;
	
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			cstate = 0;
			done = 0;
		end
		else begin
			cstate = nstate;
			case(cstate)
				5'b00000: done = 0;
				5'b11000: done = 0;
				5'b10001: done = 1;
				5'b10000: done = 0;
				default: done = 0;
			endcase
		end
	end
	
	//Next state assignment
	always@(*) begin
		case(cstate)
			5'b00000: nstate <= (en)? ( (opcode==2'd0 || opcode==2'd3)? 5'b10000 : 5'b00001) : 5'b00000;	//s0
			5'b10001: nstate <= (en)? ( (opcode==2'd0 || opcode==2'd3)? 5'b10000 : 5'b00001) : 5'b10001;	//s20
			5'b10000: nstate <= 5'b10001; //s31
			5'b00001: nstate <= 5'b00011;	//s1
			5'b00011: nstate <= 5'b00010;	//s2
			5'b00010: nstate <= 5'b00110;	//s3
			5'b00110: nstate <= 5'b00111;	//s4
			5'b00111: nstate <= 5'b00101;	//s5
			5'b00101: nstate <= 5'b00100;	//s6
			5'b00100: nstate <= 5'b01100;	//s7
			5'b01100: nstate <= 5'b01101;	//s8
			5'b01101: nstate <= 5'b01111;	//s9
			5'b01111: nstate <= 5'b01110;	//s10
			5'b01110: nstate <= 5'b01010;	//s11
			5'b01010: nstate <= 5'b01011;	//s12
			5'b01011: nstate <= 5'b01001;	//s13
			5'b01001: nstate <= 5'b01000;	//s14
			5'b01000: nstate <= 5'b11000;	//s15
			5'b11000: nstate <= 5'b10001;	//s16
			default: nstate <= 5'b00000;
		endcase
	end

endmodule
