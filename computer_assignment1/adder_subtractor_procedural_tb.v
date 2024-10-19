module adder_subtractor_tb;

    // Test case structure
    reg [31:0] a, b;
    reg sub;
    wire [31:0] result;
    wire overflow;

    // Instantiate the Unit Under Test (UUT)
    adder_subtractor #(.N_BITS(32)) uut (
        .a(a[31:0]),
        .b(b[31:0]),
        .sub(sub),
        .result(result),
        .overflow(overflow)
    );

    // Task to run a test case
    task run_test;
        input [31:0] test_a, test_b;
        input test_sub;
        input [5:0] bits;
        begin
            a = test_a;
            b = test_b;
            sub = test_sub;
            #10;
            $display("%0d-bit Test: %0d %s %0d = %0d, Overflow: %b", 
                     bits, 
                     $signed(a[bits-1:0]), 
                     sub ? "-" : "+", 
                     $signed(b[bits-1:0]), 
                     $signed(result[bits-1:0]), 
                     overflow);
        end
    endtask

    initial begin
        // 2-bit tests
        run_test(2'b01, 2'b01, 0, 2); // 1 + 1 = -2 (overflow)
        run_test(2'b10, 2'b01, 1, 2); // -2 - 1 = 1 (overflow)

        // 4-bit tests
        run_test(4'b0010, 4'b0011, 0, 4); // 2 + 3 = 5
        run_test(4'b0011, 4'b0010, 1, 4); // 3 - 2 = 1
        run_test(4'b0111, 4'b0001, 0, 4); // 7 + 1 = -8 (overflow)
        run_test(4'b1000, 4'b0001, 1, 4); // -8 - 1 = 7 (overflow)

        // 8-bit tests
        run_test(8'b01111111, 8'b00000001, 0, 8); // 127 + 1 = -128 (overflow)
        run_test(8'b10000000, 8'b00000001, 1, 8); // -128 - 1 = 127 (overflow)
        run_test(8'b00110010, 8'b00010100, 0, 8); // 50 + 20 = 70
        run_test(8'b00110010, 8'b00010100, 1, 8); // 50 - 20 = 30

        // 16-bit tests
        run_test(16'h7FFF, 16'h0001, 0, 16); // 32767 + 1 = -32768 (overflow)
        run_test(16'h8000, 16'h0001, 1, 16); // -32768 - 1 = 32767 (overflow)
        run_test(16'h1234, 16'h5678, 0, 16); // 4660 + 22136 = 26796
        run_test(16'h5678, 16'h1234, 1, 16); // 22136 - 4660 = 17476

        $finish;
    end

endmodule
