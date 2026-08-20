module alu_decoder_tb;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [3:0] alu_control;

    alu_decoder dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

    initial begin

        $dumpfile("alu_decoder.vcd");
        $dumpvars(0, alu_decoder_tb);

        // -------------------------
        // R-TYPE
        // -------------------------

        // ADD
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #1;
        if (alu_control == 4'd0)
            $display("R ADD PASS");
        else
            $display("R ADD FAIL");

        // SUB
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #1;
        if (alu_control == 4'd1)
            $display("R SUB PASS");
        else
            $display("R SUB FAIL");

        // SLL
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #1;
        if (alu_control == 4'd5)
            $display("R SLL PASS");
        else
            $display("R SLL FAIL");

        // SLT
        funct3 = 3'b010;
        #1;
        if (alu_control == 4'd8)
            $display("R SLT PASS");
        else
            $display("R SLT FAIL");

        // SLTU
        funct3 = 3'b011;
        #1;
        if (alu_control == 4'd9)
            $display("R SLTU PASS");
        else
            $display("R SLTU FAIL");

        // XOR
        funct3 = 3'b100;
        #1;
        if (alu_control == 4'd4)
            $display("R XOR PASS");
        else
            $display("R XOR FAIL");

        // SRL
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #1;
        if (alu_control == 4'd6)
            $display("R SRL PASS");
        else
            $display("R SRL FAIL");

        // SRA
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #1;
        if (alu_control == 4'd7)
            $display("R SRA PASS");
        else
            $display("R SRA FAIL");

        // OR
        funct3 = 3'b110;
        #1;
        if (alu_control == 4'd3)
            $display("R OR PASS");
        else
            $display("R OR FAIL");

        // AND
        funct3 = 3'b111;
        #1;
        if (alu_control == 4'd2)
            $display("R AND PASS");
        else
            $display("R AND FAIL");


        // -------------------------
        // I-TYPE
        // -------------------------

        opcode = 7'b0010011;

        // ADDI
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #1;
        if (alu_control == 4'd0)
            $display("I ADDI PASS");
        else
            $display("I ADDI FAIL");

        // ORI
        funct3 = 3'b110;
        #1;
        if (alu_control == 4'd3)
            $display("I ORI PASS");
        else
            $display("I ORI FAIL");

        // SRAI
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #1;
        if (alu_control == 4'd7)
            $display("I SRAI PASS");
        else
            $display("I SRAI FAIL");

        // SRLI
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #1;
        if (alu_control == 4'd6)
            $display("I SRLI PASS");
        else
            $display("I SRLI FAIL");

        $finish;

    end

endmodule
