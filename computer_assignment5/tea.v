module tea_pipelined #(
    parameter DELTA = 32'h9E3779B9;
    parameter ROUNDS = 32;
)(
    input wire clk,
    input wire rst_n,
    input wire [63:0] plaintext,
    input wire [127:0] key,
    output wire [63:0] ciphertext
);
    // Key division
    wire [31:0] k0 = key[127:96];
    wire [31:0] k1 = key[95:64];
    wire [31:0] k2 = key[63:32];
    wire [31:0] k3 = key[31:0];
    
    // Pipeline stages for v0, v1 and sum(DELTA)
    reg [31:0] v0_pipe [0:ROUNDS];
    reg [31:0] v1_pipe [0:ROUNDS];
    reg [31:0] sum_pipe [0:ROUNDS];

    // input registers
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            v0_pipe[0] <= 32'b0;
            v1_pipe[0] <= 32'b0;
            sum_pipe[0] <= 32'b0;
        end else begin
            v0_pipe[0] <= plaintext[63:32]; // v0 on the left (higher bits)
            v1_pipe[0] <= plaintext[31:0]; // v1 on the right (lower bits)
            sum_pipe[0] <= DELTA;
        end
    end

    // Pipeline stages implementation
    genvar i;
    generate
        for (i = 0; i < ROUNDS; i = i + 1) begin
            // Intermediate combinational signals for current stage
            // reg [31:0] v1_shift_l4, v1_shift_r5, v0_shift_l4, v0_shift_r5;
            // always @(*) begin
            //     v1_shift_l4 = v1_pipe[i-1] << 4;
            //     v1_shift_r5 = v1_pipe[i-1] >> 5;
            //     v0_shift_l4 = v0_pipe[i-1] << 4;
            //     v0_shift_r5 = v0_pipe[i-1] >> 5;
            // end
            
            // Pipeline registers for each stage
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    v0_pipe[i] = 32'b0;
                    v1_pipe[i] = 32'b0;
                    sum_pipe[i] = 32'b0;
                end else begin
                    // v0 update
                    v0_pipe[i+1] = v0_pipe[i] + 
                                (((v1_pipe[i] << 4) + k0) ^ 
                                    (v1_pipe[i] + sum_pipe[i]) ^ 
                                    ((v1_pipe[i] >> 5) + k1));
                    
                    // v1 update
                    v1_pipe[i+1] = v1_pipe[i] + 
                                (((v0_pipe[i+1] << 4) + k2) ^ 
                                    (v0_pipe[i+1] + sum_pipe[i]) ^ 
                                    ((v0_pipe[i+1] >> 5) + k3));
                    
                    // Sum update for next stage
                    sum_pipe[i+1] = sum_pipe[i] + DELTA;
                end
            end
        end
    endgenerate

    // Output assignment
    assign ciphertext = {v0_pipe[ROUNDS], v1_pipe[ROUNDS]};
endmodule
