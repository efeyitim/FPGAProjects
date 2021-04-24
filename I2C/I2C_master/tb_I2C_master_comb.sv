module tb_I2C_master_comb();
	logic				i_clk;			//main fpga clock
	logic				i_rst;			//active-high async reset
	logic				i_enable;		//enable for master
	//
	logic 	[6:0]	i_slave_addr;	//i2c address of slave
	logic 			i_rw;				//0 is write, 1 is read
	logic 	[7:0]	i_wr_byte;		//data to write to slave
	logic				o_busy;			//indicates master is busy
	logic		[7:0] o_rd_byte;		//data read from slave
	logic				o_ack_error;	//indicates improper ack from slave
	//
	wire				io_scl;			//serial clock output of i2c bus
	wire				io_sda;			//serial data output of i2c bus
	reg				output_value_valid;
	reg 				output_value;
	
	assign io_sda = (output_value_valid) ? output_value : 1'bz;
	
	localparam CLK_RATIO = 125;
	I2C_master_comb #(.CLK_RATIO(CLK_RATIO)) dut (.*);

	localparam input_clk_period = 20;
	localparam i2c_clk_period = input_clk_period * CLK_RATIO + 80;
	always
	begin
		i_clk = 1'b0; #(input_clk_period/2); i_clk = 1'b1; #(input_clk_period/2);	//50mhz clock
	end
	
	initial begin
		i_rst = 1'b1;
		#(5*input_clk_period);
		output_value_valid = 1'b1;
		i_rst = 1'b0;
		i_slave_addr = 7'b0000111;
		i_rw = 1'b1;
		i_enable = 1'b1;
		#(9*i2c_clk_period);
		$stop;
		
	
	
	end
endmodule
