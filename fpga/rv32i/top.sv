module top (
    input logic clk,
    input logic btn,

    output logic [5:0] led,
    output logic uart_tx
);

logic [7:0] reset_counter = 8'hFF;
logic reset;

logic [31:0] debug_a0;
logic [31:0] gpio_out;

// CPU'yu ilk birkac clock cycle icin resette beklet.

always_ff @(posedge clk) begin
    if (reset_counter != 8'd0)
        reset_counter <= reset_counter - 1'b1;
end

assign reset = (reset_counter != 8'd0);

rv32i_soc #( .IMEM_INIT_FILE("program.hex") ) cpu (
    .clk(clk),
    .reset(reset),
    .debug_a0(debug_a0),
    .gpio_out(gpio_out),
    .btn(btn),
    .uart_tx(uart_tx)
);


assign led = ~gpio_out[5:0];

endmodule
