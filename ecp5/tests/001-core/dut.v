module dut(
	input clock, reset,
	input din_valid,
	input [31:0] din,
	input dout_ready,
	output dout_valid,
	output [31:0] dout
);
	assign dout_valid = 1'b1;
	assign dout = 32'hDEADBEEF;
endmodule