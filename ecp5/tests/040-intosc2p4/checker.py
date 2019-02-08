from interface import DUTInterface

def main():
	with DUTInterface() as dut:
		dut.assert_freq(2.4e6, 0.1)
if __name__ == "__main__":
	main()