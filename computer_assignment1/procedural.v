// procedural

module multiplexer #(
    parameter N_BITS = 1
) (
    input [N_BITS-1:0] a,
    input [N_BITS-1:0] b,
    input select,
    output reg [N_BITS-1:0] out
);
    always @(a, b, select) begin
        if (select == 0) begin
            out = a;
        end else begin
            out = b;
        end
    end
endmodule

module adder #(
    parameter N_BITS = 1
) (
    input [N_BITS-1:0] a,
    input [N_BITS-1:0] b,
    output reg [N_BITS-1:0] out,
    output reg carry_out
);
    always @(a, b) begin
        // Perform addition
        {carry_out, out} = a + b;
    end
endmodule

module top_level #(
    parameter N_BITS = 1
) (
    input [N_BITS-1:0] in0,
    input [N_BITS-1:0] in1,
    input select,
    output [N_BITS-1:0] out,
    output carry_out
);
    wire [N_BITS-1:0] mux_out_adder_in;
    multiplexer #(N_BITS) mux_instance (in1, ~in1+1, select, mux_out_adder_in); // select=0: add, select=1: subtract
    adder #(N_BITS) adder_instance (mux_out_adder_in, in0, out, carry_out);
endmodule