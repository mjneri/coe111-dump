`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:32:28 10/11/2018
// Design Name:   top
// Module Name:   C:/Users/MJ/Documents/UP Diliman/4th Year/1st Sem/CoE 111/coe111/me7/tb_top_rotary.v
// Project Name:  me7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top_rotary;

	// Inputs
	reg clk;
	reg nrst;
	reg rotA;
	reg rotB;

	// Outputs
	wire [7:0] light;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.nrst(nrst),
		.rotA(rotA), 
		.rotB(rotB), 
		.light(light)
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
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		rotB = 1;
		#20;
		rotA = 1;
		#20;
		rotB = 0;
		#20;
		rotA = 0;
		#40;
		
		
		//test right direction(CW)
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		rotA = 1;
		#20;
		rotB = 1;
		#20;
		rotA = 0;
		#20;
		rotB = 0;
		#40;
		
		#40;
		$finish;
	end
      
endmodule

