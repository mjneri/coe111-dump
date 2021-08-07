`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:56:29 11/28/2018 
// Design Name: 
// Module Name:    buffer 
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
module buffer(
    input clk,
    input rst,
    input [7:0] data,
    input cmd,
    input en,
    input init_done,
    input busy,
    output reg [7:0] buf_data,
    output reg buf_cmd,
    output reg buf_en,
	 output buf_full
    );

// Handles the buffered inputs from the user/driver and outputs
// a buffered command depending on the timing FSM state.
// Buffer is a FIFO queue.

	reg [8:0] buffer [30:0];		// 31 registers containing 9 bits, format: {cmd, data}
	reg [4:0] buf_count;				// counter for buffer
	reg del_en;							// delayed en
	reg del_busy;						// delayed busy
	
	integer i = 0;						// used in for loop
	
	wire pulse_en;						// single pulse en
	wire pulse_busy;					// single pulse busy
	
	assign pulse_en = en & ~del_en;
	assign pulse_busy = ~(~busy & del_busy);
	
	assign buf_full = &buf_count;	// determine if buf is full; used for rot interface
	
// Buffer input & output
// output only when pulse_busy = 0 and when init_done = 1
// input only when pulse_en = 1
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			buf_data <= 0;
			buf_cmd <= 0;
			buf_en <= 0;
			
			for(i = 0; i < 31; i=i+1)
				buffer[i] <= 0;
			
			buf_count <= 0;
			del_en <= 0;
			del_busy <= 0;
		end
		
		else begin
			del_en <= en;
			del_busy <= busy;
			
			// Set buffer[0] as the output
			buf_data <= buffer[0][7:0];
			buf_cmd <= buffer[0][8];
			
			// assert buf_en when buf_count > 0
			buf_en <= |buf_count;
			
			// Behavior when inputting or outputting
			case({init_done, pulse_en, pulse_busy})
				// input only
				3'b111, 3'b011:
					begin
						// if buffer is full, 'do nothing' (retain previous values)
						if(buf_count == 5'd31) begin
							buffer[30] <= buffer[30];		// retain value of last entry
							buf_count <= buf_count;
						end
						else begin
							buffer[buf_count] <= {cmd, data};
							buf_count <= buf_count + 1;
						end
					end
				
				// output only
				3'b100:
					begin
						// if buffer is empty, 'do nothing' (retain previous values)
						if(buf_count == 5'd0) begin
							buffer[0] <= buffer[0];
							buf_count <= buf_count;
						end
						else begin
							// shift the data s.t. at next cycle, output is updated
							buf_count <= buf_count - 1;
							
							for(i = 0; i < 30; i=i+1)
								buffer[i] <= buffer[i+1];
							buffer[30] <= 0;
						end
					end
				
				// input & output at the same time
				3'b110:
					begin
						buf_count <= buf_count;
						for(i = 0; i < 30; i=i+1)
							buffer[i] <= buffer[i+1];
						buffer[30] <= 0;
						
						buffer[buf_count - 1] <= {cmd, data};
					end
				
				// do nothing
				default:
					begin
						buf_count <= buf_count;
						buffer[buf_count] <= buffer[buf_count];
					end
			endcase
		end
	end
endmodule
