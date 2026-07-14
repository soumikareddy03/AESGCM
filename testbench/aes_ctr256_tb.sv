`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:30:43
// Design Name: 
// Module Name: aes_ctr256_tb
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


module aes_ctr256_tb;
    reg clk;
    reg rst;
    reg start;
    reg [127:0] plaintext;
 //   reg plaintext_valid;
    logic[127:0] roundkey[0:14];
    reg[127:0] counter_block;
    logic [127:0] ciphertext;
    logic ciphertext_valid;
    logic done;
    

    aes_ctr256 DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
      //  .plaintext_valid(plaintext_valid),
        .roundkey(roundkey),
        .counter_block(counter_block),
        .ciphertext(ciphertext),
        .ciphertext_valid(ciphertext_valid),
        .done(done)
    );
   
     
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
      //  plaintext_valid = 0;
        plaintext = 128'hd9313225f88406e5a55909c5aff5269a;
       roundkey[0] = 128'h22225555777744447766447777669988;
       roundkey[1] = 128'hccddeeff8899aabb4455667700112233;
       roundkey[2] =128'ha1b19636d6c6d272a1a09605d6c60f8d;
       roundkey[3] = 128'h3a6998a2b2f03219f6a5546ef6b4765d;
       roundkey[4] =128'h2e89da74f84f080659ef9e038f29918e;
       roundkey[5] =128'h49cc19bbfb3c2ba20d997fccfb2d0991;
       roundkey[6] =128'hf2885b7b0ac7537d5328cd7edc015cf0;
       roundkey[7] =128'hcfb05337348c789539150759c2380ec8;
       roundkey[8] =128'hfd23b35ef7e4e023a4cc2d5d78cd71ad;
       roundkey[9] =128'h730df0a2478188377e948f6ebcac81a6;
       roundkey[10] =128'h7c2f973b8bcb77182f075a4557ca2be8;
       roundkey[11] =128'h287901396ff8890e116c0660adc087c6;
       roundkey[12] =128'he63823ae6df354b642f40ef3153e251b;
       roundkey[13] =128'h71cb3e961e33b7980f5fb1f8a29f363e;
       roundkey[14] =128'h7d3d919410cec522523acbd14704eeca;
               
        counter_block  = 128'hc0ffeec0ffeec0ffeec0ffee00000002;

        
        @(posedge clk);
        rst = 0; start = 1;
       //plaintext_valid = 1;
       wait(DUT.aesctr_state == 3'b000); // Wait until FSM reaches LOAD state
        @(posedge clk);
        plaintext = 128'hd9313225f88406e5a55909c5aff5269a; // Block 0 Plaintext

        @(posedge clk); start = 0; 
        

        wait(done);
        @(posedge clk);
        //plaintext_valid = 0; // Turn off validation stream tracking
        
        $display("----------------------------------------------------------------");
        $display("Final Block Ciphertext Output = %h", ciphertext);
        $display("----------------------------------------------------------------");
        #20;
        $finish;
    end

endmodule
