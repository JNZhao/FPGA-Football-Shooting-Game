module game_shoot(
		CLOCK_50,						//	On Board 50 MHz
		PS2_CLK,
		PS2_DAT,
		GPIO_0,
		
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
);	


	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	// Do not change the following outputs
	input			PS2_CLK;
	input			PS2_DAT;
	output	[0:0]	GPIO_0;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]

	reg				vga_clock=0;
	wire	[9:0]	x;
	wire	[9:0]	y;	
	wire	[2:0]	pixel_colour;
	
	wire	[7:0]	ps2_data;
	wire			dat_busy;
	wire			dat_ready;
	
	always@(posedge CLOCK_50)begin
		vga_clock<=~vga_clock;
	end

keyboard_PS2 keyboard_PS2_inst(
	.clock(CLOCK_50),
	.ps2_clk(PS2_CLK),
	.ps2_dat(PS2_DAT),
	.dat_out(ps2_data),
	.dat_busy(dat_busy),
	.dat_ready(dat_ready));

	wire	[9:0]	football_x;
	wire	[9:0]	football_y;
	wire	[9:0]	goal_keeper_x;
	wire	[9:0]	goal_keeper_y;
	wire	[9:0]	play_x;
	wire	[9:0]	play_y;
	wire	[7:0]	football_power;
	wire	[3:0]	disp_mode;

ctrl_FSM ctrl_FSM_inst(
	.clock(CLOCK_50),
	.dat_out(ps2_data),
	.dat_busy(dat_busy),
	.dat_ready(dat_ready),
	.football_x(football_x),
	.football_y(football_y),
	.goal_keeper_x(goal_keeper_x),
	.goal_keeper_y(goal_keeper_y),
	.play_x(play_x),
	.play_y(play_y),
	.football_power(football_power),
	.speeker(GPIO_0),
	.disp_mode(disp_mode)
	);
	
display_controller display_controller_inst(
	.clock(vga_clock),
	.football_x(football_x),
	.football_y(football_y), 
	.goal_keeper_x(goal_keeper_x),
	.goal_keeper_y(goal_keeper_y),
	.football_power(football_power),
	.play_x(play_x),
	.play_y(play_y),
	.disp_mode(disp_mode),
	.x(x),
	.y(y),
	.pixel_colour(pixel_colour)
);

vga_controller vga_controller_inst(
	.vga_clock(vga_clock),
	.pixel_colour(pixel_colour),
	.x(x), 
	.y(y),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_BLANK(VGA_BLANK_N),
	.VGA_SYNC(VGA_SYNC_N),
	.VGA_CLK(VGA_CLK)
);	

endmodule
