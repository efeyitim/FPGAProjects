module I2C_master
(
	input 			clk,				//system clock
	input 			reset_n,			//active low reset
	input 			enable,			//determines how many bytes consequently written/read
	input 	[6:0] addr,				//address of the slave
	input 			rw,				//0 is write, 1 is read
	input		[7:0] data_wr,
	output			busy,				//indicates master is busy
	output 	[7:0]	data_rd,			//data read from slave
	output			ack_error,		//indicates improper ack from slave
	inout 			SDA,				//serial data output of i2c bus
	inout 			SCL				//serial clock output of i2c bus
);

	//SDA HEP DAHA ONCE HAREKET EDIYOR
	
	//STOP ETMEDEN TEKRAR TRANSACTION YAPABILIYOR MUYUM DATASHEETE BAK
	
	//REGISTER ADRESLERINE BAK
	
	//VHDL'de 1 yapmak yerine pullup ile yapmak icin H veriyor. Bunun verilog karsiligi nedir? TESTBENCH ICIN DIYOR
	//TB ICIN SLAVE'I SIMULE EDIYOSUN MASTERI DEGIL
	//TB ICIN CLOCKLARI DEGISTIRMIS, DAHA YAVAS YAPMIS, DIGER TURLU COK ZOR OLUYOR BILDIGIN UZERE, SIMULASYON COK UZUN SURUYOR
	//ifdef ile yap bunu
	
	//hatti surmemen gerektigi yerde z'ye esitlemek zorundasin
	
	parameter input_clock_freq = 50000000; //50MHz
	parameter i2c_clock_freq = 400000; 		//400kHz
	parameter clock_divide = input_clock_freq / i2c_clock_freq;
	
	typedef enum {READY, START, DEVADDR, SLV_ACK1, WRITE, READ, SLAVE_ACK2, MASTER_ACK, STOP} STATE;
	
	STATE CURR_STATE, NEXT_STATE;
	
	logic bus_clk = 0;
	logic [$clog2(input_clock_freq/int'(i2c_clock_freq))-1:0] clock_counter = 0;
	logic	[2:0]	bit_counter = 3'b111;
	logic [7:0]	addr_rw;
	
	always_ff @(posedge clk)
	begin : gen_clock
		if (clock_counter == clock_divide)
			bus_clk <= ~bus_clk;
		else
			clock_counter <= clock_counter + 1;
	end : gen_clock
	
	
	always_ff @(posedge clk)
	begin : state_reg
		CURR_STATE <= NEXT_STATE;
	end : state_reg
	
	
	
	
	always_comb @(*)
	begin : NEXT_STATE_LOGIC
		if (~reset_n)
			NEXT_STATE <= START;
		
		unique case (CURR_STATE)
			READY			:	begin
									if (enable)
										NEXT_STATE = START;
									else
										NEXT_STATE = READY;
								end
							
			START			:	begin
									NEXT_STATE = DEVADDR;
								end
						
			DEVADDR		:	begin
									if (bit_counter == 3'b000)
										NEXT_STATE = SLV_ACK1;
									else
										NEXT_STATE = DEVADDR;
								end
							
			SLV_ACK1		:	begin
									if (addr_rw[0] == 1'b0)
										NEXT_STATE = WRITE;
									else
										NEXT_STATE = READ;
								end
							
			WRITE			:	begin
									if (bit_counter == 3'b000)
										NEXT_STATE = SLV_ACK2;
									else
										NEXT_STATE = WRITE;				
								end
			
			READ			:	begin
									if (bit_counter == 3'b000)
										NEXT_STATE = MASTER_ACK;
									else
										NEXT_STATE = READ;
								end
							
			SLV_ACK2		:	begin
									if (enable)
									begin
										if (addr_rw == {addr, rw}) //anlamadim
											NEXT_STATE = WRITE;
										else
											NEXT_STATE = START;
									end
										
									else
										NEXT_STATE = STOP;
								end
							
			MASTER_ACK	:	begin
									if (enable)
									begin
										if (addr_rw == {addr, rw}) //anlamadim
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
	
	end : NEXT_STATE_LOGIC
	
	
	always_comb @(STATE) // ve inputlar
	begin : datapath
	
	if (~reset_n)
	begin
		data_rd = 8'h00;
		busy = 1'b0;
		bit_counter = 3'b000;	
	end
								
		unique case (CURR_STATE)
			READY		:	begin	
								
							end
							
			START		:	begin

			
							end
						
			DEVADDR	:	begin
			
							end
							
			SLV_ACK1	:	begin
			
			
							end
							
			REGADDR	:	begin
			
							end
			
			SLV_ACK2	:	begin
			
							end
							
			READ1		:	begin
			
							end
							
			READ0		:	begin
			
							end
							
			STOP		:	begin
			
							end
		endcase
	end : datapath
	
endmodule

//Driver yazmaktan kasit nedir? I2C icin genel yazilmis bi koda her device icin farkli yazabilecegim bir wrapper yazmak degil mi?
//Stop vermeden tekrar read/write yapabildiğimi datasheetten nasıl anlarım?
//VHDL'de 1 ve 0 yapmak yerine pullup ile yapmak icin H ve L veriyor. Bunun verilog karsiligi nedir? 
//weak high ile weak low nedir? H yerine 1 verseydik direk ne olurdu?