// continuous assignment

module multiplexer #(
    parameter N_BITS = 1
) (
    input [N_BITS:0] in0,
    input [N_BITS:0] in1,
    input select,
    output [N_BITS:0] out
);
    assign out = (select == 0) ? in0 : 1'bZ;
    assign out = (select == 1) ? in1 : 1'bZ;
endmodule