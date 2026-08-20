module data_memory_tb;

    logic        clk;
    logic        mem_write;
    logic [31:0] address;
    logic [31:0] write_data;
    logic [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("data_memory.vcd");
        $dumpvars(0, data_memory_tb);

        clk        = 0;
        mem_write  = 0;
        address    = 0;
        write_data = 0;

        // memory[2]'ye yaz -> byte address = 8
        address    = 32'd8;
        write_data = 32'd123;
        mem_write  = 1;

        #6; // posedge geçti

        mem_write = 0;
        #1;

        if (read_data == 32'd123)
            $display("WRITE/READ PASS");
        else
            $display("WRITE/READ FAIL: %0d", read_data);

        // Başka word'e yaz
        address    = 32'd12;
        write_data = 32'hDEADBEEF;
        mem_write  = 1;

        #10;

        mem_write = 0;
        #1;

        if (read_data == 32'hDEADBEEF)
            $display("SECOND WORD PASS");
        else
            $display("SECOND WORD FAIL: %h", read_data);

        // İlk word hâlâ duruyor mu?
        address = 32'd8;
        #1;

        if (read_data == 32'd123)
            $display("PERSISTENCE PASS");
        else
            $display("PERSISTENCE FAIL: %0d", read_data);

        $finish;
    end

endmodule
