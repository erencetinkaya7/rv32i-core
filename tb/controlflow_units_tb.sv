module controlflow_units_tb;

    logic [31:0] instruction;
    logic [2:0]  imm_sel;
    logic [31:0] immediate;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [2:0]  funct3;
    logic        branch_enable;
    logic        branch_taken;

    localparam logic [2:0] IMM_I = 3'b000;
    localparam logic [2:0] IMM_S = 3'b001;
    localparam logic [2:0] IMM_B = 3'b010;
    localparam logic [2:0] IMM_U = 3'b011;
    localparam logic [2:0] IMM_J = 3'b100;

    immediate_generator imm_gen (
        .instruction(instruction),
        .imm_sel(imm_sel),
        .immediate(immediate)
    );

    branch_unit branch (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .funct3(funct3),
        .branch_enable(branch_enable),
        .branch_taken(branch_taken)
    );

    initial begin

        // -------------------------
        // Immediate Generator Tests
        // -------------------------

        instruction = 32'h00500093;   // addi x1,x0,5
        imm_sel = IMM_I;
        #1;
        if (immediate == 32'd5)
            $display("IMM_I PASS");
        else
            $display("IMM_I FAIL: %h", immediate);


        instruction = 32'h00102423;   // sw x1,8(x0)
        imm_sel = IMM_S;
        #1;
        if (immediate == 32'd8)
            $display("IMM_S PASS");
        else
            $display("IMM_S FAIL: %h", immediate);


        instruction = 32'h00000463;   // beq x0,x0,+8
        imm_sel = IMM_B;
        #1;
        if (immediate == 32'd8)
            $display("IMM_B +8 PASS");
        else
            $display("IMM_B +8 FAIL: %h", immediate);


        instruction = 32'hFE000EE3;   // beq x0,x0,-4
        imm_sel = IMM_B;
        #1;
        if (immediate == 32'hFFFFFFFC)
            $display("IMM_B -4 PASS");
        else
            $display("IMM_B -4 FAIL: %h", immediate);


        instruction = 32'h123452B7;   // lui x5,0x12345
        imm_sel = IMM_U;
        #1;
        if (immediate == 32'h12345000)
            $display("IMM_U PASS");
        else
            $display("IMM_U FAIL: %h", immediate);


        instruction = 32'h010000EF;   // jal x1,+16
        imm_sel = IMM_J;
        #1;
        if (immediate == 32'd16)
            $display("IMM_J +16 PASS");
        else
            $display("IMM_J +16 FAIL: %h", immediate);


        instruction = 32'hFFDFF0EF;   // jal x1,-4
        imm_sel = IMM_J;
        #1;
        if (immediate == 32'hFFFFFFFC)
            $display("IMM_J -4 PASS");
        else
            $display("IMM_J -4 FAIL: %h", immediate);


        // -------------------------
        // Branch Unit Tests
        // -------------------------

        branch_enable = 1'b0;
        rs1_data = 32'd5;
        rs2_data = 32'd5;
        funct3 = 3'b000;
        #1;
        if (branch_taken == 1'b0)
            $display("BRANCH DISABLE PASS");
        else
            $display("BRANCH DISABLE FAIL");


        // BEQ - Branch if Equal
        branch_enable = 1'b1;
        rs1_data = 32'd5;
        rs2_data = 32'd5;
        funct3 = 3'b000;
        #1;
        if (branch_taken)
            $display("BEQ PASS");
        else
            $display("BEQ FAIL");


        // BNE - Branch if Not Equal
        rs1_data = 32'd5;
        rs2_data = 32'd7;
        funct3 = 3'b001;
        #1;
        if (branch_taken)
            $display("BNE PASS");
        else
            $display("BNE FAIL");


        // BLT - Branch if Less Than (signed)
        rs1_data = 32'hFFFFFFFF; // -1
        rs2_data = 32'd1;
        funct3 = 3'b100;
        #1;
        if (branch_taken)
            $display("BLT PASS");
        else
            $display("BLT FAIL");


        // BGE - Branch if Greater or Equal (signed)
        rs1_data = 32'd5;
        rs2_data = 32'hFFFFFFFE; // -2
        funct3 = 3'b101;
        #1;
        if (branch_taken)
            $display("BGE PASS");
        else
            $display("BGE FAIL");


        // BLTU - Branch if Less Than Unsigned
        rs1_data = 32'd1;
        rs2_data = 32'hFFFFFFFF;
        funct3 = 3'b110;
        #1;
        if (branch_taken)
            $display("BLTU PASS");
        else
            $display("BLTU FAIL");


        // BGEU - Branch if Greater or Equal Unsigned
        rs1_data = 32'hFFFFFFFF;
        rs2_data = 32'd1;
        funct3 = 3'b111;
        #1;
        if (branch_taken)
            $display("BGEU PASS");
        else
            $display("BGEU FAIL");


        $finish;

    end

endmodule
