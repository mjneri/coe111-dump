`timescale 1ns / 1ps

// D flip-flop

module dff(
	clk,
	nrst,
	D,
	Q
    );

	input clk;
	input nrst;
	input D;
	output Q;
	
	reg Q;
	
	always@(posedge clk) begin
		if (!nrst) 
			Q <= 0;
		else
			Q <= D;
	end
	
endmodule