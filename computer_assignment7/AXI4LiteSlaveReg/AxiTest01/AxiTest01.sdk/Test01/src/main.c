#define AXI_ADDR0 0x0400000000
volatile unsigned int *AXIAddr0 = (volatile unsigned int *) AXI_ADDR0;

unsigned int *mem = AXI_ADDR0;

void read()
{
	unsigned int out;
	xil_printf("-------------READ--------------\n\r");
	for(int i = 0; i <= 22; i++)
	{
		out = mem[AXI_ADDR0+i];
		xil_printf("Read %d = %d\n\r", i, out);
		sleep(1);
	}
	sleep(5);
}

void write_number(int a[8], int b[8])
{
	xil_printf("-------------WRITE-------------\n\r");
	int i = 7;
	int j = 0;
	for(; i >= 0; i--)
	{
		mem[AXI_ADDR0 + j] = a[i];
		mem[AXI_ADDR0 + j + 8] = b[i];
		j++;
	}
}

void write()
{
	xil_printf("-------------WRITE-------------\n\r");
	// a = 5
	mem[AXI_ADDR0 + 0] = 5;
	for(int i = 1; i < 8; i++)
	{
		mem[AXI_ADDR0+i] = 0;
	}

	// b = 3
	mem[AXI_ADDR0 + 8] = 3;
	for(int i = 9; i < 16; i++)
	{
		mem[AXI_ADDR0+i] = 0;
	}
}


int main()
{
//	int a[8] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 5};
//	int b[8] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 3};

//	int a[8] = {0x11111111, 0x11111111, 0x0, 0x0, 0x11111111, 0x0, 0x11111111, 0x11111111};
//	int b[8] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};

//	int a[8] = {0x11111111, 0x11111111, 0x0, 0x0, 0x11111111, 0x0, 0x11111111, 0x11111111};
//	int b[8] = {0x3, 0x0, 0x0, 0x1, 0x0, 0x4, 0x5, 0x6};

	int a[8] = {8, 7, 6, 5, 4, 3, 2, 1};
	int b[8] = {16, 15, 14, 13, 12, 11, 10, 0xFFFFFFFF};

	for(;;)
	{
		write_number(a, b);
		read();
	}
}
