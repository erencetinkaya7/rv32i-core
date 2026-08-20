module control_unit (
	input logic [6:0] opcode,
	output logic reg_write,
	output logic alu_src
);

always_comb begin
	
	reg_write = 1'b0;
	alu_src = 1'b0;

	case (opcode) // R-type
		7'b0110011: begin
			reg_write = 1'b1;
			alu_src = 1'b0;
		end
		
		7'b0010011: begin // I-type
			reg_write = 1'b1;
			alu_src = 1'b1;
		end
		
		default: begin
			reg_write = 1'b0;
			alu_src = 1'b0;
		end
	endcase
end

endmodule
