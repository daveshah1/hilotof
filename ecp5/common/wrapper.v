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

module top(
    input clock,
    output uart_tx,
    input uart_rx,
    output [7:0] led
`USER_PINS
);
    wire sys_reset, dut_reset;

    reg [5:0] reset_cnt = 0;
    always @(posedge clock) begin
        reset_cnt <= reset_cnt + sys_reset;
    end
    assign sys_reset = !(&reset_cnt);

    wire dut_din_valid, dut_dout_ready, dut_dout_valid;
    wire [31:0] dut_din, dut_dout;

    hilotof_io ctrl_i (
        .clock(clock),
        .sys_reset(sys_reset),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx),
        .dut_reset(dut_reset),
        .dut_din_valid(dut_din_valid),
        .dut_din(dut_din),
        .dut_dout_ready(dut_dout_ready),
        .dut_dout_valid(dut_dout_valid),
        .dut_dout(dut_dout)
    );

    dut dut_i (
        .clock(clock),
        .reset(dut_reset),
        .din_valid(dut_din_valid),
        .din(dut_din),
        .dout_ready(dut_dout_ready),
        .dout_valid(dut_dout_valid),
        .dout(dut_dout)
        `USER_CONNECTIVITY
    );

    reg [25:0] heatbeat_ctr;
    always @(posedge clock)
        heatbeat_ctr <= heatbeat_ctr + 1'b1;

    assign led = ~{
        sys_reset, dut_reset,
        dut_din_valid, dut_dout_ready, dut_dout_valid,
        uart_rx, uart_tx,
        heatbeat_ctr[25]
    };

endmodule