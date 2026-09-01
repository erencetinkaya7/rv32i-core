`timescale 1ns/1ps

module uart_tx_tb;

    logic       clk;
    logic       reset;
    logic       start;
    logic [7:0] data_in;
                    
    logic       tx;
    logic       busy;

    // Faster UART timing for simulation
    uart_tx #(
        .CLOCK_FREQ(1000),
        .BAUD_RATE(100)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    always #5 clk = ~clk;


    integer errors;

    // Check one UART bit for a full bit period
    task check_bit(input logic expected);
        begin
            @(negedge clk);

            if (tx !== expected) begin
                $display("FAIL: tx = %b, expected %b", tx, expected);
                errors = errors + 1;
            end

            repeat (9) @(negedge clk);
        end
    endtask

        initial begin
        clk     = 0;
        reset   = 1;
        start   = 0;
        data_in = 0;
        errors  = 0;

        // Reset transmitter
        repeat (2) @(posedge clk);
        reset = 0;

        // Send ASCII 'A' = 0x41
        @(negedge clk);
        data_in = 8'h41;
        start   = 1;

        // Keep start high for one clock
        @(posedge clk);
        #1;
        start = 0;

        // Start bit
        check_bit(1'b0);

        // 8 data bits, LSB first
        for (integer i = 0; i < 8; i = i + 1)
            check_bit(data_in[i]);

        // Stop bit
        check_bit(1'b1);

        // Check idle state after transmission
        @(negedge clk);

        if (busy !== 1'b0 || tx !== 1'b1) begin
            $display("FAIL: UART did not return to IDLE");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("\nUART TX PASS");
        else
            $display("\nUART TX FAIL: %0d errors", errors);

        $finish;
    end
endmodule
