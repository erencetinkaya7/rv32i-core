module instruction_fields_tb;

    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    instruction_fields dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)
    );

    initial begin

        // add x10, x3, x8
        instruction = 32'h00818533;
        #1;

        if (
            opcode == 7'b0110011 &&
            rd     == 5'd10      &&
            funct3 == 3'b000     &&
            rs1    == 5'd3       &&
            rs2    == 5'd8       &&
            funct7 == 7'b0000000
        )
            $display("ADD decode PASS");
        else
            $display("ADD decode FAIL");


        // sub x5, x6, x7
        instruction = 32'h407302B3;
        #1;

        if (
            opcode == 7'b0110011 &&
            rd     == 5'd5       &&
            funct3 == 3'b000     &&
            rs1    == 5'd6       &&
            rs2    == 5'd7       &&
            funct7 == 7'b0100000
        )
            $display("SUB decode PASS");
        else
            $display("SUB decode FAIL");

        $finish;

    end

endmodule
