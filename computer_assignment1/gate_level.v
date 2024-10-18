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