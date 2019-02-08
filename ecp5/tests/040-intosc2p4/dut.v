module dut(
	input clock, reset,
	input din_valid,
	input [31:0] din,
	input dout_ready,
	output dout_valid,
	output [31:0] dout
);
	wire osc;
	OSCG #(.DIV(128)) osc_i(.OSC(osc));

	freq_counter fc_i (
		.sys_clock(clock),
		.probe(osc),
		.freq(dout[23:0])
	);


	assign dout[31:24] = 8'h00;
	assign dout_valid = 1'b1;
endmodule