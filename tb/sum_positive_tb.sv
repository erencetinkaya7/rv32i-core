module sum_positive_tb;

    logic clk;
    logic reset;

    rv32i_core dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;

        // Load program
        $readmemh("sw/sum_positive.hex", dut.imem.memory);

        // array = [4, -2, 7, -5, 3]
        // Each memory entry is one 32-bit word
        dut.dmem.memory[0] = 32'd4;
        dut.dmem.memory[1] = -32'sd2;
        dut.dmem.memory[2] = 32'd7;
        dut.dmem.memory[3] = -32'sd5;
        dut.dmem.memory[4] = 32'd3;

        #20;
        reset = 0;

        repeat (50) @(posedge clk);
        #1;

        // sum_positive([4,-2,7,-5,3]) = 14
        if (dut.rf.registers[10] !== 32'd14)
            $display("FAIL: a0 = %0d, expected = 14",
                     $signed(dut.rf.registers[10]));
        else
            $display("PASS: a0 = 14");

        $finish;
    end

endmodule
