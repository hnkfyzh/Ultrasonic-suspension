module my_uart_rx(
				input clk,		// 25MHz主时钟
				input rst_n,	//低电平复位信号
				input uart_rx,	// RS232接收数据信号
				input clk_bps,	// clk_bps的高电平为接收或者发送数据位的中间采样点
				output reg bps_start,		//接收到数据后，波特率时钟启动信号置位
				output reg[7:0] rx_data,	//接收数据寄存器，保存直至下一个数据来到 
				output reg rx_rdy	//接收数据有效信号,接收到数据后拉高一个时钟周期
			);

//----------------------------------------------------------------
reg uart_rx0,uart_rx1,uart_rx2,uart_rx3;	//接收数据寄存器，滤波用
wire neg_uart_rx;	//表示数据线接收到下降沿

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) begin
		uart_rx0 <= 1'b0;
		uart_rx1 <= 1'b0;
		uart_rx2 <= 1'b0;
		uart_rx3 <= 1'b0;
	end
	else begin
		uart_rx0 <= uart_rx;
		uart_rx1 <= uart_rx0;
		uart_rx2 <= uart_rx1;
		uart_rx3 <= uart_rx2;
	end

	//下面的下降沿检测可以滤掉<40ns-80ns的毛刺(包括高脉冲和低脉冲毛刺)，
	//这里就是用资源换稳定（前提是我们对时间要求不是那么苛刻，因为输入信号打了好几拍） 
	//（当然我们的有效低脉冲信号肯定是远远大于80ns的）
assign neg_uart_rx = uart_rx3 & uart_rx2 & ~uart_rx1 & ~uart_rx0;	//接收到下降沿后neg_uart_rx置高一个时钟周期

//----------------------------------------------------------------
reg[3:0] num;	//移位次数
reg rx_int;		//接收数据中断信号,接收到数据期间始终为高电平

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		bps_start <= 1'b0;
		rx_int <= 1'b0;
		rx_rdy <= 1'b0;
	end
	else if(neg_uart_rx) begin		//接收到串口接收线uart_rx的下降沿标志信号
		bps_start <= 1'b1;	//启动串口准备数据接收
		rx_int <= 1'b1;			//接收数据中断信号使能
	end
	else if(num == 4'd9) begin		//接收完有用数据信息
		bps_start <= 1'b0;	//数据接收完毕，释放波特率启动信号
		rx_int <= 1'b0;			//接收数据中断信号关闭
		rx_rdy <= 1'b1;
	end
	else rx_rdy <= 1'b0;

//----------------------------------------------------------------
reg[7:0] rx_temp_data;	//当前接收数据寄存器

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		rx_temp_data <= 8'd0;
		num <= 4'd0;
		rx_data <= 8'd0;
	end
	else if(rx_int) begin	//接收数据处理
		if(clk_bps) begin	//读取并保存数据,接收数据为一个起始位，8bit数据，1或2个结束位		
			num <= num+1'b1;
			case (num)
				4'd1: rx_temp_data[0] <= uart_rx;	//锁存第0bit
				4'd2: rx_temp_data[1] <= uart_rx;	//锁存第1bit
				4'd3: rx_temp_data[2] <= uart_rx;	//锁存第2bit
				4'd4: rx_temp_data[3] <= uart_rx;	//锁存第3bit
				4'd5: rx_temp_data[4] <= uart_rx;	//锁存第4bit
				4'd6: rx_temp_data[5] <= uart_rx;	//锁存第5bit
				4'd7: rx_temp_data[6] <= uart_rx;	//锁存第6bit
				4'd8: rx_temp_data[7] <= uart_rx;	//锁存第7bit
				default: ;
			endcase
		end
		else if(num == 4'd9) begin		//我们的标准接收模式下只有1+8+1(2)=11bit的有效数据
			num <= 4'd0;			//接收到STOP位后结束,num清零
			rx_data <= rx_temp_data;	//把数据锁存到数据寄存器rx_data中
		end
	end


endmodule
