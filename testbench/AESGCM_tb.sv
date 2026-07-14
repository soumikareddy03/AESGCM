`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 11:26:59
// Design Name: 
// Module Name: AESGCM_tb
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


module AESGCM_tb;
parameter N= 4;
reg clk;
reg rst;
reg start;

reg [127:0] plaintext;
reg plaintext_valid;
reg final_block;
reg [15:0] bitmask;
reg [95:0] IV;
reg [255:0] key;
reg [127:0] aad;
reg [127:0] length;
reg  plaintext_bitselect;
wire [127:0]ciphertext;
wire [127:0] tag;
wire done;

AESGCM #N DUT(
    .clk(clk),
    .rst(rst),
    .start(start),
    .plaintext(plaintext),
    .plaintext_valid(plaintext_valid),
    .final_block(final_block),
    .bitmask(bitmask),
    .plaintext_bitselect(plaintext_bitselect),
    .IV(IV),
    .key(key),
    .aad(aad),
    .length(length),
    .ciphertext(ciphertext),
    //.valid_cipher(valid_cipher),
    .tag(tag),
    .done(done)
);


always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;
    start = 0;
    plaintext_valid = 0;
    final_block = 0;

    // NIST AES-256-GCM Example

    IV  = 96'hbd587321566c7f1a5dd8652d;
     // IV = 96'hc0ffeec0ffeec0ffeec0ffee;
   key = 256'h5fe01c4baf01cbe07796d5aaef6ec1f45193a98a223594ae4f0ef4952e82e330;
//key = 256'h22225555777744447766447777669988ccddeeff8899aabb4455667700112233;
    plaintext = 128'h881DC6C7A5D4509F3C4BD2DAAB08F165;
   // plaintext = 128'hd9313225f88406e5a55909c5aff5269a;
  plaintext_valid = 1;
  plaintext_bitselect = 1;
  
  
    aad = 128'h9013617817dda947e135ee6dd3653382;
    
 //aad = 128'd0;
    
    length = 128'h00000000000000800000000000000198;
    //length = 128'h00000000000000800000000000000100;
    
    #15
     rst = 0;
  
    //-----------------------------------------
    // Start AES-GCM
    //-----------------------------------------

   @(posedge clk);
   start = 1;
     @(posedge clk);
    
    start = 0;
    
  
  
   wait( !DUT.ctr_busy  && DUT.state == 4'b0010 && DUT.block == 1);
   @(posedge clk);
    plaintext_valid = 1;
    plaintext =  128'hddc204489aa8134562a4eac3d0bcad79;
    plaintext_bitselect = 1;
      //plaintext =  128'h86a7a9531534f7da2e4c303d874139e6;
   //final_block = 1;
    ///////////////////////////////////////////////////
 
    wait( !DUT.ctr_busy  && DUT.state == 4'b0010 && DUT.block == 2);
    @(posedge clk);
   plaintext =  128'h65847b102733bb63d1e5c598ece0c3e5;
    plaintext_valid = 1;
     plaintext_bitselect = 1;
    
   
    wait( !DUT.ctr_busy  && DUT.state == 4'b0010 && DUT.block == 3);
    @(posedge clk) ;
    plaintext_valid = 1;
    plaintext =  128'hdadddd00000000000000000000000000;
     plaintext_bitselect = 0;
     bitmask = 16'b1110000000000000;
    final_block = 1;


    

    //-----------------------------------------
    // Wait for completion
    //-----------------------------------------

    wait(done);

    $display("--------------------------------------");
    $display("Ciphertext = %h", ciphertext);
    $display("Tag        = %h", tag);
    $display("--------------------------------------");

    #20;

    $finish;

end

endmodule