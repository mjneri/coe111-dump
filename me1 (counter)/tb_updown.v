`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:43:31 08/16/2018
// Design Name:   updown
// Module Name:   C:/CoE111_ME01_201500244/tb_updown.v
// Project Name:  CoE111_ME01_201500244
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: updown
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_updown;

	// Inputs
	reg clk;
	reg nrst;

	// Outputs
	wire [3:0] count;

	// Instantiate the Unit Under Test (UUT)
	updown uut (
		.clk(clk), 
		.nrst(nrst), 
		.count(count)
	);

	always
		#5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		nrst = 1'b1;
		#500;
		$finish;

	end
      
endmodule

