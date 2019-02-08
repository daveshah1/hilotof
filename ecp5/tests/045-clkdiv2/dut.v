module dut(
	input clock, reset,
	input din_valid,
	input [31:0] din,
	input dout_ready,
	output dout_valid,
	output [31:0] dout
);
	wire cdiv;
	CLKDIVF #(.DIV("2.0")) div_i(.CLKI(clock), .RST(1'b0), .ALIGNWD(1'b0), .CDIVX(cdiv));

	freq_counter fc_i (
		.sys_clock(clock),
		.probe(cdiv),
		.freq(dout[23:0])
	);

	assign dout[31:24] = 8'h00;
	assign dout_valid = 1'b1;
endmodule