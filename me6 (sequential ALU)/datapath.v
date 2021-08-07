`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:10:37 09/27/2018 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
	 input nrst,
    input [15:0] opA,
    input [15:0] opB,
    input [1:0] opcode,
    input [4:0] cstate,
    output reg [31:0] res
    );

	//define reg + wires
	wire [15:0] mdA, mdB;
	wire [31:0] acA, acB;
	wire [32:0] mdinit;
	wire mdsign;	//sign bit for mult & div
	
	reg s1, s_odd, s_even, s16, s20, s31;
	reg md_even_sel;
	reg [31:0] ac_array;
	reg [32:0] md1, md_odd, md_even, md16; //arrays used in mult & div
	
	//sign extend (32-bit)
	assign acA = { {16{opA[15]}}, opA};
	assign acB = { {16{opB[15]}}, opB};
	
	//negate the operands (if negative), else retain
	assign mdsign = (opA[15])^(opB[15]);
	assign mdA = opA[15]? ((~opA) + 16'd1) : opA;
	assign mdB = opB[15]? {1'b0, ((~opB) + 16'd1)} : {1'b0, opB};
	
	//initialize array used by mult & div
	assign mdinit = {1'b0, {16{1'b0}}, opA[15]? ((~opA) + 16'd1) : opA};
	
	
	//Demux for sending write signals to the registers
	//s0: initial state
	//s20: "holding" state while waiting for inputs
	//s1, s_odd, s_even, s16: mult & div states
	//s31: add & compare state
	always@(cstate) begin
		case(cstate)
			5'b00000: {s1, s_odd, s_even, s16, s20, s31} <= 6'b000000;	//s0
			5'b10001: {s1, s_odd, s_even, s16, s20, s31} <= 6'b000010;	//s20
			5'b10000: {s1, s_odd, s_even, s16, s20, s31} <= 6'b000001; 	//s31
			5'b00001: {s1, s_odd, s_even, s16, s20, s31} <= 6'b100000;	//s1
			5'b00011: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s2
			5'b00010: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s3
			5'b00110: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s4
			5'b00111: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s5
			5'b00101: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s6
			5'b00100: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s7
			5'b01100: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s8
			5'b01101: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s9
			5'b01111: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s10
			5'b01110: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s11
			5'b01010: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s12
			5'b01011: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s13
			5'b01001: {s1, s_odd, s_even, s16, s20, s31} <= 6'b001000;	//s14
			5'b01000: {s1, s_odd, s_even, s16, s20, s31} <= 6'b010000;	//s15
			5'b11000: {s1, s_odd, s_even, s16, s20, s31} <= 6'b000100;	//s16
			default: {s1, s_odd, s_even, s16, s20, s31} <= 6'b000000;
		endcase
	end
	
	//md1 reg (reg that takes contents of mdinit)
	always@(posedge s1 or negedge nrst) begin
		if(!nrst)
			md1 <= 0;
		else begin
			if(opcode==2'b01)	//mul
				if(mdinit[0])
					md1 <= {1'b0, mdinit[32:16] + mdB, mdinit[15:1]};
				else
					md1 <= mdinit;
			else	//div
				if(mdinit[32])
					md1 <= {mdinit[31:15] + mdB, mdinit[14:0], 1'b0};
				else
					md1 <= {mdinit[31:15] + (~mdB) + 1'b1, mdinit[14:0], 1'b0};
		end
	end
	
	//md_even_sel reg (mux selector for md_even reg; choose whether to take md1 or md_odd)
	always@(posedge s_odd or negedge nrst or posedge s20) begin
		if(!nrst)
			md_even_sel <= 1'b0;
		else if(s20)
			md_even_sel <= 1'b0;
		else
			md_even_sel <= 1'b1;
	end
	
	//md_even reg (takes values for even cycles of mul & div except the 16th cycle)
	always@(posedge s_even or negedge nrst) begin
		if(!nrst)
			md_even <= 0;
		else begin
			if(!md_even_sel)	//take input from md1
				if(opcode==2'b01)	//mul
					if(md1[0])
						md_even <= {1'b0, md1[32:16] + mdB, md1[15:1]};
					else
						md_even <= md1 >> 1;
				else	//div
					if(md1[32])
						md_even <= {md1[31:15] + mdB, md1[14:1], 2'b00};
					else
						md_even <= {md1[31:15] + (~mdB) + 1'b1, md1[14:1], 2'b10};
						
			else	//take input from md_odd
				if(opcode==2'b01)	//mul
					if(md_odd[0])
						md_even <= {1'b0, md_odd[32:16] + mdB, md_odd[15:1]};
					else
						md_even <= md_odd >> 1;
				else	//div
					if(md_odd[32])
						md_even <= {md_odd[31:15] + mdB, md_odd[14:1], 2'b00};
					else
						md_even <= {md_odd[31:15] + (~mdB) + 1'b1, md_odd[14:1], 2'b10};
		end
	end
	
	//md_odd reg (takes values for odd cycles except the 1st cycle)
	always@(posedge s_odd or negedge nrst) begin
		if(!nrst)
			md_odd <= 0;
		else begin
			if(opcode==2'b01)
				if(md_even[0])
					md_odd <= {1'b0, md_even[32:16] + mdB, md_even[15:1]};
				else
					md_odd <= md_even >> 1;
			else
				if(md_even[32])
					md_odd <= {md_even[31:15] + mdB, md_even[14:1], 2'b00};
				else
					md_odd <= {md_even[31:15] + (~mdB) + 1'b1, md_even[14:1], 2'b10};
		end
	end
	
	//md16 reg (takes values for the 16th cycle of mul & div)
	always@(posedge s16 or negedge nrst) begin
		if(!nrst)
			md16 <= 0;
		else begin
			if(opcode==2'b01)
				if(md_odd[0])
					md16 <= {1'b0, md_odd[32:16] + mdB, md_odd[15:1]};
				else
					md16 <= md_odd >> 1;
			else
				if(md_odd[32])
					md16 <= {md_odd[31:15] + mdB, md_odd[14:1], 2'b00};
				else
					md16 <= {md_odd[31:15] + (~mdB) + 1'b1, md_odd[14:1], 2'b10};
		end
	end
	
	//res reg (takes the result)
	always@(posedge s20 or negedge nrst) begin
		if(!nrst)
			res <= 0;
		else begin
			if(opcode==2'b01)
				if(mdsign)
					res <= ~(md16[31:0]) + 1'b1;
				else
					res <= md16[31:0];
			else if(opcode==2'b10)
				if(mdsign)
					res <= ~({16'd0, md_odd[14:1], md16[1], ~(md16[32])}) + 1'b1;
				else
					res <= {16'd0, md_odd[14:1], md16[1], ~(md16[32])};
			else
				res <= ac_array;
		end
	end
	
	//ac_array reg
	always@(posedge s31 or negedge nrst) begin
		if(!nrst)
			ac_array <= 0;
		else begin
			if(opcode==2'b00)
				ac_array <= acA + acB;
			else
				if(acA==acB)
					ac_array <= 32'd0;
				else
					if(acA>acB)
						if(mdsign)
							ac_array <= 32'hffffffff;
						else
							ac_array <= 32'd1;
					else
						if(mdsign)
							ac_array <= 32'd1;
						else
							ac_array <= 32'hffffffff;
		end
	end
endmodule
