module subbytes(

    input [127:0] data_in,
    output [127:0] data_out

);

    genvar i;

    generate

        for(i = 0; i < 16; i = i + 1)
        begin

            sbox S(

                .a(data_in[(127-(i*8)) -: 8]),
                .c(data_out[(127-(i*8)) -: 8])

            );

        end

    endgenerate

endmodule