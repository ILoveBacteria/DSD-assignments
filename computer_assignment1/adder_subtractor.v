module adder_subtractor #(
    parameter N_BITS = 4
)(
    input [N_BITS-1:0] a,
    input [N_BITS-1:0] b,
    input sub,
    output reg [N_BITS-1:0] result,
    output reg overflow
);

    reg [N_BITS-1:0] b_operand;
    reg [N_BITS:0] sum;

    always @(*) begin
        // Determine whether to add or subtract
        b_operand = sub ? ~b + 1'b1 : b;

        // Perform addition
        sum = a + b_operand;

        // Set the result
        result = sum[N_BITS-1:0];

        // Check for overflow
        overflow = (a[N_BITS-1] == b_operand[N_BITS-1]) && 
                   (a[N_BITS-1] != sum[N_BITS-1]);
    end

endmodule
