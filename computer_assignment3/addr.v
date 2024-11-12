module addr #(
    parameter BIT = 8    // Default size
) (
    input wire start,
    input wire addsub,   // 0: add, 1: subtract
    input wire clk,
    input wire nrst,
    input wire [BIT-1:0] a,
    input wire [BIT-1:0] b,
    output reg [BIT-1:0] sum,
    output reg cout,
    output reg done
);

    // Internal registers
    reg [BIT-1:0] operand_a, operand_b;
    reg [BIT-1:0] result_sum;
    reg result_carry;
    
    // For serial operation
    reg [BIT-1:0] shift_a, shift_b;
    reg [BIT-1:0] serial_sum;
    reg serial_carry;
    reg [BIT-1:0] count;

    // State definitions
    localparam COMB = 0;
    localparam SERIAL = 1;
    reg state;

    // Combinational logic for combo mode
    always @(*) begin
        {result_carry, result_sum} = operand_a + operand_b;
    end

    // Sequential logic
    always @(posedge clk) begin
        done = 0;

        if (!nrst) begin
            // Reset all registers
            operand_a = 0;
            operand_b = 0;
            shift_a = 0;
            shift_b = 0;
            serial_sum = 0;
            serial_carry = 0;
            count = 0;
            sum = 0;
            cout = 0;
            done = 0;
            state = 0;
        end

        else begin
            case (state)
                COMB: begin
                    // Combinational mode - one cycle operation
                    if (start) begin
                        // Load operands
                        if (addsub == 0)
                            shift_b = b;
                        else
                            shift_b = ~b + 1;
                        shift_a = a;
                        serial_carry = 0;
                        count = 0;
                        state = SERIAL; // next state
                    end
                    else
                    begin
                        sum = result_sum;
                        cout = result_carry;
                        if (addsub == 0)
                            operand_b = b;
                        else
                            operand_b = ~b + 1;
                        operand_a = a;
                    end
                end

                SERIAL: begin
                    if (count < BIT-1) begin
                        {serial_carry, serial_sum[BIT-1]} = shift_a[0] + shift_b[0] + serial_carry;                        
                        // Shift right
                        serial_sum = serial_sum >> 1;
                        shift_a = shift_a >> 1;
                        shift_b = shift_b >> 1;
                        count = count + 1;
                    end
                    else begin
                        {serial_carry, serial_sum[BIT-1]} = shift_a[0] + shift_b[0] + serial_carry;
                        sum = serial_sum;
                        cout = serial_carry;
                        done = 1;
                        state = COMB; // next state
                    end
                end
            endcase
        end
    end

endmodule