module LED
(
	input clk,
	input button,	//u7
	input reset,	//w9
	input speed,	//m7
	//input [3:0] switch,
	output reg [9:0] out
);

	reg button_prev = 1;
	reg button_state = 0;
	wire button_edge;
	reg [31:0] count = 0;
	reg [31:0] count_max = 32'h000FFFFF;
	always @(posedge clk)
	begin
		if (~reset)
		begin
			count <= 32'h00000000;
			out <= 10'b0000000000;
		end
		else
		begin
			if(speed)
			begin
				if (button_state)
				begin
					if (count < count_max)
						count <= count + 1'b1;
					else
					begin
						count <= 32'h00000000;
						out <= out + 1'b1;
					end
				end
			end
			else
			begin
				if (button_state)
				begin
					if (count < count_max >> 2)
						count <= count + 1'b1;
					else
					begin
						count <= 32'h00000000;
						out <= out + 1'b1;
					end
				end
			end
		end
	end
	
	always @(posedge clk)
	begin
		button_prev <= button;
	end
	
	assign button_edge = (button ^ button_prev) & button_prev;
	
	always @ (posedge clk)
	begin
		if (~reset)
			button_state <= 1'b1;
		else if (button_edge)
			button_state = ~button_state;
	end
	
	/*
	always @(posedge clk)
	begin
		count_max <= count_max >> switch;
	end
	*/
endmodule