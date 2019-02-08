/* 
 *  HiLoTOF -- Hardware-in-the-Loop Test framework for Open FPGAs
 *
 *  Copyright (C) 2019  David Shah <david@symbioticeda.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module freq_counter (
	input sys_clock,
	input probe,
	output reg [23:0] freq // Frequency in 10Hz units
);

reg [23:0] probe_counter;

always @(posedge probe)
	probe_counter <= probe_counter + 1'b1;

reg [23:0] probe_counter_sys;
reg [23:0] probe_counter_last, probe_counter_now;

reg [$clog2(`CLK_FREQ / 10)-1:0] interval_counter;
reg interval;

always @(posedge sys_clock) begin
	probe_counter_sys <= probe_counter;

	if (interval_counter == 0) begin
		interval_counter <= (`CLK_FREQ / 10) - 1;
		interval <= 1'b1;
	end else begin
		interval_counter <= interval_counter - 1'b1;
		interval <= 1'b0;
	end

	if (interval) begin
		probe_counter_last <= probe_counter_now;
		probe_counter_now <= probe_counter_sys;
	end

	freq <= probe_counter_now - probe_counter_last;
end
endmodule