`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 09:55:19
// Design Name: 
// Module Name: ghash
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ghash #(parameter N=2)(
	input clk,
	input rst,
	input [127:0] ciphertext,
	input ciphertext_valid,
	input [127:0] H,
	input [127:0] aad,
	input [127:0] length,
	input [127:0] aes_Y,
	output reg [127:0] ghash_out,
	output wire[127:0]tag,
	output reg done
);

reg[2:0] state;
reg[7:0] block;
reg[127:0] X;

reg[127:0] mult_in;
wire [127:0] mult_out;
 gf128_mult GF1(.X(mult_in),.H(H),.Z(mult_out));                  

always@(posedge clk or posedge rst) begin
	if(rst) begin
		done <= 0;
		state <= 0;
		mult_in <= 0;
		block <= 0;
		X <= 0;
		ghash_out <= 0;
		end
	else begin
		case(state)
		0 : begin
			done <= 0;
			mult_in <= aad ^ 0;
		    	state <= 1;
		    end
		1 : begin
			X <= mult_out;
			block <= 0;
			state <= 2;
			
		    end
		2: begin
			if(ciphertext_valid) begin
			mult_in <= X ^ ciphertext[127:0];
		        state <=3;
			end
			
		   end
		3 : begin
			X <= mult_out;
			if(block == N-1) 
				state <=4;
			else begin
				block <= block + 1;
				state <=2;
			     end
			end
		4 : begin
			mult_in <= X ^ length;
			state <=5;
			end
		5 : begin 
			X <= mult_out;
			ghash_out <= mult_out;
			done <=1;
		    end
		endcase
	end
end
assign tag = ghash_out ^ aes_Y;
endmodule 
