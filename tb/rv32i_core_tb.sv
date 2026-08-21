module rv32i_core_tb;

    logic clk;
    logic reset;

    rv32i_core dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("rv32i_core.vcd");
        $dumpvars(0, rv32i_core_tb);

        clk   = 0;
        reset = 1;

        // Skipped instruction'lari kontrol edebilmek icin
        dut.rf.registers[3]  = 0;
        dut.rf.registers[7]  = 0;
        dut.rf.registers[10] = 0;
        dut.rf.registers[11] = 0;

        // PC 0
        dut.imem.memory[0]  = 32'h00500093; // addi x1,x0,5

        // PC 4
        dut.imem.memory[1]  = 32'h00500113; // addi x2,x0,5

        // PC 8 -> taken, PC 16'ya git
        dut.imem.memory[2]  = 32'h00208463; // beq x1,x2,+8

        // PC 12 -> SKIP
        dut.imem.memory[3]  = 32'h06300193; // addi x3,x0,99

        // PC 16
        dut.imem.memory[4]  = 32'h12345237; // lui x4,0x12345

        // PC 20
        dut.imem.memory[5]  = 32'h00001297; // auipc x5,0x1

        // PC 24 -> PC 32'ye atla, x6 = 28
        dut.imem.memory[6]  = 32'h0080036F; // jal x6,+8

        // PC 28 -> SKIP
        dut.imem.memory[7]  = 32'h04D00393; // addi x7,x0,77

        // PC 32
        dut.imem.memory[8]  = 32'h03000413; // addi x8,x0,48

        // PC 36 -> x8'deki 48 adresine atla, x9 = 40
        dut.imem.memory[9]  = 32'h000404E7; // jalr x9,x8,0

        // PC 40 -> SKIP
        dut.imem.memory[10] = 32'h04200513; // addi x10,x0,66

        // PC 44 -> SKIP
        dut.imem.memory[11] = 32'h04D00593; // addi x11,x0,77

        // PC 48
        dut.imem.memory[12] = 32'h00B00513; // addi x10,x0,11

        #6;
        reset = 0;

        #100;
        #1;

        if (dut.rf.registers[1] == 32'd5)
            $display("ADDI x1 PASS");
        else
            $display("ADDI x1 FAIL");

        if (dut.rf.registers[3] == 32'd0)
            $display("BEQ PASS");
        else
            $display("BEQ FAIL: x3 = %0d", dut.rf.registers[3]);

        if (dut.rf.registers[4] == 32'h12345000)
            $display("LUI PASS");
        else
            $display("LUI FAIL: %h", dut.rf.registers[4]);

        if (dut.rf.registers[5] == 32'h00001014)
            $display("AUIPC PASS");
        else
            $display("AUIPC FAIL: %h", dut.rf.registers[5]);

        if (dut.rf.registers[6] == 32'd28 &&
            dut.rf.registers[7] == 32'd0)
            $display("JAL PASS");
        else
            $display("JAL FAIL: x6=%0d x7=%0d",
                     dut.rf.registers[6],
                     dut.rf.registers[7]);

        if (dut.rf.registers[9] == 32'd40 &&
            dut.rf.registers[11] == 32'd0 &&
            dut.rf.registers[10] == 32'd11)
            $display("JALR PASS");
        else
            $display("JALR FAIL: x9=%0d x10=%0d x11=%0d",
                     dut.rf.registers[9],
                     dut.rf.registers[10],
                     dut.rf.registers[11]);

        $finish;
    end

endmodule
