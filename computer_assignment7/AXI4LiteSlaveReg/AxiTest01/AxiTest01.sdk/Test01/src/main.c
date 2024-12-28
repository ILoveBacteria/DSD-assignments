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
		for(i = 0; i < 32;i ++)
		{
			mem[AXI_ADDR0+i] = 1000+i;
			xil_printf("M[%d] = %d\n\r", i, 1000+i);
		}
		sleep(1);
		for(i =0; i <= 32;i ++)
		{
			out = mem[AXI_ADDR0+i];
			xil_printf("Read %d\n\r", out);
		}
		sleep(5);
	}
}
