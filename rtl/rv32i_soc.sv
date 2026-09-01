// System-on-chip Module
// Connects RV32I Core to RAM and memory-mapped peripherals.

module rv32i_soc #( parameter IMEM_INIT_FILE = "" )(
  
    input  logic        clk,    
    input  logic        reset,
    input  logic        btn,
    
    output logic [31:0] debug_a0,   // Debug output from register x10 (a0)
    output logic [31:0] gpio_out,    // GPIO output register

    output logic        uart_tx
);


// Memory map

    localparam logic [31:0] GPIO_OUT_ADDR     = 32'h1000_0000;
    localparam logic [31:0] GPIO_IN_ADDR      = 32'h1000_0004;
    localparam logic [31:0] UART_TX_ADDR      = 32'h2000_0000;
    localparam logic [31:0] UART_STATUS_ADDR  = 32'h2000_0004;
    localparam logic [31:0] TIMER_LOAD_ADDR   = 32'h3000_0000;
    localparam logic [31:0] TIMER_STATUS_ADDR = 32'h3000_0004;
    
// CPU Data Bus

    logic [31:0] data_address;
    logic [31:0] data_write_data;
    logic [31:0] data_read_data;
    logic        data_mem_write;
    logic [2:0]  data_funct3;


// Peripheral Read Data

    logic [31:0] ram_read_data;
    logic [31:0] gpio_read_data;

    logic [31:0] uart_read_data;

    logic [31:0] timer_read_data;

    
// Peripheral Signals

    logic timer_busy;
    logic timer_done;

    
// Address Decoder

    logic ram_selected;
    
    logic gpio_out_selected;
    logic gpio_in_selected;
    
    logic uart_tx_selected;
    logic uart_status_selected;
    
    logic timer_load_selected;
    logic timer_status_selected;
    
    assign ram_selected = (data_address[31:8] == 24'b0);
    
    assign gpio_in_selected = (data_address == GPIO_IN_ADDR);
    assign gpio_out_selected = (data_address == GPIO_OUT_ADDR);

    assign uart_tx_selected = (data_address == UART_TX_ADDR);
    assign uart_status_selected = (data_address == UART_STATUS_ADDR);

    assign timer_load_selected = (data_address == TIMER_LOAD_ADDR);
    assign timer_status_selected = (data_address == TIMER_STATUS_ADDR);
    
    
// CPU Core 

    rv32i_core #(.IMEM_INIT_FILE(IMEM_INIT_FILE)
     ) cpu (

        .clk(clk),
        .reset(reset),
        .debug_a0(debug_a0),


        .data_address(data_address),
        .data_write_data(data_write_data),
        .data_mem_write(data_mem_write),
        .data_funct3(data_funct3),
        .data_read_data(data_read_data)
    );


// Data Memory

    data_memory dmem (

        .clk(clk),
        .mem_write(data_mem_write && ram_selected),
        .address(data_address),
        .write_data(data_write_data),
        .funct3(data_funct3),
        .read_data(ram_read_data)
    );


// Memory Mapped GPIO Peripheral

    gpio gpio_periph (
      
        .clk(clk),
        .reset(reset),
        .write_enable(data_mem_write && gpio_out_selected),
        .write_data(data_write_data),
        .btn(btn),    
        .gpio_out(gpio_out),
        .read_data(gpio_read_data)
    );

    // UART peripheral
    uart uart_periph (
        .clk(clk),
        .reset(reset),
        .write_enable(data_mem_write && uart_tx_selected),
        .write_data(data_write_data),
        .read_data(uart_read_data),
        .tx(uart_tx)
    );

    // Hardware timer
    timer timer_periph (
        .clk(clk),
        .reset(reset),
        .start(data_mem_write && timer_load_selected),
        .count_in(data_write_data),
        .busy(timer_busy),
        .done(timer_done)
    );
    assign timer_read_data = {31'b0, timer_busy};

    
// Read Data Mux
// Selects which peripheral returns data to the CPU.

    always_comb begin
        if (gpio_in_selected)
            data_read_data = gpio_read_data;
        else if (ram_selected)
            data_read_data = ram_read_data;
        else if (uart_status_selected)
            data_read_data = uart_read_data;
        else if (timer_status_selected)
            data_read_data = timer_read_data;
        else
            data_read_data = 32'b0;
    end


endmodule
