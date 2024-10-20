// procedural test bench

`include "procedural.v"

module procedural_tb #(
    parameter N_BITS = 32
) ();
    reg [N_BITS-1:0] a, b; 
    reg select;
    wire [N_BITS-1:0] out;
    wire carry_out;
    top_level #(N_BITS) top_level_instance (a, b, select, out, carry_out);

    initial begin
        a = 0; b = 0; select = 0;

        // 2-bit tests
        #10 a = 2'b01; b = 2'b01; select = 0; // 1 + 1 = 2
        #10 a = 2'b10; b = 2'b01; select = 1; // -2 - 1 = -3

        // 4-bit tests
        #10 a = 4'b0010; b = 4'b0011; select = 0; // 2 + 3 = 5
        #10 select = 1; a = 4'b0011; b = 4'b0010;  // 3 - 2 = 1

        // 8-bit tests
        #10 a = 8'b00110010; b = 8'b00010100; select = 0; // 50 + 20 = 70
        #10 a = 8'b00110010; b = 8'b00010100; select = 1; // 50 - 20 = 30

        // 16-bit tests
        #10 a = 16'h1234; b = 16'h5678; select = 0; // 4660 + 22136 = 26796
        #10 a = 16'h5678; b = 16'h1234; select = 1; // 22136 - 4660 = 17476

    end
endmodule