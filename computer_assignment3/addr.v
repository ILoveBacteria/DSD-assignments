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
    reg [3:0] count;
    reg is_serial_mode;

    // State definitions
    localparam IDLE = 2'b00;
    localparam COMBO = 2'b01;
    localparam SERIAL = 2'b10;
    reg [1:0] state;

    // Combinational logic for combo mode
    always @(*) begin
        if (addsub == 0) begin  // Addition
            {result_carry, result_sum} = operand_a + operand_b;
        end
        else begin              // Subtraction
            {result_carry, result_sum} = operand_a - operand_b;
        end
    end

    // Sequential logic
    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            // Reset all registers
            operand_a <= 0;
            operand_b <= 0;
            shift_a <= 0;
            shift_b <= 0;
            serial_sum <= 0;
            serial_carry <= 0;
            count <= 0;
            sum <= 0;
            cout <= 0;
            done <= 0;
            state <= IDLE;
            is_serial_mode <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Load operands
                        operand_a <= a;
                        operand_b <= b;
                        shift_a <= a;
                        shift_b <= b;
                        done <= 0;
                        count <= 0;
                        is_serial_mode <= addsub;  // Serial mode for subtraction
                        state <= (addsub) ? SERIAL : COMBO;
                    end
                end

                COMBO: begin
                    // Combinational mode - one cycle operation
                    sum <= result_sum;
                    cout <= result_carry;
                    done <= 1;
                    state <= IDLE;
                end

                SERIAL: begin
                    if (count < BIT) begin
                        if (addsub == 0) begin
                            // Serial addition
                            {serial_carry, serial_sum[count]} <= 
                                shift_a[count] + shift_b[count] + serial_carry;
                        end
                        else begin
                            // Serial subtraction
                            {serial_carry, serial_sum[count]} <= 
                                shift_a[count] - shift_b[count] - (count == 0 ? 0 : serial_carry);
                        end
                        count <= count + 1;
                    end
                    else begin
                        sum <= serial_sum;
                        cout <= serial_carry;
                        done <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule