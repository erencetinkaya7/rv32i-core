module blink (
	input logic clk,
	output logic led
);

logic [23:0] counter;

always_ff @(posedge clk) begin
	counter <= counter + 1'b1;
end

assign led = counter[23];

endmodule
