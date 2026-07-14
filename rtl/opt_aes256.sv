`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 12:26:23
// Design Name: 
// Module Name: opt_aes256
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2026 10:27:42
// Design Name: 
// Module Name: opt_aes256
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
module opt_aes256(   
    input clk,
    input rst,
    input start,
    input [127:0] plaintext,
    input logic [127:0] roundkey[0:14],
    output logic [127:0] ciphertext,
    output logic done
    );

reg [1:0] aes_state;
reg[3:0] round;
reg[127:0]state_reg,state0;
wire[127:0] state_next;
wire [127:0] round1_state;
wire [127:0] sb,sr, mc,sb0,sr0, mc0,sb1,sr1, mc1;
wire [127:0]input_state ;
reg [3:0] index;
subbytes SB0(.data_in(input_state), .data_out(sb0));
shiftrows SR0(.data_in(sb0), .data_out(sr0));
mixcolumns MC0(.data_in(sr0), .data_out(mc0));

subbytes SB(.data_in(state_reg), .data_out(sb));
shiftrows SR(.data_in(sb), .data_out(sr));
mixcolumns MC(.data_in(sr), .data_out(mc));

subbytes SB1(.data_in(round1_state), .data_out(sb1));
shiftrows SR1(.data_in(sb1), .data_out(sr1));
mixcolumns MC1(.data_in(sr1), .data_out(mc1));


 assign input_state = plaintext ^ roundkey[0];
 assign round1_state = mc ^ roundkey[index+1];
 assign state_next = mc1 ^ roundkey[index+2];
 always@(posedge clk or posedge rst) begin
        if(rst) begin
            done        <= 0;
            aes_state   <= 0;
            round       <= 0;
            state_reg   <= 0;
            state0      <= 0;
            index       <= 0;
            ciphertext  <= 0;
       end
       else begin
           done <= 1'b0;
        case(aes_state)
        2'b00 : begin if(start) begin
                state0      <= mc0 ^ roundkey[1];
                index       <= 1;
                round       <= 0;
                aes_state   <= 2'b01;
                end
                end
        2'b01: begin
                state_reg   <= state0;
                round       <= 1;
                index       <= 1;
                aes_state   <= 2'b10;
                end     
        2'b10 : begin 
                state_reg   <= state_next;
                index       <= index + 2;
                round       <= round + 1;
                if(round < 6) aes_state <= 2'b10;
                else          aes_state <= 2'b11;
                end
        2'b11: begin
                ciphertext  <= sr ^ roundkey[14];
                done        <= 1;
                state_reg   <= 0;
                aes_state   <= 2'b00;
                end
        endcase
     end
  end
endmodule