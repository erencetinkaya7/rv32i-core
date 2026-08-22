`timescale 1ns/1ps

module integrated_program_tb;

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


        // =================================================
        // PROGRAM
        //
        // Calculate:
        //
        // 1 + 2 + 3 + 4 + 5 = 15
        //
        // Then call a function:
        //
        // f(x) = 2*x + 3
        //
        // f(15) = 33
        // =================================================


        // -------------------------------------------------
        // Setup
        //
        // x1 = loop counter
        // x2 = sum
        // x3 = loop limit
        // -------------------------------------------------

        dut.imem.memory[0] = 32'h00100093; // addi x1,x0,1
        dut.imem.memory[1] = 32'h00000113; // addi x2,x0,0
        dut.imem.memory[2] = 32'h00600193; // addi x3,x0,6


        // -------------------------------------------------
        // LOOP
        //
        // sum += i
        // i++
        //
        // while (i < 6)
        // -------------------------------------------------

        dut.imem.memory[3] = 32'h00110133; // add  x2,x2,x1
        dut.imem.memory[4] = 32'h00108093; // addi x1,x1,1

        // PC = 20
        // target = 12
        // offset = -8

        dut.imem.memory[5] = 32'hfe30cce3; // blt x1,x3,-8


        // -------------------------------------------------
        // Store sum to memory
        //
        // memory[0] = 15
        // -------------------------------------------------

        dut.imem.memory[6] = 32'h00202023; // sw x2,0(x0)


        // Load it back into x4

        dut.imem.memory[7] = 32'h00002203; // lw x4,0(x0)


        // -------------------------------------------------
        // FUNCTION CALL
        //
        // PC = 32
        // target = 44
        //
        // JAL saves PC+4 = 36 into x5
        // -------------------------------------------------

        dut.imem.memory[8] = 32'h00c002ef; // jal x5,+12


        // -------------------------------------------------
        // RETURN POINT
        //
        // Function returns here.
        // -------------------------------------------------

        dut.imem.memory[9] = 32'h06300313; // addi x6,x0,99


        // Skip over function body after returning.
        //
        // PC = 40
        // target = 56

        dut.imem.memory[10] = 32'h0100006f; // jal x0,+16


        // =================================================
        // FUNCTION
        //
        // x4 = x4 * 2 + 3
        //
        // 15 -> 33
        // =================================================

        // PC = 44
        dut.imem.memory[11] = 32'h00121213; // slli x4,x4,1

        // PC = 48
        dut.imem.memory[12] = 32'h00320213; // addi x4,x4,3


        // -------------------------------------------------
        // RETURN
        //
        // x5 contains address 36
        // -------------------------------------------------

        dut.imem.memory[13] = 32'h00028067; // jalr x0,0(x5)


        // =================================================
        // AFTER FUNCTION
        // =================================================

        // Store result 33 to address 4

        dut.imem.memory[14] = 32'h00402223; // sw x4,4(x0)


        // Load result back

        dut.imem.memory[15] = 32'h00402383; // lw x7,4(x0)


        // End marker

        dut.imem.memory[16] = 32'h00100413; // addi x8,x0,1


        // =================================================
        // RESET
        // =================================================

        #20;
        reset = 0;


        // Because of the loop and function call,
        // 29 instructions are executed in total.

        repeat (29) @(posedge clk);

        #1;


        // =================================================
        // CHECK RESULTS
        // =================================================


        // Loop ended when i became 6
        check_reg(1, 32'h00000006);


        // 1+2+3+4+5 = 15
        check_reg(2, 32'h0000000f);


        // Loop limit
        check_reg(3, 32'h00000006);


        // Function result:
        // 15 * 2 + 3 = 33
        check_reg(4, 32'h00000021);


        // JAL return address
        // PC 32 + 4 = 36
        check_reg(5, 32'h00000024);


        // Proves return reached address 36
        check_reg(6, 32'h00000063);


        // Result survived store + load
        check_reg(7, 32'h00000021);


        // Program reached the end
        check_reg(8, 32'h00000001);


        // =================================================
        // FINAL RESULT
        // =================================================

        if (errors == 0)
            $display("\nINTEGRATED PROGRAM PASS");
        else
            $display(
                "\nINTEGRATED PROGRAM FAIL: %0d errors",
                errors
            );

        $finish;

    end

endmodule
