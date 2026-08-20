module control_unit_tb;

    logic [6:0] opcode;
    logic       reg_write;
    logic       alu_src;

    control_unit dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src)
    );

    initial begin

        $dumpfile("control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        // R-type
        opcode = 7'b0110011;
        #1;
        if (reg_write == 1'b1 && alu_src == 1'b0)
            $display("R-TYPE PASS");
        else
            $display("R-TYPE FAIL");

        // I-type ALU
        opcode = 7'b0010011;
        #1;
        if (reg_write == 1'b1 && alu_src == 1'b1)
            $display("I-TYPE PASS");
        else
            $display("I-TYPE FAIL");

        // Unsupported opcode
        opcode = 7'b1111111;
        #1;
        if (reg_write == 1'b0 && alu_src == 1'b0)
            $display("DEFAULT PASS");
        else
            $display("DEFAULT FAIL");

        $finish;

    end

endmodule
