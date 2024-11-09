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
        if (addsub == 1) {
            {result_carry, result_sum} = operand_a + operand_b;            
        }
        else {
            {result_carry, result_sum} = operand_a - operand_b;            
        }
    end

    //******************************
    // Sequential update register
    //******************************
    always @(posedge clk) begin
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


    parameter n = 8; // Adjust 'n' to the desired bit-width
    reg [n:0] shift_A, shift_B;
    reg [n:0] sum;
    reg carry;
    reg [3:0] count;
    always @(posedge clk) begin
        if (nrst == 0) begin
            shift_A <= 0;
            shift_B <= 0;
            sum <= 0;
            carry <= 0;
            count <= 0;
            done <= 0;
            Sum <= 0;
        end else if (start == 1) begin
            shift_A <= {1'b0, A}; // Load operands into shift registers
            shift_B <= {1'b0, B};
            sum <= 0;
            carry <= 0;
            count <= 0;
            done <= 0;
        end else if (count < n) begin
            {carry, sum[count]} <= shift_A[count] + shift_B[count] + carry; // Full adder
            count <= count + 1;
        end else begin
            Sum <= sum[n-1:0]; // Assign result to Sum
            done <= 1;
        end
    end

endmodule



// module serial_adder(
//     input clk,
//     input reset,
//     input start,
//     input [n-1:0] A, // first operand
//     input [n-1:0] B, // second operand
//     output reg [n-1:0] Sum, // Sum output
//     output reg done // Done signal
// );