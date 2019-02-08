#!/usr/bin/env bash
set -ex
openocd -f ../../prjtrellis/misc/openocd/ecp5-versa5g.cfg -c "transport select jtag; init; svf quiet build/$1/top.svf; exit"
PYTHONPATH=../py UART_PORT=/dev/ttyUSB1 UART_BAUD=115200 python3 tests/$1/checker.py