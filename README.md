# HiLoTOF -- Hardware-in-the-Loop Test framework for Open FPGAs

This is a project to develop a fully automated, hardware-in-the-loop, framework for
testing open source FPGA flows. Its first target is the Yosys, nextpnr and Trellis
flow for Lattice ECP5 FPGAs.

At the moment, the framework wraps a "DUT" Verilog module providing 32-bit input
and output over a UART. 32-bit words are sent and received over the UART
hex-encoded and terminated with \r\n. Sending "R" will reset the DUT. The
state machine for this is implemented in `rtl/framework.v` and the wrapper
for the ECP5 in `ecp5/common/wrapper.v`.

Python scripts have a few library functions (to be extended) to send, receive
and check data over the UART.

For a simple implementation of a test, see `ecp5/tests/001-loop`.

To run all ECP5 tests, run `cd ecp5 && ./all.sh`. `build.sh <test>` performs
synthesis, place-and-route and SVF generation for a given test inside `build/<test>`.
`run.sh <test>` will then load that test onto the target and run the checker Python
script.

**This is a work-in-progress. Expect breaking changes!**