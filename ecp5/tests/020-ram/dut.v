module dut(
	input clock, reset,
	input din_valid,
	input [31:0] din,
	input dout_ready,
	output reg dout_valid,
	output reg [31:0] dout
);
	reg [7:0] ram [0:1023];

	always @(posedge clock) begin
		dout_valid <= 1'b0;
		if (din_valid && din[31]) begin
			ram[din[17:8]] <= din[7:0];
		end
		if (din_valid) begin
			dout <= ram[din[27:18]];
			dout_valid <= 1'b1;
		end
	end

endmodule