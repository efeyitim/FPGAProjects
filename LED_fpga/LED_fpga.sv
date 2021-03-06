module LED_fpga
#(parameter W = 32)
(
	input clk,
	input [4:0] button,
	output logic [9:0] LEDs = 10'b0000000000,
	output logic [2:0] segments =3'b111
);

	//user defined switches
	//SW0 = U13

	typedef enum {IDLE, PRESS, DEBOUNCE} state_t;
	
	state_t STATE, NEXT;

	logic [W-1:0] count = 0;
	logic [31:0] count_max = 32'h000FFFFF;
	logic [W-1:0] debounce_count = 0;
		
	logic button_prev = 1;
	logic debounce_control;
	logic debounce_done = 0;										//is debounce done
	logic debounce_success = 0;									//is debounce successful
	
	logic button_state = 0;											//0 = idle, 1 = PRESS
	
	
	logic button_pulse;
	logic button_press;
	logic button_release;
	assign button_pulse = button[0] ^ button_prev;				//two pulses, at PRESS and at release
	assign button_press = button_pulse & button_prev;		//PRESS pulse
	assign button_release = button_pulse & button[0];			//release pulse
	
	
	//state_reg
	always_ff @(posedge clk)
		STATE <= NEXT;
		
	
	//next_state function
	always_comb
	begin
		unique case (STATE)
			PRESS:		begin
								if (button_pulse)
									NEXT = DEBOUNCE;
								else
									NEXT = PRESS;
							end
						
			DEBOUNCE:	begin
								if (debounce_done)
								begin
									if (debounce_success)
									begin
										if (button_state)
											NEXT = IDLE;
										else
											NEXT = PRESS;
									end
									
									else
									begin
										if (button_state)
											NEXT = PRESS;
										else
											NEXT = IDLE;
									end
										
								end
								
								else
								begin
									NEXT = DEBOUNCE;
								end
							end
							
			IDLE:			begin
								if (button_pulse)
									NEXT = DEBOUNCE;
								else
									NEXT = IDLE;			
							end
							
		endcase
	end
	
	
	//datapath
	always_ff @(posedge clk)
	begin
		unique case (STATE)
			PRESS:		begin
								debounce_control <= 0;
								button_state <= 1;
								segments <= 3'b110;
								debounce_done <= 1'b0;
								count <= count + 1'b1;
								if (count == count_max >> button[4:1]) //1 second wrt 50mhz
								begin
									LEDs <= LEDs + 1'b1;
									count <= 32'h00000000;
								end		
							end
						
			DEBOUNCE:	begin
								segments <= 3'b101;
								debounce_count <= debounce_count + 1'b1;
								if (debounce_count == 32'd1000000) //20 ms wrt 50 mhz //1000000
								begin
									//check if the button is really PRESSed, ..
									//if pressed = debounce_success = 1;
									//else debounce_success = 0;
									//debounce_count = 0 no matter what.								
									if (~debounce_control == button[0])	
										debounce_success <= 1'b1;
									else
										debounce_success <= 1'b0;
									debounce_count <= 32'h00000000;
									debounce_done <= 1'b1;
								end								
							end
							
			IDLE:			begin
								debounce_control <= 1;
								button_state <= 0;
								segments <= 3'b011;
								debounce_done <= 1'b0;
								LEDs <= 10'b0000000000;
								count <= 32'h00000000;			
							end
		endcase
	end
	
	
	always_ff @(posedge clk)
		button_prev <= button[0];
		
	

endmodule