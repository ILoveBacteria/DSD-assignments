// gate level

module multiplexer (
    input in0, in1, select,
    output out
);
    wire in0_and_out, in1_and_out, not_select;
    and(in0_and_out, in0, select);
    not(not_select, select);
    and(in1_and_out, in1, not_select);
    or(out, in0_and_out, in1_and_out);
endmodule

module adder (
    input a, b, carry_in,
    output out, carry_out
);
    wire and1_to_or, and2_to_or, and3_to_or;
    xor(out, a, b, carry_in); 
    and(and1_to_or, a, b);
    and(and2_to_or, a, carry_in);
    and(and3_to_or, b, carry_in);
    or(carry_out, and1_to_or, and2_to_or, and3_to_or); 
endmodule

module multiplexer_2bit (
    input [1:0] in0, in1, select,
    output [1:0] out
);
    multiplexer mux1 (in0[0], in1[0], select, out[0]);
    multiplexer mux2 (in0[1], in1[1], select, out[1]);
endmodule

module adder_2bit (
    input [1:0] a, b, carry_in,
    output [1:0] out, carry_out
);
    wire carry1, carry2;
    adder adder1 (a[0], b[0], carry_in, out[0], carry1);
    adder adder2 (a[1], b[1], carry1, out[1], carry2);
    assign carry_out = carry2;
endmodule

module top_level (
    input [1:0] in0,
    input [1:0] in1,
    input select,
    output [1:0] out,
    output carry_out
);
    wire [1:0] mux_out_adder_in;
    multiplexer_2bit mux_instance (in1, ~in1+1, select, mux_out_adder_in); // select=0: add, select=1: subtract
    adder_2bit adder_instance (mux_out_adder_in, in0, out, carry_out);
endmodule