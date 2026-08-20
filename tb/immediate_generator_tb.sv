module immediate_generator_tb;

    logic [31:0] instruction;
    logic        imm_type;
    logic [31:0] immediate;

    immediate_generator dut (
        .instruction(instruction),
        .imm_type(imm_type),
        .immediate(immediate)
    );

    initial begin
        $dumpfile("immediate_generator.vcd");
        $dumpvars(0, immediate_generator_tb);

        // ----------------
        // I-TYPE
        // ----------------

        // +5
        imm_type = 1'b0;
        instruction = {12'h005, 20'b0};
        #1;

        if (immediate == 32'd5)
            $display("I +5 PASS");
        else
            $display("I +5 FAIL");

        // -1
        instruction = {12'hFFF, 20'b0};
        #1;

        if (immediate == 32'hFFFFFFFF)
            $display("I -1 PASS");
        else
            $display("I -1 FAIL");


        // ----------------
        // S-TYPE
        // ----------------

        // immediate = +12
        imm_type = 1'b1;
        instruction = 32'b0;
        instruction[31:25] = 7'b0000000;  // imm[11:5]
        instruction[11:7]  = 5'b01100;    // imm[4:0]
        #1;

        if (immediate == 32'd12)
            $display("S +12 PASS");
        else
            $display("S +12 FAIL");

        // immediate = -8 = 12'hFF8
        instruction = 32'b0;
        instruction[31:25] = 7'b1111111;
        instruction[11:7]  = 5'b11000;
        #1;

        if (immediate == 32'hFFFFFFF8)
            $display("S -8 PASS");
        else
            $display("S -8 FAIL");

        $finish;
    end

endmodule
