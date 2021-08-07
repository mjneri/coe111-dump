`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:59:39 11/28/2018 
// Design Name: 
// Module Name:    timing_fsm 
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
module timing_fsm(
    input clk,
    input rst,
    input en,
    output reg [2:0] cstate
    );

// Timing FSM
// Handles the timing required for sending
// commands and characters to the LCD.
// Starts operating only when <en> is asserted for at least 1 cycle.

	reg [31:0] count;
	
// Define counter behavior
	always@(posedge clk or posedge rst) begin
		if(rst)
			count = 0;
		else begin
			case(cstate)
				3'h0: count = 0;						// If at init state, don't start counter
				default: count = count + 1;		// start the counter
			endcase
		end
	end

// Next state transition and output assignments
	always@(posedge clk or posedge rst) begin
		if(rst)
			cstate = 0;
		else begin
			case(cstate)
// If en is asserted, start the fsm. But if cstate is 0x1, en is deasserted, 
// but the counter has not started incrementing yet, keep cstate at 0x1.
				3'h0: cstate = (en)? 3'h1 : 3'h0;	
			
// When the user sends an input, en is asserted for at least one clock cycle.
// When en is asserted, the timing FSM goes to state 0x1, indicating that
// operation has started, and LCD_E is asserted. Also, when en is asserted,
// the upper nibble is sent to the LCD.

				3'h1: cstate = (count[31:6]==26'd1)? 3'h2 : 3'h1;				// after 1.26us, deassert LCD_E
				3'h2: cstate = (count[31:6]==26'd3)? 3'h3 : 3'h2;				// after 2*1.26us, send lower nibble
				3'h3: cstate = (count[31:6]==26'd4)? 3'h4 : 3'h3;				// after 1.26us, deassert LCD_E
			
// After deasserting LCD_E again, wait for 1500*1.26us before accepting the next
// input from the user.

				3'h4: cstate = (count[31:6]==26'd1504)? 3'h5 : 3'h4;			// after 1500*1.26us, go to buffer state
				3'h5: cstate = (count[31:6]==26'd1505)? 3'h0 : 3'h5;			// after 1.26us, go back to idle state
				default: cstate = 0;
			endcase
		end
	end
endmodule
