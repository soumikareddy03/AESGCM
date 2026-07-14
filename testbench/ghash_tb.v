`timescale 1ns/1ps

module ghash_tb;

parameter N = 4;

reg clk;
reg rst;
reg start;
reg last_block;
reg [127:0] ciphertext;
reg ciphertext_valid;
reg [127:0] H;
reg [127:0] aad;
reg [127:0] length;
reg [127:0] aes_Y;

wire [127:0] ghash_out;
wire [127:0] tag;
wire done;
ghash #(N) DUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .last_block(last_block),
    .ciphertext(ciphertext),
    .ciphertext_valid(ciphertext_valid),
    .H(H),
    .aad(aad),
    .length(length),
    .aes_Y(aes_Y),
    .ghash_out(ghash_out),
    .tag(tag),
    .done(done)
);

always @(posedge clk)
begin
    $display("T=%0t state=%0d  valid=%b done=%b",
             $time,
             DUT.state,
            
             ciphertext_valid,
             done);
end
always #5 clk = ~clk;


initial begin

    clk = 0;
    rst = 1;
    start = 0;
    ciphertext       = 0;
    ciphertext_valid = 0;
    last_block  = 0;

    H =
    128'habf1b2317fa217f1084fe6d1318d9e23;
    aad =
    128'h9013617817dda947e135ee6dd3653382;

    length =
    128'h00000000000000800000000000000198;

    aes_Y = 128'h949a851ce96507316b3dfea093276649;
    //128'h949a851ce96507316b3dfea093276649;

   @(posedge clk);
    start = 1;
    rst = 0;
   
   
    
    wait(DUT.state==2  );
    @(negedge clk);
    ciphertext_valid = 1'b1;
    ciphertext =
    128'h16e375b4973b339d3f746c1c5a568bc7;
    start = 0;     

    repeat(2)@(posedge clk);
    ciphertext_valid = 1'b0;


    wait(DUT.state==2 );
    @(negedge clk);
    ciphertext_valid = 1'b1;
    ciphertext =
    128'h526e909ddff1e19c95c94a6ccff210c9;
        

    repeat(2)@(posedge clk);
    ciphertext_valid = 1'b0;


 wait(DUT.state==2);
    @(negedge clk);
    ciphertext_valid = 1'b1;
    ciphertext =
    128'ha4a40679de5760c396ac0e2ceb1234f9;
         
    repeat(2)@(posedge clk);
    ciphertext_valid = 1'b0;
    
    
     wait(DUT.state==2 );
    @(negedge clk);
    ciphertext_valid = 1'b1;
    ciphertext =
   128'hf5fe2600000000000000000000000000;
   
    
     last_block = 1;   
    repeat(2)@(posedge clk);
    ciphertext_valid = 1'b0;
    
     
    wait(done);

    
    $display("GHASH_OUT = %h", ghash_out);
    $display("TAG       = %h", tag);
    $display("DONE      = %b", done);
     
    #20;
    $finish;

end

endmodule