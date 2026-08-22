`timescale 1ns/1ps

module arithmetic_regression_tb;

    logic clk;
    logic reset;

    rv32i_core dut (
        .clk   (clk),
        .reset (reset)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    integer errors;

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


    initial begin

        clk = 0;
        reset = 1;
        errors = 0;

        // ------------------------------------------------
        // Arithmetic regression program
        // ------------------------------------------------

        dut.imem.memory[0]  = 32'hff800093; // addi x1,x0,-8
        dut.imem.memory[1]  = 32'h00300113; // addi x2,x0,3
        dut.imem.memory[2]  = 32'h00500193; // addi x3,x0,5
        dut.imem.memory[3]  = 32'h02300213; // addi x4,x0,35

        dut.imem.memory[4]  = 32'h003102b3; // add  x5,x2,x3
        dut.imem.memory[5]  = 32'h40310333; // sub  x6,x2,x3
        dut.imem.memory[6]  = 32'h003173b3; // and  x7,x2,x3
        dut.imem.memory[7]  = 32'h00316433; // or   x8,x2,x3
        dut.imem.memory[8]  = 32'h003144b3; // xor  x9,x2,x3

        dut.imem.memory[9]  = 32'h00419533; // sll  x10,x3,x4
        dut.imem.memory[10] = 32'h0040d5b3; // srl  x11,x1,x4
        dut.imem.memory[11] = 32'h4040d633; // sra  x12,x1,x4

        dut.imem.memory[12] = 32'h0020a6b3; // slt  x13,x1,x2
        dut.imem.memory[13] = 32'h0020b733; // sltu x14,x1,x2

        dut.imem.memory[14] = 32'hffb10793; // addi x15,x2,-5
        dut.imem.memory[15] = 32'h00f0f813; // andi x16,x1,15
        dut.imem.memory[16] = 32'h00816893; // ori  x17,x2,8
        dut.imem.memory[17] = 32'hfff1c913; // xori x18,x3,-1

        dut.imem.memory[18] = 32'h00419993; // slli x19,x3,4
        dut.imem.memory[19] = 32'h0040da13; // srli x20,x1,4
        dut.imem.memory[20] = 32'h4020da93; // srai x21,x1,2

        dut.imem.memory[21] = 32'hfff0ab13; // slti  x22,x1,-1
        dut.imem.memory[22] = 32'hfff13b93; // sltiu x23,x2,-1


        // CPU'yu bir süre reset'te tut
        #20;

        // Reset'i bırak -> CPU artık PC=0'dan çalışmaya başlar
        reset = 0;


        // 23 instruction var.
        // Her instruction single-cycle olduğu için 23 clock yeterli.
        repeat (23) @(posedge clk);

        // Son register write'ın tamamlanması için küçük bekleme
        #1;


        // ------------------------------------------------
        // Check results
        // ------------------------------------------------

        check_reg(1,  32'hfffffff8);
        check_reg(2,  32'h00000003);
        check_reg(3,  32'h00000005);
        check_reg(4,  32'h00000023);

        check_reg(5,  32'h00000008); // ADD
        check_reg(6,  32'hfffffffe); // SUB
        check_reg(7,  32'h00000001); // AND
        check_reg(8,  32'h00000007); // OR
        check_reg(9,  32'h00000006); // XOR

        check_reg(10, 32'h00000028); // SLL
        check_reg(11, 32'h1fffffff); // SRL
        check_reg(12, 32'hffffffff); // SRA

        check_reg(13, 32'h00000001); // SLT
        check_reg(14, 32'h00000000); // SLTU

        check_reg(15, 32'hfffffffe); // ADDI
        check_reg(16, 32'h00000008); // ANDI
        check_reg(17, 32'h0000000b); // ORI
        check_reg(18, 32'hfffffffa); // XORI

        check_reg(19, 32'h00000050); // SLLI
        check_reg(20, 32'h0fffffff); // SRLI
        check_reg(21, 32'hfffffffe); // SRAI

        check_reg(22, 32'h00000001); // SLTI
        check_reg(23, 32'h00000001); // SLTIU


        // ------------------------------------------------
        // Final result
        // ------------------------------------------------

        if (errors == 0)
            $display("\nARITHMETIC REGRESSION PASS");
        else
            $display("\nARITHMETIC REGRESSION FAIL: %0d errors", errors);

        $finish;

    end

endmodule
