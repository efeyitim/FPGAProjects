module I2C_master
#(parameter CLK_RATIO = 125)
(
	input					i_clk,			//main fpga clock
	input					i_rst,			//active-high async reset
	input					i_enable,		//enable for master
	//
	input 		[6:0]	i_slave_addr,	//i2c address of slave
	input 				i_rw,				//0 is write, 1 is read
	input 		[7:0]	i_wr_byte,		//data to write to slave
	output reg			o_busy,			//indicates master is busy
	output reg 	[7:0] o_rd_byte,		//data read from slave
	output reg			o_ack_error,	//indicates improper ack from slave
	//
	inout					io_scl,			//serial clock output of i2c bus
	inout					io_sda			//serial data output of i2c bus
);

	//W_SCL_EN VE W_SDA_EN'IN NE OLDUGUNU ANLA, INOUTLARI VERIRKEN ASSIGN ILE KULLANDIN, VHDL KODUNA VE NANDLANDE BAKABILIRSIN
	//BU URETTIGIMIZ R_DATA_CLK VE R_SCL_CLK NE ISE YARIYOR ANLA
	//W_STATE_CHANGE'YI BEN NIYE YAZMISTIM HATIRLA ONU GUZELCE YAZ
	//STRETCH NE ISE YARIYOR OGREN, VHDL CLOCK GENERATIONU ANLA
	
	typedef enum logic [3:0] {READY, START, ADDR, SLAVE_ACK1, WRITE, READ, SLAVE_ACK2, MASTER_ACK, STOP} states;
	
	//internal signals
	logic	w_state_change;						//pulsed when bit counter is 0
	
	states 		STATE, NEXT_STATE;					//states
	logic 		r_data_clk;								//data clock for sda
	logic 		r_data_clk_prev;						//data clock from previous system clock
	logic 		r_scl_clk;								//constantly running internal scl
	logic 		r_scl_ena = 1'b0;						//enables internal scl to output
	logic 		r_sda_int = 1'b1;						//internal sda
	logic 		w_sda_ena_n;							//enables internal sda to output
	logic [7:0]	r_addr_rw;								//latched in address and read/write
	logic [7:0] r_data_tx;								//latched in data to write to slave
	logic [7:0] r_data_rx;								//data received from slave
	logic [2:0] r_bit_counter = 3'b111;				//tracks bit number
	logic			r_stretch = 1'b0;						//identifies if slave is stretching scl
	
	logic [9:0] r_clock_counter = 0;					//for clock freq reducing, count until CLK_RATIO
	logic [1:0] r_clock_regions = 0;					//there are 4 clock regions, r_data_clk r_scl_clk 00,10,11,01
	
	assign w_state_change = ~|r_bit_counter;	//when the counter is 0, w_state_change is pulsed
	assign w_sda_ena_n = (STATE == START) ? r_data_clk_prev :
																				(STATE == STOP) ? ~r_data_clk_prev : r_sda_int;
	assign io_scl = (r_scl_ena && ~r_scl_clk) ? 1'b0 : 1'bZ;
	assign io_sda = ~w_sda_ena_n ? 1'b0 : 1'bZ;
	
	always_ff @(posedge i_clk or posedge i_rst)
	begin	: clock_generation
		if (i_rst)
		begin
			r_data_clk <= 1'b0;
			r_scl_clk <= 1'b0;
			r_data_clk_prev <= 1'b0;
			r_stretch <= 1'b0;
		end
		
		else
		begin
			r_data_clk_prev <= r_data_clk;
			
			if (r_clock_regions == 2'b00)
			begin
				r_data_clk <= 1'b0;
				r_scl_clk <= 1'b0;
			end
			
			else if (r_clock_regions == 2'b01)
			begin
				r_data_clk <= 1'b1;
				r_scl_clk <= 1'b0;
			end
			
			else if (r_clock_regions == 2'b10)
			begin
				r_data_clk <= 1'b1;
				r_scl_clk <= 1'b1;
				if (io_scl == 1'b0)
					r_stretch <= 1'b1;
				else
					r_stretch <= 1'b0;
			end

			else
			begin
				r_data_clk <= 1'b0;
				r_scl_clk <= 1'b1;
			end
		end
	end : clock_generation
	
	always_ff @(posedge i_clk or posedge i_rst)
	begin : clock_counter
		if (i_rst)
		begin
			r_clock_counter <= 0;
			r_clock_regions <= 0;
		end
		
		else
		begin
			if (r_clock_counter == CLK_RATIO/4 - 1)
			begin
				r_clock_regions <= r_clock_regions + 2'b01;
				r_clock_counter <= 0;
			end
			else if (r_stretch == 1'b0)
				r_clock_counter <= r_clock_counter + 10'b0000000001;
		end
	end : clock_counter
	
	always_ff @(posedge i_clk)
	begin	: CURRENT_STATE_LOGIC
		STATE <= NEXT_STATE;
	end 	: CURRENT_STATE_LOGIC
	
	always_ff @(posedge i_clk or posedge i_rst)
	begin	: NEXT_STATE_LOGIC
		if (i_rst)
			NEXT_STATE = READY;
			
		else if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
		begin
			case (STATE)
				READY			:	begin
										if (i_enable)
											NEXT_STATE = START;
										else
											NEXT_STATE = READY;
									end
				
				START			:	begin
										NEXT_STATE = ADDR;
									end
				
				ADDR			:	begin
										if (w_state_change)
											NEXT_STATE = SLAVE_ACK1;
										else
											NEXT_STATE = ADDR;
									end
				
				SLAVE_ACK1	:	begin
										if (r_addr_rw[0])
											NEXT_STATE = READ;
										else
											NEXT_STATE = WRITE;
									end
				
				WRITE			:	begin
										if (w_state_change)
											NEXT_STATE = SLAVE_ACK2;
										else
											NEXT_STATE = WRITE;
									end
				
				READ			:	begin
										if (w_state_change)
											NEXT_STATE = MASTER_ACK;
										else
											NEXT_STATE = READ;			
									end
				
				SLAVE_ACK2	:	begin											//slave acknowledge bit (write)
										if (i_enable)
										begin
											if (r_addr_rw == {i_slave_addr, i_rw})
												NEXT_STATE = WRITE;
											else
												NEXT_STATE = START;
										end
										
										else
											NEXT_STATE = START;
									end
				
				MASTER_ACK	:	begin
										if (i_enable)
										begin
											if (r_addr_rw == {i_slave_addr, i_rw})
												NEXT_STATE = READ;
											else
												NEXT_STATE = START;
										end
										
										else
											NEXT_STATE = STOP;		
									end
				
				STOP			:	begin
										NEXT_STATE = READY;
									end
			endcase
		end
		
	end	: NEXT_STATE_LOGIC

	always_ff @(posedge i_clk or posedge i_rst)
	begin	: datapath
		if (i_rst)
		begin
		
		end
			
		else
		begin
			case (STATE)
				READY			:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											if (i_enable)
											begin
												o_busy <= 1'b1;
												r_addr_rw <= {i_slave_addr, i_rw};
												r_data_tx <= i_wr_byte;
											end
											
											else
												o_busy <= 1'b0;
										end		
									end
				
				START			:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											o_busy <= 1'b1;
											r_sda_int <= r_addr_rw[r_bit_counter];
										end
										
										else if (r_data_clk == 1'b0 && r_data_clk_prev == 1'b1)
										begin
											if (r_scl_ena == 1'b0)
											begin
												r_scl_ena <= 1'b1;
												o_ack_error <= 1'b0;
											end
										end
									
									end
				
				ADDR			:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											if (w_state_change)
											begin
												r_sda_int <= 1'b1;
												r_bit_counter <= 3'b111;
											end
											
											else
											begin
												r_bit_counter <= r_bit_counter - 3'b001;
												r_sda_int <= r_addr_rw[r_bit_counter - 1];
											end
										end
									end
				
				SLAVE_ACK1	:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											if (~r_addr_rw[0])	//write
												r_sda_int <= r_data_tx[r_bit_counter];
											else
												r_sda_int <= 1'b1;
										end
										
										else if (r_data_clk == 1'b0 && r_data_clk_prev == 1'b1)
											if (io_sda != 1'b0 || o_ack_error == 1'b1)
												o_ack_error <= 1'b1;
									end
				
				WRITE			:	begin	
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											o_busy <= 1'b1;											//master is busy
											if (w_state_change)										//if all bits are written
											begin
												r_sda_int <= 1'b1;									//release sda for slave ack
												r_bit_counter <= 3'b111;							//reset bit counter
											end
											
											else
											begin
												r_bit_counter <= r_bit_counter - 3'b001;		//decrement bit counter
												r_sda_int <= r_data_tx[r_bit_counter - 1];	//write next bit to bus
											end
										end
									end
				
				READ			:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											o_busy <= 1'b1;														//master is busy										
											if (w_state_change)													//if r_bit_counter == 0
											begin
												r_bit_counter <= 3'b111;										//reset bit counter
												o_rd_byte <= r_data_rx;											//output received byte												
												if (i_enable && r_addr_rw == {i_slave_addr, i_rw})		//continue with another read from the same address
													r_sda_int <= 1'b0;											//ack that the byte is received
												else
													r_sda_int <= 1'b1;											//send a no-ack (before stop or repeated start)											
											end
											
											else
												r_bit_counter <= r_bit_counter - 3'b001;
										end

										
										else if (r_data_clk == 1'b0 && r_data_clk_prev == 1'b1)
											r_data_rx[r_bit_counter] <= io_sda;
									end
				
				SLAVE_ACK2	:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											if (i_enable)
											begin
												o_busy <= 1'b0;
												r_addr_rw <= {i_slave_addr, i_rw};
												r_data_tx <= i_wr_byte;
												if (r_addr_rw == {i_slave_addr, i_rw})
													r_sda_int <= i_wr_byte[r_bit_counter];											
											end
										end
										
										else if (r_data_clk == 1'b0 && r_data_clk_prev == 1'b1)
										begin
											if (io_sda != 1'b0 || o_ack_error == 1'b1)
												o_ack_error <= 1'b1;
										end
									end
				
				MASTER_ACK	:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
										begin
											if (i_enable)
											begin
												o_busy <= 1'b0;
												r_addr_rw <= {i_slave_addr, i_rw};
												r_data_tx <= i_wr_byte;
												if (r_addr_rw == {i_slave_addr, i_rw})
													r_sda_int <= 1'b1;											
											end
										end
									end
				
				STOP			:	begin
										if (r_data_clk == 1'b1 && r_data_clk_prev == 1'b0)
											o_busy <= 1'b0;
										
										else if (r_data_clk == 1'b0 && r_data_clk_prev == 1'b1)
											r_scl_ena <= 1'b0;
									end
			endcase
		end
	end	: datapath
endmodule
