// gate level test bench

`include "gate_level.v"

module gate_level_tb;
    reg [1:0] a, b; 
    reg select;
    wire [1:0] out;
    wire carry_out;

    top_level top_level_instance (
        .in0(a),
        .in1(b),
        .select(select),
        .out(out),
        .carry_out(carry_out)
    );

    initial begin
        a = 0; b = 0; select = 0;

        // 2-bit tests
        // Set radix to unsigned in mpdelsim
        #10 a = 2'b01; b = 2'b01; select = 0; // 1 + 1 = 2
        #10 a = 2'b10; b = 2'b01; select = 1; // 2 - 1 = 1
        #10 a = 2'b11; b = 2'b01; select = 0; // 3 + 1 = 0 (overflow)

        // Set radix to decimal in modelsim
        #10 a = 2'b00; b = 2'b11; select = 1; // 0 - (-1) = 1
        #10 a = 2'b10; b = 2'b01; select = 0; // -2 + 1 = -1
        #10 a = 2'b01; b = 2'b11; select = 1; // 1 - (-1) = 2 (overflow)

    end
endmodule