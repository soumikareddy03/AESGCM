`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 12:45:19
// Design Name: 
// Module Name: opt_aes256_tb
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


module opt_aes256_tb;
    reg clk;
    reg rst;
    reg start;
    reg [127:0] plaintext;
   logic [127:0] roundkey[0:14];
   logic[127:0] ciphertext;
   logic done;
    
    
     opt_aes256 DUT (
        .clk(clk),.rst(rst),.start(start),.plaintext(plaintext),.roundkey(roundkey),
        .ciphertext(ciphertext),.done(done));
    
    always #5 clk = ~clk;
    initial begin
 
	
        clk = 0;
        rst = 1;
        start = 0;
	
       plaintext = 128'hc0ffeec0ffeec0ffeec0ffee00000002;
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
               
        #20
        rst = 0;

        @(posedge clk)
        start = 1;

     @(posedge clk)
        start = 0;

	wait(done);

        $display("--------------------------------");
        $display("Ciphertext = %h", ciphertext);
        $display("--------------------------------");
        #10
        $finish;

    end

endmodule
