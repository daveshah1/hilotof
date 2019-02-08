from interface import DUTInterface

def xorshift32(x):
	x ^= x << 13
	x ^= x >> 17
	x ^= x << 5
	return x

def main():
	with DUTInterface() as dut:
		dut.assert_freq(155e6, 0.1)
if __name__ == "__main__":
	main()