`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:58:53 11/28/2018 
// Design Name: 
// Module Name:    init_fsm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module init_fsm(
    input clk,
    input rst,
    output reg [3:0] data,
    output reg [6:0] cstate
    );

// Initialization FSM
// Active only when resetting the whole controller
// data -> 4 bit nibble to be sent to lcd

	reg [6:0] nstate;
	reg [31:0] count;

// Defining counter behavior
	always@(posedge clk or posedge rst) begin
		if(rst)
			count = 0;
		else begin
			case(cstate)
				7'h45, 7'h7f: count = 32'hffffffff;
				default: count = count + 1;	// increment counter
			endcase
		end
	end
	
// Next state transition and output assignment
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			data = 0;
			cstate = 0;
		end else begin
			cstate = nstate;
			
			// Output assignments
			case(cstate)
// Initialization sequence as described in the FPGA starter guide
				7'h0: data = 0;
				7'h1: data = 4'h3;
				7'h2: data = 4'h3;
				7'h3: data = 4'h3;
				7'h4: data = 4'h3; 
				7'h5:	data = 4'h3; 
				7'h6: data = 4'h3; 
				7'h7: data = 4'h2; 
				7'h8: data = 4'h2;
				
// After 2,500 clock cycles, display "LCD Ready"
//	LCD_E is on only when sending commands
				7'h9:	data = 4'h2; 			// Function set, upper nibble
				7'ha: data = 4'h2; 			// deassert LCD_E
				7'hb: data = 4'h8; 			// Function set, lower nibble
				7'hc: data = 4'h8; 			// deassert LCD_E
				
				7'hd: data = 4'h0; 			// Entry mode set, upper nibble
				7'he: data = 4'h0; 			// deassert LCD_E
				7'hf: data = 4'h6; 			// Entry mode set, lower nibble
				7'h10: data = 4'h6;			// deassert LCD_E
				
				7'h11: data = 4'h0;  		// Display on/off, upper nibble
				7'h12: data = 4'h0;			// deassert LCD_E
				7'h13: data = 4'hf;			// Display on/off, lower nibble
				7'h14: data = 4'hf;			// deassert LCD_E
				
				7'h15: data = 4'h0; 		// Clear display, upper nibble
				7'h16: data = 4'h0; 		// deassert LCD_E
				7'h17: data = 4'h1; 		// Clear display, lower nibble
				7'h18: data = 4'h1; 		// deassert LCD_E
				
// After clear display, wait 100,000 clock cycles before sending characters
// When sending commands, LCD_RS is 0; Sending the characters,
// LCD_RS is asserted.
				7'h19: data = 4'h8; 		// Set DDRAM addr, upper nibble
				7'h1a: data = 4'h8; 		// deassert LCD_E
				7'h1b: data = 4'h0;  		// Set DDRAM addr, lower nibble
				7'h1c: data = 4'h0; 		// deassert LCD_E
				
				7'h1d: data = 4'h4; 		// L, upper nibble
				7'h1e: data = 4'h4; 		// deassert LCD_E
				7'h1f: data = 4'hc;  		// L, lower nibble
				7'h20: data = 4'hc; 		// deassert LCD_E
				
				7'h21: data = 4'h4;  		// C, upper nibble
				7'h22: data = 4'h4; 		// deassert LCD_E
				7'h23: data = 4'h3;  		// C, lower nibble
				7'h24: data = 4'h3;			// deassert LCD_E
				
				7'h25: data = 4'h4;			// D, upper nibble
				7'h26: data = 4'h4;			// deassert LCD_E
				7'h27: data = 4'h4;			// D, lower nibble
				7'h28: data = 4'h4;			// deassert LCD_E
				
				7'h29: data = 4'hc;			// Set DDRAM addr to 2nd line
				7'h2a: data = 4'hc;			// deassert LCD_E
				7'h2b: data = 4'h0;			// lower nibble
				7'h2c: data = 4'h0;			// deassert LCD_E
				
				7'h2d: data = 4'h5;			// R, upper nib
				7'h2e: data = 4'h5;			// deassert LCD_E
				7'h2f: data = 4'h2;			// R, lower nib
				7'h30: data = 4'h2;			// deassert LCD_E
				
				7'h31: data = 4'h6;			// e, upper nib
				7'h32: data = 4'h6;			// deassert LCD_E
				7'h33: data = 4'h5;			// e, lower nib
				7'h34: data = 4'h5;			// deassert LCD_E
				
				7'h35: data = 4'h6;			// a, upper nib
				7'h36: data = 4'h6;			// deassert LCD_E
				7'h37: data = 4'h1;			// a, lower nib
				7'h38: data = 4'h1;			// deassert LCD_E
				
				7'h39: data = 4'h6;			// d, upper nib
				7'h3a: data = 4'h6;			// deassert LCD_E
				7'h3b: data = 4'h4;			// d, lower nib
				7'h3c: data = 4'h4;			// deassert LCD_E
				
				7'h3d: data = 4'h7;			// y, upper nib
				7'h3e: data = 4'h7;			// deassert LCD_E
				7'h3f: data = 4'h9;			// y, lower nib
				7'h40: data = 4'h9;			// deassert LCD_E

// After displaying "LCD Ready", wait for 1s before clearing display
				7'h41: data = 4'h0;			// clear display, upper nib
				7'h42: data = 4'h0;			// deassert LCD_E
				7'h43: data = 4'h1;			// lower nib
				7'h44: data = 4'h1;			// deassert LCD_E
				
// After clear display, wait for 100,000 cycles
// before deasserting <busy> signal.
				7'h45: data = 4'h0;			// after 100,000 cycles
				
// After deasserting LCD_E, wait for at least 10 clock cycles
// Before disabling counter and going to done(7f) state
				7'h7f: data = 0;
				default: data = data;
			endcase
		end
	end

// ********************************************************************************************************************
// Next state assignment
// First 6 bits of counter add a delay of 1.26us to the other bits.
// Makes sure that nstate is set for longer, avoiding glitches
// when implemented in the FPGA.
	always@(*) begin
		case(cstate)
			7'h00: nstate = (count[31:6]==26'd12000)? 7'h01 : 7'h00;			// init state
			
			7'h01: nstate = (count[31:6]==26'd12001)? 7'h02 : 7'h01;			// after ~15ms (12,000*1.26us)
			7'h02: nstate = (count[31:6]==26'd16001)? 7'h03 : 7'h02;			// after ~1us (1*1.26us)
			7'h03: nstate = (count[31:6]==26'd16002)? 7'h04 : 7'h03;			// after ~5ms (4,000*1.26us)
			7'h04: nstate = (count[31:6]==26'd16082)? 7'h05 : 7'h04;			// after ~1us
			7'h05: nstate = (count[31:6]==26'd16083)? 7'h06 : 7'h05;			// after ~100us (80*1.26us)
			7'h06: nstate = (count[31:6]==26'd16123)? 7'h07 : 7'h06;			// after ~1us
			7'h07: nstate = (count[31:6]==26'd16124)? 7'h08 : 7'h07;			// after ~50us (40*1.26us)
			7'h08: nstate = (count[31:6]==26'd16164)? 7'h09 : 7'h08;			// after ~1us
			
			7'h09: nstate = (count[31:6]==26'd16165)? 7'h0a : 7'h09;			// after ~50us, send Function_set upper nibble
			
// Let counter desccribe the timing needed for sending the nibbles
// Each nibble is spaced 2us(2*1.26us) apart, and each command is spaced at least
// 50us(40*1.26us) apart.
// When nibbles are being sent, LCD_E is asserted for 1us(1*1.26us) only
// before deasserting.

			7'h0a: nstate = (count[31:6]==26'd16167)? 7'h0b : 7'h0a;			// deassert LCD_E
			7'h0b: nstate = (count[31:6]==26'd16168)? 7'h0c : 7'h0b;			// sending Function set lower nibble
			7'h0c: nstate = (count[31:6]==26'd16208)? 7'h0d : 7'h0c;			// deassert LCD_E
			
			7'h0d: nstate = (count[31:6]==26'd16209)? 7'h0e : 7'h0d;			// Entry mode set u.n.
			7'h0e: nstate = (count[31:6]==26'd16211)? 7'h0f : 7'h0e;			// deassert LCD_E
			7'h0f: nstate = (count[31:6]==26'd16212)? 7'h10 : 7'h0f;			// lower nibble
			7'h10: nstate = (count[31:6]==26'd16252)? 7'h11 : 7'h10;			// deassert LCD_E
			
			7'h11: nstate = (count[31:6]==26'd16253)? 7'h12 : 7'h11;			// Display on/off u.n.
			7'h12: nstate = (count[31:6]==26'd16255)? 7'h13 : 7'h12;			// deassert LCD_E
			7'h13: nstate = (count[31:6]==26'd16256)? 7'h14 : 7'h13;			// lower nibble
			7'h14: nstate = (count[31:6]==26'd16296)? 7'h15 : 7'h14;			// deassert LCD_E
			
			7'h15: nstate = (count[31:6]==26'd16297)? 7'h16 : 7'h15;			// Clear display
			7'h16: nstate = (count[31:6]==26'd16299)? 7'h17 : 7'h16;			// deassert LCD_E
			7'h17: nstate = (count[31:6]==26'd16300)? 7'h18 : 7'h17;			// lower nibble
			7'h18: nstate = (count[31:6]==26'd17800)? 7'h19 : 7'h18;			// deassert LCD_E
			
// Pause for 1.64ms (1500*1.26us) after clear display command
			7'h19: nstate = (count[31:6]==26'd17801)? 7'h1a : 7'h19;			// Set DDRAM Address
			7'h1a: nstate = (count[31:6]==26'd17803)? 7'h1b : 7'h1a;			// deassert LCD_E
			7'h1b: nstate = (count[31:6]==26'd17804)? 7'h1c : 7'h1b;			// lower nibble
			7'h1c: nstate = (count[31:6]==26'd17844)? 7'h1d : 7'h1c;			// deassert LCD_E

			7'h1d: nstate = (count[31:6]==26'd17845)? 7'h1e : 7'h1d;			// L
			7'h1e: nstate = (count[31:6]==26'd17847)? 7'h1f : 7'h1e;			// deassert LCD_E
			7'h1f: nstate = (count[31:6]==26'd17848)? 7'h20 : 7'h1f;			// lower nibble
			7'h20: nstate = (count[31:6]==26'd17888)? 7'h21 : 7'h20;			// deassert LCD_E
			
			7'h21: nstate = (count[31:6]==26'd17889)? 7'h22 : 7'h21;			// C
			7'h22: nstate = (count[31:6]==26'd17891)? 7'h23 : 7'h22;			// deassert LCD_E
			7'h23: nstate = (count[31:6]==26'd17892)? 7'h24 : 7'h23;			// lower nibble
			7'h24: nstate = (count[31:6]==26'd17932)? 7'h25 : 7'h24;			// deassert LCD_E
			
			7'h25: nstate = (count[31:6]==26'd17933)? 7'h26 : 7'h25;			// D
			7'h26: nstate = (count[31:6]==26'd17935)? 7'h27 : 7'h26;			// deassert LCD_E
			7'h27: nstate = (count[31:6]==26'd17936)? 7'h28 : 7'h27;			// lower nibble
			7'h28: nstate = (count[31:6]==26'd17976)? 7'h29 : 7'h28;			// deassert LCD_E
			
			7'h29: nstate = (count[31:6]==26'd17977)? 7'h2a : 7'h29;			// DDRAM set (2ndline)
			7'h2a: nstate = (count[31:6]==26'd17979)? 7'h2b : 7'h2a;			// deassert LCD_E
			7'h2b: nstate = (count[31:6]==26'd17980)? 7'h2c : 7'h2b;			// lower nibble
			7'h2c: nstate = (count[31:6]==26'd18020)? 7'h2d : 7'h2c;			// deassert LCD_E
			
			7'h2d: nstate = (count[31:6]==26'd18021)? 7'h2e : 7'h2d;			// R
			7'h2e: nstate = (count[31:6]==26'd18023)? 7'h2f : 7'h2e;			// deassert LCD_E
			7'h2f: nstate = (count[31:6]==26'd18024)? 7'h30 : 7'h2f;			// lower nibble
			7'h30: nstate = (count[31:6]==26'd18064)? 7'h31 : 7'h30;			// deassert LCD_E
			
			7'h31: nstate = (count[31:6]==26'd18065)? 7'h32 : 7'h31;			// e
			7'h32: nstate = (count[31:6]==26'd18067)? 7'h33 : 7'h32;			// deassert LCD_E
			7'h33: nstate = (count[31:6]==26'd18068)? 7'h34 : 7'h33;			// lower nibble
			7'h34: nstate = (count[31:6]==26'd18108)? 7'h35 : 7'h34;			// deassert LCD_E
			
			7'h35: nstate = (count[31:6]==26'd18109)? 7'h36 : 7'h35;			// a
			7'h36: nstate = (count[31:6]==26'd18111)? 7'h37 : 7'h36;			// deassert LCD_E
			7'h37: nstate = (count[31:6]==26'd18112)? 7'h38 : 7'h37;			// lower nibble
			7'h38: nstate = (count[31:6]==26'd18152)? 7'h39 : 7'h38;			// deassert LCD_E
			
			7'h39: nstate = (count[31:6]==26'd18153)? 7'h3a : 7'h39;			// d
			7'h3a: nstate = (count[31:6]==26'd18155)? 7'h3b : 7'h3a;			// deassert LCD_E
			7'h3b: nstate = (count[31:6]==26'd18156)? 7'h3c : 7'h3b;			// lower nibble
			7'h3c: nstate = (count[31:6]==26'd18196)? 7'h3d : 7'h3c;			// deassert LCD_E
			
			7'h3d: nstate = (count[31:6]==26'd18197)? 7'h3e : 7'h3d;			// y
			7'h3e: nstate = (count[31:6]==26'd18199)? 7'h3f : 7'h3e;			// deassert LCD_E
			7'h3f: nstate = (count[31:6]==26'd18200)? 7'h40 : 7'h3f;			// lower nibble
			7'h40: nstate = (count[31:6]==26'd818200)? 7'h41 : 7'h40;			// deassert LCD_E
			
// After displaying "LCD Ready", wait for 1second (800,000*1.26us)
// before clearing the display.

			7'h41: nstate = (count[31:6]==26'd818201)? 7'h42 : 7'h41;			// clear display
			7'h42: nstate = (count[31:6]==26'd818203)? 7'h43 : 7'h42;			// deassert LCD_E
			7'h43: nstate = (count[31:6]==26'd818204)? 7'h44 : 7'h43;			// lower nibble
			7'h44: nstate = (count[31:6]==26'd819704)? 7'h45 : 7'h44;			// deassert LCD_E
			
// After clearing display, wait for 1.64ms (1500*1.26us)
// before accepting inputs
			
			7'h45: nstate = (count[31:6]==26'h3ffffff)? 7'h7f : 7'h45;			// after 1.64ms (1500*1.26us)
			
			7'h7f: nstate = 7'h7f;			// done
		endcase
	end
	
endmodule
