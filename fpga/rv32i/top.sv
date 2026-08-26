module top (
    input logic clk,
    output logic led
);

logic [7:0] reset_counter = 8'hFF;
logic reset;

logic [31:0] debug_a0;

// CPU'yu ilk birkac clock cycle icin resette beklet.

always_ff @(posedge clk) begin
    if (reset_counter != 8'd0)
        reset_counter <= reset_counter - 1'b1;
end

assign reset = (reset_counter != 8'd0);

rv32i_core #( .IMEM_INIT_FILE("program.hex") ) cpu (
    .clk(clk),
    .reset(reset),
    .debug_a0(debug_a0)
);


assign led = ~debug_a0[23];

endmodule
