module testbench();

	reg clk;

	always #5 clk = (clk === 1'b0);

	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0, testbench);


		repeat (100000) @(posedge clk);

		$finish;
	end

	wire [7:0] led;

	top top_i (
		.clock(clk),
		.uart_tx(uart_tx),
		.uart_rx(1'b1),
		.led(led)
	);
endmodule
