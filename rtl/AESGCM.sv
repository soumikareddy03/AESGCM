module AESGCM #(parameter N=4) (
    input clk,
    input rst,
    input start,
    input [127:0] plaintext,
    input plaintext_valid,
    input final_block,
    input plaintext_bitselect,
    input[15:0]bitmask,
    input [95:0] IV,
    input [255:0] key,
    input [127:0] aad,
    input [127:0] length,
    output reg [127:0] ciphertext,
    output wire [127:0] tag,
    output reg done
);
reg[7:0] block;
reg [3:0] state;
reg aes_start1;
reg [127:0] aes_input1;
wire aes_done1;
wire [127:0] aes_output1;
reg ctr_start;
reg ctr_busy;
reg [127:0] ctr_plaintext;
reg [127:0] ctr_counter;
wire [127:0] ctr_ciphertext;
wire ctr_ciphertext_valid;
wire ctr_done;
reg ghash_start;
wire [127:0] ghash_out;
wire ghash_done;
reg [127:0] H;
reg [127:0] aes_Y;
reg [127:0] counter;
reg [127:0] Y_0;
wire [127:0] input_a;
wire [127:0] input_b;
wire [127:0]valid_cipher;
wire [127:0]valid_bits;
logic [127:0] roundkey[0:14];
reg keyexp_start;
wire keyexp_done;
wire roundkey_valid;
reg index;

opt_aes256_keyexp EXP(
.clk(clk),.rst(rst),.start(keyexp_start),.key(key),
.roundkey(roundkey),.roundkey_valid(roundkey_valid),.keyexp_done(keyexp_done)
    );
    
opt_aes256 AES (
    .clk(clk),.rst(rst),.start(aes_start1),.plaintext(aes_input1),.roundkey(roundkey),
    .ciphertext(aes_output1),.done(aes_done1)
);

aes_ctr256 CTR (
    .clk(clk),.rst(rst),.start(ctr_start),
    .plaintext(ctr_plaintext),.roundkey(roundkey),.counter_block(ctr_counter),
    .ciphertext(ctr_ciphertext),.ciphertext_valid(ctr_ciphertext_valid),.done(ctr_done)
);
assign valid_bits = {
    {8{bitmask[15]}},{8{bitmask[14]}},{8{bitmask[13]}},{8{bitmask[12]}},
    {8{bitmask[11]}},{8{bitmask[10]}},{8{bitmask[9]}},{8{bitmask[8]}},
    {8{bitmask[7]}},{8{bitmask[6]}},{8{bitmask[5]}}, {8{bitmask[4]}},
    {8{bitmask[3]}},{8{bitmask[2]}},{8{bitmask[1]}},{8{bitmask[0]}}
};
                        
assign input_a = ctr_ciphertext;
assign input_b = ctr_ciphertext & valid_bits;
assign valid_cipher = (plaintext_bitselect)?input_a:input_b;

ghash #(N) GHASH (
    .clk(clk),.rst(rst),.start(ghash_start),.last_block(final_block),
    .ciphertext(valid_cipher),.ciphertext_valid(ctr_ciphertext_valid),.H(H),
    .aad(aad),.length(length),
    .ghash_out(ghash_out),.done(ghash_done)
);

 always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
            done           <= 0;
            state          <= 0;
            H              <= 0;
            keyexp_start   <= 1;
            aes_start1     <= 0;
            ctr_start      <= 0;
            ghash_start    <= 0;
            counter        <= 0;
            aes_input1     <= 0;
            ctr_counter    <= 0;
            ctr_plaintext  <= 0;
            aes_Y          <= 0;
            ciphertext     <= 0;
            block          <=0 ;
            ctr_busy       <= 0;
            index          <= 0;
            Y_0            <= {IV, 31'b0, 1'b1};
        end else begin
            aes_start1     <= 1'b0; 
            ctr_start      <= 1'b0;
           ghash_start     <= 1'b0;
            keyexp_start   <= 1'b0;
            case (state)
            4'b0000: begin  if (start) begin
                        done        <= 0;
                        aes_input1  <= 128'h0; 
                        aes_start1  <= 1'b1;   
                        ciphertext  <= 0;
                        block       <= 0;
                        counter     <= {IV, 31'b0, 1'b1};
                         Y_0        <= {IV, 31'b0, 1'b1};
                        state       <= 4'b0001;
                    end end
           4'b0001: begin 
                    if(aes_done1) begin
                        H            <= aes_output1;
                        aes_input1   <= Y_0; 
                        ghash_start  <= 1;
                        counter      <= counter + 1;
                        state        <= 4'b0010;
                    end end
           4'b0010: begin if(plaintext_valid) begin
                        counter         <= counter + 1;
                        ctr_plaintext   <= plaintext;
                        ctr_counter     <= counter;
                        ctr_start       <= 1;
                        ctr_busy        <= 1;
                         state          <= 4'b0011;
                        end
                        end
              4'b0011: begin    
                       if (ctr_done && ctr_ciphertext_valid) begin
                        ciphertext      <= valid_cipher;
                        ctr_busy        <= 0;
                        block           <= block +1;
                        if (block == N-1) begin
                          state         <= 4'b0100; 
                          aes_start1    <= 1;  
                        end       
                        else begin
                           state        <= 4'b0010;          
                         end 
                       end end
             4'b0100: begin if(aes_done1) begin
                        aes_Y       <= aes_output1;
                        state       <= 4'b0000;
                        done        <=1;
                    end end
            endcase
        end
    end
    assign  tag  = ghash_out ^ aes_Y;
endmodule
