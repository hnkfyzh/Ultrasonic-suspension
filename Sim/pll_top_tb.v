`timescale 1ns/1ps
module pll_top_tb;
	reg					clk				;
	reg					rst_n			;
	wire				clk_out			;
	wire                wav0_0    ;
	wire                wav0_1    ;
	wire                wav0_2    ;
	wire                wav0_3    ;
	wire                wav1_0    ;
	wire                wav1_1    ;
	wire                wav1_2    ;
	wire                wav1_3    ;
	wire                wav2_0    ;
	wire                wav2_1    ;
	wire                wav2_2    ;
	wire                wav2_3    ;
	wire                wav3_0    ;
	wire                wav3_1    ;
	wire                wav3_2    ;
	wire                wav3_3    ;
initial
begin
	clk = 0;
	rst_n=0;
	#100
	rst_n=1;
end
always #10 clk=~clk;
pll_top Upll_top(
	.clk		(clk	),
	.rst_n		(rst_n	),
	.clk_out    (clk_out),
	.wav0_0       (wav0_0) ,
	.wav0_1       (wav0_1) ,
	.wav0_2       (wav0_2) ,
	.wav0_3       (wav0_3) ,
	.wav1_0       (wav1_0) ,
	.wav1_1       (wav1_1) ,
	.wav1_2       (wav1_2) ,
	.wav1_3       (wav1_3) ,
	.wav2_0       (wav2_0) ,
	.wav2_1       (wav2_1) ,
	.wav2_2       (wav2_2) ,
	.wav2_3       (wav2_3) ,
	.wav3_0       (wav3_0) ,
	.wav3_1       (wav3_1) ,
	.wav3_2       (wav3_2) ,
	.wav3_3       (wav3_3) 
	);
	endmodule
