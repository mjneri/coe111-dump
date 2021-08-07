`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:54:31 09/06/2018
// Design Name:   alu
// Module Name:   C:/CoE111_ME04_201500244/tb_alu.v
// Project Name:  CoE111_ME04_201500244
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_alu;

	// Inputs
	reg [7:0] opA;
	reg [7:0] opB;
	reg opcode;
	
	// Outputs
	wire [15:0] res;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.opA(opA), 
		.opB(opB), 
		.opcode(opcode), 
		.res(res)
	);

	initial begin
		// Initialize Inputs
		opA = 0;
		opB = 0;
		opcode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		//set opA & opB
		opA = 8'd67;
		opB = 8'd33;
		opcode = 1'b0;
		
		#100
		opA = 8'ha3;
		
		#100;
		opB = 8'hda;
		
		#100;
		opA = 8'd54;
		
		#100
		opcode = 1'b1;
		
		#100;
		opA = 8'd67;
		
		#100;
		opB = 8'd33;
		
		#100
		opA = 8'ha3;
		
		#100;
		opB = 8'hda;
		$finish;
	end
      
endmodule

