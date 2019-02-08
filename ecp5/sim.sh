#!/usr/bin/env bash
set -ex
mkdir -p build/$1

USER_DEFINES=
if [ -f tests/$1/defines.v ]; then
	USER_DEFINES=tests/$1/defines.v
fi

iverilog -o build/$1/testbench common/defines.v $USER_DEFINES ../rtl/framework.v ../rtl/instruments.v ../rtl/uart_baud_tick_gen.v ../rtl/uart_rx.v ../rtl/uart_tx.v common/wrapper.v tests/$1/dut.v common/testbench.v
vvp build/$1/testbench