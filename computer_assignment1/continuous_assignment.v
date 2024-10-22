// continuous assignment

module multiplexer #(
    parameter N_BITS = 1
) (
    input [N_BITS-1:0] in0,
    input [N_BITS-1:0] in1,
    input select,
    output [N_BITS-1:0] out
);
    assign out = (select == 0) ? in0 : (select == 1) ? in1 : {N_BITS{1'bZ}};
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