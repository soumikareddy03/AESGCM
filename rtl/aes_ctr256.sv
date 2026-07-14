`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:23:49
// Design Name: 
// Module Name: aes_ctr256
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


module aes_ctr256(
    input clk,
    input rst,
    input start,
    input [127:0] plaintext,
    input logic[127:0] roundkey[0:14],
    input [127:0] counter_block,
    output logic [127:0] ciphertext,
    output logic ciphertext_valid,
    output logic done
);
    reg [2:0] aesctr_state; 
    reg aes_start;
    reg [127:0] inputtext;
    wire [127:0] encryptedtext;
    wire aes_done;
  
    opt_aes256 DUT(
        .clk(clk),.rst(rst),.start(aes_start),.plaintext(counter_block),
        .roundkey(roundkey),.ciphertext(encryptedtext),.done(aes_done)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            done              <= 0;
            aesctr_state      <= 3'b000;
            ciphertext        <= 0;
            inputtext         <= 0;
            aes_start         <= 0;
            ciphertext_valid  <= 0;
        end else begin
            aes_start <= 1'b0; 
            case (aesctr_state)
            3'b000: begin 
                    done  <= 0;
                    ciphertext_valid <= 0;
                    if (start) begin
                        aes_start       <= 1'b1;  
                        inputtext       <= plaintext;             
                        aesctr_state    <= 3'b001;             
                    end
                end
           3'b001: begin if (aes_done ) begin
                     ciphertext       <= inputtext ^ encryptedtext; 
                     done             <= 1;
                     ciphertext_valid <= 1;
                     aesctr_state     <= 3'b000;            
                   end end
            endcase
        end
    end
endmodule