`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:45 10/11/2018 
// Design Name: 
// Module Name:    runlight_switch 
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
module runlight_switch(
    input clk,
    input nrst,
    //input dir,
	 input rotated,
	 input dir,
    output reg [7:0] light
    );

	always@(posedge clk or negedge nrst) begin
		if(!nrst)
			light <= 8'b1;
		else begin
			/*if(dir)
				if(light==8'b1)
					light <= 8'h80;
				else
					light <= light >> 1;
			else
				if(light==8'h80)
					light <= 8'b1;
				else
					light <= light << 1;*/
			//Rotary switch implementation
			case({rotated, dir})	//dir = 0 -> left || dir = 1 -> right
				2'b11: begin	//right
							if(light==8'b1)
								light <= 8'h80;
							else
								light <= light >> 1;
						 end
				2'b10: begin	//left
							if(light==8'h80)
								light <= 8'b1;
							else
								light <= light << 1;
						 end
				default: light <= light;
			endcase
		end
	end
endmodule
