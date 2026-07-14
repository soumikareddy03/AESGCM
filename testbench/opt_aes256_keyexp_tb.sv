`timescale 1ns/1ps

module opt_aes256_keyexp_tb;
reg clk;
reg rst;
reg start;
reg [255:0] key;
//wire [127:0]roundkey_even;
//wire [127:0]roundkey_odd;
logic [127:0] roundkey[0:14];
wire roundkey_valid;
wire keyexp_done;

opt_aes256_keyexp DUT(
        .clk(clk), .rst(rst),.start(start),.key(key), .roundkey(roundkey),
        .roundkey_valid(roundkey_valid),.keyexp_done(keyexp_done));
integer i;
always@(posedge clk or posedge rst) begin
for(i=0;i<16;i++)
$display("roundkey=%h", roundkey[i]);
end
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;

    // AES-256 test key
    key =
    256'h22225555777744447766447777669988ccddeeff8899aabb4455667700112233;

    #10;
    rst = 0;

    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    wait(keyexp_done);
    #5
    $finish;
    end
    endmodule