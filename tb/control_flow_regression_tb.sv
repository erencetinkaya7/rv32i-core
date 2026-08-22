`timescale 1ns/1ps

module control_flow_regression_tb;

    logic clk;
    logic reset;
    integer errors;

    rv32i_core dut (
        .clk   (clk),
        .reset (reset)
    );

    always #5 clk = ~clk;


    task check_reg(
        input integer reg_num,
        input logic [31:0] expected
    );
        begin
            if (dut.rf.registers[reg_num] !== expected) begin
                $display(
                    "FAIL: x%0d = %h, expected %h",
                    reg_num,
                    dut.rf.registers[reg_num],
                    expected
                );
                errors = errors + 1;
            end
            else begin
                $display(
                    "PASS: x%0d = %h",
                    reg_num,
                    dut.rf.registers[reg_num]
                );
            end
        end
    endtask


    task check_unwritten(
        input integer reg_num
    );
        begin
            if (dut.rf.registers[reg_num] === 32'hxxxxxxxx) begin
                $display(
                    "PASS: x%0d was not written",
                    reg_num
                );
            end
            else begin
                $display(
                    "FAIL: x%0d was unexpectedly written: %h",
                    reg_num,
                    dut.rf.registers[reg_num]
                );
                errors = errors + 1;
            end
        end
    endtask


    initial begin

        clk = 0;
        reset = 1;
        errors = 0;


        // ------------------------------------------------
        // Setup
        // x1 = -1
        // x2 = 1
        // ------------------------------------------------

        dut.imem.memory[0]  = 32'hfff00093; // addi x1,x0,-1
        dut.imem.memory[1]  = 32'h00100113; // addi x2,x0,1


        // ------------------------------------------------
        // BEQ = Branch if Equal
        // taken -> x10 skipped
        // ------------------------------------------------

        dut.imem.memory[2]  = 32'h00210463; // beq x2,x2,+8
        dut.imem.memory[3]  = 32'h00100513; // addi x10,x0,1


        // ------------------------------------------------
        // BNE = Branch if Not Equal
        // taken -> x11 skipped
        // ------------------------------------------------

        dut.imem.memory[4]  = 32'h00209463; // bne x1,x2,+8
        dut.imem.memory[5]  = 32'h00100593; // addi x11,x0,1


        // ------------------------------------------------
        // BLT = Branch if Less Than
        // signed: -1 < 1
        // taken -> x12 skipped
        // ------------------------------------------------

        dut.imem.memory[6]  = 32'h0020c463; // blt x1,x2,+8
        dut.imem.memory[7]  = 32'h00100613; // addi x12,x0,1


        // ------------------------------------------------
        // BGE = Branch if Greater or Equal
        // signed: 1 >= -1
        // taken -> x13 skipped
        // ------------------------------------------------

        dut.imem.memory[8]  = 32'h00115463; // bge x2,x1,+8
        dut.imem.memory[9]  = 32'h00100693; // addi x13,x0,1


        // ------------------------------------------------
        // BLTU = Branch if Less Than Unsigned
        //
        // x2 = 1
        // x1 = 0xffffffff unsigned
        // 1 < 0xffffffff
        //
        // taken -> x14 skipped
        // ------------------------------------------------

        dut.imem.memory[10] = 32'h00116463; // bltu x2,x1,+8
        dut.imem.memory[11] = 32'h00100713; // addi x14,x0,1


        // ------------------------------------------------
        // BGEU = Branch if Greater or Equal Unsigned
        //
        // 0xffffffff >= 1
        //
        // taken -> x15 skipped
        // ------------------------------------------------

        dut.imem.memory[12] = 32'h0020f463; // bgeu x1,x2,+8
        dut.imem.memory[13] = 32'h00100793; // addi x15,x0,1


        // ------------------------------------------------
        // BEQ NOT taken
        //
        // x1 != x2
        // therefore x16 MUST execute
        // ------------------------------------------------

        dut.imem.memory[14] = 32'h00208463; // beq x1,x2,+8
        dut.imem.memory[15] = 32'h01000813; // addi x16,x0,16


        // ------------------------------------------------
        // LUI = Load Upper Immediate
        // ------------------------------------------------

        dut.imem.memory[16] = 32'h123458b7; // lui x17,0x12345


        // ------------------------------------------------
        // AUIPC = Add Upper Immediate to PC
        //
        // PC = 68 = 0x44
        // 0x1000 + 0x44 = 0x1044
        // ------------------------------------------------

        dut.imem.memory[17] = 32'h00001917; // auipc x18,0x1


        // ------------------------------------------------
        // JAL = Jump And Link
        //
        // PC = 72
        // target = 80
        //
        // x19 = PC + 4 = 76 = 0x4c
        //
        // x20 instruction skipped
        // ------------------------------------------------

        dut.imem.memory[18] = 32'h008009ef; // jal x19,+8
        dut.imem.memory[19] = 32'h01400a13; // addi x20,x0,20


        // ------------------------------------------------
        // Prepare JALR target
        //
        // x21 = 93
        // ------------------------------------------------

        dut.imem.memory[20] = 32'h05d00a93; // addi x21,x0,93


        // ------------------------------------------------
        // JALR = Jump And Link Register
        //
        // PC = 84
        // x22 = PC + 4 = 88
        //
        // target:
        // 93 & ~1 = 92
        //
        // therefore x23 skipped
        // ------------------------------------------------

        dut.imem.memory[21] = 32'h000a8b67; // jalr x22,0(x21)
        dut.imem.memory[22] = 32'h01700b93; // addi x23,x0,23


        // JALR target: address 92
        dut.imem.memory[23] = 32'h01800c13; // addi x24,x0,24


        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #20;
        reset = 0;


        // 16 instructions are actually executed
        repeat (16) @(posedge clk);

        #1;


        // ------------------------------------------------
        // Branch taken checks
        //
        // These registers should NEVER have been written.
        // Therefore they remain X in our current register file.
        // ------------------------------------------------

        check_unwritten(10); // BEQ
        check_unwritten(11); // BNE
        check_unwritten(12); // BLT
        check_unwritten(13); // BGE
        check_unwritten(14); // BLTU
        check_unwritten(15); // BGEU


        // ------------------------------------------------
        // Branch not taken
        // ------------------------------------------------

        check_reg(16, 32'h00000010);


        // ------------------------------------------------
        // LUI / AUIPC
        // ------------------------------------------------

        check_reg(17, 32'h12345000);
        check_reg(18, 32'h00001044);


        // ------------------------------------------------
        // JAL
        // ------------------------------------------------

        check_reg(19, 32'h0000004c);
        check_unwritten(20);


        // ------------------------------------------------
        // JALR
        // ------------------------------------------------

        check_reg(21, 32'h0000005d);
        check_reg(22, 32'h00000058);
        check_unwritten(23);

        // proves jump landed at address 92
        check_reg(24, 32'h00000018);


        // ------------------------------------------------
        // Final result
        // ------------------------------------------------

        if (errors == 0)
            $display("\nCONTROL FLOW REGRESSION PASS");
        else
            $display(
                "\nCONTROL FLOW REGRESSION FAIL: %0d errors",
                errors
            );

        $finish;

    end

endmodule
