module immediate_generator_tb;

logic [31:0] instruction;
logic [31:0] immediate;

immediate_generator dut (
	.instruction(instruction),
	.immediate(immediate)
);

initial begin
	$dumpfile("immediate_generator.vcd");
	$dumpvars(0, immediate_generator_tb);

	instruction = {12'h005, 20'b0};
	#1
	
	if (immediate == 32'd5)
		$display("PASS");
	else 
		$display("FAIL");
	

	instruction = {12'hFFF, 20'b0};
	#1
	
	if (immediate == 32'hFFFFFFFF)
		$display("PASS");
	else 
		$display("FAIL");
	

	instruction = {12'h800, 20'b0};
	#1
	
	if (immediate == 32'hFFFFF800)
		$display("PASS");
	else 
		$display("FAIL");
	
	$finish;
end

endmodule
