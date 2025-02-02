// `timescale 1ns / 1ps

module NeuralNetwork (
    input clk,
    input rst,
    input start,
    input [783:0] in_features, // 784 input features
    output reg [3:0] prediction, // 10 output classes (ArgMax index)
    output reg done
);

    // register to hold the input features
    reg [783:0] features;

    // state machine
    localparam IDLE = 0, COMPUTE = 1;
    reg state;
    reg [2:0] count_clocks; 

    // Define the parameters for layer sizes
    parameter INPUT_SIZE = 784;
    parameter HIDDEN1_SIZE = 64;
    parameter HIDDEN2_SIZE = 32;
    parameter OUTPUT_SIZE = 10;
    
    // Define memory for weights and biases (assumed preloaded)
    reg signed [15:0] weights1 [0:HIDDEN1_SIZE-1][0:INPUT_SIZE-1];
    reg signed [15:0] biases1 [0:HIDDEN1_SIZE-1];
    
    reg signed [15:0] weights2 [0:HIDDEN2_SIZE-1][0:HIDDEN1_SIZE-1];
    reg signed [15:0] biases2 [0:HIDDEN2_SIZE-1];
    
    reg signed [15:0] weights3 [0:OUTPUT_SIZE-1][0:HIDDEN2_SIZE-1];
    reg signed [15:0] biases3 [0:OUTPUT_SIZE-1];
    
    // Layer Outputs
    reg signed [15:0] hidden1 [0:HIDDEN1_SIZE-1];
    reg signed [15:0] hidden2 [0:HIDDEN2_SIZE-1];
    reg signed [15:0] output_layer [0:OUTPUT_SIZE-1];
    
    integer i, j;
    
    // ReLU activation function
    function signed [15:0] relu;
        input signed [15:0] x;
        begin
            relu = (x > 0) ? x : 0;
        end
    endfunction


    // ============================================
    // combinational Computation of the neurons
    // ============================================

    // layer 1
    reg signed [15:0] new_hidden1 [0:HIDDEN1_SIZE-1];
    always @(*) begin
        for (i = 0; i < HIDDEN1_SIZE; i = i + 1) begin
            new_hidden1[i] = biases1[i];
            for (j = 0; j < INPUT_SIZE; j = j + 1) begin
                new_hidden1[i] = new_hidden1[i] + (features[j] == 1 ? weights1[i][j] : 0); 
            end
            new_hidden1[i] = relu(new_hidden1[i]); 
        end
    end

    // layer 2
    reg signed [15:0] new_hidden2 [0:HIDDEN2_SIZE-1];
    reg signed [15:0] multiplier_out2 [0:HIDDEN2_SIZE-1][0:HIDDEN1_SIZE-1];
    reg signed [15:0] shift_out2 [0:HIDDEN2_SIZE-1][0:HIDDEN1_SIZE-1];
    always @(*) begin
        for (i = 0; i < HIDDEN2_SIZE; i = i + 1) begin
            new_hidden2[i] = biases2[i];
            for (j = 0; j < HIDDEN1_SIZE; j = j + 1) begin
                multiplier_out2[i][j] = hidden1[j] * weights2[i][j];
                shift_out2[i][j] = multiplier_out2[i][j] >> 8;
                new_hidden2[i] = new_hidden2[i] + shift_out2[i][j];
            end
            new_hidden2[i] = relu(new_hidden2[i]);
        end
    end

    // Output Layer computation
    reg signed [15:0] new_output_layer [0:OUTPUT_SIZE-1];
    reg signed [15:0] multiplier_out3 [0:OUTPUT_SIZE-1][0:HIDDEN2_SIZE-1];
    reg signed [15:0] shift_out3 [0:OUTPUT_SIZE-1][0:HIDDEN2_SIZE-1];
    always @(*) begin
        for (i = 0; i < OUTPUT_SIZE; i = i + 1) begin
            new_output_layer[i] = biases3[i];
            for (j = 0; j < HIDDEN2_SIZE; j = j + 1) begin
                multiplier_out3[i][j] = hidden2[j] * weights3[i][j];
                shift_out3[i][j] = multiplier_out3[i][j] >> 8;
                new_output_layer[i] = new_output_layer[i] + shift_out3[i][j];
            end
        end
    end

    // ArgMax operation
    reg [3:0] new_prediction;
    always @(*) begin
        new_prediction = 0;
        for (i = 1; i < OUTPUT_SIZE; i = i + 1) begin
            if (output_layer[i] > output_layer[new_prediction]) begin
                new_prediction = i;
            end
        end
    end
    

    // ============================================
    // Sequential update of the neurons
    // ============================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            count_clocks <= 0;
            prediction <= 0;
            for (i = 0; i < INPUT_SIZE; i = i + 1) begin
                features[i] <= 0;
            end
        end 
        else if (state == IDLE) begin
            if (start) begin
                // Load the input features
                for (i = 0; i < INPUT_SIZE; i = i + 1) begin
                    features[i] <= in_features[i];
                end
                state <= COMPUTE;
                done <= 0;
                count_clocks <= 0;
            end
        end 
        else begin
            // Layer 1 computation
            for (i = 0; i < HIDDEN1_SIZE; i = i + 1) begin
                hidden1[i] <= new_hidden1[i];
            end

            // Layer 2 computation
            for (i = 0; i < HIDDEN2_SIZE; i = i + 1) begin
                hidden2[i] <= new_hidden2[i];
            end

            // Output Layer computation
            for (i = 0; i < OUTPUT_SIZE; i = i + 1) begin
                output_layer[i] <= new_output_layer[i];
            end

            // ArgMax operation
            prediction <= new_prediction;

            // Update state or increment the clock counter
            if (count_clocks >= 3) begin
                state <= IDLE;
                done <= 1;
            end
            else begin
                count_clocks <= count_clocks + 1;
            end
        end
    end

    initial begin
        $readmemb("layer1_weight.mem", weights1);
        $readmemb("layer1_bias.mem", biases1);
        $readmemb("layer2_weight.mem", weights2);
        $readmemb("layer2_bias.mem", biases2);
        $readmemb("layer3_weight.mem", weights3);
        $readmemb("layer3_bias.mem", biases3);
    end

endmodule
