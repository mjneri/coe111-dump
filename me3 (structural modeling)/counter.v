`timescale 1ns / 1ps

// 4-bit counter

module counter(
	clk,
	clr,
	en,
	out
    );
	
	input clk, clr, en;
	output [3:0] out;
	
	reg [3:0] out;
	
	always@(posedge clk) begin
		if (clr) 
			out <= 0;
		else
			if (en)
				out <= out + 1;
	end

endmodule