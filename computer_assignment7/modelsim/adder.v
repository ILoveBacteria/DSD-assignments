module adder (
    input wire start,
    input wire clk,
    input wire rst,
    input wire [255:0] a,
    input wire [255:0] b,
    output reg [255:0] sum,
    output reg done
);

    // Internal registers
    reg [255:0] shift_a, shift_b;
    reg [255:0] serial_sum;
    reg serial_carry;
    reg [2:0] count; // 2^3 = 8

    // state
    reg state;
    localparam IDLE = 0;
    localparam RUNNING = 1;

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            shift_a = 0;
            shift_b = 0;
            serial_sum = 0;
            serial_carry = 0;
            count = 0;
            sum = 0;
            done = 0;
            state = 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Load operands
                        shift_b = b;
                        shift_a = a;
                        serial_carry = 0;
                        count = 0;
                        done = 0;
                        state = RUNNING; // next state
                    end
                end

                RUNNING: begin
                    if (count < 7) begin
                        {serial_carry, serial_sum[255:224]} = shift_a[31:0] + shift_b[31:0] + serial_carry;                        
                        // Shift right
                        serial_sum = serial_sum >> 32;
                        shift_a = shift_a >> 32;
                        shift_b = shift_b >> 32;
                        count = count + 1;
                    end
                    else begin
                        {serial_carry, serial_sum[255:224]} = shift_a[31:0] + shift_b[31:0] + serial_carry;  
                        sum = serial_sum;
                        done = 1;
                        state = IDLE; // next state
                    end
                end
            endcase
        end
    end

endmodule