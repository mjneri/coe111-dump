`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:33:38 09/27/2018
// Design Name:   ALU
// Module Name:   /home/ubuntuvm/progs/coe111/me6/tb_alu.v
// Project Name:  me6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_longalu;

	// Inputs
	reg clk;
	reg nrst;
	reg [15:0] opA;
	reg [15:0] opB;
	reg [1:0] opcode;
	reg en;

	// Outputs
	wire [31:0] res;
	wire done;
	wire [4:0] count;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.clk(clk), 
		.nrst(nrst), 
		.opA(opA), 
		.opB(opB), 
		.opcode(opcode), 
		.en(en), 
		.res(res), 
		.done(done),
		.count(count)
	);

	always
		#100 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		opA = 0;
		opB = 0;
		opcode = 0;
		en = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		nrst = 1;
		
		//Sim runs for 5us
		//Test opcode = 00 (addition) ; ++, +-, -+, --
		opA = 16'd111;
		opB = 16'd135;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = 16'd111;
		opB = ~(16'd135) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd111) + 1'b1;
		opB = 16'd135;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd111) + 1'b1;
		opB = ~(16'd135) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		//Test opcode = 11 (comparator) ; ++ >,<,= | -- >,<,= | +- >,= | -+ <,=
		#200;
		opA = 16'd135;
		opB = 16'd111;
		opcode = 2'd3;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = 16'd111;
		opB = 16'd135;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = 16'd107;
		opB = 16'd107;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd135) + 1'b1;
		opB = ~(16'd111) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd111) + 1'b1;
		opB = ~(16'd135) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd107) + 1'b1;
		opB = ~(16'd107) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = 16'd135;
		opB = ~(16'd111) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = 16'd107;
		opB = ~(16'd107) + 1'b1;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd135) + 1'b1;
		opB = 16'd111;
		en = 1;
		#200;
		en = 0;
		
		#200;
		opA = ~(16'd135) + 1'b1;
		opB = 16'd135;
		en = 1;
		#200;
		en = 0;
		
		//Test opcode = 01 (mult); ++, +-, -+, --
		#200;
		opA = 16'd135;
		opB = 16'd111;
		opcode = 2'd1;
		en = 1;
		#200;
		en = 0;
		
		#3400;
		opA = 16'd135;
		opB = ~(16'd111) + 1'b1;
		opcode = 2'd1;
		en = 1;
		#200;
		en = 0;
		
		#3400;
		opA = ~(16'd135) + 1'b1;
		opB = 16'd111;
		opcode = 2'd1;
		en = 1;
		#20;
		en = 0;
		
		#3400;
		opA = ~(16'd135) + 1'b1;
		opB = ~(16'd111) + 1'b1;
		opcode = 2'd1;
		en = 1;
		#200;
		en = 0;
		
		//test opcode = 10 (div) ; ++, +-, -+, --
		#3400;
		opA = 16'h7eed;
		opB = 16'h105;
		opcode = 2'd2;
		en = 1;
		#200;
		en = 0;
		
		#3400;
		opA = 16'h7eed;
		opB = ~(16'h105) + 1'b1;
		opcode = 2'd2;
		en = 1;
		#200;
		en = 0;
		
		#3400;
		opA = ~(16'h7eed) + 1'b1;
		opB = 16'h105;
		opcode = 2'd2;
		en = 1;
		#200;
		en = 0;
		
		#3400;
		opA = ~(16'h7eed) + 1'b1;
		opB = ~(16'h105) + 1'b1;
		opcode = 2'd2;
		en = 1;
		#200;
		en = 0;
		
		#10000;
		$finish;
	end
      
endmodule

