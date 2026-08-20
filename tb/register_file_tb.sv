module register_file_tb;

    logic clk;
    logic write_enable;

    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;

    logic [31:0] rd_data;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    register_file dut (
        .clk(clk),
        .write_enable(write_enable),

        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),

        .rd_data(rd_data),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        write_enable = 0;

        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        rd_data = 0;

        // -------------------------
        // TEST 1: x5'e veri yaz
        // -------------------------

        rd_addr = 5'd5;
        rd_data = 32'd123;
        write_enable = 1;

        @(posedge clk);
        #1;

        write_enable = 0;

        rs1_addr = 5'd5;
        #1;

        if (rs1_data == 32'd123)
            $display("TEST 1 PASS: x5 = 123");
        else
            $display("TEST 1 FAIL: x5 = %0d", rs1_data);


        // -------------------------
        // TEST 2: ikinci okuma portu
        // -------------------------

        rd_addr = 5'd8;
        rd_data = 32'd456;
        write_enable = 1;

        @(posedge clk);
        #1;

        write_enable = 0;

        rs1_addr = 5'd5;
        rs2_addr = 5'd8;
        #1;

        if (rs1_data == 32'd123 && rs2_data == 32'd456)
            $display("TEST 2 PASS: two read ports");
        else
            $display("TEST 2 FAIL");


        // -------------------------
        // TEST 3: write_enable = 0
        // -------------------------

        rd_addr = 5'd5;
        rd_data = 32'd999;
        write_enable = 0;

        @(posedge clk);
        #1;

        rs1_addr = 5'd5;
        #1;

        if (rs1_data == 32'd123)
            $display("TEST 3 PASS: write disabled");
        else
            $display("TEST 3 FAIL: x5 changed");


        // -------------------------
        // TEST 4: x0'a yazmayı dene
        // -------------------------

        rd_addr = 5'd0;
        rd_data = 32'hDEADBEEF;
        write_enable = 1;

        @(posedge clk);
        #1;

        write_enable = 0;

        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        #1;

        if (rs1_data == 32'd0 && rs2_data == 32'd0)
            $display("TEST 4 PASS: x0 stays zero");
        else
            $display("TEST 4 FAIL: x0 is not zero");


        $finish;

    end

endmodule
