//Memory Mapped GPIO Peripheral

module gpio (
    input  logic        clk,            // System clock
    input  logic        reset,          // Synchronous reset
    
    input  logic        write_enable,   // GPIO write enable
    input  logic [31:0] write_data,     // Data from CPU

    input  logic        btn,            // Onboard button input

    output logic [31:0] gpio_out,       // GPIO output register
    output logic [31:0] read_data       // GPIO read data
);


// GPIO output register

always_ff @(posedge clk) begin
    if (reset)
        gpio_out <= 32'b0;
    else if (write_enable)
        gpio_out <= write_data;
end

assign read_data = {31'b0, ~btn}; // Button input readback, active-low

endmodule
