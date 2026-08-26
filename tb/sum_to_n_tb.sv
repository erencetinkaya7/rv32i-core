module sum_to_n_tb;

logic clk;
logic reset;

always #5 clk = ~clk;

rv32i_core dut (
	.clk(clk),
	.reset(reset)
);

initial begin

	reset = 1;
	clk = 0;
	
	$readmemh("sw/sum_to_n.hex", dut.imem.memory);

	#20;
	reset = 0;
	
	repeat (40) @(posedge clk);
	#1;

	if (dut.rf.registers[10] !== 32'd15)
		$display("FAIL: a0 = %0d, expected = 15", dut.rf.registers[10]);
	else
		$display("PASS");
	
	if (dut.rf.registers[2] !== 32'd128)
                $display("FAIL: sp = %0d, expected = 128", dut.rf.registers[2]);
        else
                $display("PASS");

	$finish;
end

endmodule
