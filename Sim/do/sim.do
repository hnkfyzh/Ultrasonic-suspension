vlib work
vlog	../../Source/pll_top.v     
vlog	../../Source/pwm.v     	
vlog	../../Project/PLL.v  
vlog    ../../Source/my_uart_rx.v  	
vlog    ../../Source/my_uart_tx.v  	
vlog    ../../Source/speed_setting.v 	
vlog	../*.v                     	
vsim -L Altera_lib pll_top_tb 		
set NumericStdNoWarnings 1
set StdArithNoWarnings 1
do wave.do  						
run 50ms 							
stop 								