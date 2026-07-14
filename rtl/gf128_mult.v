module gf128_mult(
    input [127:0] X,
    input [127:0] H,
    output reg [127:0] Z
);
    
    reg [127:0] V;
    integer i;

always@(*) 
   
    begin
        Z = 128'd0;
        V = H;

        for(i=0;i<128;i=i+1)
        begin
            if(X[127-i])
                Z = Z ^ V;

            if(V[0])
                V = (V >> 1)
                  ^ 128'hE1000000000000000000000000000000;
            else
                V = V >> 1;
        end

 
    end

endmodule