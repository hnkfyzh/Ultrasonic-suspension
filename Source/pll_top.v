module pll_top(
	 input	    clk       ,
	 input	    rst_n     ,
	 input       uart_rx   ,
	 output	    clk_out   ,
	 output      wav0_0    ,
	 output      wav0_1    ,
	 output      wav0_2    ,
	 output      wav0_3    ,
	 output      wav1_0    ,
	 output      wav1_1    ,
	 output      wav1_2    ,
	 output      wav1_3    ,
	 output      wav2_0    ,
	 output      wav2_1    ,
	 output      wav2_2    ,
	 output      wav2_3    ,
	 output      wav3_0    ,
	 output      wav3_1    ,
	 output      wav3_2    ,
	 output      wav3_3    ,
	 output   reg led      
	 
	 );
	 reg [9:0]   rom_addr[7:0][7:0];//循环读取地址0~1023
	 reg [9:0]   addr[7:0][7:0]  ;
	 reg [9:0]   delay ;//延时调节相位，数据由上位机通信发给FPGA，0~1023表示0~360度 
	 reg   switch[4:0][4:0];//表示控制物体在哪一个位置，这个位置是1，其它都是0
    wire  rom_data[7:0][7:0];//从相应地址位置读出的数据（波形）
	 reg  wav[7:0][7:0];
	 wire  clk_bps1;
    wire  [7:0] rxd_data;
	 reg   [7:0] databag[4:0];
	 reg   [3:0] datanum = 0;
	 wire  rxd_data_rdy;

assign wav0_0=wav[0][0]     ;//将波形输出与数据连接
assign wav0_1=wav[0][1]     ; 
assign wav0_2=wav[0][2]     ;
assign wav0_3=wav[0][3]     ;
assign wav1_0=wav[1][0]    ;
assign wav1_1=wav[1][1]     ;
assign wav1_2=wav[1][2]    ;
assign wav1_3=wav[1][3]     ;
assign wav2_0=wav[2][0]     ;
assign wav2_1=wav[2][1]     ;
assign wav2_2=wav[2][2]     ;
assign wav2_3=wav[2][3]    ;
assign wav3_0=wav[3][0]    ;
assign wav3_1=wav[3][1]     ;
assign wav3_2=wav[3][2]     ;
assign wav3_3=wav[3][3]    ;

integer      i ;
integer      j ;
integer      m ;
integer      n ;
integer      q ;
integer      p ;
reg [3:0] direction_x;
reg [3:0] direction_y;
initial begin
 for(m=0; m<=3; m=m+1) 
    begin
	      for(n=0; n<=3; n=n+1)
			   begin
				  rom_addr[m][n] = 0;
				  delay = 0 ;
				  addr[m][n] = 0 ;
				end
			led = 1;
	 end
 for(m=0; m<=4; m=m+1)
    begin
    for(n=0; n<=4; n=n+1)  
	  switch[m][n] = 0;	
	 end 
 direction_x = 3;
 direction_y = 3;
 switch[direction_x][direction_y] = 1;
end


always @(negedge clk_out)
begin

     for(q=0; q<=3; q=q+1) begin
	      for(p=0; p<=3; p=p+1)
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
							  wav[i][j] = rom_data[i][j];  
							 end
						end 
					 for(i=0;i<m;i=i+1)
					   begin
						  for(j=0;j<n;j=j+1)
						    begin
							  wav[i][j] = 0;  
							 end
						end 
					 for(i=m+4;i<=7;i=i+1)
					   begin
						  for(j=n+4;j<=7;j=j+1)
						    begin
							  wav[i][j] = 0;  
							 end
						end 
				  end
				end
    end 
end //本循环程序的作用是扫描所有小物体能在的地方，找到那个为1地址，把它对应的周围换能器全换成开启状态,其它的都变成关闭状态

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

speed_setting	Uspeed_rx(	
	.clk		(clk		),	//������ѡ��ģ��
	.rst_n		(rst_n	),
	.bps_start	(bps_start1	),
	.clk_bps	(clk_bps1	)
		);
//UART�������ݴ���
my_uart_rx	Umy_uart_rx(		
	.clk		(clk		),	//��������ģ��
	.rst_n		(rst_n	),
	.uart_rx	(uart_rx	),
	.rx_data	(rxd_data		),
	.rx_rdy		(rxd_data_rdy		),
	.clk_bps	(clk_bps1	),
	.bps_start	(bps_start1	)
    );
	 

reg [7:0] direction;//8'h41对应字母‘A’向左移动，8'h44对应字母‘D’向左移动，8'h57对应字母‘W’向前移动，8'h53对应字母‘S’向后移动
integer e,f;
always@(posedge rxd_data_rdy)//表示已经接收到了一个数据，触发信号
begin
 if(rxd_data == 8'hff && datanum == 0)//开始标志
 begin
     databag[0] = rxd_data;
	  led = 0;
	  datanum = datanum + 1;  
 end
 
 else if(datanum == 1)//向左/向右移动
 begin
     databag[1] = rxd_data;
	  datanum = datanum + 1;
 end
 
 else if(datanum == 2)//延迟相位
 begin 
     databag[2] = rxd_data;
	  datanum = datanum + 1;
 end
 
 else if(rxd_data == 8'h3c && datanum == 3)//结束标志
 begin
     databag[3] = rxd_data;
     if(databag[1] == 8'h41)    direction_x = direction_x - 1; 
	  if(databag[1] == 8'h44)    direction_x = direction_x + 1; 
	  if(databag[1] == 8'h57)    direction_y = direction_y + 1; 
	  if(databag[1] == 8'h53)    direction_y = direction_y - 1; 
	  switch[direction_x][direction_y] = 1;
	  for(e=0;e<=4;e=e+1)
	  begin
	     for(f=0;f<=4;f=f+1)
		  begin
		     if(e!=direction_x || f!=direction_y) switch[e][f] = 0;
		  end
	  end
	  delay = 4*databag[2];
	  datanum = 0;
 end
 else 
 begin
     datanum = 0;
     led = 1;
 end
 

end
endmodule
