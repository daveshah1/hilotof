from interface import DUTInterface

def main():
	with DUTInterface() as dut:
		dut.assert_freq(50e6, 0.001)
if __name__ == "__main__":
	main()