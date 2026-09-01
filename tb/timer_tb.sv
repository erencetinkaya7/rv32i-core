`timescale 1ns/1ps

module timer_tb;

    logic        clk;
    logic        reset;
    logic        start;
    logic [31:0] count_in;

    logic busy;
    logic done;

    integer errors;

    timer dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .count_in(count_in),
        .busy(busy),
        .done(done)
    );

    // 100 MHz simulation clock
    always #5 clk = ~clk;

    initial begin
        clk      = 1'b0;
        reset    = 1'b1;
        start    = 1'b0;
        count_in = 32'b0;
        errors   = 0;

        // Reset
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        // Test normal countdown
        count_in = 32'd3;
        start    = 1'b1;

        @(negedge clk);
        start = 1'b0;

        if (busy !== 1'b1) begin
            $display("FAIL: Timer did not start");
            errors = errors + 1;
        end

        wait(done == 1'b1);

        if (busy !== 1'b0) begin
            $display("FAIL: Busy stayed high after countdown");
            errors = errors + 1;
        end

        // done must be a one-cycle pulse
        @(posedge clk);
        #1;

        if (done !== 1'b0) begin
            $display("FAIL: Done pulse lasted too long");
            errors = errors + 1;
        end

        // Test zero count
        @(negedge clk);
        count_in = 32'd0;
        start    = 1'b1;

        @(negedge clk);
        start = 1'b0;

        if (done !== 1'b1 || busy !== 1'b0) begin
            $display("FAIL: Zero-count behavior incorrect");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("TIMER PASS");
        else
            $display("TIMER FAIL: %0d errors", errors);

        $finish;
    end

endmodule
