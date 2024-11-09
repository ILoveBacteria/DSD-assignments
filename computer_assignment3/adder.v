module addr #(
    parameter BIT = 1;
) (
    input start, addsub, clk, nrst
    input [BIT-1:0] a, b
    reg output [BIT-1:0] sum
    reg output cout, done
);
    reg [BIT-1:0] operand_a, operand_b, result_sum, result_carry;

    //******************************
    // Combinational sum
    //******************************
    always @(*) begin
        {result_carry, result_sum} = operand_a + operand_b;
    end

    //******************************
    // Sequential update register
    //******************************
    always @(clk) begin
        if (nrst == 0) {
            // reset
        }

        // Update input registers
        operand_a = a;
        operand_b = b;

        // Update output registers
        sum = result_sum;
        cout = result_carry;
    end

endmodule