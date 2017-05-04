module test(
		CLOCK_50,						//	On Board 50 MHz
		PS2_CLK,
		PS2_DAT,
		LEDR,
		LEDG
);	


	input			CLOCK_50;				//	50 MHz
	input			PS2_CLK;
	input			PS2_DAT;
	output	[17:0]	LEDR;
	output	[7:0]	LEDG;
	
	wire	[7:0]	ps2_data;
	wire			dat_busy;
	wire			dat_ready;
	
	reg				LED_dat_busy=0;
	reg				LED_dat_busy_delay1=0;
	reg				LED_dat_busy_delay2=0;
	
	reg				LED_dat_ready=0;
	
keyboard_PS2 keyboard_PS2_inst(
	.clock(CLOCK_50),
	.ps2_clk(PS2_CLK),
	.ps2_dat(PS2_DAT),
	.dat_out(LEDG),
	.dat_busy(dat_busy),
	.dat_ready(dat_ready));

	always@(posedge CLOCK_50)begin
		if(dat_ready==1)
			LED_dat_ready<=~LED_dat_ready;
	end
	
	assign LEDR[0]=LED_dat_ready;
	
	always@(posedge CLOCK_50)begin
		LED_dat_busy_delay1<=dat_busy;
		LED_dat_busy_delay2<=LED_dat_busy_delay1;
		if(LED_dat_busy_delay2^LED_dat_busy_delay1==1)
			LED_dat_busy<=~LED_dat_busy;
	end

	assign LEDR[1]=LED_dat_busy;

endmodule
