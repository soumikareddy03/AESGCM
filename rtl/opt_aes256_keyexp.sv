`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 11:44:36
// Design Name: 
// Module Name: opt_aes256_keyexp
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


module opt_aes256_keyexp(
    input clk,
    input rst,
    input start,
    input [255:0] key,
    output logic [127:0] roundkey [0:14],
    output reg roundkey_valid,
    output reg keyexp_done
    );
    
    reg[7:0] rcon;
    reg[1:0] keyexp_state;
    reg[2:0] round;
    reg[3:0] count;
    reg[31:0] w[0:7];
    wire[31:0] w0,w1,w2,w3,w4,w5,w6,w7;
    wire[31:0] nw0,nw1,nw2,nw3,nw4,nw5,nw6,nw7;
    wire[31:0] nnw0,nnw1,nnw2,nnw3,nnw4,nnw5,nnw6,nnw7;
    wire[31:0] g_out1,g_out2,sub_out1,sub_out2;
    integer i;
    assign w0 = key[255:224];     assign w4 = key[127:96];  //Roundkey 0 
    assign w1 = key[223:192];     assign w5 = key[95:64];   //Roundkey 1
    assign w2 = key[191:160];     assign w6 = key[63:32];
    assign w3 = key[159:128];     assign w7 = key[31:0];
  
    subword S1(.word_in(nw3),.word_out(sub_out1)); 
    subword S2(.word_in(nnw3),.word_out(sub_out2));   
    keyexp_gFun G2( .word_in(w[7]),.rc(rcon),.word_out(g_out2));
    keyexp_gFun G1( .word_in(w7),.rc(8'h01),.word_out(g_out1));
    
    assign nw0 = w0 ^ g_out1;     assign nw4 = w4 ^ sub_out1;
    assign nw1 = w1 ^ nw0;        assign nw5 = w5 ^ nw4;
    assign nw2 = w2 ^ nw1;        assign nw6 = w6 ^ nw5;
    assign nw3 = w3 ^ nw2;        assign nw7 = w7 ^ nw6;
   
    assign nnw0 = w[0] ^ g_out2;  assign nnw4 = w[4] ^ sub_out2;
    assign nnw1 = w[1] ^ nnw0;    assign nnw5 = w[5] ^ nnw4;
    assign nnw2 = w[2] ^ nnw1;    assign nnw6 = w[6] ^ nnw5;
    assign nnw3 = w[3] ^ nnw2;    assign nnw7 = w[7] ^ nnw6;
  
always_ff@(posedge clk or posedge rst) begin
    if(rst) begin
       for(i=0;i<15;i++)
            roundkey[i] <= 0;
        keyexp_state     <= 0;
        round           <= 0;
        count           <= 0;
        rcon            <= 8'h01;   
        roundkey_valid  <= 0;
        keyexp_done     <= 0;
    end
    else begin
            keyexp_done     <=0;
            roundkey_valid  <= 0;
        case(keyexp_state)
        2'b00 : begin  if(start) begin
                    w[0] <= nw0;          w[4] <= nw4;
                    w[1] <= nw1;          w[5] <= nw5;
                    w[2] <= nw2;          w[6] <= nw6;
                    w[3] <= nw3;          w[7] <= nw7;  
                    roundkey[count]     <= key[255:128];
                    roundkey[count+1]   <= key[127:0];
                    roundkey[count+2]   <= {nw0,nw1,nw2,nw3};
                    roundkey[count+3]   <= {nw4,nw5,nw6,nw7};
                    roundkey_valid      <= 1;
                    round               <= 1;
                    rcon                <= rcon << 1; 
                    count               <= count + 3; 
                   keyexp_state         <= 2'b01 ;   
               end end
        2'b01: begin
                    w[0] <= nnw0;          w[4] <= nnw4;
                    w[1] <= nnw1;          w[5] <= nnw5;
                    w[2] <= nnw2;          w[6] <= nnw6;
                    w[3] <= nnw3;          w[7] <= nnw7;          
                    roundkey_valid      <= 1;
                    round               <= round + 1;
                    rcon                <= rcon << 1;
                    roundkey[count+1]   <= {nnw0,nnw1,nnw2,nnw3};
                    roundkey[count+2]   <={nnw4,nnw5,nnw6,nnw7};
                    count               <= count + 2;
                    if(round < 5)keyexp_state   <= 2'b01;
                    else keyexp_state           <= 2'b10;
               end 
        2'b10: begin 
                    roundkey[count+1]   <= {nnw0,nnw1,nnw2,nnw3};
                    roundkey_valid      <= 0;
                    keyexp_done         <= 1; 
                    keyexp_state        <= 2'b0;
                    round               <= 0;
                    rcon                <= 8'h01;
              end
        endcase
      end
    end
endmodule

