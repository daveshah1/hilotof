#!/usr/bin/env bash
set -ex
openocd -f ../../prjtrellis/misc/openocd/ecp5-versa5g.cfg -c "transport select jtag; init; svf quiet build/$1/top.svf; exit"
