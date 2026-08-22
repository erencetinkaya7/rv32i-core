`timescale 1ns/1ps

module toolchain_program_tb;

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


    initial begin

        clk = 0;
        reset = 1;
        errors = 0;


        // Load program.hex directly into instruction memory.
        //
        // program.hex contains 3 instructions,
        // so load them into memory[0]..memory[2].
        $readmemh(
            "sw/program.hex",
            dut.imem.memory,
            0,
            2
        );


        // Reset CPU
        #20;
        reset = 0;


        // program.S contains 3 instructions
        repeat (3) @(posedge clk);

        #1;


        // Expected:
        //
        // x1 = 5
        // x2 = 7
        // x3 = 5 + 7 = 12

        check_reg(1, 32'd5);
        check_reg(2, 32'd7);
        check_reg(3, 32'd12);


        if (errors == 0)
            $display("\nTOOLCHAIN PROGRAM PASS");
        else
            $display(
                "\nTOOLCHAIN PROGRAM FAIL: %0d errors",
                errors
            );

        $finish;

    end

endmodule
