module instruction_memory_tb;

    logic [31:0] pc;
    logic [31:0] instruction;

    instruction_memory dut (
        .pc(pc),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("instruction_memory.vcd");
        $dumpvars(0, instruction_memory_tb);

        dut.memory[0] = 32'h11111111;
        dut.memory[1] = 32'h22222222;
        dut.memory[2] = 32'h33333333;

        pc = 32'd0;
        #1;
        if (instruction == 32'h11111111)
            $display("PC 0 PASS");
        else
            $display("PC 0 FAIL");

        pc = 32'd4;
        #1;
        if (instruction == 32'h22222222)
            $display("PC 4 PASS");
        else
            $display("PC 4 FAIL");

        pc = 32'd8;
        #1;
        if (instruction == 32'h33333333)
            $display("PC 8 PASS");
        else
            $display("PC 8 FAIL");

        $finish;
    end

endmodule
