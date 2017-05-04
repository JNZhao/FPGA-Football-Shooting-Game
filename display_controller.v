module display_controller(
	clock,
	football_x,
	football_y, 
	goal_keeper_x,
	goal_keeper_y,
	football_power,
	play_x,
	play_y,
	disp_mode,
	x,
	y,
	pixel_colour
);	
	/* Screen resolution and colour depth parameters. */
	
	/*****************************************************************************/
	/* Declare inputs and outputs.                                               */
	/*****************************************************************************/
	
	input			clock;
	input	[9:0]	football_x;
	input	[9:0]	football_y;
	input	[9:0]	goal_keeper_x;
	input	[9:0]	goal_keeper_y;
	input	[9:0]	play_x;
	input	[9:0]	play_y;
	input	[7:0]	football_power;
	input	[3:0]	disp_mode;
	input	[9:0]	x;
	input	[9:0]	y;	
	output	reg[2:0]	pixel_colour;

	reg	[9:0]	rom_player_x=140;
	reg	[9:0]	rom_player_y=200;
	
	reg	[9:0]	rom_again_x=260;
	reg	[9:0]	rom_again_y=200;
	
	(* ram_init_file = "background.mif " *) reg [2:0] image_background [0:19199];
	wire	[14:0]	addr_background;
	reg		[2:0]	colour_background;
	assign addr_background=({2'b00, y[9:2], 7'd0} + {4'b0000, y[9:2], 5'd0} + {9'b000000000, x[9:2]});
	
	always@(posedge clock)begin
		colour_background<=image_background[addr_background];
	end
	
	(* ram_init_file = "player.mif " *) reg [2:0] image_player [0:734];
	wire	[14:0]	addr_player;
	reg		[2:0]	colour_player;
	assign addr_player=(y[9:2]>=play_y[9:2] && y[9:2]<play_y[9:2]+49 && x[9:2]>=play_x[9:2] && x[9:2]<play_x[9:2]+15)?((y[9:2]-play_y[9:2])*15+(x[9:2]-play_x[9:2])): 0;
	always@(posedge clock)begin
		colour_player<=image_player[addr_player];
	end	

	(* ram_init_file = "goal_keeper.mif " *) reg [2:0] image_goal_keeper [0:159];
	wire	[14:0]	addr_goal_keeper;
	reg		[2:0]	colour_goal_keeper;
	assign addr_goal_keeper=(y[9:2]>=goal_keeper_y[9:2] && y[9:2]<goal_keeper_y[9:2]+16 && x[9:2]>=goal_keeper_x[9:2] && x[9:2]<goal_keeper_x[9:2]+10)?((y[9:2]-goal_keeper_y[9:2])*10+(x[9:2]-goal_keeper_x[9:2])): 0;
	always@(posedge clock)begin
		colour_goal_keeper<=image_goal_keeper[addr_goal_keeper];
	end
	
	(* ram_init_file = "rom_player.mif " *) reg [0:0]image_rom_player [0:767];
	wire	[14:0]	addr_rom_player;
	reg		[0:0]	colour_rom_player;
	assign addr_rom_player=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2] && x[9:2]<rom_player_x[9:2]+48)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])): 0;
	always@(posedge clock)begin
		colour_rom_player<=image_rom_player[addr_rom_player];
	end

	reg	[9:0]	image_test_x=400;
	reg	[9:0]	image_test_y=300;
	
	(* ram_init_file = "rom_P.mif " *) reg [0:0] char_P [0:127];
	wire	[14:0]	addr_char_P;
	reg		[0:0]	colour_char_P;
	assign addr_char_P=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2] && x[9:2]<rom_player_x[9:2]+8)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])): 0;
	always@(posedge clock)begin
		colour_char_P<=char_P[addr_char_P];
	end
	
	(* ram_init_file = "rom_L.mif " *) reg [0:0] char_L [0:127];
	wire	[14:0]	addr_char_L;
	reg		[0:0]	colour_char_L;
	assign addr_char_L=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+8 && x[9:2]<rom_player_x[9:2]+16)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-8): 0;
	always@(posedge clock)begin
		colour_char_L<=char_L[addr_char_L];
	end
	
	(* ram_init_file = "rom_A.mif " *) reg [0:0] char_A [0:127];
	wire	[14:0]	addr_char_A;
	reg		[0:0]	colour_char_A;
	assign addr_char_A=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+16 && x[9:2]<rom_player_x[9:2]+24)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-16): 0;
	always@(posedge clock)begin
		colour_char_A<=char_A[addr_char_A];
	end	

	(* ram_init_file = "rom_Y.mif " *) reg [0:0] char_Y [0:127];
	wire	[14:0]	addr_char_Y;
	reg		[0:0]	colour_char_Y;
	assign addr_char_Y=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+24 && x[9:2]<rom_player_x[9:2]+32)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-24): 0;
	always@(posedge clock)begin
		colour_char_Y<=char_Y[addr_char_Y];
	end	

	(* ram_init_file = "rom_E.mif " *) reg [0:0] char_E [0:127];
	wire	[14:0]	addr_char_E;
	reg		[0:0]	colour_char_E;
	assign addr_char_E=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+32 && x[9:2]<rom_player_x[9:2]+40)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-32): 0;
	always@(posedge clock)begin
		colour_char_E<=char_E[addr_char_E];
	end
	
	(* ram_init_file = "rom_R.mif " *) reg [0:0] char_R [0:127];
	wire	[14:0]	addr_char_R;
	reg		[0:0]	colour_char_R;
	assign addr_char_R=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+40 && x[9:2]<rom_player_x[9:2]+48)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-40): 0;
	always@(posedge clock)begin
		colour_char_R<=char_R[addr_char_R];
	end

	(* ram_init_file = "rom_1.mif " *) reg [0:0] char_1 [0:127];
	wire	[14:0]	addr_char_1;
	reg		[0:0]	colour_char_1;
	assign addr_char_1=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+48 && x[9:2]<rom_player_x[9:2]+56)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-48): 0;
	always@(posedge clock)begin
		colour_char_1<=char_1[addr_char_1];
	end
	
	(* ram_init_file = "rom_2.mif " *) reg [0:0] char_2 [0:127];
	wire	[14:0]	addr_char_2;
	reg		[0:0]	colour_char_2;
	assign addr_char_2=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+48 && x[9:2]<rom_player_x[9:2]+56)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-48): 0;
	always@(posedge clock)begin
		colour_char_2<=char_2[addr_char_2];
	end		
	
	(* ram_init_file = "rom_space.mif " *) reg [0:0] char_space [0:127];
	wire	[14:0]	addr_char_space;
	reg		[0:0]	colour_char_space;
	assign addr_char_space=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+56 && x[9:2]<rom_player_x[9:2]+64)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-56): 0;
	always@(posedge clock)begin
		colour_char_space<=char_space[addr_char_space];
	end

	(* ram_init_file = "rom_W.mif " *) reg [0:0] char_W [0:127];
	wire	[14:0]	addr_char_W;
	reg		[0:0]	colour_char_W;
	assign addr_char_W=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+64 && x[9:2]<rom_player_x[9:2]+72)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-64): 0;
	always@(posedge clock)begin
		colour_char_W<=char_W[addr_char_W];
	end

	(* ram_init_file = "rom_I.mif " *) reg [0:0] char_I [0:127];
	wire	[14:0]	addr_char_I;
	reg		[0:0]	colour_char_I;
	assign addr_char_I=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+72 && x[9:2]<rom_player_x[9:2]+80)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-72): 0;
	always@(posedge clock)begin
		colour_char_I<=char_I[addr_char_I];
	end

	(* ram_init_file = "rom_N.mif " *) reg [0:0] char_N [0:127];
	wire	[14:0]	addr_char_N;
	reg		[0:0]	colour_char_N;
	assign addr_char_N=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+80 && x[9:2]<rom_player_x[9:2]+88)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-80): 0;
	always@(posedge clock)begin
		colour_char_N<=char_N[addr_char_N];
	end
	
	(* ram_init_file = "rom_S.mif " *) reg [0:0] char_S [0:127];
	wire	[14:0]	addr_char_S;
	reg		[0:0]	colour_char_S;
	assign addr_char_S=(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+88 && x[9:2]<rom_player_x[9:2]+96)?((y[9:2]-rom_player_y[9:2])*8+(x[9:2]-rom_player_x[9:2])-88): 0;
	always@(posedge clock)begin
		colour_char_S<=char_S[addr_char_S];
	end

	(* ram_init_file = "rom_A.mif " *) reg [0:0] char_A2 [0:127];
	wire	[14:0]	addr_char_A2;
	reg		[0:0]	colour_char_A2;
	assign addr_char_A2=(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2] && x[9:2]<rom_again_x[9:2]+8)?((y[9:2]-rom_again_y[9:2])*8+(x[9:2]-rom_again_x[9:2])): 0;
	always@(posedge clock)begin
		colour_char_A2<=char_A2[addr_char_A2];
	end
	
	(* ram_init_file = "rom_G.mif " *) reg [0:0] char_G [0:127];
	wire	[14:0]	addr_char_G;
	reg		[0:0]	colour_char_G;
	assign addr_char_G=(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+8 && x[9:2]<rom_again_x[9:2]+16)?((y[9:2]-rom_again_y[9:2])*8+(x[9:2]-rom_again_x[9:2])-8): 0;
	always@(posedge clock)begin
		colour_char_G<=char_G[addr_char_G];
	end
	
	(* ram_init_file = "rom_A.mif " *) reg [0:0] char_A3 [0:127];
	wire	[14:0]	addr_char_A3;
	reg		[0:0]	colour_char_A3;
	assign addr_char_A3=(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+16 && x[9:2]<rom_again_x[9:2]+24)?((y[9:2]-rom_again_y[9:2])*8+(x[9:2]-rom_again_x[9:2])-16): 0;
	always@(posedge clock)begin
		colour_char_A3<=char_A3[addr_char_A3];
	end
	
	(* ram_init_file = "rom_I.mif " *) reg [0:0] char_I2 [0:127];
	wire	[14:0]	addr_char_I2;
	reg		[0:0]	colour_char_I2;
	assign addr_char_I2=(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+24 && x[9:2]<rom_again_x[9:2]+32)?((y[9:2]-rom_again_y[9:2])*8+(x[9:2]-rom_again_x[9:2])-24): 0;
	always@(posedge clock)begin
		colour_char_I2<=char_I2[addr_char_I2];
	end
	
	(* ram_init_file = "rom_N.mif " *) reg [0:0] char_N2 [0:127];
	wire	[14:0]	addr_char_N2;
	reg		[0:0]	colour_char_N2;
	assign addr_char_N2=(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+32 && x[9:2]<rom_again_x[9:2]+40)?((y[9:2]-rom_again_y[9:2])*8+(x[9:2]-rom_again_x[9:2])-32): 0;
	always@(posedge clock)begin
		colour_char_N2<=char_N2[addr_char_N2];
	end
	
	always@(posedge clock)begin
		if(x<640 && y<480)begin
			if(disp_mode==0)begin
				if(y[9:2]>=play_y[9:2] && y[9:2]<play_y[9:2]+49 && x[9:2]>=play_x[9:2] && x[9:2]<play_x[9:2]+15)begin
					if(colour_player!=3'b010)
						pixel_colour<=colour_player;
					else
						pixel_colour<=colour_background;
				end		
				else if(((x-football_x)**2 + (y-football_y)**2)<=225)
					pixel_colour<=3'b100;
				else if(y[9:2]>=goal_keeper_y[9:2] && y[9:2]<goal_keeper_y[9:2]+16 && x[9:2]>=goal_keeper_x[9:2] && x[9:2]<goal_keeper_x[9:2]+10)begin
					if(colour_goal_keeper!=3'b010)
						pixel_colour<=colour_goal_keeper;
					else
						pixel_colour<=colour_background;
				end							
				else if((x>=40 && x<=60)&&(y>400-football_power && y<=400))
					pixel_colour<=3'b110;				
				else
					pixel_colour<=colour_background;
			end
			else if(disp_mode==1)begin
				if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2] && x[9:2]<rom_player_x[9:2]+8)begin
					if(colour_char_P[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+8 && x[9:2]<rom_player_x[9:2]+16)begin
					if(colour_char_L[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+16 && x[9:2]<rom_player_x[9:2]+24)begin
					if(colour_char_A[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+24 && x[9:2]<rom_player_x[9:2]+32)begin
					if(colour_char_Y[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+32 && x[9:2]<rom_player_x[9:2]+40)begin
					if(colour_char_E[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+40 && x[9:2]<rom_player_x[9:2]+48)begin
					if(colour_char_R[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+48 && x[9:2]<rom_player_x[9:2]+56)begin
					if(colour_char_1[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end	
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+56 && x[9:2]<rom_player_x[9:2]+64)begin
					if(colour_char_space[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+64 && x[9:2]<rom_player_x[9:2]+72)begin
					if(colour_char_W[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+72 && x[9:2]<rom_player_x[9:2]+80)begin
					if(colour_char_I[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+80 && x[9:2]<rom_player_x[9:2]+88)begin
					if(colour_char_N[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+88 && x[9:2]<rom_player_x[9:2]+96)begin
					if(colour_char_S[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end				
				else
					pixel_colour<=3'b000;
			end
			else if(disp_mode==2)begin
				if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2] && x[9:2]<rom_player_x[9:2]+8)begin
					if(colour_char_P[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+8 && x[9:2]<rom_player_x[9:2]+16)begin
					if(colour_char_L[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+16 && x[9:2]<rom_player_x[9:2]+24)begin
					if(colour_char_A[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+24 && x[9:2]<rom_player_x[9:2]+32)begin
					if(colour_char_Y[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+32 && x[9:2]<rom_player_x[9:2]+40)begin
					if(colour_char_E[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+40 && x[9:2]<rom_player_x[9:2]+48)begin
					if(colour_char_R[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+48 && x[9:2]<rom_player_x[9:2]+56)begin
					if(colour_char_2[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end	
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+56 && x[9:2]<rom_player_x[9:2]+64)begin
					if(colour_char_space[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+64 && x[9:2]<rom_player_x[9:2]+72)begin
					if(colour_char_W[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+72 && x[9:2]<rom_player_x[9:2]+80)begin
					if(colour_char_I[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+80 && x[9:2]<rom_player_x[9:2]+88)begin
					if(colour_char_N[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_player_y[9:2] && y[9:2]<rom_player_y[9:2]+16 && x[9:2]>=rom_player_x[9:2]+88 && x[9:2]<rom_player_x[9:2]+96)begin
					if(colour_char_S[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end				
				else
					pixel_colour<=3'b000;
			end
			else begin
				if(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2] && x[9:2]<rom_again_x[9:2]+8)begin
					if(colour_char_A2[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+8 && x[9:2]<rom_again_x[9:2]+16)begin
					if(colour_char_G[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+16 && x[9:2]<rom_again_x[9:2]+24)begin
					if(colour_char_A3[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end	
				else if(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+24 && x[9:2]<rom_again_x[9:2]+32)begin
					if(colour_char_I2[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end
				else if(y[9:2]>=rom_again_y[9:2] && y[9:2]<rom_again_y[9:2]+16 && x[9:2]>=rom_again_x[9:2]+32 && x[9:2]<rom_again_x[9:2]+40)begin
					if(colour_char_N2[0]==1)
						pixel_colour<=3'b111;
					else
						pixel_colour<=3'b000;
				end					
			end
		end
		else begin
			pixel_colour<=3'b000;
		end
	end	


endmodule
