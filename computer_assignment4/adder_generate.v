module adder #(
    parameter BIT = 3   // Generic parameter for bit-width
)(
    input wire addsub,         // 0: add, 1: subtract
    input wire clk,            // Clock signal
    input wire nrst,           // Active-low reset
    input wire [BIT-1:0] A,    // Operand A
    input wire [BIT-1:0] B,    // Operand B
    output reg [BIT-1:0] SUM,  // Sum output
    output reg cout            // Carry-out output
);

    // Internal pipeline registers for each stage
    reg [BIT-1:0] pipeline_A [0:BIT-1];
    reg [BIT-1:0] pipeline_B [0:BIT-1];
    reg [BIT-1:0] pipeline_SUM [0:BIT-1];
    reg pipeline_cout [0:BIT-1];

    // Wires for intermediate sums and carries
    wire sum_wire [0:BIT-1];
    wire cout_wire [0:BIT-1];

    // Generate block for intermediate sum and carry calculations
    genvar i;
    generate
        for (i = 0; i < BIT; i = i + 1) begin
            assign {cout_wire[i], sum_wire[i]} = pipeline_A[i][i] + pipeline_B[i][i] + pipeline_cout[i];
        end
    endgenerate

    integer j;
    integer k;
    // Pipeline stages
    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            // Reset all pipeline registers
            for (j = 0; j < BIT; j = j + 1) begin
                pipeline_A[j] <= 0;
                pipeline_B[j] <= 0;
                pipeline_SUM[j] <= 0;
                pipeline_cout[j] <= 0;
            end
            SUM <= 0;
            cout <= 0;
        end else begin
            // First stage
            pipeline_A[0] <= A;
            pipeline_B[0] <= addsub ? (~B + 1'b1) : B; // 2's complement B if subtracting
            pipeline_SUM[0] <= 0;
            pipeline_cout[0] <= 0;

            // Intermediate stages
            for (j = 1; j < BIT; j = j + 1) begin
                pipeline_A[j] <= pipeline_A[j-1];
                pipeline_B[j] <= pipeline_B[j-1];
                pipeline_cout[j] <= cout_wire[j-1];

                // Update pipeline_SUM
                if (j == 1)
                    pipeline_SUM[j] <= {{BIT{1'b0}}, sum_wire[j-1]};
                else begin
                    // pipeline_SUM[j] <= {{BIT{1'b0}}, sum_wire[j-1], pipeline_SUM[j-1][j-2:0]};
                    for (k = 0; k < BIT; k = k + 1) begin
                        if (k == j-1)
                            pipeline_SUM[j][k] <= sum_wire[j-1];
                        else
                            pipeline_SUM[j][k] <= pipeline_SUM[j-1][k];
                    end
                end
            end

            // Final output
            SUM <= {{BIT{1'b0}}, sum_wire[BIT-1], pipeline_SUM[BIT-1][BIT-2:0]};
            cout <= cout_wire[BIT-1];
        end
    end
endmodule