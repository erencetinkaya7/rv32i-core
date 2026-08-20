module program_counter_tb;

    logic        clk;
    logic        reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("program_counter.vcd");
        $dumpvars(0, program_counter_tb);

        clk     = 0;
        reset   = 1;
        next_pc = 32'd100;

        // Reset aktifken ilk posedge
        #6;
        if (pc == 32'd0)
            $display("RESET PASS");
        else
            $display("RESET FAIL");

        // next_pc = 4
        reset   = 0;
        next_pc = 32'd4;
        #10;

        if (pc == 32'd4)
            $display("PC 4 PASS");
        else
            $display("PC 4 FAIL");

        // next_pc = 100
        next_pc = 32'd100;
        #10;

        if (pc == 32'd100)
            $display("PC 100 PASS");
        else
            $display("PC 100 FAIL");

        $finish;
    end

endmodule
