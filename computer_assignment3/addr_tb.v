module addr_tb();
    // Parameters
    parameter BIT = 4;  // 4-bit test for easier viewing
    
    // Signals
    reg start;
    reg addsub;
    reg clk;
    reg nrst;
    reg [BIT-1:0] a;
    reg [BIT-1:0] b;
    wire [BIT-1:0] sum;
    wire cout;
    wire done;

    // Instantiate the adder
    addr #(
        .BIT(BIT)
    ) dut (
        .start(start),
        .addsub(addsub),
        .clk(clk),
        .nrst(nrst),
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout),
        .done(done)
    );

    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Test stimulus
    initial begin
        // Initialize
        start = 0;
        addsub = 0;
        a = 0;
        b = 0;
        nrst = 1;

        // Reset
        #10 nrst = 0;
        #10 nrst = 1;

        // Test 1: Combinational Addition (5 + 3 = 8)
        #10;
        a = 4'b0101;  // 5
        b = 4'b0011;  // 3
        addsub = 0;   // Addition
        start = 1;
        #10 start = 0;
        wait(done);
        #10;

        // Test 2: Combinational Subtraction (7 - 3 = 4)
        a = 4'b0111;  // 7
        b = 4'b0011;  // 3
        addsub = 1;   // Subtraction
        start = 1;
        #10 start = 0;
        wait(done);
        #10;

        // Test 3: Serial Addition (9 + 6 = 15)
        a = 4'b1001;  // 9
        b = 4'b0110;  // 6
        addsub = 0;   // Addition
        start = 1;
        #10 start = 0;
        wait(done);
        #10;

        // Test 4: Serial Subtraction (12 - 5 = 7)
        a = 4'b1100;  // 12
        b = 4'b0101;  // 5
        addsub = 1;   // Subtraction
        start = 1;
        #10 start = 0;
        wait(done);
        #10;

        // Test 5: Overflow test (15 + 1 = 0, cout = 1)
        a = 4'b1111;  // 15
        b = 4'b0001;  // 1
        addsub = 0;   // Addition
        start = 1;
        #10 start = 0;
        wait(done);
        #10;

        #20 $stop;
    end
endmodule