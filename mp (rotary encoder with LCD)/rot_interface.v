`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:04 11/28/2018 
// Design Name: 
// Module Name:    rot_interface 
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
module rot_interface(
    input clk,
    input rst,
	 input buf_full,
    input rotated,
    input dir,
    input center,
    input north,
    input south,
    input east,
    input west,
    output reg en,
    output reg cmd,
    output reg [7:0] data
    );

// This module determines the behavior of rotary shaft & friends
// We just map each input to specific commands to be sent to
// the buffer.
// Some inputs send two commands.

	reg [7:0] lcd_pos;			// determines position of cursor in lcd
	reg [3:0] lcd_addr;			// determines display address that the cursor is on
	reg [7:0] lcd_char;			// determines character to be displayed
	reg [4:0] count;				// 5-bit counter
	reg loop_shift;					// determine if shift should be looped
	reg [4:0] cstate, nstate;
	reg cont_rot;					// determine if rotation is continuous
	reg [7:0] lcd_array [103:0];	// determines what char is stored in each DDRAM addr
	integer i = 0;
	
	wire [5:0] detect_input;
	assign detect_input = {rotated, north, south, east, west, center};
	
// input type parameters
	parameter ROTATED = 6'b100000;
	parameter CENTER = 6'b000001;
	parameter NORTH = 6'b010000;
	parameter SOUTH = 6'b001000;
	parameter EAST = 6'b000100;
	parameter WEST = 6'b000010;
	
// states parameters
	parameter S0 = 5'h0;
	
	parameter A1 = 5'h1;		// north/south
	parameter A2 = 5'h2;
	parameter A3 = 5'h3;
	parameter A4 = 5'h4;
	parameter A5 = 5'h5;
	
	parameter B1 = 5'h6;		// west
	parameter B2 = 5'h7;
	parameter B3 = 5'h8;
	parameter B4 = 5'h9;
	parameter B5 = 5'ha;
	parameter B6 = 5'hb;
	parameter B7 = 5'hc;
	
	parameter C1 = 5'hd;		// east
	parameter C2 = 5'he;
	parameter C3 = 5'hf;
	parameter C4 = 5'h10;
	parameter C5 = 5'h11;
	parameter C6 = 5'h12;
	parameter C7 = 5'h13;
	
	parameter D1 = 5'h14;	// rotated
	parameter D2 = 5'h15;		
	parameter D3 = 5'h16;	
	parameter D4 = 5'h17;	
	parameter D5 = 5'h18;
	parameter D6 = 5'h19;
	parameter D7 = 5'h1a;
	
	parameter E1 = 5'h1b;	// center
	
// Output assignments
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			cstate <= S0;
			cont_rot <= 0;
			data <= 0;
			cmd <= 0;
			en <= 0;
			count <= 0;
			loop_shift <= 0;
			lcd_pos <= 0;
			lcd_addr <= 0;
			lcd_char <= 8'h20;
			for(i = 0; i < 104; i = i+1)
				lcd_array[i] <= 8'h20;		// init each char to whitespace 0x20
		end
		else begin
			if(buf_full)
				cstate <= cstate;
			else begin
				cstate <= nstate;
				case(cstate)
					A1:	// NS: setup writing of previous char to ddram
						begin
							cont_rot <= 0;
							cmd <= 0;
							data <= lcd_array[lcd_pos];
						end
						
					A2: en <= 1;	// NS: assert en	
					
					A3:	// NS: deassert en, setup lcd_pos
						begin
							en <= 0;
							if(lcd_pos >= 8'h40)
								lcd_pos <= lcd_pos - 8'h40;
							else
								lcd_pos <= lcd_pos + 8'h40;
						end
						
					A4:	// NS: setup data
						begin
							cmd <= 1;
							data <= lcd_pos + 8'h80;	// Set DDRAM command
						end
						
					A5: en <= 1;	// NS: assert en
	/***********************************************************************************************************/
					B1:	// W: setup writing of previous char to ddram, determine looping shift
						begin
							cont_rot <= 0;
							cmd <= 0;
							data <= lcd_array[lcd_pos];
							
							if(lcd_pos == 8'h00 || lcd_pos == 8'h40)
								loop_shift <= 1;
							else
								loop_shift <= 0;
						end
						
					B2: en <= 1;	// W: assert en
					
					B3:	// W: deassert en, check if loop is done
						begin
							en <= 0;
							if(count == 4'hf)
								loop_shift <= 0;
							else
								if(lcd_pos == 8'h00 || lcd_pos == 8'h40)
									loop_shift <= 1;
								else
									loop_shift <= 0;
						end
						
					B4:	// W: setup data for shifting display/cursor, update lcd_pos & lcd_addr
						begin
							cmd <= 1;
							if(loop_shift) begin
								lcd_pos <= lcd_pos;
								lcd_addr <= lcd_addr;
							end
							else
								if(lcd_pos == 8'h00) begin
									lcd_pos <= 8'h67;
									lcd_addr <= 4'hf;
								end
								else if(lcd_pos == 8'h40) begin
									lcd_pos <= 8'h27;
									lcd_addr <= 4'hf;
								end
								else begin
									lcd_pos <= lcd_pos - 1;
									lcd_addr <= (!lcd_addr)? 4'h0 : lcd_addr - 1;
								end
							
							if(lcd_addr == 4'd0) begin
								data <= 8'h1c;		// display shift right command
							end
							else begin
								data <= 8'h10;		// cursor shift left command
							end
						end
					
					B5:	// W: assert en, increment count
						begin
							en <= 1;
							count <= count + 1;
						end
						
					B6:	// W: deassert en, setup data for DDRAM
						begin
							en <= 0;
							cmd <= 1;
							data <= lcd_pos + 8'h80;
						end
						
					B7: en <= 1;	// W: assert en
	/***********************************************************************************************************/
					C1:	// E: setup writing of previous char to DDRAM, determine looping shift
						begin
							cont_rot <= 0;
							cmd <= 0;
							data <= lcd_array[lcd_pos];
							
							if(lcd_pos == 8'h27 || lcd_pos == 8'h67)
								loop_shift <= 1;
							else
								loop_shift <= 0;
						end
						
					C2: en <= 1;	// E: assert en
					
					C3:	// E: deassert en, check if loop is done
						begin
							en <= 0;
							if(count == 4'hf)
								loop_shift <= 0;
							else
								if(lcd_pos == 8'h27 || lcd_pos == 8'h67)
									loop_shift <= 1;
								else
									loop_shift <= 0;
						end
						
					C4:	// E: setup data for shifting display/cursor, update lcd_pos & ldc_addr
						begin
							cmd <= 1;
							if(loop_shift) begin
								lcd_pos <= lcd_pos;
								lcd_addr <= lcd_addr;
							end
							else
								if(lcd_pos == 8'h27) begin
									lcd_pos <= 8'h40;
									lcd_addr <= 4'h0;
								end
								else if(lcd_pos == 8'h67) begin
									lcd_pos <= 8'h00;
									lcd_addr <= 4'h0;
								end
								else begin
									lcd_pos <= lcd_pos + 1;
									lcd_addr <= (&lcd_addr)? 4'hf : lcd_addr + 1;
								end
							
							if(lcd_addr == 4'hf) begin
								data <= 8'h18;		// display shift left command
							end
							else begin
								data <= 8'h14;		// cursor shift right command
							end
						end
						
					C5:	// E: assert en, increment count
						begin
							en <= 1;
							count <= count + 1;
						end
					
					C6:	// E: deassert en, setup data for DDRAM
						begin
							en <= 0;
							cmd <= 1;
							data <= lcd_pos + 8'h80;	// set DDRAM
						end
					
					C7: en <= 1;	// E: assert en
	/***********************************************************************************************************/				
					D1:		// ROT: set up lcd_char
						begin
							cmd <= 0;
							if(!cont_rot)
								lcd_char <= lcd_array[lcd_pos];
							else
								lcd_char <= lcd_char;
						end
						
					D2:		// ROT: inc/dec lcd_char
						begin
							if(dir) begin	// rot right/cw
								if(lcd_char == 8'h7f)
									lcd_char <= 8'h20;
								else
									lcd_char <= lcd_char + 1;
							end
							else begin	// rot left/ccw
								if(lcd_char == 8'h20)
									lcd_char <= 8'h7f;
								else
									lcd_char <= lcd_char - 1;
							end
						end
						
					D3:		// ROT: setup data, assert cont_rot
						begin
							cont_rot <= 1;
							data <= lcd_char;
						end
						
					D4: en <= 1;	// ROT: assert en
					D5: en <= 0;	// ROT: deassert en
					
					D6:		// ROT: setup returning of cursor
						begin
							cmd <= 1;
							data <= lcd_pos + 8'h80;		// Set DDRAM command
						end
						
					D7: en <= 1;	// ROT: assert en
	/***********************************************************************************************************/				
					E1:	// CENTER: setup data for cursor shift, overwrite character in lcd_array
						begin
							cont_rot <= 0;
							lcd_array[lcd_pos] <= lcd_char;
							cmd <= 1;
							data <= 8'h14;		// cursor shift right command
							
							if(lcd_pos == 8'h27 || lcd_pos == 8'h67)
								loop_shift <= 1;
							else
								loop_shift <= 0;
						end
	/***********************************************************************************************************/				
					default:	// S0; deassert en, reset count
						begin
							en <= 0;
							count <= 0;
						end
				endcase
			end
		end
	end

	always@(*) begin
		case(cstate)
			S0:
				begin
					case(detect_input)
						WEST: nstate <= B1;
						EAST: nstate <= C1;
						ROTATED: nstate <= D1;
						CENTER: nstate <= E1;
						NORTH, SOUTH: nstate <= A1;
						default: nstate <= S0;
					endcase
				end
			A1: nstate <= A2;
			A2: nstate <= A3;
			A3: nstate <= A4;
			A4: nstate <= A5;
			
			B1: nstate <= B2;
			B2: nstate <= B3;
			B3: nstate <= B4;
			B4: nstate <= B5;
			B5: nstate <= B6;
			B6: nstate <= B7;
			B7: nstate <= (loop_shift)? B3 : S0;
			
			C1: nstate <= C2;
			C2: nstate <= C3;
			C3: nstate <= C4;
			C4: nstate <= C5;
			C5: nstate <= C6;
			C6: nstate <= C7;
			C7: nstate <= (loop_shift)? C3 : S0;
			
			D1: nstate <= D2;
			D2: nstate <= D3;
			D3: nstate <= D4;
			D4: nstate <= D5;
			D5: nstate <= D6;
			D6: nstate <= D7;
			
			E1: nstate <= C2;
			default: nstate <= S0;
		endcase
	end
endmodule
