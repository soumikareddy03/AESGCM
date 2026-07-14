module subword(
    input [31:0] word_in,
    output[31:0] word_out
    );
    


wire [7:0] s0,s1,s2,s3;



sbox SB0(
    .a(word_in[31:24]),
    .c(s0)
);

sbox SB1(
    .a(word_in[23:16]),
    .c(s1)
);

sbox SB2(
    .a(word_in[15:8]),
    .c(s2)
);

sbox SB3(
    .a(word_in[7:0]),
    .c(s3)
);

assign word_out = {s0,s1,s2,s3};

endmodule
