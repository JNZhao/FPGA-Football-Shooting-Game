/*******************************************************************
ģ�����ƣ�ps2_keyboard
ʵ�ֹ��ܣ�PS2������������
********************************************************************/
module keyboard_PS2(
	clock,
	ps2_clk,
	ps2_dat,
	dat_out,
	dat_busy,
	dat_ready);

	input			clock;									//50Mʱ���ź�
	input			ps2_clk;								//PS2�ӿ�ʱ���ź�
	input			ps2_dat;								//PS2�ӿ������ź�
	output	[7:0]	dat_out;								// 1byte��ֵ��ֻ���򵥵İ���ɨ��
	output			dat_busy;
	output			dat_ready;								//���̵�ǰ״̬��ps2_state=1��ʾ�м������� 
	reg	[7:0] 		dat_out;								//�������ݵ���ӦASCII��
	reg				dat_ready;
	//------------------------------------------
	reg				ps2_clk_delay1=0;						//ps2k_clk״̬�Ĵ���
	reg				ps2_clk_delay2=0;
	reg				ps2_clk_delay3=0;	
	wire			ps2_clk_neg;							// ps2k_clk�½��ر�־λ
	
	always @ (posedge clock ) begin							//���ؼ��							
		ps2_clk_delay1 <= ps2_clk;
		ps2_clk_delay2 <= ps2_clk_delay1;
		ps2_clk_delay3 <= ps2_clk_delay2;
	end

	assign ps2_clk_neg = ~ps2_clk_delay2 & ps2_clk_delay3;	//�½���

	//------------------------------------------
	reg	[7:0]	ps2_byte		=0;								//PC��������PS2��һ���ֽ����ݴ洢��
	reg	[7:0]	temp_data		=0;								//��ǰ�������ݼĴ���
	reg	[3:0] 	num				=0;								//�����Ĵ���
	reg 		ps2_state		=1;								//���̵�ǰ״̬��ps2_state_r=1��ʾ�м�������
	reg			ps2_state_delay1=0;								
	reg			ps2_state_delay2=0;
	reg 		key_flag		=0;								//�ɼ���־λ����1��ʾ���յ�����8'hf0���ٽ��յ���һ�����ݺ�����
	
	assign dat_busy=~key_flag;
	
	always@(posedge clock)begin
		ps2_state_delay1<=ps2_state;
		ps2_state_delay2<=ps2_state_delay1;
		dat_ready<=(~ps2_state_delay2) &  ps2_state_delay1;
	end
	
	always @ (posedge clock ) begin
		if(ps2_clk_neg) begin						//��⵽ps2k_clk���½���
			case (num)
				4'd0:	num <= num+1'b1;
				4'd1:	begin
						num <= num+1'b1;
						temp_data[0] <= ps2_dat;	//bit0
						end
				4'd2:	begin
						num <= num+1'b1;
						temp_data[1] <= ps2_dat;	//bit1
						end
				4'd3:	begin
						num <= num+1'b1;
						temp_data[2] <= ps2_dat;	//bit2
						end
				4'd4:	begin
						num <= num+1'b1;
						temp_data[3] <= ps2_dat;	//bit3
						end
				4'd5:	begin
						num <= num+1'b1;
						temp_data[4] <= ps2_dat;	//bit4
						end
				4'd6:	begin
						num <= num+1'b1;
						temp_data[5] <= ps2_dat;	//bit5
						end
				4'd7:	begin
						num <= num+1'b1;
						temp_data[6] <= ps2_dat;	//bit6
						end
				4'd8:	begin
						num <= num+1'b1;
						temp_data[7] <= ps2_dat;	//bit7
						end
				4'd9:	begin
						num <= num+1'b1;			//��żУ��λ����������
						end
				4'd10:  begin
						num <= 4'd0;				// num����
						end
				default:;
			endcase
		end	
	end 

	always @ (posedge clock)begin	//�������ݵ���Ӧ��������ֻ��1byte�ļ�ֵ���д���
		if(num==4'd10 && ps2_clk_neg==1) begin	//�մ�����һ���ֽ�����
			if(temp_data == 8'hf0) 
				key_flag <= 1'b1;
			else begin
				if(!key_flag) begin	//˵���м�����
					ps2_state <= 1'b1;
					ps2_byte <= temp_data;	//���浱ǰ��ֵ
				end
				else begin
					ps2_state <= 1'b0;
					key_flag <= 1'b0;
				end
			end
		end
	end

	always @ (*) begin
		case (ps2_byte)		//��ֵת��ΪASCII�룬�������ıȽϼ򵥣�ֻ������ĸ
			8'h15: dat_out <= 8'h51;	//Q
			8'h1d: dat_out <= 8'h57;	//W
			8'h24: dat_out <= 8'h45;	//E
			8'h2d: dat_out <= 8'h52;	//R
			8'h2c: dat_out <= 8'h54;	//T
			8'h35: dat_out <= 8'h59;	//Y
			8'h3c: dat_out <= 8'h55;	//U
			8'h43: dat_out <= 8'h49;	//I
			8'h44: dat_out <= 8'h4f;	//O
			8'h4d: dat_out <= 8'h50;	//P				  	
			8'h1c: dat_out <= 8'h41;	//A
			8'h1b: dat_out <= 8'h53;	//S
			8'h23: dat_out <= 8'h44;	//D
			8'h2b: dat_out <= 8'h46;	//F
			8'h34: dat_out <= 8'h47;	//G
			8'h33: dat_out <= 8'h48;	//H
			8'h3b: dat_out <= 8'h4a;	//J
			8'h42: dat_out <= 8'h4b;	//K
			8'h4b: dat_out <= 8'h4c;	//L
			8'h1a: dat_out <= 8'h5a;	//Z
			8'h22: dat_out <= 8'h58;	//X
			8'h21: dat_out <= 8'h43;	//C
			8'h2a: dat_out <= 8'h56;	//V
			8'h32: dat_out <= 8'h42;	//B
			8'h31: dat_out <= 8'h4e;	//N
			8'h3a: dat_out <= 8'h4d;	//M
			
			8'h45: dat_out <= 8'h30;	//0		
			8'h16: dat_out <= 8'h31;	//1
			8'h1e: dat_out <= 8'h32;	//2		
			8'h26: dat_out <= 8'h33;	//3
			8'h25: dat_out <= 8'h34;	//4		
			8'h2e: dat_out <= 8'h35;	//5
			8'h36: dat_out <= 8'h36;	//6		
			8'h3d: dat_out <= 8'h37;	//7
			8'h3e: dat_out <= 8'h38;	//8		
			8'h46: dat_out <= 8'h39;	//9

			8'h5a: dat_out <= 8'h13;	//enter
			8'h29: dat_out <= 8'h08;	//backspace		
			8'h66: dat_out <= 8'h27;	//esc
											
			default:dat_out<=8'h00 ;
		endcase
	end	 

endmodule
