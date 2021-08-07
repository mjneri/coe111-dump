`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:49:25 09/20/2018
// Design Name:   fdiv
// Module Name:   /home/ubuntuvm/progs/coe111/me5/tb_fdiv.v
// Project Name:  me5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fdiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_fdiv;

	// Inputs
	reg clk;
	reg nrst;

	// Outputs
	wire div_clk;

	// Instantiate the Unit Under Test (UUT)
	fdiv uut (
		.clk(clk), 
		.nrst(nrst), 
		.div_clk(div_clk)
	);

	always
		#10 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		#100000000;
		$finish;
	end
      
endmodule

