`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:52:46 08/30/2018
// Design Name:   seqgen
// Module Name:   C:/CoE111_ME03_201500244/tb_seqgen.v
// Project Name:  CoE111_ME03_201500244
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: seqgen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_seqgen;

	// Inputs
	reg clk;
	reg nrst;
	reg en;

	// Outputs
	wire [3:0] out;

	// Instantiate the Unit Under Test (UUT)
	seqgen uut (
		.clk(clk), 
		.nrst(nrst), 
		.en(en), 
		.out(out)
	);

	always
		#5 clk = ~clk; //10ns period
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		en = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here
		
		//set en to 1
		en = 1'b1;
		#30
		
		//set nrst to 1
		nrst = 1'b1;
		#100 //10 seconds
		
		//set en to 0
		en = 1'b0;
		#100 //10 seconds
		
		//set en to 1
		en = 1'b0;
		#50 //5 seconds
		
		//nrst
		nrst = 1'b0;
		#100 //1 second
		$finish;
	end
      
endmodule

