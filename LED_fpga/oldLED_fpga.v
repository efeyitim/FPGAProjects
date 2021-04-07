module LED_fpga
#(parameter W = 32)
(
	input clk,
	input button,
	output reg [3:0] LEDs = 4'b1111
);

	//user defined leds are D4, D7, D9, D10
	//D4 = USER_LED_G0, USER_LED_R0 B19 B18
	//D7 = USER_LED_G1, USER_LED_R1 E17 F17
	//D9 = USER_LED_G2, USER_LED_R2 D18 E18
	//D10 = USER_LED_G3, USER_LED_R3 D19 E19
	//The LEDs illuminate when a logic 0 is driven, and turn OFF when a logic 1 is driven.

	
	//user defined buttons are S5, S6, S7
	//S5 = USER_PB2 FPGA PIN NUMBER=B17
	//S6 = USER_PB1 FPGA PIN NUMBER=A19
	//S7 = USER_PB0 FPGA PIN NUMBER=B20
	//When you press and hold down the button, the device pin is set to logic 0. When you release the button, the device pin is set to logic 1.
	
	//CLK_FPGA_50M 50MHZ PIN=BH33
	
	
	reg [W-1:0] count = 0;
	reg button_prev = 1;
	reg flag = 0;
	

	//counter and leds
	always @(posedge clk)
	begin
		if (flag)
		begin
			count <= count + 1'b1;
			if (count == 200000000) //1 second wrt 50mhz
			begin
				LEDs <= LEDs - 1'b1;
				count <= 32'h00000000;
			end
		end
		
		else
		begin
			LEDs <= 4'b1111;
			count <= 32'h00000000;
		end
	
	end
	

	always @(posedge clk)
	begin
		if((button_prev ^ button) && button_prev)
			flag = ~flag;
	end

	
	always @(posedge clk)
	begin
		button_prev <= button;
	end



endmodule