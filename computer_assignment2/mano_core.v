module mano_core(input clk, rst);

    //************************************
    // Control signals
    //************************************
    reg ar_ld, ar_clr, ar_inr;
    reg ac_ld, ac_clr, ac_inr;
    reg dr_ld, dr_clr, dr_inr;
    reg tr_ld, tr_clr, tr_inr;
    reg pc_ld, pc_clr, pc_inr;
    reg ir_ld;
    reg wr, rd;
    reg sc_clr;
    reg [2:0] sc;
    reg [3:0] bus_sel;
    reg [3:0] alu_func;

    //************************************
    // Registers and busses
    //************************************
    wire [15:0] mem_out;
    reg  [15:0] alu_out, abus, dr, ac, tr, ir;
    reg  [11:0] pc = 0, ar;
    reg  [7:0]  inpr, outr;
    reg  [15:0] mem [31:0];
    reg  i;
    
    //************************************
    // 32x16 Memory
    //************************************
    always @(posedge clk)
    begin
        if (wr == 1)
            mem[ar[5:0]] = abus;
        mem[0]  = 16'h100A;
        mem[1]  = 16'h7800;
        mem[10] = 16'h0005;    
    end
    assign mem_out = mem[ar[5:0]];

    //************************************
    // Bus assigner
    //************************************
    always @(*)
    begin
        case (bus_sel)
            3'b001:  abus = ar;
            3'b010:  abus = pc;
            3'b011:  abus = dr;
            3'b100:  abus = ac;
            3'b101:  abus = ir;
            3'b110:  abus = tr;
            default: abus = mem_out;
        endcase
    end
 
    //************************************
    // ALU
    //************************************
    always @(*)
    begin
        case (alu_func)
            3'b000:  alu_out = dr;
            3'b001:  alu_out = dr & ac;
            3'b010:  alu_out = dr + ac;
            default: alu_out = dr + ac;
        endcase
    end

    //************************************
    // State machine always
    //************************************
    always @(posedge clk)
    begin
        if (rst == 1)
            sc = 3'b000;
        else
        begin
            if (sc_clr == 1)
                sc = 0;
            else  
                sc = sc + 1;
            
            if (sc == 3'b101)
                i = ir[15];
            
            if (ac_clr == 1)
                ac = 0;
            else if (ac_ld == 1)  
                ac = alu_out;

            if (ar_clr == 1)
                ar = 0;
            else if (ar_ld == 1)  
                ar = abus;

            if (dr_clr == 1)
                dr = 0;
            else if (dr_ld == 1)  
                dr = abus;

            if (pc_clr == 1)
                pc = 0;
            else if (pc_ld == 1)  
                pc = abus;
            else if (pc_inr == 1)  
                pc = pc + 1;

            if (ir_ld == 1)
                ir = abus;
        end
    end

    //************************************
    // Combinational state machine always
    //************************************
    always @(*)
    begin
        ar_ld = 0;
        ar_clr = 0;
        ac_ld = 0;
        ac_clr = 0;
        ac_inr = 0;
        dr_ld = 0;
        dr_clr = 0;
        tr_ld = 0;
        tr_clr = 0;
        pc_ld = 0;
        pc_clr = 0;
        pc_inr = 0;
        ir_ld = 0;
        sc_clr = 0;
        wr = 0;
        rd = 0;
        case (sc)
            3'b000: 
            begin 
                ar_ld = 1; 
                bus_sel = 3'b010;  //PC
            end

            3'b001: 
            begin 
                pc_inr = 1; 
                bus_sel = 3'b111;  //mem
                ir_ld = 1;
            end
            
            3'b010: 
            begin 
                bus_sel = 3'b101;  //IR
                ar_ld = 1;
            end
            
            3'b011: 
            begin 
                if (ir[14:12] == 3'b111)
                begin
                    if (ir[11:0] == 12'b100000000000)
                    begin
                        ac_clr = 1;
                        sc_clr = 1;
                    end
                end
                else
                begin
                    if (i == 1)
                    begin
                        ar_ld = 1;
                        bus_sel = 3'b111;
                    end
                end
            end
            
            3'b100: 
            begin 
            if (ir[14:12] == 3'b000)
            begin
                dr_ld = 1;
                bus_sel = 3'b111;
            end
                sc_clr = 1;
            end
        endcase
    end
endmodule
