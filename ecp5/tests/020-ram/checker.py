from interface import DUTInterface

def xorshift32(x):
	x ^= x << 13
	x ^= x >> 17
	x ^= x << 5
	return x

def main():
	with DUTInterface() as dut:
		def write(addr, data):
			dut.set_din((1 << 31) | (addr << 8) | data)
		def verify(addr, data):
			dut.assert_result(addr << 18, data)
		x = 1

		ram = []
		for i in range(1024):
			x = xorshift32(x)
			ram.append(x & 0xFF)
			write(i, x & 0xFF)

		for i in range(32):
			x = xorshift32(x)
			addr = x & 0x3FF
			verify(addr, ram[addr])
if __name__ == "__main__":
	main()