module array_sum_tb;

logic clk;
logic reset;

// Generate Clk (Clock) Signal

always #5 clk = ~clk;

// rv32i-core design under test instace

rv32i_core dut (
	.clk(clk),
	.reset(reset)
);

initial begin
	clk = 0;
	reset = 1;
	
	// Loading test data
	dut.dmem.memory[0] = 32'd4;
	dut.dmem.memory[1] = 32'd7;
	dut.dmem.memory[2] = 32'd2;
	dut.dmem.memory[3] = 32'd9;
	dut.dmem.memory[4] = 32'd3;


	// Load instructions
	dut.imem.memory[0]  = 32'h00000293;
	dut.imem.memory[1]  = 32'h00500313;
	dut.imem.memory[2]  = 32'h00000393;
	dut.imem.memory[3]  = 32'h00000e93;
	dut.imem.memory[4]  = 32'h0062dc63;
	dut.imem.memory[5]  = 32'h000eaf03;
	dut.imem.memory[6]  = 32'h01e383b3;
	dut.imem.memory[7]  = 32'h004e8e93;
	dut.imem.memory[8]  = 32'h00128293;
	dut.imem.memory[9]  = 32'hfedff06f;
	dut.imem.memory[10] = 32'h0000006f;


	#20; 
	reset = 0;

	repeat (36) @(posedge clk);
	#1;

	if (dut.rf.registers[7] !== 32'd25) begin
		$display("FAIL: sum = %0d, expected 25", dut.rf.registers[7]);
	end
	else begin
		$display("PASS: sum =  %0d", dut.rf.registers[7]);
	end
	
	$finish;

end

endmodule
