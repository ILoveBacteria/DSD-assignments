#define AXI_ADDR0 0x0400000000
volatile unsigned int *AXIAddr0 = (volatile unsigned int *) AXI_ADDR0;

int main()
{
	int i;
	unsigned int *mem = AXI_ADDR0;
	unsigned int out;

	for(;;)
	{
		xil_printf("--------------------------------\n\r");
		// a = 5
		mem[AXI_ADDR0 + 0] = 5;
		for(i = 1; i < 8; i++)
		{
			mem[AXI_ADDR0+i] = 0;
			xil_printf("M[%d] = %d\n\r", i, 0);
		}
		// b = 3
		mem[AXI_ADDR0 + 8] = 3;
		for(i = 9; i < 16; i++)
		{
			mem[AXI_ADDR0+i] = 0;
			xil_printf("M[%d] = %d\n\r", i, 0);
		}

		// read
		sleep(5);
		xil_printf("--------------------------------\n\r");
		for(i = 0; i <= 16; i++)
		{
			out = mem[AXI_ADDR0+i];
			xil_printf("Read %d = %d\n\r", i, out);
			sleep(1);
		}
		sleep(5);
	}
}
