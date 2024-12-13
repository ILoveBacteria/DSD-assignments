module reg8 #(
    parameter DELTA = 32'h9E3779B9,
    parameter ROUNDS = 1
)(
    input wire clk,
    input wire rst_n,
    input wire [63:0] plaintext,
    input wire [127:0] key,
    output wire [63:0] ciphertext
);
    
    // Pipeline stages for v0, v1 and sum(DELTA)
    reg [31:0] v0_pipe [0:ROUNDS];
    reg [31:0] v1_pipe [0:ROUNDS];
    reg [31:0] sum_pipe [0:ROUNDS];
    reg [127:0] key_pipe [0:ROUNDS];

    // input registers
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            v0_pipe[0] = 32'b0;
            v1_pipe[0] = 32'b0;
            sum_pipe[0] = 32'b0;
            key_pipe[0] = 128'b0;
        end else begin
            v0_pipe[0] = plaintext[63:32]; // v0 on the left (higher bits)
            v1_pipe[0] = plaintext[31:0]; // v1 on the right (lower bits)
            sum_pipe[0] = DELTA;
            key_pipe[0] = key;
        end
    end

    // Pipeline stages implementation
    genvar i;
    generate
        for (i = 0; i < ROUNDS; i = i + 1) begin
            // Key division
            wire [31:0] k0 = key_pipe[i][127:96];
            wire [31:0] k1 = key_pipe[i][95:64];
            wire [31:0] k2 = key_pipe[i][63:32];
            wire [31:0] k3 = key_pipe[i][31:0];

            // Intermediate combinational signals for current stage
            reg [31:0] v1_shift_l4;
            reg [31:0] v1_shift_r5;
            reg [31:0] v0_shift_l4;
            reg [31:0] v0_shift_r5;

            reg [31:0] next_pipe_v0;
            reg [31:0] next_pipe_v1;
            reg [31:0] next_pipe_sum;

            always @(*) begin
                v1_shift_l4 = v1_pipe[i] << 4;
                v1_shift_r5 = v1_pipe[i] >> 5;
                v0_shift_l4 = next_pipe_v0 << 4;
                v0_shift_r5 = next_pipe_v0 >> 5;
            end

            always @(*) begin
                next_pipe_v0 = v0_pipe[i] + 
                                ((v1_shift_l4 + k0) ^ 
                                    (v1_pipe[i] + sum_pipe[i]) ^ 
                                    (v1_shift_r5 + k1));
                
                next_pipe_v1 = v1_pipe[i] + 
                                ((v0_shift_l4 + k2) ^ 
                                    (next_pipe_v0 + sum_pipe[i]) ^ 
                                    (v0_shift_r5 + k3));
                
                next_pipe_sum = sum_pipe[i] + DELTA;
            end

            // Pipeline registers for each stage
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    v0_pipe[i+1] = 32'b0;
                    v1_pipe[i+1] = 32'b0;
                    sum_pipe[i+1] = 32'b0;
                    key_pipe[i+1] = 128'b0;
                end else begin
                    // v0 update
                    v0_pipe[i+1] = next_pipe_v0;
                    
                    // v1 update
                    v1_pipe[i+1] = next_pipe_v1;
                    
                    // Sum update for next stage
                    sum_pipe[i+1] = next_pipe_sum;

                    key_pipe[i+1] = {k0, k1, k2, k3};
                end
            end
        end
    endgenerate

    // Output assignment
    assign ciphertext = {v0_pipe[ROUNDS], v1_pipe[ROUNDS]};
endmodule
