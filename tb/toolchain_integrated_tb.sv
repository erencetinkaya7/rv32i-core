`timescale 1ns/1ps

module toolchain_integrated_tb;

    logic clk;
    logic reset;
    integer errors;

    rv32i_soc dut (
        .clk   (clk),
        .reset (reset)
    );

    always #5 clk = ~clk;


    task check_reg(
        input integer reg_num,
        input logic [31:0] expected
    );
        begin
            if (dut.cpu.rf.registers[reg_num] !== expected) begin
                $display(
                    "FAIL: x%0d = %h, expected %h",
                    reg_num,
                    dut.cpu.rf.registers[reg_num],
                    expected
                );
                errors = errors + 1;
            end
            else begin
                $display(
                    "PASS: x%0d = %h",
                    reg_num,
                    dut.cpu.rf.registers[reg_num]
                );
            end
        end
    endtask


    initial begin

        clk = 0;
        reset = 1;
        errors = 0;


        // Load assembler-generated program
        // 17 static instructions -> memory[0] through memory[16]
        $readmemh(
            "sw/integrated_program.hex",
            dut.cpu.imem.memory,
            0,
            16
        );


        // Reset CPU
        #20;
        reset = 0;


        // Runtime instruction count before reaching "end":
        //
        // setup       = 3
        // loop        = 15  (3 instructions x 5 iterations)
        // memory/call = 3
        // function    = 3
        // after return= 4
        //
        // total = 28
        repeat (28) @(posedge clk);

        #1;


        // Loop ends with i = 6
        check_reg(1, 32'd6);

        // 1 + 2 + 3 + 4 + 5 = 15
        check_reg(2, 32'd15);

        // limit = 6
        check_reg(3, 32'd6);

        // Function:
        // 15 * 2 + 3 = 33
        check_reg(4, 32'd33);

        // JAL at PC=32 saves PC+4 = 36
        check_reg(5, 32'd36);

        // Proves JALR returned correctly
        check_reg(6, 32'd99);

        // 33 stored to memory and loaded back
        check_reg(7, 32'd33);

        // Program reached completion marker
        check_reg(8, 32'd1);


        if (errors == 0)
            $display("\nTOOLCHAIN INTEGRATED PROGRAM PASS");
        else
            $display(
                "\nTOOLCHAIN INTEGRATED PROGRAM FAIL: %0d errors",
                errors
            );

        $finish;

    end

endmodule

