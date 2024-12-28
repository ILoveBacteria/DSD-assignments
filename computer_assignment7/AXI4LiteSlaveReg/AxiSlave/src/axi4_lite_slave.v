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
   
    reg  [2:0] state, next_state;
    reg  [ADDRESS-1:0] read_addr;
    wire [ADDRESS-1:0] S_ARADDR_T;
    wire [ADDRESS-1:0] S_AWADDR_T;
    reg  [DATA_WIDTH-1:0] register [0:REG_NUM-1]; // 32 ta register 32bits
    reg  [DATA_WIDTH-1:0] result;
    
    // Address Read
    assign S_ARREADY = (state == RADDR_CHANNEL) ? 1 : 0;
    // Read
    assign S_RVALID = (state == RDATA_CHANNEL) ? 1 : 0;
    assign S_RDATA  = (state == RDATA_CHANNEL) ? ((read_addr == 32) ? result : register[read_addr]) : 0;
    assign S_RRESP  = (state == RDATA_CHANNEL) ? 2'b00 : 0;
    // Address Write
    assign S_AWREADY = (state == WRITE_CHANNEL) ? 1 : 0;
    // Write
    assign S_WREADY = (state == WRITE_CHANNEL) ? 1 : 0;
    // Responce
    assign S_BVALID = (state == WRESP_CHANNEL) ? 1 : 0;
    assign S_BRESP  = (state == WRESP_CHANNEL )? 0:0;

    assign S_ARADDR_T = S_ARADDR[ADDRESS-1:2]; // Read address 
    assign S_AWADDR_T = S_AWADDR[ADDRESS-1:2]; // Write address 
    
    always @(posedge ACLK) begin
        // Reset the register array
        if (~ARESETN) begin
            result = 32'b0;
            state <= IDLE;
        end
        else begin
            state <= next_state;
            if (state == WRITE_CHANNEL) begin
                register[S_AWADDR_T] <= S_WDATA;
                result[15:0] = result[15:0] + S_WDATA[15:0];
            end
            else if (state == RADDR_CHANNEL) begin
                read_addr <= S_ARADDR_T;
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
                if (S_ARVALID && S_ARREADY) 
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

