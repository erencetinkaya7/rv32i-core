module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_control;

    logic [31:0] result;

    localparam logic [3:0]
        ALU_ADD  = 4'd0,
        ALU_SUB  = 4'd1,
        ALU_AND  = 4'd2,
        ALU_OR   = 4'd3,
        ALU_XOR  = 4'd4,
        ALU_SLL  = 4'd5,
        ALU_SRL  = 4'd6,
        ALU_SRA  = 4'd7,
        ALU_SLT  = 4'd8,
        ALU_SLTU = 4'd9;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result)
    );

    initial begin

        // ADD
        a = 32'd10;
        b = 32'd20;
        alu_control = ALU_ADD;
        #1;

        if (result == 32'd30)
            $display("ADD PASS");
        else
            $display("ADD FAIL: result = %h", result);


        // SUB
        a = 32'd20;
        b = 32'd7;
        alu_control = ALU_SUB;
        #1;

        if (result == 32'd13)
            $display("SUB PASS");
        else
            $display("SUB FAIL: result = %h", result);


        // AND
        a = 32'h0000F0F0;
        b = 32'h00000FF0;
        alu_control = ALU_AND;
        #1;

        if (result == 32'h000000F0)
            $display("AND PASS");
        else
            $display("AND FAIL: result = %h", result);


        // OR
        alu_control = ALU_OR;
        #1;

        if (result == 32'h0000FFF0)
            $display("OR PASS");
        else
            $display("OR FAIL: result = %h", result);


        // XOR
        alu_control = ALU_XOR;
        #1;

        if (result == 32'h0000FF00)
            $display("XOR PASS");
        else
            $display("XOR FAIL: result = %h", result);


        // SLL
        a = 32'd1;
        b = 32'd4;
        alu_control = ALU_SLL;
        #1;

        if (result == 32'd16)
            $display("SLL PASS");
        else
            $display("SLL FAIL: result = %h", result);


        // SRL
        a = 32'h80000000;
        b = 32'd1;
        alu_control = ALU_SRL;
        #1;

        if (result == 32'h40000000)
            $display("SRL PASS");
        else
            $display("SRL FAIL: result = %h", result);


        // SRA
        a = 32'h80000000;
        b = 32'd1;
        alu_control = ALU_SRA;
        #1;

        if (result == 32'hC0000000)
            $display("SRA PASS");
        else
            $display("SRA FAIL: result = %h", result);


        // SLT: signed olarak -1 < 1
        a = 32'hFFFFFFFF;
        b = 32'd1;
        alu_control = ALU_SLT;
        #1;

        if (result == 32'd1)
            $display("SLT PASS");
        else
            $display("SLT FAIL: result = %h", result);


        // SLTU: unsigned olarak 0xFFFFFFFF > 1
        alu_control = ALU_SLTU;
        #1;

        if (result == 32'd0)
            $display("SLTU PASS");
        else
            $display("SLTU FAIL: result = %h", result);


        // b'nin sadece alt 5 biti kullanılmalı:
        // 33 = 100001, alt 5 bit = 00001 -> 1 bit shift
        a = 32'd1;
        b = 32'd33;
        alu_control = ALU_SLL;
        #1;

        if (result == 32'd2)
            $display("SHIFT AMOUNT PASS");
        else
            $display("SHIFT AMOUNT FAIL: result = %h", result);


        $finish;

    end

endmodule
