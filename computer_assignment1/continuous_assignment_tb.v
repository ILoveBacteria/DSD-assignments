// continuous assignment test bench

`include "continuous_assignment.v"

module continuous_assignment_tb #(
    parameter N_BITS = 1
) ();
    reg [N_BITS-1:0] a, b; 
    reg select;
    wire [N_BITS-1:0] out;
    wire carry_out;
    top_level #(N_BITS) top_level_instance (a, b, select, out, carry_out);

    initial begin
        a = 0; b = 0; select = 0;
        #10 a = 1;
        #10 b = 1;
        #10 a = 0; b = 0; select = 1;
        #10 a = 1;
        #10 b = 1;
    end
endmodule