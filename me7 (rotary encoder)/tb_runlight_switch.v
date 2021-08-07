`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:28:35 10/11/2018
// Design Name:   runlight_switch
// Module Name:   C:/Users/MJ/Documents/UP Diliman/4th Year/1st Sem/CoE 111/coe111/me7/tb_runlight_switch.v
// Project Name:  me7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: runlight_switch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_runlight_switch;

	// Inputs
	reg clk;
	reg nrst;
	reg dir;

	// Outputs
	wire [7:0] light;

	// Instantiate the Unit Under Test (UUT)
	runlight_switch uut (
		.clk(clk), 
		.nrst(nrst), 
		.dir(dir), 
		.light(light)
	);

	always
		#10 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		dir = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		//test dir = 1;
		nrst = 1;
		
		#200;
		dir = 1;
		
		#200;
		nrst = 0;
		
		#40;
		$finish;
	end
      
endmodule

