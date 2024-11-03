module mano_core(input clk, rst);

    //************************************
    // Control signals
    //************************************
    reg ar_ld, ar_clr, ar_inr;
    reg ac_ld, ac_clr, ac_inr;
    reg dr_ld, dr_clr, dr_inr;
    reg tr_ld, tr_clr, tr_inr;
    reg pc_ld, pc_clr, pc_inr;
    reg ir_ld, outr_ld;
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
        mem[0]  = 16'h7800; // Clear AC
        mem[1]  = 16'h7020; // Increment AC
        mem[2]  = 16'h7010; // Skip next instruction if AC is positive
        mem[3]  = 16'h7020; // Increment AC
        mem[4]  = 16'h7004; // Skip next instruction if AC is zero
        mem[5]  = 16'h7200; // Complement AC
        mem[6]  = 16'h7080; // Circulate right AC
        mem[7]  = 16'h7040; // Circulate left AC
        mem[8]  = 16'h0014; // And the content in mem[20] with AC
        mem[9]  = 16'h2015; // Load the content in mem[21] to AC
        mem[20] = 16'h0005;    
        mem[21] = 16'h1234;    
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
            3'b011:  alu_out = ~ac;
            3'b100:  alu_out = {ac[0], ac[15:1]};
            3'b101:  alu_out = {ac[14:0], ac[15]};
            default: alu_out = dr;
        endcase
    end

    //************************************
    // State machine always
    //************************************
    always @(posedge clk)
    begin
        if (rst == 1)
            sc = 3'b000; // reset state machine
        else
        begin
            // Update sequence counter
            if (sc_clr == 1)
                sc = 0;
            else  
                sc = sc + 1;
            
            // Copy IR[15] to i
            if (sc == 3'b010)
                i = ir[15];
            
            // Update acumulator register
            if (ac_clr == 1)
                ac = 0;
            else if (ac_ld == 1)  
                ac = alu_out;
            else if (ac_inr == 1)
                ac = ac + 1;

            // Update address register
            if (ar_clr == 1)
                ar = 0;
            else if (ar_ld == 1)  
                ar = abus;
            else if (ar_inr == 1)
                ar = ar + 1;

            // Update data register
            if (dr_clr == 1)
                dr = 0;
            else if (dr_ld == 1)  
                dr = abus;
            else if (dr_inr == 1)
                dr = dr + 1;

            // Update program counter
            if (pc_clr == 1)
                pc = 0;
            else if (pc_ld == 1)  
                pc = abus;
            else if (pc_inr == 1)  
                pc = pc + 1;

            // Update instruction register
            if (ir_ld == 1)
                ir = abus;

            // Update TR
            if (tr_clr == 1)
                tr = 0;
            else if (tr_ld == 1)  
                tr = abus;
            else if (tr_inr == 1)  
                tr = tr + 1;

            // Update OUTR
            if (outr_ld == 1)
                outr = abus;

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
            // Copy PC to AR
            3'b000: 
            begin 
                ar_ld = 1; 
                bus_sel = 3'b010; // PC on the bus
            end

            // Read the next instruction from Memory and store it into IR
            3'b001: 
            begin
                pc_inr = 1; 
                ir_ld = 1;
                bus_sel = 3'b111; // Memory on the bus
            end
            
            // Copy the lower 12bits from IR to AR
            3'b010: 
            begin 
                ar_ld = 1;
                bus_sel = 3'b101; // IR on the bus
            end
            
            // Instruction executing - cycle 1
            3'b011: 
            begin
                // Register reference instruction
                if (ir[14:12] == 3'b111)
                begin
                    // Clear AC
                    if (ir[11:0] == 12'h800)
                    begin
                        ac_clr = 1;
                        sc_clr = 1;
                    end
                    // Increment AC
                    else if (ir[11:0] == 12'h020)
                    begin
                        ac_inr = 1;
                        sc_clr = 1;
                    end
                    // Complement AC
                    else if (ir[11:0] == 12'h200)
                    begin
                        ac_ld = 1;
                        alu_func = 3'b011;
                        sc_clr = 1;
                    end
                    // Circulate right AC
                    else if (ir[11:0] == 12'h080)
                    begin
                        ac_ld = 1;
                        alu_func = 3'b100;
                        sc_clr = 1;
                    end
                    // Circulate left AC
                    else if (ir[11:0] == 12'h040)
                    begin
                        ac_ld = 1;
                        alu_func = 3'b101;
                        sc_clr = 1;
                    end
                    // Skip next instruction if AC is positive
                    else if (ir[11:0] == 12'h010)
                    begin
                        if (ac[15] == 0)
                            pc_inr = 1;
                        sc_clr = 1;
                    end
                    // Skip next instruction if AC is negative
                    else if (ir[11:0] == 12'h008)
                    begin
                        if (ac[15] == 1)
                            pc_inr = 1;
                        sc_clr = 1;
                    end
                    // Skip next instruction if AC is zero
                    else if (ir[11:0] == 12'h004)
                    begin
                        if (ac == 0)
                            pc_inr = 1;
                        sc_clr = 1;
                    end
                end
                // Memory reference instruction
                else
                begin
                    if (i == 1)
                    begin
                        ar_ld = 1;
                        bus_sel = 3'b111;
                    end
                end
            end

            // Instruction executing - cycle 2
            3'b100:
            begin
                // Memory reference instruction
                // Read operand from memory and store it in DR (AND, ADD, LDA instructions)
                if (ir[14:12] == 3'b000 || ir[14:12] == 3'b001 || ir[14:12] == 3'b010)
                begin
                    dr_ld = 1;
                    bus_sel = 3'b111; // Memory on the bus
                end
            end

            // Instruction executing - cycle 3
            3'b101:
            begin
                // Memory reference instruction
                // AND instruction - DR & AC
                if (ir[14:12] == 3'b000)
                begin
                    alu_func = 3'b001; // AND function
                    ac_ld = 1;
                    sc_clr = 1;
                end
                // ADD instruction - DR + AC
                else if (ir[14:12] == 3'b001)
                begin
                    // TODO: implement e register
                end
                // LDA instruction - DR -> AC
                else if (ir[14:12] == 3'b010)
                begin
                    alu_func = 0; // Pass DR to AC
                    ac_ld = 1;
                    sc_clr = 1;
                end
            end

            default: sc_clr = 1;
        endcase
    end
endmodule
