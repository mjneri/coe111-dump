`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:03:15 10/11/2018
// Design Name:   rot_decode
// Module Name:   C:/Users/MJ/Documents/UP Diliman/4th Year/1st Sem/CoE 111/coe111/me7/tb_rot_decode.v
// Project Name:  me7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rot_decode
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_rot_decode;

	// Inputs
	reg clk;
	reg nrst;
	reg rotA;
	reg rotB;

	// Outputs
	wire rotated;
	wire dir;

	// Instantiate the Unit Under Test (UUT)
	rot_decode uut (
		.clk(clk), 
		.nrst(nrst), 
		.rotA(rotA), 
		.rotB(rotB), 
		.rotated(rotated), 
		.dir(dir)
	);

	always
		#10 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		rotA = 0;
		rotB = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		nrst = 1;
		//test left direction(CCW)
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
		rotB = 1;
		#10;
		rotA = 1;
		#10;
		rotB = 0;
		#10;
		rotA = 0;
		#20;
		
	end
      
endmodule

