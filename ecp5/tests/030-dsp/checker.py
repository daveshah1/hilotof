from interface import DUTInterface

def xorshift32(x):
	x ^= x << 13
	x ^= x >> 17
	x ^= x << 5
	return x

def main():
	with DUTInterface() as dut:
		x = 1
		for i in range(64):
			x = xorshift32(x)
			dut.assert_result(x, ((x & 0xFFFF) * ((x >> 16) & 0xFFFF)))
if __name__ == "__main__":
	main()