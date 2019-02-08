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

module hilotof_io (
    // Clock, at platform defined frequency
    input clock,
    input sys_reset,
    // UART interface to host PC
    input uart_rx,
    output uart_tx,
    // DUT interface
    output reg dut_reset,
    // 32-bit stimilus from PC to DUT
    output reg [31:0] dut_din,
    output reg dut_din_valid,
    // 32-bit result from DUT to PC
    input [31:0] dut_dout,
    output dut_dout_ready,
    input dut_dout_valid
);
    // Convert uppercase ASCII to hex (returns {valid, hex[3:0]})
    function [4:0] ascii_to_hex;
        input [7:0] i_ascii;
        case(i_ascii)
            "0": ascii_to_hex = 5'h10;
            "1": ascii_to_hex = 5'h11;
            "2": ascii_to_hex = 5'h12;
            "3": ascii_to_hex = 5'h13;
            "4": ascii_to_hex = 5'h14;
            "5": ascii_to_hex = 5'h15;
            "6": ascii_to_hex = 5'h16;
            "7": ascii_to_hex = 5'h17;
            "8": ascii_to_hex = 5'h18;
            "9": ascii_to_hex = 5'h19;
            "A": ascii_to_hex = 5'h1A;
            "B": ascii_to_hex = 5'h1B;
            "C": ascii_to_hex = 5'h1C;
            "D": ascii_to_hex = 5'h1D;
            "E": ascii_to_hex = 5'h1E;
            "F": ascii_to_hex = 5'h1F;
            default: ascii_to_hex = 5'h00;
        endcase
    endfunction

    // Convert hex to uppercase ASCII
    function [7:0] hex_to_ascii;
        input [3:0] i_ascii;
        case(i_ascii)
            4'h0: hex_to_ascii = "0";
            4'h1: hex_to_ascii = "1";
            4'h2: hex_to_ascii = "2";
            4'h3: hex_to_ascii = "3";
            4'h4: hex_to_ascii = "4";
            4'h5: hex_to_ascii = "5";
            4'h6: hex_to_ascii = "6";
            4'h7: hex_to_ascii = "7";
            4'h8: hex_to_ascii = "8";
            4'h9: hex_to_ascii = "9";
            4'hA: hex_to_ascii = "A";
            4'hB: hex_to_ascii = "B";
            4'hC: hex_to_ascii = "C";
            4'hD: hex_to_ascii = "D";
            4'hE: hex_to_ascii = "E";
            4'hF: hex_to_ascii = "F";
        endcase
    endfunction

    wire uart_rx_valid;
    wire [7:0] uart_rx_data;
    wire [4:0] decoded_rx = ascii_to_hex(uart_rx_data);

    always @(posedge clock)
    begin

        dut_reset <= 1'b0;

        if (uart_rx_valid) begin
            dut_din_valid <= 1'b0;
            if (decoded_rx[4])
                dut_din <= {dut_din[27:0], decoded_rx[3:0]};
            else if (uart_rx_data == "R")
                dut_reset <= 1'b1;
            else if (uart_rx_data == "\n")
                dut_din_valid <= 1'b1;
        end

        if (sys_reset) begin
            dut_reset <= 1'b1;
            dut_din <= 32'b0;
            dut_din_valid <= 1'b0;
        end
    end

    reg uart_tx_valid;
    reg [7:0] uart_tx_data;
    wire tx_busy;
    reg tx_in_progress;
    reg [11:0] tx_count;
    reg [31:0] tx_shiftreg;

    always @(posedge clock)
    begin
        uart_tx_valid <= 1'b0;

        if (dut_dout_valid && !tx_in_progress) begin
            tx_shiftreg <= dut_dout;
            tx_count <= 4'b0;
            tx_in_progress <= 1'b1;
        end else if (tx_in_progress && !uart_tx_valid && !tx_busy) begin
            if (tx_count < 8) begin
                uart_tx_valid <= 1'b1;
                uart_tx_data <= hex_to_ascii(tx_shiftreg[31:28]);
                tx_shiftreg <= {tx_shiftreg[27:0], 4'b0000};
            end else if (tx_count == 8) begin
                uart_tx_valid <= 1'b1;
                uart_tx_data <= "\r";
            end else if (tx_count == 9) begin
                uart_tx_valid <= 1'b1;
                uart_tx_data <= "\n";
            end else if (&tx_count) begin // Wait a bit to ensure a gap between bytes
                tx_in_progress <= 1'b0;
            end
            tx_count <= tx_count + 1'b1;
        end

        if (sys_reset) begin
            uart_tx_valid <= 1'b0;
            uart_tx_data <= 8'b0;
            tx_in_progress <= 1'b0;
            tx_count <= 4'b0;
        end
    end

    assign dut_dout_ready = !tx_in_progress;

    uart_rx #(
        .clk_freq(`CLK_FREQ),
        .baud(`UART_BAUD)
    ) uart_rx_i (
        .clk(clock),
        .rx(uart_rx),
        .rx_ready(uart_rx_valid),
        .rx_data(uart_rx_data)
    );

    uart_tx #(
        .clk_freq(`CLK_FREQ),
        .baud(`UART_BAUD)
    ) uart_tx_i (
        .clk(clock),
        .tx_start(uart_tx_valid),
        .tx_data(uart_tx_data),
        .tx_busy(tx_busy),
        .tx(uart_tx)
    );

endmodule