library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity block_ram is

    generic (
	ram_width : integer := 8;
	ram_depth : integer := 8);	-- please enter the log2 result of the depth

    port (
	clk	     : in  std_logic;				       -- main clock
	rst_n	     : in  std_logic;				       -- active low reset
	i_en	     : in  std_logic;				       -- enable signal
	i_read_en    : in  std_logic;				       -- read enable signal
	i_write_en   : in  std_logic;				       -- write enable signal
	i_addr	     : in  std_logic_vector (ram_depth - 1 downto 0);  -- address
	i_data	     : in  std_logic_vector (ram_width - 1 downto 0);  -- input data
	o_data	     : out std_logic_vector (ram_width - 1 downto 0);  --output data
	o_data_valid : out std_logic);				       -- output data enable signal

end entity block_ram;

architecture rtl of block_ram is

    type t_BRAM_DATA is array (0 to 2**ram_depth - 1) of std_logic_vector (ram_width - 1 downto 0);
    signal r_BRAM_DATA : t_BRAM_DATA;

begin  -- architecture rtl

    PROC_BRAM : process (clk, rst_n) is
    begin  -- process PROC_BRAM
	if rst_n = '0' then		-- asynchronous reset (active low)
	    r_BRAM_DATA		 <= (others => (others => '0'));
	    o_data		 <= (others => '0');
	elsif rising_edge(clk) then	-- rising clock edge
	    if i_en = '1' then
		if i_read_en = '1' then
		    o_data	 <= r_BRAM_DATA(to_integer(unsigned(i_addr)));
		    o_data_valid <= '1';
		else
		    o_data_valid <= '0';
		end if;

		if i_write_en = '1' then
		    r_BRAM_DATA(to_integer(unsigned(i_addr))) <= i_data;
		end if;
	    end if;
	end if;
    end process PROC_BRAM;

end architecture rtl;
