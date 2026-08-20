module immediate_generator (
	input logic [31:0] instruction,
	output logic [31:0] immediate,

	input logic imm_type
);

always_comb begin
	if (imm_type)
		immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
	else
		immediate = {{20{instruction[31]}}, instruction[31:20]};
end

endmodule
