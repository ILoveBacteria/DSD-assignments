// gate level

module multiplexer (
    input in0, in1, select,
    output out
);
    wire in0_and_out, in1_and_out, not_select;
    and(in1_and_out, in1, select);
    not(not_select, select);
    and(in0_and_out, in0, not_select);
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
    input [1:0] in0, in1,
    input select,
    output [1:0] out
);
    multiplexer mux0 (in0[0], in1[0], select, out[0]);
    multiplexer mux1 (in0[1], in1[1], select, out[1]);
endmodule

module adder_2bit (
    input [1:0] a, b,
    input carry_in,
    output [1:0] out,
    output carry_out
);
    wire carry_middle;
    adder adder0 (a[0], b[0], carry_in, out[0], carry_middle);
    adder adder1 (a[1], b[1], carry_middle, out[1], carry_out);
endmodule

module top_level (
    input [1:0] in0, in1,
    input select,
    output [1:0] out,
    output carry_out
);
    wire [1:0] mux_out;
    wire [1:0] in1_complement;
    assign in1_complement = ~in1 + 1;
    
    multiplexer_2bit mux_instance (
        .in0(in1),
        .in1(in1_complement),
        .select(select),
        .out(mux_out)
    );
    
    adder_2bit adder_instance (
        .a(mux_out),
        .b(in0),
        .carry_in(1'b0),
        .out(out),
        .carry_out(carry_out)
    );
endmodule