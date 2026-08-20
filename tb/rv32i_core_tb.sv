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

        // Program:
        // addi x1, x0, 5
        // addi x2, x0, 7
        // add  x3, x1, x2
        // sw   x3, 8(x0)
        // lw   x4, 8(x0)

        dut.imem.memory[0] = 32'h00500093;
        dut.imem.memory[1] = 32'h00700113;
        dut.imem.memory[2] = 32'h002081B3;
        dut.imem.memory[3] = 32'h00302423;
        dut.imem.memory[4] = 32'h00802203;

        // Reset sırasında ilk posedge
        #6;
        reset = 0;

        // 5 instruction
        #50;
        #1;

        if (dut.rf.registers[1] == 32'd5)
            $display("x1 PASS");
        else
            $display("x1 FAIL: %0d", dut.rf.registers[1]);

        if (dut.rf.registers[2] == 32'd7)
            $display("x2 PASS");
        else
            $display("x2 FAIL: %0d", dut.rf.registers[2]);

        if (dut.rf.registers[3] == 32'd12)
            $display("x3 PASS");
        else
            $display("x3 FAIL: %0d", dut.rf.registers[3]);

        if (dut.dmem.memory[2] == 32'd12)
            $display("MEMORY PASS");
        else
            $display("MEMORY FAIL: %0d", dut.dmem.memory[2]);

        if (dut.rf.registers[4] == 32'd12)
            $display("x4 PASS");
        else
            $display("x4 FAIL: %0d", dut.rf.registers[4]);

        $finish;

    end

endmodule
