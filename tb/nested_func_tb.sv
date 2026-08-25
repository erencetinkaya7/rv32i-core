module nested_func_tb;

logic clk;
logic reset;

rv32i_core dut (
	.clk(clk),
	.reset(reset)
);


always #5 clk = ~clk;

initial begin
	
	clk = 0;
	reset = 1;
	
	$readmemh("sw/nested_func.hex", dut.imem.memory);

	#20;
	reset = 0;

	repeat (25) @(posedge clk);
	#1;


	if (dut.rf.registers[10] !== 32'd11)
	    $display("FAIL: a0=%0d, expected 11", dut.rf.registers[10]);
	else
	    $display("PASS: a0=11");

	if (dut.rf.registers[2] !== 32'd128)
	    $display("FAIL: sp=%0d, expected 128", dut.rf.registers[2]);
	else
	    $display("PASS: sp=128");

	if (dut.dmem.memory[31] !== 32'h0000000c)
	    $display("FAIL: stack ra=%h, expected 0000000c", dut.dmem.memory[31]);
	else
	    $display("PASS: stack saved ra=0000000c");


	$finish;
end

endmodule
