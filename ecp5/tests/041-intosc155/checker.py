from interface import DUTInterface

def main():
	with DUTInterface() as dut:
		dut.assert_freq(155e6, 0.1)
if __name__ == "__main__":
	main()