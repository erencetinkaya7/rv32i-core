module control_unit (
	input logic [6:0] opcode,
	output logic reg_write,
	output logic alu_src,
	output logic imm_type,
	output logic mem_write,
	output logic [1:0] result_src
);

always_comb begin
	
	reg_write = 1'b0;
	alu_src = 1'b0;
	imm_type = 1'b0;
	mem_write = 1'b0;
	result_src = 2'b0;

	case (opcode) // R-type
		7'b0110011: begin
			reg_write = 1'b1;
			alu_src = 1'b0;
			mem_write = 1'b0;
			result_src = 2'b0;
		end
		
		7'b0010011: begin // I-type
			reg_write = 1'b1;
			alu_src = 1'b1;
			imm_type = 1'b0;
			mem_write = 1'b0;
			result_src = 2'b0;
		end
		
		7'b0000011: begin //lw
			reg_write = 1'b1;
			alu_src = 1'b1;
			imm_type = 1'b0;
			mem_write = 1'b0;
			result_src = 2'b01;
		end

		7'b0100011: begin //sw
			reg_write = 1'b0;
			alu_src = 1'b1;
			imm_type = 1'b1;
			mem_write = 1'b1;
		end
			
		default: ;
	endcase
end

endmodule
