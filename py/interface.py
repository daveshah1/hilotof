from serial import Serial
import os, sys, time

class DUTInterface:
    def __init__(self):
        pass

    def __enter__(self):
        self.port = Serial(os.environ["UART_PORT"], os.environ["UART_BAUD"])
        self.port.timeout = 1
        self.port.reset_input_buffer()
        self.port.write(b'R') # Reset DUT
        self.port.reset_input_buffer()
        return self

    def __exit__(self, *args):
        self.port.close()

    def set_din(self, val):
        # Write value
        self.port.write(("%08X" % val).encode('utf-8'))
        # Write newline to set valid
        self.port.write(b"\n")
        self.port.flush()

    def purge(self):
        oldto = self.port.timeout
        self.port.timeout = 0.01
        for i in range(4):
            data = self.port.read(4096)
        self.port.timeout = oldto

    def check_dout(self, val):
        self.port.reset_input_buffer()
        self.port.readline()
        line = self.port.readline().strip()
        assert val == int(line, 16), ("%s != %08X" % (line, val))

    def assert_result(self, din, dout):
        self.set_din(din)
        self.purge()
        self.check_dout(dout)