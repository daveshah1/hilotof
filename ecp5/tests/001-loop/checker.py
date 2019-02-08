from interface import DUTInterface

def main():
	with DUTInterface() as dut:
		dut.assert_result(0x00000000, 0xFFFFFFFF)
		dut.assert_result(0x00000001, 0xFFFFFFFE)
		dut.assert_result(0xDEADBEEF, 0x21524110)

if __name__ == "__main__":
	main()