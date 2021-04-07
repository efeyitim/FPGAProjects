module tb #(parameter W = 32) ();

	logic clk;
	logic [4:0] button;
	logic [9:0] LEDs;
	logic [2:0] segments;

	
	LED_fpga dut(.*);
	
	always begin
		clk = 1; #10; clk = 0; #10;	//50 mhz
	end
	

	initial begin
		button = 1;
		#100;
		repeat(99)
		begin
			button = ~button; #50;	//button press
		end
		#1500000;
		repeat(99)
		begin
			button = ~button; #50;	//button release
		end
		#1000000;
		
		#5000000;
		
		repeat(99)
		begin
			button = ~button; #50;	//button press
		end
		#1500000;
		repeat(99)
		begin
			button = ~button; #50;	//button release
		end
		#1000000;
		
		$stop();
	end

endmodule