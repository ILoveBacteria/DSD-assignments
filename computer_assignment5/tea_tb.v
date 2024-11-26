module tea_pipelined_tb;
    reg clk;
    reg rst_n;
    reg [63:0] plaintext;
    reg [127:0] key;
    wire [63:0] ciphertext;


    tea_pipelined dut (
        .clk(clk),
        .rst_n(rst_n),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext)
    );

    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        // Initialize inputs
        rst_n = 0;
        #18 rst_n = 1;

        plaintext = 64'h0123456789ABCDEF;
        key = 128'h000102030405060708090A0B0C0D0E0F;

        #10 plaintext = 64'hFEDCBA9876543210; 
        key = 128'hA00102030405060708090A0B0C0D0E0F;

        #10 plaintext = 64'hABCCBA9876543210;
        key = 128'hB00102030405060708090A0B0C0D0E0F;
    end
endmodule