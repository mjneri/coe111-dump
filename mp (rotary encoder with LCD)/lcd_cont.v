`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:52:17 11/28/2018 
// Design Name: 
// Module Name:    lcd_cont 
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
module lcd_cont(
    input clk,
    input rst,
	 input en,
    input cmd,
    input [7:0] data,
    output reg [7:4] DB,
    output reg LCD_E,
    output reg LCD_RS,
    output LCD_RW,
	 output reg busy,
	 output init_done
    );

// Use multiple finite state machines to control the operation of the
// controller.
//
// Parts inside the controller:
// 	Main Datapath
//		Initialization FSM - handle LCD initialization
//		Timing constraints FSM - handle the timing constraints needed for sending nibbles

// signals from init_fsm
	wire [6:0] init_state;
	wire [3:0] init_db;			// Data from <init_fsm> that is sent to the LCD
	reg [1:0] init_code;			// {LCD_E, LCD_RS}
	
// signals from timing_fsm
	wire [2:0] timing_state;
	reg [3:0] timing_db;			// Taken from timing_data
	reg [1:0] timing_code;		// {LCD_E, LCD_RS}
	
	reg timing_cmd;				// Taken from input cmd
	reg [7:0] timing_data;				// taken from input data
	
// Instantiate blocks
	wire timing_en;
	assign timing_en = en & init_done;	// timing_fsm can be enabled only when init_done = 1
	
	init_fsm init(clk, rst, init_db, init_state);
	timing_fsm timing(clk, rst, timing_en, timing_state);

// Assigning outputs
	assign init_done = &init_state;		// Assert when init_state = 7'h7f
	
// LCD_RW is never asserted.
	assign LCD_RW = 0;

// Multiplexer for outputs
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			LCD_E = 0;
			LCD_RS = 0;
			DB = 0;
		end else begin
			case(init_done)
				1'b1: 
					begin
						LCD_E = timing_code[1];
						LCD_RS = timing_code[0];
						DB = timing_db;
					end
					
				default: 
					begin
						LCD_E = init_code[1];
						LCD_RS = init_code[0];
						DB = init_db;
					end
			endcase
		end
	end

// Busy is asserted during initialization or
// when timing_fsm is not at its idle/buffer state.
	always@(posedge clk or posedge rst) begin
		if(rst)
			busy = 0;
		else begin
			case(init_done)
				1'b1:										// init_fsm is done
					begin
						if(timing_state == 3'h0 || timing_state == 3'h5)	// timing_fsm is idle | at its buffer state
							busy = 0;
						else								// timing_fsm is active
							busy = 1;
					end
					
				default: busy = 1;
			endcase
		end
	end

// Init FSM Output
// The main datapath takes the output of the Init FSM
// to determine which of the LCD_<> signals to drive.
// init_code = {LCD_E, LCD_RS}
	always@(posedge clk or posedge rst) begin
		if(rst)
			init_code = 0;
		else begin
			case(init_state)
				// Initialization sequence
				7'h1, 7'h3, 7'h5, 7'h7: init_code = 2'b10;
				7'h2, 7'h4, 7'h6, 7'h8: init_code = 2'b00;
				
				// Sending commands
				7'h09, 7'h0b: init_code = 2'b10;		// Function set
				7'h0a, 7'h0c: init_code = 2'b00;		// Deassert LCD_E
				
				7'h0d, 7'h0f: init_code = 2'b10;		// Entry mode set
				7'h0e, 7'h10: init_code = 2'b00;		// Deassert LCD_E
				
				7'h11, 7'h13: init_code = 2'b10;		// Display on/off
				7'h12, 7'h14: init_code = 2'b00;		// deassert LCD_E
				
				7'h15, 7'h17: init_code = 2'b10;		// Clear display
				7'h16, 7'h18: init_code = 2'b00;		// deassert LCD_E
				
				7'h19, 7'h1b: init_code = 2'b10;		// Set DDRAM Addr
				7'h1a, 7'h1c: init_code = 2'b00;		// deassert LCD_E
				
// When sending characters, LCD_RS is asserted
				7'h1d, 7'h1f: init_code = 2'b11;		// L
				7'h1e, 7'h20: init_code = 2'b01;		// deassert LCD_E
				
				7'h21, 7'h23: init_code = 2'b11;		// C
				7'h22, 7'h24: init_code = 2'b01;		// deassert LCD_E
				
				7'h25, 7'h27: init_code = 2'b11;		// D
				7'h26, 7'h28: init_code = 2'b01;		// deassert LCD_E
				
				7'h29, 7'h2b: init_code = 2'b10;		// Set DDRAM Addr
				7'h2a, 7'h2c: init_code = 2'b00;		// deassert LCD_E
				
				7'h2d, 7'h2f: init_code = 2'b11;		// R
				7'h2e, 7'h30: init_code = 2'b01;		// deassert LCD_E
				
				7'h31, 7'h33: init_code = 2'b11;		// e
				7'h32, 7'h34: init_code = 2'b01;		// deassert LCD_E
				
				7'h35, 7'h37: init_code = 2'b11;		// a
				7'h36, 7'h38: init_code = 2'b01;		// deassert LCD_E
				
				7'h39, 7'h3b: init_code = 2'b11;		// d
				7'h3a, 7'h3c: init_code = 2'b01;		// deassert LCD_E
				
				7'h3d, 7'h3f: init_code = 2'b11;		// y
				7'h3e, 7'h40: init_code = 2'b01;		// deassert LCD_E
				
				7'h41, 7'h43: init_code = 2'b10;		// Clear display
				7'h42, 7'h44: init_code = 2'b00;		// deassert LCD_E
				
				default: init_code = 2'b00;	// 100,000 cycles done, can now take inputs
			endcase
		end
	end


// ***************************************************************************************************************
// Timing FSM Output
// The main datapath takes the cstate of the timing FSM
// to determine which nibble to send & what LCD_<> signals
// to drive.
// timing_code = {LCD_E, LCD_RS}
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			timing_code = 0;
			timing_db = 0;
			timing_cmd = 0;
			timing_data = 0;
		end 
		else begin
			case(timing_state)
				// No input yet, set LCD_E to low, set-up upper nibble.
				// While at idle/buffer state, save the inputs cmd and data to registers
				// timing_cmd and timing_data so that when the inputs change
				// while the fsm is operating, the data being sent does not change.
				3'h0, 3'h5: 
						begin
							timing_code = {1'b0, (~timing_cmd)};
							timing_cmd = cmd;
							timing_data = data;
							timing_db = data[7:4];
						end
				
				3'h1:	begin
							timing_code = {1'b1, (~timing_cmd)};		// assert LCD_E
							timing_db = timing_data[7:4];					// send upper nibble
						end
						
				3'h2:	begin
							timing_code = {1'b0, (~timing_cmd)};		// deassert LCD_E
							timing_db = timing_data[3:0];					// setup lower nibble
						end
				
				3'h3: begin
							timing_code = {1'b1, (~timing_cmd)};		// assert LCD_E
							timing_db = timing_data[3:0];					// send lower nibble
						end
						
				3'h4: begin
							timing_code = {1'b0, (~timing_cmd)};		// deassert LCD_E
							timing_db = timing_data[3:0];					// retain
						end
			endcase
		end
	end
endmodule