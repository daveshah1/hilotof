from interface import DUTInterface

def xorshift32(x):
	x ^= x << 13
	x &= 0xFFFFFFFF
	x ^= x >> 17
	x &= 0xFFFFFFFF
	x ^= x << 5
	return x & 0xFFFFFFFF

def main():
	with DUTInterface() as dut:
		x = 1
		for i in range(64):
			dut.assert_result(x, ((x & 0xFFFF) * ((x >> 16) & 0xFFFF)))
if __name__ == "__main__":
	main()