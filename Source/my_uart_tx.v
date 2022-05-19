`timescale 1ns/1ps
module my_uart_tx(
				input 			clk		,//25MHz主时钟
				input 			rst_n	,//低电平复位信号
				input 			clk_bps	,//clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
				input	[7:0] 	rx_data	,//接收数据寄存器
				input 			rx_int	,//接收数据中断信号,接收到数据期间始终为高电平,在该模块中利用它的下降沿来启动串口发送数据
				output 			uart_tx	,// RS232发送数据信号
				output 	reg 	bps_start,//接收或者要发送数据，波特率时钟启动信号置位
				output	reg		byte_end
			);

//---------------------------------------------------------
reg[7:0] tx_data;	//待发送数据的寄存器
reg tx_en;	//发送数据使能信号，高有效
reg[3:0] num;

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) begin
		bps_start <= 1'b0;
		tx_en <= 1'b0;
		tx_data <= 8'd0;
	end
	else if(rx_int) begin	//接收数据完毕，准备把接收到的数据发回去，也就是rx_rdy拉高电平的时候，num==9，开始发送
		bps_start <= 1'b1;
		tx_data <= rx_data;	//把接收到的数据存入发送数据寄存器
		tx_en <= 1'b1;		//进入发送数据状态中
	end
	else if(num == 4'd10) begin	//数据发送完成，复位
		bps_start <= 1'b0;
		tx_en <= 1'b0;
	end

//---------------------------------------------------------
reg uart_tx_r;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		num <= 4'd0;
		uart_tx_r <= 1'b1;
	end
	else if(tx_en) begin
		if(clk_bps)	begin//每一个clk_bps都是一个位
			num <= num+1'b1;
			case (num)
				4'd0: uart_tx_r <= 1'b0; 	//发送起始位
				4'd1: uart_tx_r <= tx_data[0];	//发送bit0
				4'd2: uart_tx_r <= tx_data[1];	//发送bit1
				4'd3: uart_tx_r <= tx_data[2];	//发送bit2
				4'd4: uart_tx_r <= tx_data[3];	//发送bit3
				4'd5: uart_tx_r <= tx_data[4];	//发送bit4
				4'd6: uart_tx_r <= tx_data[5];	//发送bit5
				4'd7: uart_tx_r <= tx_data[6];	//发送bit6
				4'd8: uart_tx_r <= tx_data[7];	//发送bit7
				4'd9: uart_tx_r <= 1'b1;	//发送结束位
			 	default: uart_tx_r <= 1'b1;
			endcase
		end
		else if(num == 4'd10) num <= 4'd0;	//复位
	end

assign uart_tx = uart_tx_r;
always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n) 
			byte_end<=0;
		else if(num==9)
			byte_end<=1;
		else
			byte_end<=0;
	end
endmodule


