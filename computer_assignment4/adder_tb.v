module adder_tb();

    // Parameters
    parameter BIT = 3;

    // Inputs
    reg addsub;
    reg clk;
    reg nrst;
    reg [BIT-1:0] A;
    reg [BIT-1:0] B;

    // Outputs
    wire [BIT-1:0] SUM;
    wire cout;

    // Instantiate the Unit Under Test (UUT)
    adder #(BIT) uut (
        .addsub(addsub),
        .clk(clk),
        .nrst(nrst),
        .A(A),
        .B(B),
        .SUM(SUM),
        .cout(cout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        nrst = 0;
        addsub = 0;
        A = 0;
        B = 0;

        // Reset the design
        #18 nrst = 1;

        // Apply test vectors
        #10 A = 3'b001; B = 3'b010; addsub = 0; // 1 + 2 = 3
        #10 A = 3'b011; B = 3'b001; addsub = 0; // 3 + 1 = 4
        #10 A = 3'b100; B = 3'b011; addsub = 0; // 4 + 3 = 7
        #10 A = 3'b101; B = 3'b010; addsub = 1; // 5 - 2 = 3
        #10 A = 3'b110; B = 3'b011; addsub = 1; // 6 - 3 = 3
        #10 A = 3'b111; B = 3'b001; addsub = 1; // 7 - 1 = 6
    end


endmodule