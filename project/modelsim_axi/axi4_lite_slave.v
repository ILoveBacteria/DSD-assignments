//////////////////////////////////////////////////////////////////////////////////
// AXI4 Lite Slave Example
// By:
//        Ali Jahanian
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module axi4_lite_slave #(
    parameter ADDRESS = 32,
    parameter DATA_WIDTH = 32
    )
    (
        // Global Signals
        input                           ACLK, // # of used = 1
        input                           ARESETN, // # of used = 1

        // Read Address Channel INPUTS
        input           [ADDRESS-1:0]   S_ARADDR, // # of used = 4
        input                           S_ARVALID, // # of used = 2

        // Read Data Channel INPUTS
        input                           S_RREADY, // # of used = 1

        // Write Address Channel INPUTS
        /* verilator lint_off UNUSED */
        input           [ADDRESS-1:0]   S_AWADDR, // # of used = 4
        input                           S_AWVALID, // # of used = 2

        // Write Data  Channel INPUTS
        input          [DATA_WIDTH-1:0] S_WDATA, // # of used = 2
        input          [3:0]            S_WSTRB, // # of used = 0
        input                           S_WVALID, // # of used = 1

        // Write Response Channel INPUTS
        input                           S_BREADY, // # of used = 1

        // Read Address Channel OUTPUTS
        output                     S_ARREADY, // # of used = 2

        // Read Data Channel OUTPUTS
        output [DATA_WIDTH-1:0]    S_RDATA, // # of used = 1
        output          [1:0]      S_RRESP, // # of used = 1
        output                     S_RVALID, // # of used = 2

        // Write Address Channel OUTPUTS
        output                     S_AWREADY, // # of used = 2
        output                     S_WREADY, // # of used = 2
        
        // Write Response Channel OUTPUTS
        output          [1:0]      S_BRESP, // # of used = 1
        output                     S_BVALID // # of used = 2
    );

    localparam REG_NUM       = 32;
    localparam IDLE          = 0;
    localparam WRITE_CHANNEL = 1;
    localparam WRESP_CHANNEL = 2;
    localparam RADDR_CHANNEL = 3;
    localparam RDATA_CHANNEL = 4;
    localparam MY_STATE      = 5;

    reg start;
    wire clk;
    reg rst;
    reg [783:0] in_features;
    reg [783:0] not_reversed_in_features;
    wire [3:0] prediction;
    wire done;

    NeuralNetwork my_NeuralNetwork (clk, rst, start, in_features, prediction, done);

    assign clk = ACLK;
   
    reg  [2:0] state, next_state;
    reg  [ADDRESS-1:0] read_addr;
    wire [ADDRESS-1:0] S_ARADDR_T;
    wire [ADDRESS-1:0] S_AWADDR_T;
    reg  [DATA_WIDTH-1:0] register [0:REG_NUM-1]; // 32 ta register 32bits
    
    // Address Read
    assign S_ARREADY = (state == RADDR_CHANNEL) ? 1 : 0;
    
    // Read
    assign S_RVALID = (state == RDATA_CHANNEL) ? 1 : 0;
    assign S_RDATA  = (state == RDATA_CHANNEL) ? register[read_addr] : 0;
    assign S_RRESP  = (state == RDATA_CHANNEL) ? 2'b00 : 0;

    // Address Write
    assign S_AWREADY = (state == WRITE_CHANNEL) ? 1 : 0;

    // Write
    assign S_WREADY = (state == WRITE_CHANNEL) ? 1 : 0;

    // Response
    assign S_BVALID = (state == WRESP_CHANNEL) ? 1 : 0;
    assign S_BRESP  = (state == WRESP_CHANNEL )? 0:0;

    assign S_ARADDR_T = S_ARADDR[ADDRESS-1:2]; // Read address 
    assign S_AWADDR_T = S_AWADDR[ADDRESS-1:2]; // Write address 
    
    always @(posedge ACLK) begin
        // Reset the register array
        if (~ARESETN) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
            if (state == WRITE_CHANNEL) begin
                register[S_AWADDR_T] <= S_WDATA;
            end
            else if (state == RADDR_CHANNEL) begin
                read_addr <= S_ARADDR_T;
            end
            else if (state == IDLE) begin
                start <= 0;
                rst <= 1;
            end
            else if (state == MY_STATE) begin
                start <= 1;
                rst <= 0;
                in_features = {register[23], register[22], register[21], register[20], register[19], register[18], register[17], register[16], register[15], register[14], register[13], register[12], register[11], register[10], register[9], register[8], register[7], register[6], register[5], register[4], register[3], register[2], register[1], register[0]};
                // in_features = 784'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110000000000000000000000011111100000000000000000000011000000000000000000000000001000000000000000000000000001100000000000000000000000000100000000000000000000000000010000000000000000000000000001000000000000000000000000000101111111000000000000000000010100000111000000000000000001110000000110000000000000000110000000001000000000000000011000000000100000000000000000100000000010000000000000000010000000001000000000000000000110000001000000000000000000001111111000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
                register[24] <= {28'h0000000, prediction};
            end
        end
    end

    // State machine
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (S_AWVALID) begin
                    next_state = WRITE_CHANNEL;
                end 
                else if (S_ARVALID) begin
                    next_state = RADDR_CHANNEL;
                end 
                else begin
                    next_state = IDLE;
                end
            end

            RADDR_CHANNEL: begin
                if (S_ARVALID && S_ARREADY && S_ARADDR_T == 24)
                    next_state = MY_STATE;
                else if (S_ARVALID && S_ARREADY)
                    next_state = RDATA_CHANNEL;
            end

            MY_STATE: begin
                if (done)
                    next_state = RDATA_CHANNEL;
            end

            RDATA_CHANNEL: begin
                if (S_RVALID && S_RREADY)
                    next_state = IDLE;
            end

            WRITE_CHANNEL: begin
                if (S_AWVALID && S_AWREADY && S_WREADY && S_WVALID)
                    next_state = WRESP_CHANNEL;
            end

            WRESP_CHANNEL: begin
                if (S_BVALID && S_BREADY) 
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end 
        endcase
    end
endmodule

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
    integer count_clocks; 

    // Define the parameters for layer sizes
    parameter INPUT_SIZE = 784;
    parameter HIDDEN1_SIZE = 64;
    parameter HIDDEN2_SIZE = 32;
    parameter OUTPUT_SIZE = 10;

    // Define weight and bias sizes
    parameter WEIGHTS1_SIZE = 50176;
    parameter BIASES1_SIZE = 64;
    parameter WEIGHTS2_SIZE = 2048;
    parameter BIASES2_SIZE = 32;
    parameter WEIGHTS3_SIZE = 320;
    parameter BIASES3_SIZE = 10;

    // Define memory for weights and biases (assumed preloaded)
    wire signed [15:0] weights1;
    wire signed [15:0] biases1 [0:BIASES1_SIZE-1];
    
    wire signed [15:0] weights2;
    wire signed [15:0] biases2 [0:BIASES2_SIZE-1];
    
    wire signed [15:0] weights3;
    wire signed [15:0] biases3 [0:BIASES3_SIZE-1];

    // Define address registers for weights and biases
    reg [15:0] weights1_addr;
    reg [15:0] weights2_addr;
    reg [15:0] weights3_addr;

    // Instantiate the BRAM for weights1
    mem_weights1 mem_weights1(clk, weights1_addr, weights1);
    mem_weights2 mem_weights2(clk, weights2_addr, weights2);
    mem_weights3 mem_weights3(clk, weights3_addr, weights3);

    // Layer Outputs
    reg signed [15:0] hidden1 [0:HIDDEN1_SIZE-1];
    reg signed [15:0] hidden2 [0:HIDDEN2_SIZE-1];
    reg signed [15:0] output_layer [0:OUTPUT_SIZE-1];
    
    // ReLU activation function
    function signed [15:0] relu;
        input signed [15:0] x;
        begin
            relu = (x > 0) ? x : 0;
        end
    endfunction

    // Define the loop variables
    integer i, j, i_features;
    reg [5:0] i_neuron1;

    // ============================================
    // combinational Computation of the neurons
    // ============================================

    // layer 1
    reg signed [15:0] new_hidden1 [0:HIDDEN1_SIZE-1];
    reg signed [15:0] neuron_out1 [0:HIDDEN1_SIZE-1];

    always @(*) begin
        for (i = 0; i < HIDDEN1_SIZE; i = i + 1) begin
            new_hidden1[i] = relu(neuron_out1[i] + biases1[i]); 
        end
    end

    // layer 2
    reg signed [15:0] new_hidden2 [0:HIDDEN2_SIZE-1];
    reg signed [31:0] multiplier_out2 [0:HIDDEN2_SIZE-1][0:HIDDEN1_SIZE-1];
    reg signed [15:0] shift_out2 [0:HIDDEN2_SIZE-1][0:HIDDEN1_SIZE-1];
    always @(*) begin
        for (i = 0; i < HIDDEN2_SIZE; i = i + 1) begin
            new_hidden2[i] = biases2[i];
            for (j = 0; j < HIDDEN1_SIZE; j = j + 1) begin
                multiplier_out2[i][j] = hidden1[j] * weights2[i*HIDDEN1_SIZE+j];
                shift_out2[i][j] = multiplier_out2[i][j] >> 8;
                new_hidden2[i] = new_hidden2[i] + shift_out2[i][j];
            end
            new_hidden2[i] = relu(new_hidden2[i]);
        end
    end

    // Output Layer computation
    reg signed [15:0] new_output_layer [0:OUTPUT_SIZE-1];
    reg signed [31:0] multiplier_out3 [0:OUTPUT_SIZE-1][0:HIDDEN2_SIZE-1];
    reg signed [15:0] shift_out3 [0:OUTPUT_SIZE-1][0:HIDDEN2_SIZE-1];
    always @(*) begin
        for (i = 0; i < OUTPUT_SIZE; i = i + 1) begin
            new_output_layer[i] = biases3[i];
            for (j = 0; j < HIDDEN2_SIZE; j = j + 1) begin
                multiplier_out3[i][j] = hidden2[j] * weights3[i*HIDDEN2_SIZE+j];
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
            weights1_addr <= 0;
            i_features <= 0;
            i_neuron1 <= 0;
            for (i = 0; i < INPUT_SIZE; i = i + 1) begin
                features[i] <= 0;
            end
            for (i = 0; i < HIDDEN1_SIZE; i = i + 1) begin
                neuron_out1[i] <= 0;
            end
        end 
        else if (state == IDLE) begin
            if (start) begin
                // Load the input features
                for (i = 0; i < INPUT_SIZE; i = i + 1) begin
                    features[i] <= in_features[i];
                end
                for (i = 0; i < HIDDEN1_SIZE; i = i + 1) begin
                    neuron_out1[i] <= 0;
                end
                state <= COMPUTE;
                done <= 0;
                count_clocks <= 0;
                weights1_addr <= 0;
                i_features <= 0;
                i_neuron1 <= 0;
            end
        end 
        else begin
            // Layer 1 computation
            neuron_out1[i_neuron1] <= neuron_out1[i_neuron1] + (features[i_features] == 1 ? weights1 : 0); 
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
            if (count_clocks >= WEIGHTS1_SIZE + 2) begin
                state <= IDLE;
                done <= 1;
            end
            else begin
                count_clocks <= count_clocks + 1;
            end

            // Update the weights1 address
            if (weights1_addr >= WEIGHTS1_SIZE - 1) begin
                weights1_addr <= 0;
            end
            else begin
                weights1_addr <= weights1_addr + 1;
            end
            if (i_features >= INPUT_SIZE - 1) begin
                i_features <= 0;
                i_neuron1 <= i_neuron1 + 1;
            end
            else begin
                i_features <= i_features + 1;
            end
        end
    end

    assign biases1[0] = 16'b0000000001110011;
    assign biases1[1] = 16'b0000000000100101;
    assign biases1[2] = 16'b0000000001000000;
    assign biases1[3] = 16'b0000000001010010;
    assign biases1[4] = 16'b1111111111100000;
    assign biases1[5] = 16'b0000000001000110;
    assign biases1[6] = 16'b0000000000000000;
    assign biases1[7] = 16'b0000000001010000;
    assign biases1[8] = 16'b1111111101110101;
    assign biases1[9] = 16'b1111111110010110;
    assign biases1[10] = 16'b1111111111001111;
    assign biases1[11] = 16'b0000000000011100;
    assign biases1[12] = 16'b0000000001000100;
    assign biases1[13] = 16'b0000000000011010;
    assign biases1[14] = 16'b1111111111111001;
    assign biases1[15] = 16'b1111111110010111;
    assign biases1[16] = 16'b1111111110010011;
    assign biases1[17] = 16'b0000000100011101;
    assign biases1[18] = 16'b0000000000011001;
    assign biases1[19] = 16'b1111111111111010;
    assign biases1[20] = 16'b0000000001001100;
    assign biases1[21] = 16'b0000000100001110;
    assign biases1[22] = 16'b0000000001000101;
    assign biases1[23] = 16'b1111111110100000;
    assign biases1[24] = 16'b0000000001001101;
    assign biases1[25] = 16'b0000000000011000;
    assign biases1[26] = 16'b1111111111101101;
    assign biases1[27] = 16'b0000000001001010;
    assign biases1[28] = 16'b0000000010000110;
    assign biases1[29] = 16'b0000000010011001;
    assign biases1[30] = 16'b0000000000010111;
    assign biases1[31] = 16'b0000000000100101;
    assign biases1[32] = 16'b1111111111110100;
    assign biases1[33] = 16'b1111111111101000;
    assign biases1[34] = 16'b0000000010011111;
    assign biases1[35] = 16'b0000000000110111;
    assign biases1[36] = 16'b0000000000001001;
    assign biases1[37] = 16'b0000000000101001;
    assign biases1[38] = 16'b0000000000011000;
    assign biases1[39] = 16'b0000000010011101;
    assign biases1[40] = 16'b1111111001101000;
    assign biases1[41] = 16'b1111111101011000;
    assign biases1[42] = 16'b0000000010010111;
    assign biases1[43] = 16'b0000000000000001;
    assign biases1[44] = 16'b0000000000011001;
    assign biases1[45] = 16'b1111111110001111;
    assign biases1[46] = 16'b0000000001000110;
    assign biases1[47] = 16'b0000000000101110;
    assign biases1[48] = 16'b0000000000110100;
    assign biases1[49] = 16'b0000000100010011;
    assign biases1[50] = 16'b0000000010000101;
    assign biases1[51] = 16'b1111111111111000;
    assign biases1[52] = 16'b0000000010010001;
    assign biases1[53] = 16'b1111111111110110;
    assign biases1[54] = 16'b0000000000000000;
    assign biases1[55] = 16'b0000000000000010;
    assign biases1[56] = 16'b0000000001000000;
    assign biases1[57] = 16'b0000000001001100;
    assign biases1[58] = 16'b1111111110100001;
    assign biases1[59] = 16'b0000000010010101;
    assign biases1[60] = 16'b1111111111100010;
    assign biases1[61] = 16'b0000000010100000;
    assign biases1[62] = 16'b0000000000001000;
    assign biases1[63] = 16'b1111111111101010;
    
    assign biases2[0] = 16'b0000000010000011;
    assign biases2[1] = 16'b0000000001110011;
    assign biases2[2] = 16'b0000000010001011;
    assign biases2[3] = 16'b0000000011010100;
    assign biases2[4] = 16'b0000000010101100;
    assign biases2[5] = 16'b0000000000111101;
    assign biases2[6] = 16'b0000000011111100;
    assign biases2[7] = 16'b0000000011110111;
    assign biases2[8] = 16'b0000000010110001;
    assign biases2[9] = 16'b1111111110001000;
    assign biases2[10] = 16'b0000000000100001;
    assign biases2[11] = 16'b0000000100101101;
    assign biases2[12] = 16'b1111111101101000;
    assign biases2[13] = 16'b0000000110110010;
    assign biases2[14] = 16'b0000000100000101;
    assign biases2[15] = 16'b0000000010011100;
    assign biases2[16] = 16'b0000000000010100;
    assign biases2[17] = 16'b0000000100100011;
    assign biases2[18] = 16'b1111111101111111;
    assign biases2[19] = 16'b1111111110010101;
    assign biases2[20] = 16'b0000000011101001;
    assign biases2[21] = 16'b0000000010101111;
    assign biases2[22] = 16'b0000000011010101;
    assign biases2[23] = 16'b0000000100011011;
    assign biases2[24] = 16'b1111111111010110;
    assign biases2[25] = 16'b0000000101010010;
    assign biases2[26] = 16'b0000000010000000;
    assign biases2[27] = 16'b0000000000000111;
    assign biases2[28] = 16'b0000000001011011;
    assign biases2[29] = 16'b1111111100101010;
    assign biases2[30] = 16'b1111111110011101;
    assign biases2[31] = 16'b0000000001110000;
    
    assign biases3[0] = 16'b0000000000000100;
    assign biases3[1] = 16'b1111111011110110;
    assign biases3[2] = 16'b0000000000011001;
    assign biases3[3] = 16'b1111111111110100;
    assign biases3[4] = 16'b0000000001000000;
    assign biases3[5] = 16'b0000000000110111;
    assign biases3[6] = 16'b1111111110001101;
    assign biases3[7] = 16'b1111111101100110;
    assign biases3[8] = 16'b0000000011001010;
    assign biases3[9] = 16'b0000000010001111;

endmodule
