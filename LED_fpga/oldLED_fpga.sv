module LED_fpga
#(parameter W = 32)
(
	input clk,
	input button,
	output logic [3:0] LEDs = 4'b1111
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
	
	typedef enum {IDLE, PRESS, DEBOUNCE} state_t;
	
	state_t STATE, NEXT;
	
	
	logic [W-1:0] count = 0;
	logic [W-1:0] debounce_count = 0;
	
	logic button_prev = 1;
	logic debounce_success = 0;
	
	logic button_press = 0;
	logic button_release = 0;
	logic button_state = 0;
	
	//counter and leds
	always_ff @(posedge clk)
	begin
		STATE <= NEXT;
	end
	
	always_comb @(button_press or button_release or debounce_success)
	begin
		NEXT = STATE;
		unique case	(STATE)
			IDLE:			if (button_press || button_release) NEXT = DEBOUNCE;
			
			// burda press mi release mi diye de bakmak lazim
			// press + success = state degistir
			// press + failure = state ayni kalsin
			// release + success = state ayni kalsin
			// release + failure = idle'ye donsun??
			DEBOUNCE: 	begin
								if (button_press)
								begin							
									if (debounce_success)
									begin
										if (STATE == IDLE) NEXT = PRESS;
										else if (STATE == PRESS) NEXT = IDLE;
									end
									
									else if (~debounce_success) 
									begin
										if (STATE == IDLE) NEXT = IDLE;
										else if (STATE  == PRESS) NEXT = PRESS;
									end
								end
								
								else if (button_release)
								begin
									if (debounce_success)
									begin
										if (STATE == IDLE) NEXT = IDLE;
										else if (STATE == PRESS) NEXT = PRESS;
									end
									
									else if (~debounce_success) 
									begin
										NEXT = IDLE;
									end
								end
							end
							
			PRESS:		if (button_press || button_release) NEXT = DEBOUNCE;
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		unique case (STATE)
			IDLE:			begin
								LEDs <= 4'b1111;
								count <= 32'h00000000;
							end
						
			PRESS:		begin
								count <= count + 1'b1;
								if (count == 200000000) //1 second wrt 50mhz
								begin
									LEDs <= LEDs - 1'b1;
									count <= 32'h00000000;
								end
							end
						
			DEBOUNCE:	begin
								debounce_count <= debounce_count + 1'b1;
								if (debounce_count == 20000000) //0.1 sec wrt 50 mhz
								begin
									//check if the button is really pressed, ..
									//if pressed = debounce_success = 1;
									//else debounce_success = 0;
									//debounce_count = 0 no matter what.								
									if (button == button_state)
										debounce_success <= 1'b1;
									else
										debounce_success <= 1'b0;
									debounce_count <= 32'h00000000;
								end
							end
		endcase	
	end
	
	//button press
	always_ff @(posedge clk)
	begin
		if((button_prev ^ button) && button_prev)
		begin
			button_press <= 1'b1;
		end
		else if ((button_prev ^ button) && button)
		begin
			button_release <= 1'b1;
			button_state <= button;
		end
		else 	
		begin
			button_press <= 1'b0;
			button_release <= 1'b0;
		end
	end

	
	always_ff @(posedge clk)
	begin
		button_prev <= button;
	end
	
endmodule