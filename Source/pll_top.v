module pll_top(
	 input	    clk       ,
	 input	    rst_n     ,
	 input       uart_rx   ,
	 output	    clk_out   ,
	 output      uart_tx   ,
	 output      wav0_0    ,
	 output      wav0_1    ,
	 output      wav0_2    ,
	 output      wav0_3    ,
	 output      wav0_4    ,
	 output      wav0_5    ,
	 output      wav0_6    ,
	 output      wav0_7    ,
	 output      wav1_0    ,
	 output      wav1_1    ,
	 output      wav1_2    ,
	 output      wav1_3    ,
	 output      wav1_4    ,
	 output      wav1_5    ,
	 output      wav1_6    ,
	 output      wav1_7    ,
	 output      wav2_0    ,
	 output      wav2_1    ,
	 output      wav2_2    ,
	 output      wav2_3    ,
	 output      wav2_4    ,
	 output      wav2_5    ,
	 output      wav2_6    ,
	 output      wav2_7    ,
	 output      wav3_0    ,
	 output      wav3_1    ,
	 output      wav3_2    ,
	 output      wav3_3    ,
	 output      wav3_4    ,
	 output      wav3_5    ,
	 output      wav3_6    ,
	 output      wav3_7    ,
	 output      wav4_0    ,
	 output      wav4_1    ,
	 output      wav4_2    ,
	 output      wav4_3    ,
	 output      wav4_4    ,
	 output      wav4_5    ,
	 output      wav4_6    ,
	 output      wav4_7    ,
	 output      wav5_0    ,
	 output      wav5_1    ,
	 output      wav5_2    ,
	 output      wav5_3    ,
	 output      wav5_4    ,
	 output      wav5_5    ,
	 output      wav5_6    ,
	 output      wav5_7    ,
	 output      wav6_0    ,
	 output      wav6_1    ,
	 output      wav6_2    ,
	 output      wav6_3    ,
	 output      wav6_4    ,
	 output      wav6_5    ,
	 output      wav6_6    ,
	 output      wav6_7    ,
	 output      wav7_0    ,
	 output      wav7_1    ,
	 output      wav7_2    ,
	 output      wav7_3    ,
	 output      wav7_4    ,
	 output      wav7_5    ,
	 output      wav7_6    ,
	 output      wav7_7    ,
	 output  reg led_1     ,
    output  reg led_2     	 
	 
	 );
	 reg [9:0]   rom_addr[7:0][7:0];//循环读取地址0~1023
	 reg [9:0]   addr[7:0][7:0]  ;
	 reg [9:0]   delay ;//延时调节相位，数据由上位机通信发给FPGA，0~1023表示0~360度，但串口发送的延时数据只能到255，相位分辨率为360/255
	 reg   switch[4:0][4:0];//表示开启的左上角的那一个换能器
    wire  rom_data[7:0][7:0];//从相应地址位置读出的数据（波形）
	 reg  wav[7:0][7:0];
	 wire  clk_bps1;
	 wire  clk_bps2;
    wire  [7:0] rxd_data;
	 reg   [7:0] databag[4:0];
	 reg   [3:0] datanum = 0;
	 wire  rxd_data_rdy;

assign wav0_0=wav[0][0]     ;//将波形输出与数据连接
assign wav0_1=wav[0][1]     ; 
assign wav0_2=wav[0][2]     ;
assign wav0_3=wav[0][3]     ;
assign wav0_4=wav[0][4]     ;//将波形输出与数据连接
assign wav0_5=wav[0][5]     ; 
assign wav0_6=wav[0][6]     ;
assign wav0_7=wav[0][7]     ;
assign wav1_0=wav[1][0]     ;
assign wav1_1=wav[1][1]     ;
assign wav1_2=wav[1][2]     ;
assign wav1_3=wav[1][3]     ;
assign wav1_4=wav[1][4]     ;
assign wav1_5=wav[1][5]     ;
assign wav1_6=wav[1][6]     ; 
assign wav1_7=wav[1][7]     ;
assign wav2_0=wav[2][0]     ;
assign wav2_1=wav[2][1]     ;
assign wav2_2=wav[2][2]     ;
assign wav2_3=wav[2][3]     ;
assign wav2_4=wav[2][4]     ;
assign wav2_5=wav[2][5]     ;
assign wav2_6=wav[2][6]     ;
assign wav2_7=wav[2][7]     ;
assign wav3_0=wav[3][0]     ;
assign wav3_1=wav[3][1]     ;
assign wav3_2=wav[3][2]     ;
assign wav3_3=wav[3][3]     ;
assign wav3_4=wav[3][4]     ;
assign wav3_5=wav[3][5]     ;
assign wav3_6=wav[3][6]     ;
assign wav3_7=wav[3][7]     ;
assign wav4_0=wav[4][0]     ;
assign wav4_1=wav[4][1]     ;
assign wav4_2=wav[4][2]     ;
assign wav4_3=wav[4][3]     ;
assign wav4_4=wav[4][4]     ;
assign wav4_5=wav[4][5]     ;
assign wav4_6=wav[4][6]     ;
assign wav4_7=wav[4][7]     ;
assign wav5_0=wav[5][0]     ;
assign wav5_1=wav[5][1]     ;
assign wav5_2=wav[5][2]     ;
assign wav5_3=wav[5][3]     ;
assign wav5_4=wav[5][4]     ;
assign wav5_5=wav[5][5]     ;
assign wav5_6=wav[5][6]     ;
assign wav5_7=wav[5][7]     ;
assign wav6_0=wav[6][0]     ;
assign wav6_1=wav[6][1]     ;
assign wav6_2=wav[6][2]     ;
assign wav6_3=wav[6][3]     ;
assign wav6_4=wav[6][4]     ;
assign wav6_5=wav[6][5]     ;
assign wav6_6=wav[6][6]     ;
assign wav6_7=wav[6][7]     ;
assign wav7_0=wav[7][0]     ;
assign wav7_1=wav[7][1]     ;
assign wav7_2=wav[7][2]     ;
assign wav7_3=wav[7][3]     ;
assign wav7_4=wav[7][4]     ;
assign wav7_5=wav[7][5]     ;
assign wav7_6=wav[7][6]     ;
assign wav7_7=wav[7][7]     ;


integer      i ;
integer      j ;
integer      m ;
integer      n ;
integer      q ;
integer      p ;
reg [3:0] direction_x;
reg [3:0] direction_y;
initial begin
 for(m=0; m<=7; m=m+1) 
    begin
	      for(n=0; n<=7; n=n+1)
			   begin
				  rom_addr[m][n] = 0;
				  addr[m][n] = 0 ;
				end
			led_1 = 1;
			led_2 = 0;
	 end
 for(m=0; m<=4; m=m+1)
    begin
    for(n=0; n<=4; n=n+1)  
	  switch[m][n] = 0;	
	 end 
 direction_x = 2;
 direction_y = 2;
 delay = 0 ;
 switch[direction_x][direction_y] = 1;
end
//初始化，所有置零

always @(negedge clk_out)
begin

     for(q=0; q<=7; q=q+1) begin
	      for(p=0; p<=7; p=p+1)
			   begin
				rom_addr[q][p] = addr[q][p] + delay;
				addr[q][p] = addr[q][p] + 1'b1;
				end
	  end
	 
end //本循环程序的作用是扫描所有波形输出口，将延时加进去

always @(negedge clk_out)
begin
 for(m=0; m<=4; m=m+1)
    begin
	      for(n=0; n<=4; n=n+1)
			   begin
              if(switch[m][n] == 1)
				  begin
				    for(i=m;i<=m+3;i=i+1)
					   begin
						  for(j=n;j<=n+3;j=j+1)
						    begin
							  wav[i][j] = rom_data[i][j];  //打开switch之后的4x4换能器
							 end
						end 
						for(i=0;i<m;i=i+1)  //后面四个for循环为把除打开的换能器全部不给PWM波
					   begin
						  for(j=0;j<8;j=j+1)
						    begin
							  wav[i][j] = 0;  
							 end
						end 
					   for(i=m+4;i<8;i=i+1)
					   begin
						  for(j=0;j<8;j=j+1)
						    begin
							  wav[i][j] = 0;  
							 end
						end
					   for(j=0;j<n;j=j+1)
					   begin
						  for(i=0;i<8;i=i+1)
						    begin
							  wav[i][j] = 0;  
							 end
						end 
					   for(j=n+4;j<8;j=j+1)
					   begin
						  for(i=0;i<8;i=i+1)
						    begin
							  wav[i][j] = 0;  
							 end
						end 
				  end
				end
    end 
end //本循环程序的作用是扫描所有小物体能在的地方，找到那个为1地址，把它之后的4x4换能器全换成开启状态,其它的都变成关闭状态

always @(negedge clk_out)
begin


end



PLL UPLL(
    .areset	   (1'b0)      ,
	 .inclk0	   (clk)       ,
	 .c0		   (clk_out)   ,
	 .locked    ()
	 );//锁相环倍频
	
//后面所有的程序都是从ROM中读取输出数据
pwm Uwav0_0 (
    .clock	   (clk_out)      , 
    .address   (rom_addr[0][0])  ,
    .q		   (rom_data[0][0]) 
);

pwm Uwav0_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[0][1])  ,
    .q		   (rom_data[0][1]) 
);

pwm Uwav0_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[0][2])  ,
    .q		   (rom_data[0][2]) 
);
pwm Uwav0_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[0][3])  ,
    .q		   (rom_data[0][3]) 
);
pwm Uwav0_4 (
    .clock	   (clk_out)      , 
    .address   (rom_addr[0][4])  ,
    .q		   (rom_data[0][4]) 
);

pwm Uwav0_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[0][5])  ,
    .q		   (rom_data[0][5]) 
);

pwm Uwav0_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[0][6])  ,
    .q		   (rom_data[0][6]) 
);
pwm Uwav0_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[0][7])  ,
    .q		   (rom_data[0][7]) 
);

pwm Uwav1_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][0])  ,
    .q		   (rom_data[1][0]) 
);
pwm Uwav1_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][1])  ,
    .q		   (rom_data[1][1]) 
);
pwm Uwav1_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][2])  ,
    .q		   (rom_data[1][2]) 
);
pwm Uwav1_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][3])  ,
    .q		   (rom_data[1][3]) 
);
pwm Uwav1_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][4])  ,
    .q		   (rom_data[1][4]) 
);
pwm Uwav1_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][5])  ,
    .q		   (rom_data[1][5]) 
);
pwm Uwav1_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][6])  ,
    .q		   (rom_data[1][6]) 
);
pwm Uwav1_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[1][7])  ,
    .q		   (rom_data[1][7]) 
);
pwm Uwav2_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][0])  ,
    .q		   (rom_data[2][0]) 
);
pwm Uwav2_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][1])  ,
    .q		   (rom_data[2][1]) 
);
pwm Uwav2_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][2])  ,
    .q		   (rom_data[2][2]) 
);
pwm Uwav2_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][3])  ,
    .q		   (rom_data[2][3]) 
);
pwm Uwav2_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][4])  ,
    .q		   (rom_data[2][4]) 
);
pwm Uwav2_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][5])  ,
    .q		   (rom_data[2][5]) 
);
pwm Uwav2_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][6])  ,
    .q		   (rom_data[2][6]) 
);
pwm Uwav2_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[2][7])  ,
    .q		   (rom_data[2][7]) 
);
pwm Uwav3_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][0])  ,
    .q		   (rom_data[3][0]) 
);
pwm Uwav3_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][1])  ,
    .q		   (rom_data[3][1]) 
);
pwm Uwav3_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][2])  ,
    .q		   (rom_data[3][2]) 
);
pwm Uwav3_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][3])  ,
    .q		   (rom_data[3][3]) 
);

pwm Uwav3_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][4])  ,
    .q		   (rom_data[3][4]) 
);
pwm Uwav3_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][5])  ,
    .q		   (rom_data[3][5]) 
);
pwm Uwav3_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][6])  ,
    .q		   (rom_data[3][6]) 
);
pwm Uwav3_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[3][7])  ,
    .q		   (rom_data[3][7]) 
);
pwm Uwav4_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][0])  ,
    .q		   (rom_data[4][0]) 
);
pwm Uwav4_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][1])  ,
    .q		   (rom_data[4][1]) 
);
pwm Uwav4_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][2])  ,
    .q		   (rom_data[4][2]) 
);
pwm Uwav4_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][3])  ,
    .q		   (rom_data[4][3]) 
);

pwm Uwav4_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][4])  ,
    .q		   (rom_data[4][4]) 
);
pwm Uwav4_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][5])  ,
    .q		   (rom_data[4][5]) 
);
pwm Uwav4_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][6])  ,
    .q		   (rom_data[4][6]) 
);
pwm Uwav4_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[4][7])  ,
    .q		   (rom_data[4][7]) 
);
pwm Uwav5_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][0])  ,
    .q		   (rom_data[5][0]) 
);
pwm Uwav5_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][1])  ,
    .q		   (rom_data[5][1]) 
);
pwm Uwav5_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][2])  ,
    .q		   (rom_data[5][2]) 
);
pwm Uwav5_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][3])  ,
    .q		   (rom_data[5][3]) 
);

pwm Uwav5_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][4])  ,
    .q		   (rom_data[5][4]) 
);
pwm Uwav5_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][5])  ,
    .q		   (rom_data[5][5]) 
);
pwm Uwav5_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][6])  ,
    .q		   (rom_data[5][6]) 
);
pwm Uwav5_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[5][7])  ,
    .q		   (rom_data[5][7]) 
);
pwm Uwav6_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][0])  ,
    .q		   (rom_data[6][0]) 
);
pwm Uwav6_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][1])  ,
    .q		   (rom_data[6][1]) 
);
pwm Uwav6_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][2])  ,
    .q		   (rom_data[6][2]) 
);
pwm Uwav6_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][3])  ,
    .q		   (rom_data[6][3]) 
);

pwm Uwav6_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][4])  ,
    .q		   (rom_data[6][4]) 
);
pwm Uwav6_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][5])  ,
    .q		   (rom_data[6][5]) 
);
pwm Uwav6_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][6])  ,
    .q		   (rom_data[6][6]) 
);
pwm Uwav6_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[6][7])  ,
    .q		   (rom_data[6][7]) 
);
pwm Uwav7_0 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][0])  ,
    .q		   (rom_data[7][0]) 
);
pwm Uwav7_1 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][1])  ,
    .q		   (rom_data[7][1]) 
);
pwm Uwav7_2 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][2])  ,
    .q		   (rom_data[7][2]) 
);
pwm Uwav7_3 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][3])  ,
    .q		   (rom_data[7][3]) 
);

pwm Uwav7_4 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][4])  ,
    .q		   (rom_data[7][4]) 
);
pwm Uwav7_5 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][5])  ,
    .q		   (rom_data[7][5]) 
);
pwm Uwav7_6 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][6])  ,
    .q		   (rom_data[7][6]) 
);
pwm Uwav7_7 (
    .clock	   (clk_out)      ,
    .address	(rom_addr[7][7])  ,
    .q		   (rom_data[7][7]) 
);

speed_setting	Uspeed_rx(	
	.clk		(clk		),	//波特率选择模块
	.rst_n		(rst_n	),
	.bps_start	(bps_start1	),
	.clk_bps	(clk_bps1	)
		);
//UART接收数据处理
my_uart_rx	Umy_uart_rx(		
	.clk		(clk		),	//接收数据模块
	.rst_n		(rst_n	),
	.uart_rx	(uart_rx	),
	.rx_data	(rxd_data		),
	.rx_rdy		(rxd_data_rdy		),
	.clk_bps	(clk_bps1	),
	.bps_start	(bps_start1	)
		);	
		
speed_setting	Uspeed_tx(	
	.clk		(clk		),	//波特率选择模块
	.rst_n		(rst_n	),
	.bps_start	(bps_start2	),
	.clk_bps	(clk_bps2	)
		);
		
my_uart_tx Umy_uart_tx(
	.clk		(clk			),//25MHz主时钟
	.rst_n		(rst_n			),//低电平复位信号
	.clk_bps	(clk_bps2		),//clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
	.rx_data	(rxd_data		),//接收数据寄存器
	.rx_int		(rxd_data_rdy	),//接收数据中断信号,接收到数据期间始终为高电平,在该模块中利用它的下降沿来启动串口发送数据
	.uart_tx	(uart_tx		),// RS232发送数据信号
	.bps_start	(bps_start2		),//接收或者要发送数据，波特率时钟启动信号置位
	.byte_end   (				)
			);
	
	
reg [7:0] direction;//8'h41对应字母‘A’向左移动，8'h44对应字母‘D’向左移动，8'h57对应字母‘W’向前移动，8'h53对应字母‘S’向后移动
integer e,f;
always@(posedge rxd_data_rdy)//表示已经接收到了一个数据，触发信号，必须要保证上一个数据接收并运行完之后，下一个数据才过来
begin
 if(rxd_data == 8'hff && datanum == 0)//开始标志
 begin
     databag[0] <= rxd_data;
	  led_1 <= 0;
	  datanum <= datanum + 1;  
 end
 
 else if(datanum == 1)//向左/向右/向前/向后/不移动
 begin
     databag[1] <= rxd_data;
	  datanum <= datanum + 1;
 end
 
 else if(datanum == 2)//延迟相位
 begin 
     databag[2] <= rxd_data;
	  datanum <= datanum + 1;
 end
 
 else if(rxd_data == 8'h3c && datanum == 3)//结束标志
 begin
     databag[3] <= rxd_data;
     if(databag[1] == 8'h41)    direction_x = direction_x - 1; //左
	  if(databag[1] == 8'h44)    direction_x = direction_x + 1; //右
	  if(databag[1] == 8'h53)    direction_y = direction_y + 1; //后
	  if(databag[1] == 8'h57)    direction_y = direction_y - 1; //前
	  switch[direction_x][direction_y] = 1;//左上换能器
	  for(e=0;e<=4;e=e+1)
	  begin
	     for(f=0;f<=4;f=f+1)
		  begin
		     if(e!=direction_x || f!=direction_y) switch[e][f] = 0;//其它的switch都置0，为的是只让有一个为1
		  end
	  end
	  delay <= 4*databag[2];//因为一个字节十六进制数只能表示到255，而设计的相位分辨是1024
	  datanum <= 0;
	  led_1 <= 1;
 end
 else 
 begin
     datanum <= 0;
     led_1 <= 1;
 end
 

end
endmodule
