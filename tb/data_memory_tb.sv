module data_memory_tb;

    logic clk;
    logic mem_write;
    logic [31:0] address;
    logic [31:0] write_data;
    logic [2:0] funct3;
    logic [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .funct3(funct3),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;
        funct3 = 0;

        // SW - Store Word
        address = 0;
        write_data = 32'hDEADBEEF;
        funct3 = 3'b010;
        mem_write = 1;
        #10;
        mem_write = 0;

        // LW - Load Word
        funct3 = 3'b010;
        #1;
        if (read_data == 32'hDEADBEEF)
            $display("LW/SW PASS");
        else
            $display("LW/SW FAIL: %h", read_data);

        // LB - Load Byte signed: 0xEF -> 0xFFFFFFEF
        address = 0;
        funct3 = 3'b000;
        #1;
        if (read_data == 32'hFFFFFFEF)
            $display("LB PASS");
        else
            $display("LB FAIL: %h", read_data);

        // LBU - Load Byte Unsigned: address 1 -> 0xBE
        address = 1;
        funct3 = 3'b100;
        #1;
        if (read_data == 32'h000000BE)
            $display("LBU PASS");
        else
            $display("LBU FAIL: %h", read_data);

        // LH - Load Halfword signed: 0xBEEF
        address = 0;
        funct3 = 3'b001;
        #1;
        if (read_data == 32'hFFFFBEEF)
            $display("LH PASS");
        else
            $display("LH FAIL: %h", read_data);

        // LHU - upper halfword: 0xDEAD
        address = 2;
        funct3 = 3'b101;
        #1;
        if (read_data == 32'h0000DEAD)
            $display("LHU PASS");
        else
            $display("LHU FAIL: %h", read_data);

        // SB - replace byte at address 1 with AA
        address = 1;
        write_data = 32'h000000AA;
        funct3 = 3'b000;
        mem_write = 1;
        #10;
        mem_write = 0;

        if (dut.memory[0] == 32'hDEADAAEF)
            $display("SB PASS");
        else
            $display("SB FAIL: %h", dut.memory[0]);

        // SH - replace upper halfword with 1234
        address = 2;
        write_data = 32'h00001234;
        funct3 = 3'b001;
        mem_write = 1;
        #10;
        mem_write = 0;

        if (dut.memory[0] == 32'h1234AAEF)
            $display("SH PASS");
        else
            $display("SH FAIL: %h", dut.memory[0]);

        $finish;
    end

endmodule
