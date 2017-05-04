module ctrl_FSM(
	clock,
	dat_out,
	dat_busy,
	dat_ready,
	football_x,
	football_y,
	goal_keeper_x,
	goal_keeper_y,
	play_x,
	play_y,
	football_power,
	speeker,
	disp_mode
	);

	input			clock;					//50M time signal
	input	[7:0]	dat_out;					// 1byte，simple input-scanning
	input			dat_busy;
	input			dat_ready;			     //current state of the keyboard，ps2_state=1 -> key impressed
	output	[9:0]	football_x;
	output	[9:0]	football_y;
	output	[9:0]	goal_keeper_x;
	output	[9:0]	goal_keeper_y;
	output	[9:0]	play_x;
	output	[9:0]	play_y;
	output	[7:0]	football_power;
	output			speeker;
	output	[3:0]	disp_mode;	


	reg		[9:0]	football_x=380;
	reg		[9:0]	football_y=360;
	reg		[9:0]	goal_keeper_x=360;
	reg		[9:0]	goal_keeper_y=140;
	reg		[9:0]	play_x=240;
	reg		[9:0]	play_y=240;	
	reg		[7:0]	football_power=1;
	reg		[3:0]	disp_mode=0;	
	
	parameter		IDLE  	=6'b000001,
					READY1	=6'b000010,
					PLAY1	=6'b000100,
					READY2	=6'b001000,
					PLAY2	=6'b010000,
					FINISH	=6'b100000;
					
	reg		[5:0]	state	=READY1;	
	
	reg		[3:0]	football_dir	=3;
	reg		[3:0]	goal_keeper_pos	=3;
	
	reg		[39:0]	cnt_speeker_goin_delay=50000000;
	reg		[29:0]	cnt_speeker_goin=0;
	reg				tone_goin		=0;
	reg				flag_goin		=0;
	
	reg		[39:0]	cnt_speeker_goout_delay=0;
	reg		[29:0]	cnt_speeker_goout=0;
	reg				tone_goout		=0;	
	reg				flag_goout		=0;
	
	always@(posedge clock)begin
		if(flag_goin==1)begin
			cnt_speeker_goin_delay<=0;
		end
		else if(cnt_speeker_goin_delay<12500000)begin
			cnt_speeker_goin_delay<=cnt_speeker_goin_delay+1;
			if(cnt_speeker_goin<25000)begin
				cnt_speeker_goin<=cnt_speeker_goin+1;
			end
			else begin
				cnt_speeker_goin<=0;
				tone_goin<=~tone_goin;
			end
		end
		else begin
			tone_goin<=0;
			cnt_speeker_goin_delay<=cnt_speeker_goin_delay;
		end
	end
	
	always@(posedge clock)begin
		if(flag_goout==1)begin
			cnt_speeker_goout_delay<=0;
		end
		else if(cnt_speeker_goout_delay<12500000)begin
			cnt_speeker_goout_delay<=cnt_speeker_goout_delay+1;
			if(cnt_speeker_goout<12500)begin
				cnt_speeker_goout<=cnt_speeker_goout+1;
			end
			else begin
				cnt_speeker_goout<=0;
				tone_goout<=~tone_goout;
			end
		end
		else begin
			tone_goout<=0;
			cnt_speeker_goin_delay<=cnt_speeker_goin_delay;
		end
	end	

	assign speeker=(cnt_speeker_goin_delay<12500000) ? tone_goin : ((cnt_speeker_goout_delay<12500000) ? tone_goout : 0);



	wire			key_football_dir_0;
	wire			key_football_dir_1;
	wire			key_football_dir_2;
	wire			key_football_dir_3;
	wire			key_football_dir_4;
	wire			key_football_dir_5;
	wire			key_football_dir_6;
	wire			key_football_dir_7;
	wire			key_football_dir_8;
	
	assign key_football_dir_0=(dat_out==8'h5a)? dat_ready : 1'b0;//z
	assign key_football_dir_1=(dat_out==8'h41)? dat_ready : 1'b0;//a
	assign key_football_dir_2=(dat_out==8'h51)? dat_ready : 1'b0;//q
	assign key_football_dir_3=(dat_out==8'h58)? dat_ready : 1'b0;//x
	assign key_football_dir_4=(dat_out==8'h53)? dat_ready : 1'b0;//s
	assign key_football_dir_5=(dat_out==8'h57)? dat_ready : 1'b0;//w
	assign key_football_dir_6=(dat_out==8'h43)? dat_ready : 1'b0;//c
	assign key_football_dir_7=(dat_out==8'h44)? dat_ready : 1'b0;//d
	assign key_football_dir_8=(dat_out==8'h45)? dat_ready : 1'b0;//e
	
	wire			key_goal_keeper_pos_0;
	wire			key_goal_keeper_pos_1;
	wire			key_goal_keeper_pos_2;
	wire			key_goal_keeper_pos_3;
	wire			key_goal_keeper_pos_4;
	wire			key_goal_keeper_pos_5;
	wire			key_goal_keeper_pos_6;
	wire			key_goal_keeper_pos_7;
	wire			key_goal_keeper_pos_8;
	
	wire			key_kick;
	reg				key_kick_delay_flag=0;
	reg		[39:0]	key_kick_delay=0;
	wire			key_start;
	
	assign key_goal_keeper_pos_0=(dat_out==8'h42)? dat_ready : 1'b0;//b
	assign key_goal_keeper_pos_1=(dat_out==8'h47)? dat_ready : 1'b0;//g
	assign key_goal_keeper_pos_2=(dat_out==8'h54)? dat_ready : 1'b0;//t
	assign key_goal_keeper_pos_3=(dat_out==8'h4e)? dat_ready : 1'b0;//n
	assign key_goal_keeper_pos_4=(dat_out==8'h48)? dat_ready : 1'b0;//h
	assign key_goal_keeper_pos_5=(dat_out==8'h59)? dat_ready : 1'b0;//y
	assign key_goal_keeper_pos_6=(dat_out==8'h4d)? dat_ready : 1'b0;//m
	assign key_goal_keeper_pos_7=(dat_out==8'h4a)? dat_ready : 1'b0;//j
	assign key_goal_keeper_pos_8=(dat_out==8'h55)? dat_ready : 1'b0;//u
	
	assign key_kick	=(dat_out==8'h08)? dat_ready : 1'b0;//space
	assign key_start=(dat_out==8'h13)? dat_ready : 1'b0;//enter
	
	reg		[1:0]	play_win=2'b00;
	reg				flag_key_kick=0;
	reg		[39:0]	cnt_10hz=0;
	reg				clk_10hz_pos=0;
	
	reg		[39:0]	cntx=0;
	reg		[39:0]	cnty=0;
	
	always@(posedge clock)begin
		if(cnt_10hz<2000000)begin
			cnt_10hz<=cnt_10hz+1;
			clk_10hz_pos<=0;
		end
		else begin
			cnt_10hz<=0;
			clk_10hz_pos<=1;			
		end
	end
			
	always@(posedge clock)begin
		case(state)
		IDLE:begin
			flag_goin<=0;
			flag_goout<=0;		
			play_win<=2'b00;
			disp_mode<=0;
			goal_keeper_pos<=3;
			football_x<=380;
			football_y<=360;
			if(key_start==1)begin
				state<=READY1;
				football_power<=1;
			end
			else begin
				state<=IDLE;
			end
		end
		READY1:begin
			flag_goin<=0;
			flag_goout<=0;
			key_kick_delay_flag<=0;
			play_win<=2'b00;
			disp_mode<=0;
			state<=READY1;
			football_x<=380;
			football_y<=360;
			if(key_football_dir_0==1)
				football_dir<=0;
			else if(key_football_dir_1==1)
				football_dir<=1;
			else if(key_football_dir_2==1)
				football_dir<=2;
			else if(key_football_dir_3==1)
				football_dir<=3;
			else if(key_football_dir_4==1)
				football_dir<=4;
			else if(key_football_dir_5==1)
				football_dir<=5;
			else if(key_football_dir_6==1)
				football_dir<=6;
			else if(key_football_dir_7==1)
				football_dir<=7;
			else if(key_football_dir_8==1)
				football_dir<=8;
			else if(key_kick==1)begin
				if(flag_key_kick==0)begin
					flag_key_kick<=1;
				end
				else begin
					flag_key_kick<=0;
					key_kick_delay_flag<=1;
					state<=PLAY1;
				end
			end
			if(clk_10hz_pos==1 && flag_key_kick==1)begin
				if(football_power<99)begin
					football_power<=football_power+1;
				end
				else begin
					football_power<=1;
				end
			end			
			
			if(key_goal_keeper_pos_0==1)
				goal_keeper_pos<=0;
			else if(key_goal_keeper_pos_1==1)
				goal_keeper_pos<=1;
			else if(key_goal_keeper_pos_2==1)
				goal_keeper_pos<=2;
			else if(key_goal_keeper_pos_3==1)
				goal_keeper_pos<=3;
			else if(key_goal_keeper_pos_4==1)
				goal_keeper_pos<=4;
			else if(key_goal_keeper_pos_5==1)
				goal_keeper_pos<=5;
			else if(key_goal_keeper_pos_6==1)
				goal_keeper_pos<=6;
			else if(key_goal_keeper_pos_7==1)
				goal_keeper_pos<=7;
			else if(key_goal_keeper_pos_8==1)
				goal_keeper_pos<=8;
																																
		end
		PLAY1:begin
			flag_goin<=0;
			flag_goout<=0;		
			state<=PLAY1;
			key_kick_delay_flag<=0;
			disp_mode<=0;
			if(key_goal_keeper_pos_0==1)
				goal_keeper_pos<=0;
			else if(key_goal_keeper_pos_1==1)
				goal_keeper_pos<=1;
			else if(key_goal_keeper_pos_2==1)
				goal_keeper_pos<=2;
			else if(key_goal_keeper_pos_3==1)
				goal_keeper_pos<=3;
			else if(key_goal_keeper_pos_4==1)
				goal_keeper_pos<=4;
			else if(key_goal_keeper_pos_5==1)
				goal_keeper_pos<=5;
			else if(key_goal_keeper_pos_6==1)
				goal_keeper_pos<=6;
			else if(key_goal_keeper_pos_7==1)
				goal_keeper_pos<=7;
			else if(key_goal_keeper_pos_8==1)
				goal_keeper_pos<=8;
			case(football_dir)
				0:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x>220)
							football_x<=football_x-1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end					
				end
				1:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x>220)
							football_x<=football_x-1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*6;
					else begin
						cnty<=0;
						if(football_y>120)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end				
				end
				2:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x>220)
							football_x<=football_x-1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*7;
					else begin
						cnty<=0;
						if(football_y>80)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end				
				end
				3:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end				
				end
				4:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*6;
					else begin
						cnty<=0;
						if(football_y>120)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end					
				end
				5:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*7;
					else begin
						cnty<=0;
						if(football_y>80)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end					
				end
				6:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x<540)
							football_x<=football_x+1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end					
				end
				7:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x<540)
							football_x<=football_x+1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*6;
					else begin
						cnty<=0;
						if(football_y>120)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end					
				end	
				8:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x<540)
							football_x<=football_x+1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*7;
					else begin
						cnty<=0;
						if(football_y>80)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
						end
					end					
				end
				default:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[0]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[0]<=0;
								flag_goout<=1;
							end
							state<=READY2;
							football_x<=380;
							football_y<=360;
							football_power<=0;
						end
					end					
				end
			endcase																								
		end
		READY2:begin
			flag_goin<=0;
			flag_goout<=0;	
			disp_mode<=0;
			state<=READY2;
			football_x<=380;
			football_y<=360;
			key_kick_delay_flag<=0;
			if(key_football_dir_0==1)
				football_dir<=0;
			else if(key_football_dir_1==1)
				football_dir<=1;
			else if(key_football_dir_2==1)
				football_dir<=2;
			else if(key_football_dir_3==1)
				football_dir<=3;
			else if(key_football_dir_4==1)
				football_dir<=4;
			else if(key_football_dir_5==1)
				football_dir<=5;
			else if(key_football_dir_6==1)
				football_dir<=6;
			else if(key_football_dir_7==1)
				football_dir<=7;
			else if(key_football_dir_8==1)
				football_dir<=8;
			else if(key_kick==1)begin
				if(flag_key_kick==0)begin
					flag_key_kick<=1;
				end
				else begin
					flag_key_kick<=0;
					key_kick_delay_flag<=1;
					state<=PLAY2;
				end
			end
			if(clk_10hz_pos==1 && flag_key_kick==1)begin
				if(football_power<99)begin
					football_power<=football_power+1;
				end
				else begin
					football_power<=1;
				end
			end	
			if(key_goal_keeper_pos_0==1)
				goal_keeper_pos<=0;
			else if(key_goal_keeper_pos_1==1)
				goal_keeper_pos<=1;
			else if(key_goal_keeper_pos_2==1)
				goal_keeper_pos<=2;
			else if(key_goal_keeper_pos_3==1)
				goal_keeper_pos<=3;
			else if(key_goal_keeper_pos_4==1)
				goal_keeper_pos<=4;
			else if(key_goal_keeper_pos_5==1)
				goal_keeper_pos<=5;
			else if(key_goal_keeper_pos_6==1)
				goal_keeper_pos<=6;
			else if(key_goal_keeper_pos_7==1)
				goal_keeper_pos<=7;
			else if(key_goal_keeper_pos_8==1)
				goal_keeper_pos<=8;																													
		end
		PLAY2:begin
			flag_goin<=0;
			flag_goout<=0;		
			state<=PLAY2;
			key_kick_delay_flag<=0;
			if(key_goal_keeper_pos_0==1)
				goal_keeper_pos<=0;
			else if(key_goal_keeper_pos_1==1)
				goal_keeper_pos<=1;
			else if(key_goal_keeper_pos_2==1)
				goal_keeper_pos<=2;
			else if(key_goal_keeper_pos_3==1)
				goal_keeper_pos<=3;
			else if(key_goal_keeper_pos_4==1)
				goal_keeper_pos<=4;
			else if(key_goal_keeper_pos_5==1)
				goal_keeper_pos<=5;
			else if(key_goal_keeper_pos_6==1)
				goal_keeper_pos<=6;
			else if(key_goal_keeper_pos_7==1)
				goal_keeper_pos<=7;
			else if(key_goal_keeper_pos_8==1)
				goal_keeper_pos<=8;
			case(football_dir)
				0:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x>220)
							football_x<=football_x-1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end
				1:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x>220)
							football_x<=football_x-1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*6;
					else begin
						cnty<=0;
						if(football_y>120)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end				
				end
				2:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x>220)
							football_x<=football_x-1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*7;
					else begin
						cnty<=0;
						if(football_y>80)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end				
				end
				3:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end				
				end
				4:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*6;
					else begin
						cnty<=0;
						if(football_y>120)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end
				5:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*7;
					else begin
						cnty<=0;
						if(football_y>80)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end
				6:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x<540)
							football_x<=football_x+1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end
				7:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x<540)
							football_x<=football_x+1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*6;
					else begin
						cnty<=0;
						if(football_y>120)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end	
				8:begin
					if(cntx<200000000)
						cntx<=cntx+football_power*4;
					else begin
						cntx<=0;
						if(football_x<540)
							football_x<=football_x+1;						
					end
					if(cnty<200000000)
						cnty<=cnty+football_power*7;
					else begin
						cnty<=0;
						if(football_y>80)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end
				default:begin
					if(cnty<200000000)
						cnty<=cnty+football_power*5;
					else begin
						cnty<=0;
						if(football_y>160)
							football_y<=football_y-1;
						else begin
							if(goal_keeper_pos==football_dir)begin
								play_win[1]<=1;
								flag_goin<=1;
							end
							else begin
								play_win[1]<=0;
								flag_goout<=1;
							end
							state<=FINISH;
						end
					end					
				end
			endcase																										
		end		
		FINISH:begin
			flag_goin<=0;
			flag_goout<=0;
			key_kick_delay_flag<=0;
			if(play_win==2'b01)
				disp_mode<=1;
			else if(play_win==2'b10)
				disp_mode<=2;
			else
				disp_mode<=3;
			if(key_start==1)begin
				football_power<=1;
				goal_keeper_pos<=3;
				play_win<=0;
				state<=READY1;
				disp_mode<=0;
			end
			else begin
				state<=FINISH;
			end
		end
		endcase						
	end
	
	always@(posedge clock)begin
		if(key_kick_delay_flag==1)
			key_kick_delay<=0;
		else if(key_kick_delay<25000000)begin
			key_kick_delay<=key_kick_delay+1;
			play_x<=300;
			play_y<=180;
		end
		else begin
			key_kick_delay<=key_kick_delay;
			play_x<=240;
			play_y<=240;
		end
	end
	 
	always @ (*) begin
		case (goal_keeper_pos)
			0: begin goal_keeper_x <= 200;goal_keeper_y <= 140;end
			1: begin goal_keeper_x <= 200;goal_keeper_y <= 100;end
			2: begin goal_keeper_x <= 200;goal_keeper_y <= 60;end
			3: begin goal_keeper_x <= 360;goal_keeper_y <= 140;end
			4: begin goal_keeper_x <= 360;goal_keeper_y <= 100;end
			5: begin goal_keeper_x <= 360;goal_keeper_y <= 60;end
			6: begin goal_keeper_x <= 520;goal_keeper_y <= 140;end
			7: begin goal_keeper_x <= 520;goal_keeper_y <= 100;end
			8: begin goal_keeper_x <= 520;goal_keeper_y <= 60;end
			default:begin goal_keeper_x <= 360;goal_keeper_y <= 140;end
		endcase
	end	 

endmodule
