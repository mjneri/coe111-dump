`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:17:58 08/30/2018 
// Design Name: 
// Module Name:    seqgen 
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
module seqgen(
    input clk,
    input nrst,
    input en,
    output [3:0] out
    );

	//define wires
	wire div_clk, clr, clrcount, invnrst;
	wire [3:0] cnt1_out;
	wire [3:0] add1_out;
	wire [3:0] shft1_out;
	wire [3:0] add2_out;
	
	wire [3:0] const_a;
	wire [3:0] const_b;
	wire [3:0] const_c;
	wire const_sr, const_rst;
	wire [1:0] const_shamt;
	wire x3, x2, x1, x0; //xnor output
	wire [3:0] cnt1_inv; //inverted counter
	
	//define constants
	assign const_a = 4'b0011; //6
	assign const_b = 4'b1111; //-1
	assign const_c = 4'd1; //1
	assign const_sr = 1'b0; //shift left mode
	assign const_shamt = 2'd1; //shift left 1 bit
	assign const_rst = 1'b1;
	
	//instantiate blocks
	fdiv fdiv(clk, const_rst, div_clk);
	counter cnt1(div_clk, clrcount, en, cnt1_out);
	
	//equality checking
	xnor EQ3(x3, out[3], const_a[3]);
	xnor EQ2(x2, out[2], const_a[2]);
	xnor EQ1(x1, out[1], const_a[1]);
	xnor EQ0(x0, out[0], const_a[0]);
	and EQX(clr, x3, x2, x1, x0);
	
	//invert counter output
	not INV3(cnt1_inv[3], cnt1_out[3]);
	not INV2(cnt1_inv[2], cnt1_out[2]);
	not INV1(cnt1_inv[1], cnt1_out[1]);
	not INV0(cnt1_inv[0], cnt1_out[0]);
	
	//adder 1
	adder add1(cnt1_inv, const_b, add1_out);
	
	//discard msb of adder output using left shift then increment
	shifter shft1(add1_out, const_sr, const_shamt, shft1_out);
	adder add2(shft1_out, const_c, add2_out);
	
	//save output of adder in 4bit reg (4 dffs)
	//dff dff3(div_clk, nrst, add2_out[3], out[3]);
	//dff dff2(div_clk, nrst, add2_out[2], out[2]);
	//dff dff1(div_clk, nrst, add2_out[1], out[1]);
	//dff dff0(div_clk, nrst, add2_out[0], out[0]);
	assign out = add2_out;
	
	//clear counter when nrst is set to 0
	not INVX(invnrst, nrst);
	or OR1(clrcount, invnrst, clr);
	//and AND1(clrcount, clrex, en);

endmodule
