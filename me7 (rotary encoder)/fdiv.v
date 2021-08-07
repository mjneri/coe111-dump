`timescale 1ns / 1ps

// frequency divider

module fdiv(
    input clk,
    input nrst,
    output reg div_clk
    );
	
	reg [23:0] delay;
	
	// delay
	always@(posedge clk or negedge nrst) begin
		if (!nrst) begin
			delay <= 24'b0;
		end
		else begin
			delay <= delay + 1'b1;
		end
	end
	
	// div_clk
	always@(posedge clk or negedge nrst) begin
		if (!nrst) begin
			div_clk <= 0;
		end
		else begin
			if (&delay) div_clk <= ~div_clk;
			else div_clk <= div_clk;
		end
	end
	
endmodule