module my_uart_rx(
				input clk,		// 25MHz��ʱ��
				input rst_n,	//�͵�ƽ��λ�ź�
				input uart_rx,	// RS232���������ź�
				input clk_bps,	// clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м�������
				output reg bps_start,		//���յ����ݺ󣬲�����ʱ�������ź���λ
				output reg[7:0] rx_data,	//�������ݼĴ������ֱ����һ��������� 
				output reg rx_rdy	//����������Ч�ź�,���յ����ݺ����һ��ʱ������
				
			);

//----------------------------------------------------------------
reg uart_rx0,uart_rx1,uart_rx2,uart_rx3;	//�������ݼĴ������˲���
wire neg_uart_rx;	//��ʾ�����߽��յ��½���

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

	//�������½��ؼ��������˵�<40ns-80ns��ë��(����������͵�����ë��)��
	//������������Դ���ȶ���ǰ�������Ƕ�ʱ��Ҫ��������ô��̣���Ϊ�����źŴ��˺ü��ģ� 
	//����Ȼ���ǵ���Ч�������źſ϶���ԶԶ����80ns�ģ�
assign neg_uart_rx = uart_rx3 & uart_rx2 & ~uart_rx1 & ~uart_rx0;	//���յ��½��غ�neg_uart_rx�ø�һ��ʱ������

//----------------------------------------------------------------
reg[3:0] num;	//��λ����
reg rx_int;		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		bps_start <= 1'b0;
		rx_int <= 1'b0;
		rx_rdy <= 1'b0;
	end
	else if(neg_uart_rx) begin		//���յ����ڽ�����uart_rx���½��ر�־�ź�
		bps_start <= 1'b1;	//�����׼�����ݽ���
		rx_int <= 1'b1;			//���������ж��ź�ʹ��
	end
	else if(num == 4'd9) begin		//����������������Ϣ
		bps_start <= 1'b0;	//���ݽ������ϣ��ͷŲ����������ź�
		rx_int <= 1'b0;			//���������ж��źŹر�
		rx_rdy <= 1'b1;
	end
	else rx_rdy <= 1'b0;

//----------------------------------------------------------------
reg[7:0] rx_temp_data;	//��ǰ�������ݼĴ���

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		rx_temp_data <= 8'd0;
		num <= 4'd0;
		rx_data <= 8'd0;
	end
	else if(rx_int) begin	//�������ݴ���
		if(clk_bps) begin	//��ȡ����������,��������Ϊһ����ʼλ��8bit���ݣ�1��2������λ		
			num <= num+1'b1;
			case (num)
				4'd1: rx_temp_data[0] <= uart_rx;	//������0bit
				4'd2: rx_temp_data[1] <= uart_rx;	//������1bit
				4'd3: rx_temp_data[2] <= uart_rx;	//������2bit
				4'd4: rx_temp_data[3] <= uart_rx;	//������3bit
				4'd5: rx_temp_data[4] <= uart_rx;	//������4bit
				4'd6: rx_temp_data[5] <= uart_rx;	//������5bit
				4'd7: rx_temp_data[6] <= uart_rx;	//������6bit
				4'd8: rx_temp_data[7] <= uart_rx;	//������7bit
				default: ;
			endcase
		end
		else if(num == 4'd9) begin		//���ǵı�׼����ģʽ��ֻ��1+8+1(2)=11bit����Ч����
			num <= 4'd0;			//���յ�STOPλ������,num����
			rx_data <= rx_temp_data;	//���������浽���ݼĴ���rx_data��
		end
	end


endmodule
