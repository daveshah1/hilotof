#!/usr/bin/env bash
set -ex
mkdir -p build/$1

USER_DEFINES=
if [ -f tests/$1/defines.v ]; then
	USER_DEFINES=tests/$1/defines.v
fi

yosys -p "synth_ecp5 -json build/$1/top.json -top top" -ql build/$1/yosys.log common/defines.v $USER_DEFINES ../rtl/framework.v ../rtl/instruments.v ../rtl/uart_baud_tick_gen.v ../rtl/uart_rx.v ../rtl/uart_tx.v common/wrapper.v tests/$1/dut.v
nextpnr-ecp5 --um5g-45k --json build/$1/top.json --lpf common/versa.lpf --textcfg build/$1/top.config -ql build/$1/nextpnr.log --freq 100
ecppack --svf build/$1/top.svf build/$1/top.config build/$1/top.bit