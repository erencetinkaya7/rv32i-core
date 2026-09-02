// Memory-mapped UART peripheral
// Provides transmit data and status interfaces to the SoC.

module uart #(

    parameter CLOCK_FREQ = 27_000_000,
    parameter BAUD_RATE  = 115_200
)(

    input  logic clk,
    input  logic reset,

    input  logic write_enable,       // Transmit write request
    input  logic [31:0] write_data,  // Data from CPU

    output logic [31:0] read_data,   // UART status
    output logic tx                  // Serial transmit output

);

    logic busy;
    logic start;


// Accept a write only when transmitter is read

    assign start = write_enable && !busy;


// UART status register: bit 0 = busy
    assign read_data = {31'b0, busy};


// UART transmitter

    uart_tx #(

        .CLOCK_FREQ(CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)

    ) tx_unit (

        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(write_data[7:0]),
        .tx(tx),
        .busy(busy)
    );


endmodule
