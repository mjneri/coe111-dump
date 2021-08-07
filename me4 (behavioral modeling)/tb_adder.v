`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:35:00 09/06/2018
// Design Name:   adder
// Module Name:   C:/CoE111_ME04_201500244/tb_adder.v
// Project Name:  CoE111_ME04_201500244
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_adder;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;

	// Outputs
	wire [15:0] res;

	// Instantiate the Unit Under Test (UUT)
	adder uut (
		.A(A), 
		.B(B), 
		.res(res)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		A = 8'd67;
		B = 8'd33;
		
		#100
		A = 8'hbd;
		
		#100
		$finish;
	end
      
endmodule

