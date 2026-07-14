`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 11:23:37
// Design Name: 
// Module Name: keyexp_gFun
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


module keyexp_gFun(
    input [31:0] word_in,
    input [7:0] rc,
    output [31:0] word_out
    );
    
    wire [31:0] rconj;
    wire [31:0] rotword;
wire [31:0] subword;

wire [7:0] s0,s1,s2,s3;

assign rotword = {word_in[23:0], word_in[31:24]};

sbox SB0(
    .a(rotword[31:24]),
    .c(s0)
);

sbox SB1(
    .a(rotword[23:16]),
    .c(s1)
);

sbox SB2(
    .a(rotword[15:8]),
    .c(s2)
);

sbox SB3(
    .a(rotword[7:0]),
    .c(s3)
);

assign subword = {s0,s1,s2,s3};
    assign rconj = {rc,24'h0};
    assign word_out = subword ^ rconj;
endmodule
