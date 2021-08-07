`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:55 09/13/2018 
// Design Name: 
// Module Name:    vendo 
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
module vendo(
    input clk,
    input nrst,
    input sel_A,
    input sel_B,
    input p_1,
    input p_5,
    output reg disp_A,
    output reg disp_B,
    output reg change
    );

	//define wires
	//wire div_clk, const_rst;
	wire [1:0] sel, coin; //sel_AselB
	reg [4:0] cstate, nstate; //5 bit state
	assign sel = {sel_A, sel_B};
	assign coin = {p_1, p_5};
		
	//define constants
	//assign const_rst = 1'b1;
	
	//instantiate blocks
	//fdiv fdivblk(clk, const_rst, div_clk);

	always@(posedge clk or negedge nrst) begin
		if (!nrst) begin
			disp_A = 1'b0;
			disp_B = 1'b0;
			change = 1'b0;
			cstate = 5'h1;
		end
		else begin
			//state transition
			cstate = nstate;
			case(cstate)
			5'h4: begin
						disp_A = 1'b1;
						disp_B = 1'b0;
						change = 1'b0;
					end
			5'h5, 5'h6:
					begin
						disp_A = 1'b1;
						disp_B = 1'b0;
						change = 1'b1;
					end
			5'h7, 5'h8, 5'h9:
					begin
						disp_A = 1'b0;
						disp_B = 1'b0;
						change = 1'b1;
					end
			5'hd: begin
						disp_A = 1'b0;
						disp_B = 1'b1;
						change = 1'b0;
					end
			5'he, 5'hf, 5'h10:
					begin
						disp_A = 1'b0;
						disp_B = 1'b1;
						change = 1'b1;
					end
			5'h11, 5'h12, 5'h13:
					begin
						disp_A = 1'b0;
						disp_B = 1'b0;
						change = 1'b1;
					end
			default: begin
							disp_A = 1'b0;
							disp_B = 1'b0;
							change = 1'b0;
						end
		endcase
		end
	end

	//next state assignment
	always@(*) begin
		case(cstate)
			5'h1: nstate = (sel == 2'b10)? 5'h2 : ( (sel == 2'b01)? 5'ha : 5'h1);
			5'h2: nstate = (coin == 2'b10)? 5'h3 : ( (coin == 2'b01)? 5'h6 : 5'h2);
			5'h3: nstate = (coin == 2'b10)? 5'h4 : ( (coin == 2'b01)? 5'h5 : 5'h3);
			5'h4: nstate = 5'h1;
			5'h5: nstate = 5'h7;
			5'h6: nstate = 5'h8;
			5'h7: nstate = 5'h8;
			5'h8: nstate = 5'h9;
			5'h9: nstate = 5'h1;
			5'ha: nstate = (coin == 2'b10)? 5'hb : ( (coin == 2'b01)? 5'h10 : 5'ha);
			5'hb: nstate = (coin == 2'b10)? 5'hc : ( (coin == 2'b01)? 5'hf : 5'hb);
			5'hc: nstate = (coin == 2'b10)? 5'hd : ( (coin == 2'b01)? 5'he : 5'hc);
			5'hd: nstate = 5'h1;
			5'he: nstate = 5'h11;
			5'hf: nstate = 5'h12;
			5'h10: nstate = 5'h13;
			5'h11: nstate = 5'h12;
			5'h12: nstate = 5'h13;
			5'h13: nstate = 5'h1;
		endcase
	end

	
endmodule
