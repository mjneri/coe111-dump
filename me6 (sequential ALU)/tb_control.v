`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:05:16 09/27/2018
// Design Name:   control
// Module Name:   /home/ubuntuvm/progs/coe111/me6/tb_control.v
// Project Name:  me6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_control;

	// Inputs
	reg clk;
	reg nrst;
	reg [1:0] opcode;
	reg en;

	// Outputs
	wire [4:0] cstate;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.clk(clk), 
		.nrst(nrst), 
		.opcode(opcode), 
		.en(en), 
		.cstate(cstate), 
		.done(done)
	);

	always
		#10 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		opcode = 0;
		en = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		nrst = 1;
		#100;
		en = 1;
		#100;
		en = 0;
		#100;
		opcode = 5'd1;
		#100;
		en = 1;
		#20;
		en = 0;
		

	end
      
endmodule

