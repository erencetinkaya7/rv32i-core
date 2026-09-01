// UART transmitter
// Sends 8-bit data using 8N1 serial format.

module uart_tx #(

    parameter CLOCK_FREQ = 27_000_000,
    parameter BAUD_RATE  = 115_200
) (
    input  logic clk,           // System Clock
    input  logic reset,         // Synchronous Reset
    
    input  logic start,         // Start transmission
    input  logic [7:0] data_in, // Byte to tranmist
    
    output logic tx,            // UART serial output
    output logic busy           // High while transmitting
);

// Number of FPGA clock cycles per UART bit

    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;


// UART timing and data registers

    logic [$clog2(CLKS_PER_BIT)-1:0] baud_counter;
    logic [2:0] bit_index;
    logic [7:0] tx_data;


// UART transmitter states
    
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state;


// UART transmitter state machine

    always_ff @(posedge clk) begin
        if (reset) begin
            state        <= IDLE;
            tx           <= 1'b1;
            busy         <= 1'b0;
            baud_counter <= '0;
            bit_index    <= '0;
            tx_data      <= '0;
        end
        
        else begin
            case (state)
                

                // Wait for a new byte to transmit
                IDLE: begin         
                    tx <= 1'b1;
                    busy <= 1'b0;
                    baud_counter <= '0;
                    bit_index <= '0;
            
                    if (start) begin
                        tx_data <= data_in;
                        busy    <= 1'b1;
                        tx      <= 1'b0;
                        state   <= START;
                    end
                end
        

                // Hold the start bit low for one bit period
                START: begin        
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        baud_counter <= '0;
                        bit_index <= '0;
                        tx <= tx_data[0];
                        state <= DATA;
                    end
                    else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                

                // Transmit 8 data bits, LSB first
                DATA: begin
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        baud_counter <= '0;
                    
                        if (bit_index == 3'd7) begin
                            tx <= 1'b1;
                            state <= STOP;
                        end
                                   
                        else begin
                            bit_index <= bit_index + 1'b1;
                            tx <= tx_data[bit_index + 1'b1];
                        end
                    end
                    else begin
                        baud_counter <= baud_counter + 1'b1;
                    end
                 end


                // Hold stop bit high for one bit period
                STOP: begin
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        baud_counter <= '0;
                        busy <= 1'b0;
                        state <= IDLE;
                    end
                    else begin
                        baud_counter <= baud_counter + 1'b1;
                    end
                end

            endcase
        end
    end


endmodule
