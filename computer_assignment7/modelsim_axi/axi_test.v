module axi_tb();
    // Parameters
    reg [255:0] a;
    reg [255:0] b;

    reg                           ACLK; // # of used = 1
    reg                           ARESETN; // # of used = 1

    // Read Address Channel regS
    reg           [31:0]   S_ARADDR; // # of used = 4
    reg                           S_ARVALID; // # of used = 2

    // Read Data Channel regS
    reg                           S_RREADY; // # of used = 1

    // Write Address Channel regS
    /* verilator lint_off UNUSED */
    reg           [31:0]   S_AWADDR; // # of used = 4
    reg                           S_AWVALID; // # of used = 2

    // Write Data  Channel regS
    reg          [31:0] S_WDATA; // # of used = 2
    reg          [3:0]            S_WSTRB; // # of used = 0
    reg                           S_WVALID; // # of used = 1

    // Write Response Channel regS
    reg                           S_BREADY; // # of used = 1

    // Read Address Channel regS
    wire                     S_ARREADY; // # of used = 2

    // Read Data Channel OUTPUTS
    wire [31:0]    S_RDATA; // # of used = 1
    wire          [1:0]      S_RRESP; // # of used = 1
    wire                     S_RVALID; // # of used = 2

    // Write Address Channel OUTPUTS
    wire                     S_AWREADY; // # of used = 2
    wire                     S_WREADY; // # of used = 2
    
    // Write Response Channel OUTPUTS
    wire          [1:0]      S_BRESP; // # of used = 1
    wire                     S_BVALID; // # of used = 2

    // instantiate
    axi4_lite_slave axi (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .S_ARADDR(S_ARADDR),
        .S_ARVALID(S_ARVALID),
        .S_RREADY(S_RREADY),
        .S_AWADDR(S_AWADDR),
        .S_AWVALID(S_AWVALID),
        .S_WDATA(S_WDATA),
        .S_WSTRB(S_WSTRB),
        .S_WVALID(S_WVALID),
        .S_BREADY(S_BREADY),
        .S_ARREADY(S_ARREADY),
        .S_RDATA(S_RDATA),
        .S_RRESP(S_RRESP),
        .S_RVALID(S_RVALID),
        .S_AWREADY(S_AWREADY),
        .S_WREADY(S_WREADY),
        .S_BRESP(S_BRESP),
        .S_BVALID(S_BVALID)
    );

    // Clock generation
    always begin
        ACLK = 0; #5;
        ACLK = 1; #5;
    end

    reg [31:0] temp_var;

    // Test stimulus
    initial begin
        // Initialize
        a = 0;
        b = 0;
        S_ARADDR = 0;
        S_ARVALID = 0;
        S_RREADY = 0;
        S_AWADDR = 0;
        S_AWVALID = 0;
        S_WDATA = 0;
        S_WSTRB = 0;
        S_WVALID = 0;
        S_BREADY = 0;
       
        ARESETN = 1;
        // reset
        ARESETN = 0;
        #10;
        ARESETN = 1;
        
        // Test 1: Combinational Addition (5 + 3 = 8)
        #10;
        a = 256'd5;  // 5
        b = 256'd3;  // 3

        // write
        temp_var = 5;
        S_AWADDR = temp_var << 2;
        S_WDATA = 5;
        S_WVALID = 1;
        S_AWVALID = 1;
        S_BREADY = 1;

        #20
        S_AWVALID = 0;
        #100
        S_WVALID = 0;
        S_BREADY = 0;

        // Read data from address 0 to 15
        temp_var = 16;
        S_ARADDR = temp_var << 2;
        S_ARVALID = 1;
        S_RREADY = 1;

        #10
        
        wait(S_RVALID == 1'b1);

        temp_var = 17;
        S_ARADDR = temp_var << 2;

        #10

        wait(S_RVALID == 1'b1);
        
        temp_var = 18;
        S_ARADDR = temp_var << 2;
    end
endmodule