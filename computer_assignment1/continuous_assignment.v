// continuous assignment

module multiplexer #(
    parameter N_BITS = 1
) (
    input [N_BITS-1:0] in0,
    input [N_BITS-1:0] in1,
    input select,
    output [N_BITS-1:0] out
);
    assign out = (select == 0) ? in0 : 1'bZ;
    assign out = (select == 1) ? in1 : 1'bZ;
endmodule

module adder #(
    parameter N_BITS = 1
) (
    input [N_BITS-1:0] in0,
    input [N_BITS-1:0] in1,
    output [N_BITS-1:0] out,
    output carry_out
);
    assign {carry_out, out} = in0 + in1;    
endmodule