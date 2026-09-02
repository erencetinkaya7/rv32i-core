module top (
    input logic clk,
    input logic btn,
    input logic reset_btn,      // Onboard reset button
                        
    output logic [5:0] led,
    output logic uart_tx
);

logic [31:0] debug_a0;
logic [31:0] gpio_out;

logic [7:0] reset_counter = 8'hFF;
logic reset;

logic reset_btn_meta = 1'b1;
logic reset_btn_sync = 1'b1;


// Synchronize external reset button

    always_ff @(posedge clk) begin
        reset_btn_meta <= reset_btn;
        reset_btn_sync <= reset_btn_meta;
    end


// Power-up reset counter

always_ff @(posedge clk) begin
    if (reset_counter != 8'd0)
        reset_counter <= reset_counter - 1'b1;
end

assign reset = (reset_counter != 8'd0) || !reset_btn_sync;

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
