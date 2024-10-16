// gate level

module multiplexer (
    input in0,
    input in1,
    input select,
    output out
);
    wire in0_and_out, in1_and_out, not_select;
    and(in0_and_out, in0, select);
    not(not_select, select);
    and(in1_and_out, in1, not_select);
    or(out, in0_and_out, in1_and_out);
endmodule