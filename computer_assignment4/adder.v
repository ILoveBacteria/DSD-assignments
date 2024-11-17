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

    // Internal pipeline registers - stage 0
    reg [BIT-1:0] pipeline_A0;
    reg [BIT-1:0] pipeline_B0;
    reg [BIT-1:0] pipeline_SUM0;
    reg pipeline_cout0;

    // Internal pipeline registers - stage 1
    reg [BIT-1:0] pipeline_A1;
    reg [BIT-1:0] pipeline_B1;
    reg [BIT-1:0] pipeline_SUM1;
    reg pipeline_cout1;

    // Internal pipeline registers - stage 2
    reg [BIT-1:0] pipeline_A2;
    reg [BIT-1:0] pipeline_B2;
    reg [BIT-1:0] pipeline_SUM2;
    reg pipeline_cout2;

    // Wires for intermediate sums and carries
    wire sum0, sum1, sum2;
    wire cout0, cout1, cout2;

    // Example combinational logic for sum and carry-out
    assign {cout0, sum0} = pipeline_A0[0] + pipeline_B0[0] + pipeline_cout0;
    assign {cout1, sum1} = pipeline_A1[1] + pipeline_B1[1] + pipeline_cout1;
    assign {cout2, sum2} = pipeline_A2[2] + pipeline_B2[2] + pipeline_cout2;

    // Pipeline stages
    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            pipeline_A0 <= 0;
            pipeline_B0 <= 0;
            pipeline_SUM0 <= 0;
            pipeline_cout0 <= 0;

            pipeline_A1 <= 0;
            pipeline_B1 <= 0;
            pipeline_SUM1 <= 0;
            pipeline_cout1 <= 0;

            pipeline_A2 <= 0;
            pipeline_B2 <= 0;
            pipeline_SUM2 <= 0;
            pipeline_cout2 <= 0;

            SUM <= 0;
            cout <= 0;
        end else begin
            pipeline_A0 <= A;
            pipeline_B0 <= addsub ? ~B + 1 : B; // 2s complement B if subtracting
            pipeline_SUM0 <= 0;
            pipeline_cout0 <= 0;

            pipeline_A1 <= pipeline_A0;
            pipeline_B1 <= pipeline_B0;
            pipeline_SUM1 <= {{BIT{1'b0}}, sum0};
            pipeline_cout1 <= cout0;

            pipeline_A2 <= pipeline_A1;
            pipeline_B2 <= pipeline_B1;
            pipeline_SUM2 <= {{BIT{1'b0}}, sum1, pipeline_SUM1[0]};
            pipeline_cout2 <= cout1;

            SUM <= {{BIT{1'b0}}, sum2, pipeline_SUM2[1:0]};
            cout <= cout2;
        end
    end
endmodule