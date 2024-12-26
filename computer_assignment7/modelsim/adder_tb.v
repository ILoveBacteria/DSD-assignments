module adder_tb();
    // Parameters
    reg start;
    reg clk;
    reg rst;
    reg [255:0] a;
    reg [255:0] b;
    wire [255:0] sum;
    wire done;

    // Instantiate the adder
    adder dut (
        .start(start),
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .sum(sum),
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
        a = 0;
        b = 0;
        rst = 0;

        // rest
        rst = 1;
        #10
        rst = 0;
        
        // Test 1: Combinational Addition (5 + 3 = 8)
        #10;
        a = 256'd5;  // 5
        b = 256'd3;  // 3
        start = 1;
        #10
        start = 0;

        #80;
        a = 256'd100;  // 5
        b = 256'd3;  // 3
        start = 1;
        #10
        start = 0;
        
        // Test 2: Combinational Subtraction (7 - 3 = 4)
        // #20;
        // a = 4'b0111;  // 7
        // b = 4'b0011;  // 3
        // addsub = 1;   // Subtraction

        // // Test 3: Serial Addition (9 + 6 = 15)
        // #20;
        // b = 4'b1001;  // 9
        // a = 4'b0110;  // 6
        // addsub = 0;   // Addition
        // start = 1;
        // #10 start = 0;
        // wait(done);

        // // Test 4: Serial Subtraction (12 - 5 = 7)
        // #20;
        // a = 4'b1100;  // 12
        // b = 4'b0101;  // 5
        // addsub = 1;   // Subtraction
        // start = 1;
        // #10 start = 0;
        // wait(done);

        // // Test 5: Overflow test (15 + 1 = 0, cout = 1)
        // #20;
        // a = 4'b1111;  // 15
        // b = 4'b0001;  // 1
        // addsub = 0;   // Addition
        // start = 1;
        // #10 start = 0;
        // wait(done);
        // #10;

        // #20 $stop;
    end
endmodule