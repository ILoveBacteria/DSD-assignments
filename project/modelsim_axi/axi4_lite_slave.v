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
    reg [2:0] count_clocks; 

    // Define the parameters for layer sizes
    parameter INPUT_SIZE = 784;
    parameter HIDDEN1_SIZE = 64;
    parameter HIDDEN2_SIZE = 32;
    parameter OUTPUT_SIZE = 10;
    
    // Define memory for weights and biases (assumed preloaded)
    (* ram_style = "block" *) reg signed [15:0] mem_weights1 [0:65535];
    (* ram_style = "block" *) reg signed [15:0] mem_biases1 [0:63];
    
    (* ram_style = "block" *) reg signed [15:0] mem_weights2 [0:2047];
    (* ram_style = "block" *) reg signed [15:0] mem_biases2 [0:31];
    
    (* ram_style = "block" *) reg signed [15:0] mem_weights3 [0:511];
    (* ram_style = "block" *) reg signed [15:0] mem_biases3 [0:15];

    reg signed [15:0] weights1 [0:65535];
    reg signed [15:0] biases1 [0:63];
    
    reg signed [15:0] weights2 [0:2047];
    reg signed [15:0] biases2 [0:31];
    
    reg signed [15:0] weights3 [0:511];
    reg signed [15:0] biases3 [0:15];

    integer i, j;

    always @(posedge clk) begin
        for (i = 0; i < 65536; i = i + 1) begin
            weights1[i] <= mem_weights1[i];
        end
        for (i = 0; i < 64; i = i + 1) begin
            biases1[i] <= mem_biases1[i];
        end
        for (i = 0; i < 2048; i = i + 1) begin
            weights2[i] <= mem_weights2[i];
        end
        for (i = 0; i < 32; i = i + 1) begin
            biases2[i] <= mem_biases2[i];
        end
        for (i = 0; i < 512; i = i + 1) begin
            weights3[i] <= mem_weights3[i];
        end
        for (i = 0; i < 16; i = i + 1) begin
            biases3[i] <= mem_biases3[i];
        end
    end
    
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


    // ============================================
    // combinational Computation of the neurons
    // ============================================

    // layer 1
    reg signed [15:0] new_hidden1 [0:HIDDEN1_SIZE-1];
    always @(*) begin
        for (i = 0; i < HIDDEN1_SIZE; i = i + 1) begin
            new_hidden1[i] = biases1[i];
            for (j = 0; j < INPUT_SIZE; j = j + 1) begin
                new_hidden1[i] = new_hidden1[i] + (features[j] == 1 ? weights1[i*INPUT_SIZE+j] : 0); 
            end
            new_hidden1[i] = relu(new_hidden1[i]); 
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
        $readmemb("layer1_weight.mem", mem_weights1);
        $readmemb("layer1_bias.mem", mem_biases1);
        $readmemb("layer2_weight.mem", mem_weights2);
        $readmemb("layer2_bias.mem", mem_biases2);
        $readmemb("layer3_weight.mem", mem_weights3);
        $readmemb("layer3_bias.mem", mem_biases3);
    end
endmodule
