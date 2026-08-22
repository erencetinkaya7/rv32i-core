module rv32i_core (
    input logic clk,
    input logic reset
);

logic [31:0] pc, next_pc, instruction;

logic [6:0] opcode, funct7;
logic [4:0] rs1, rs2, rd;
logic [2:0] funct3;

logic [31:0] rs1_data, rs2_data, immediate;
logic [31:0] alu_operand_b, alu_result;
logic [3:0]  alu_control;

logic reg_write, alu_src;

logic mem_write;
logic [1:0]  result_src;
logic [31:0] memory_read_data;
logic [31:0] writeback_data;

logic [31:0] alu_operand_a;
logic [31:0] pc_plus4;
logic [31:0] pc_target;
logic [31:0] jalr_target;

logic [2:0] imm_sel;
logic [1:0] alu_a_sel;

logic branch_enable;
logic branch_taken;
logic jump;
logic jalr;

assign pc_plus4 = pc + 32'd4;
assign pc_target = pc + immediate;

program_counter pc_unit (
	.clk(clk),
	.reset(reset),
	.next_pc(next_pc),
	.pc(pc)
);

instruction_memory imem (
	.pc(pc),
	.instruction(instruction)
);

instruction_fields fields (
	.instruction(instruction),	
	.opcode(opcode),
	.rd(rd),
	.funct3(funct3),
	.rs1(rs1),
	.rs2(rs2),
	.funct7(funct7)
);

assign writeback_data = (result_src == 2'b01) ? memory_read_data : (result_src == 2'b10) ? pc_plus4 : alu_result;

register_file rf (
    .clk(clk),
    .write_enable(reg_write),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rd_addr(rd),
    .rd_data(writeback_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

control_unit control (
    .opcode(opcode),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .imm_sel(imm_sel),
    .mem_write(mem_write),
    .result_src(result_src),
    .alu_a_sel(alu_a_sel),
    .branch_enable(branch_enable),
    .jump(jump),
    .jalr(jalr)
);

alu_decoder decoder (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .alu_control(alu_control)
);

immediate_generator imm_gen (
    .instruction(instruction),
    .immediate(immediate),
    .imm_sel(imm_sel)
);

data_memory dmem (
    .clk(clk),
    .mem_write(mem_write),
    .address(alu_result),
    .write_data(rs2_data),
    .read_data(memory_read_data),
    .funct3(funct3)
);

assign alu_operand_b = alu_src ? immediate : rs2_data;

always_comb begin
	case (alu_a_sel)
		2'b00: alu_operand_a = rs1_data;
		2'b01: alu_operand_a = pc;
		2'b10: alu_operand_a = 32'b0;
		default: alu_operand_a = rs1_data;
	endcase
end

alu alu_unit (
    .a(alu_operand_a),
    .b(alu_operand_b),
    .alu_control(alu_control),
    .result(alu_result)
);

branch_unit branch_control (
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .funct3(funct3),
    .branch_enable(branch_enable),
    .branch_taken(branch_taken)
);

assign jalr_target = alu_result & 32'hFFFFFFFE;
assign next_pc = jalr ? jalr_target : (branch_taken || jump) ? pc_target :
    pc_plus4;
endmodule
