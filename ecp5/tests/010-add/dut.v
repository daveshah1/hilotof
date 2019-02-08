module dut(
	input clock, reset,
	input din_valid,
	input [31:0] din,
	input dout_ready,
	output dout_valid,
	output [31:0] dout
);
	assign dout_valid = din_valid;
	assign dout = din[31:16] + din[15:0];
endmodule