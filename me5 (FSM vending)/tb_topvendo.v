`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:13:48 09/20/2018
// Design Name:   top_vendo
// Module Name:   /home/ubuntuvm/progs/coe111/me5/tb_topvendo.v
// Project Name:  me5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_vendo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_topvendo;

	// Inputs
	reg clk;
	reg nrst;
	reg sel_A;
	reg sel_B;
	reg p_1;
	reg p_5;

	// Outputs
	wire disp_A;
	wire disp_B;
	wire change;

	// Instantiate the Unit Under Test (UUT)
	top_vendo uut (
		.clk(clk), 
		.nrst(nrst), 
		.sel_A(sel_A), 
		.sel_B(sel_B), 
		.p_1(p_1), 
		.p_5(p_5), 
		.disp_A(disp_A), 
		.disp_B(disp_B), 
		.change(change)
	);

	always
		#10 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		sel_A = 0;
		sel_B = 0;
		p_1 = 0;
		p_5 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		nrst = 1;
		sel_A = 1;
		#20;
		sel_A = 0;
		#20;
		p_1 = 1;
		#20;
		p_1 = 0;
		p_5 = 1;
		#20;
		p_5 = 0;
		sel_B = 1;
		#20;
		sel_B = 0;
		#20;
		p_1 = 1;
		#20;
		p_1 = 0;
		#20;
		sel_B = 1;
		#20;
		sel_B = 0;
		p_5 = 1;
		#20;
		p_5 = 0;
		#20;
		p_5 = 1;
		#40;
		p_5 = 0;
		sel_A = 1;
		#20;
		sel_A = 0;
		p_1 = 1;
		#20;
		p_1 = 0;
		#20;
		p_1 = 1;
		#20;
		p_1 = 0;
		#20;
		sel_B = 1;
		#20;
		sel_B = 0;
		p_1 = 1;
		#40;
		p_1 = 0;
		p_5 = 1;
		#20;
		p_5 = 0;
		#20;
		sel_A = 1;
		#20;
		sel_A = 0;
		p_1 = 1;
		#20;
		p_1 = 0;
		p_5 = 1;
		#20;
		p_5 = 0;
		
		#40;
		nrst = 0;
		sel_A = 1;
		#20;
		sel_A = 0;
		p_1 = 1;
		#20;
		p_1 = 0;
		p_5 = 1;
		#20;
		p_5 = 0;
		
		#500;
		$finish;
	end
      
endmodule
