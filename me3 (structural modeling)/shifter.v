`timescale 1ns / 1ps

// variable shifter

module shifter(
	data_in,
	sr,
	shamt,
	data_out
    );
	
	input [3:0] data_in;
	input sr;
	input [1:0] shamt;
	output [3:0] data_out;
	
	reg [3:0] data_out;
	
	always@(*) begin
		if (sr) begin
			case(shamt)
				2'd1: data_out = {1'd0, data_in[3:1]};
				2'd2: data_out = {2'd0, data_in[3:2]};
				2'd3: data_out = {3'd0, data_in[3]};
				default: data_out = data_out;
			endcase
		end
		else begin
			case(shamt)
				2'd1: data_out = {data_in[2:0], 1'd0};
				2'd2: data_out = {data_in[1:0], 2'd0};
				2'd3: data_out = {data_in[0], 3'd0};
				default: data_out = data_out;
			endcase
		end
	end

endmodule