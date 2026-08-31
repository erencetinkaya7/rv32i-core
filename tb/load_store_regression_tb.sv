`timescale 1ns/1ps

module load_store_regression_tb;

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


        // ------------------------------------------------
        // Build 0x80FF7F01 and store it to address 0
        // ------------------------------------------------

        dut.cpu.imem.memory[0]  = 32'h80ff8a37; // lui  x20,0x80ff8
        dut.cpu.imem.memory[1]  = 32'hf01a0a13; // addi x20,x20,-255
        dut.cpu.imem.memory[2]  = 32'h01402023; // sw   x20,0(x0)


        // ------------------------------------------------
        // LOAD regression
        //
        // memory word:
        //
        // address:   3    2    1    0
        // byte:     80   FF   7F   01
        //
        // ------------------------------------------------

        dut.cpu.imem.memory[3]  = 32'h00000083; // lb  x1,0(x0)
        dut.cpu.imem.memory[4]  = 32'h00100103; // lb  x2,1(x0)
        dut.cpu.imem.memory[5]  = 32'h00200183; // lb  x3,2(x0)
        dut.cpu.imem.memory[6]  = 32'h00204203; // lbu x4,2(x0)

        dut.cpu.imem.memory[7]  = 32'h00300283; // lb  x5,3(x0)
        dut.cpu.imem.memory[8]  = 32'h00304303; // lbu x6,3(x0)

        dut.cpu.imem.memory[9]  = 32'h00001383; // lh  x7,0(x0)
        dut.cpu.imem.memory[10] = 32'h00201403; // lh  x8,2(x0)
        dut.cpu.imem.memory[11] = 32'h00205483; // lhu x9,2(x0)

        dut.cpu.imem.memory[12] = 32'h00002503; // lw x10,0(x0)


        // ------------------------------------------------
        // SB regression
        //
        // Create word at address 4 one byte at a time:
        //
        // 0x44332211
        //
        // ------------------------------------------------

        dut.cpu.imem.memory[13] = 32'h01100593; // addi x11,x0,0x11
        dut.cpu.imem.memory[14] = 32'h00b00223; // sb   x11,4(x0)

        dut.cpu.imem.memory[15] = 32'h02200593; // addi x11,x0,0x22
        dut.cpu.imem.memory[16] = 32'h00b002a3; // sb   x11,5(x0)

        dut.cpu.imem.memory[17] = 32'h03300593; // addi x11,x0,0x33
        dut.cpu.imem.memory[18] = 32'h00b00323; // sb   x11,6(x0)

        dut.cpu.imem.memory[19] = 32'h04400593; // addi x11,x0,0x44
        dut.cpu.imem.memory[20] = 32'h00b003a3; // sb   x11,7(x0)

        dut.cpu.imem.memory[21] = 32'h00402603; // lw x12,4(x0)


        // ------------------------------------------------
        // SH regression
        //
        // lower half = 0x0123
        // upper half = 0x0456
        //
        // final word = 0x04560123
        //
        // ------------------------------------------------

        dut.cpu.imem.memory[22] = 32'h12300693; // addi x13,x0,0x123
        dut.cpu.imem.memory[23] = 32'h00d01423; // sh   x13,8(x0)

        dut.cpu.imem.memory[24] = 32'h45600693; // addi x13,x0,0x456
        dut.cpu.imem.memory[25] = 32'h00d01523; // sh   x13,10(x0)

        dut.cpu.imem.memory[26] = 32'h00802703; // lw x14,8(x0)


        // ------------------------------------------------
        // SW regression
        // ------------------------------------------------

        dut.cpu.imem.memory[27] = 32'hff800793; // addi x15,x0,-8
        dut.cpu.imem.memory[28] = 32'h00f02623; // sw   x15,12(x0)
        dut.cpu.imem.memory[29] = 32'h00c02803; // lw   x16,12(x0)


        // Reset
        #20;
        reset = 0;


        // 30 instructions
        repeat (30) @(posedge clk);
        #1;


        // ------------------------------------------------
        // LOAD checks
        // ------------------------------------------------

        check_reg(1,  32'h00000001); // LB  0x01
        check_reg(2,  32'h0000007f); // LB  0x7f

        check_reg(3,  32'hffffffff); // LB  0xff sign extend
        check_reg(4,  32'h000000ff); // LBU 0xff

        check_reg(5,  32'hffffff80); // LB  0x80 sign extend
        check_reg(6,  32'h00000080); // LBU 0x80

        check_reg(7,  32'h00007f01); // LH lower
        check_reg(8,  32'hffff80ff); // LH upper, sign extend
        check_reg(9,  32'h000080ff); // LHU upper

        check_reg(10, 32'h80ff7f01); // LW


        // ------------------------------------------------
        // STORE checks through LW
        // ------------------------------------------------

        check_reg(12, 32'h44332211); // four SB operations

        check_reg(14, 32'h04560123); // two SH operations

        check_reg(16, 32'hfffffff8); // SW


        if (errors == 0)
            $display("\nLOAD/STORE REGRESSION PASS");
        else
            $display(
                "\nLOAD/STORE REGRESSION FAIL: %0d errors",
                errors
            );

        $finish;

    end

endmodule
