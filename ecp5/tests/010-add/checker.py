from interface import DUTInterface

def main():
	with DUTInterface() as dut:
		dut.assert_result(0x00010001, 0x00000002)
		dut.assert_result(0x1234ABCD, 0x0000BE01)
		dut.assert_result(0x00FF0001, 0x00000100)
		dut.assert_result(0xFFFF0010, 0x0001000F)

if __name__ == "__main__":
	main()