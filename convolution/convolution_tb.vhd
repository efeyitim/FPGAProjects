-------------------------------------------------------------------------------
-- Title      : Testbench for design "convolution"
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : convolution_tb.vhd
-- Author     : Efe  <efe@efeASUS>
-- Company    : 
-- Created    : 2021-10-09
-- Last update: 2021-10-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2021-10-09  1.0	efe	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_arith.all;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

entity convolution_tb is

end entity convolution_tb;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of convolution_tb is

    -- component generics
    constant c_data_length : integer := 24;
    constant c_num_coef	   : integer := 17;
    constant c_coef_length : integer := 8;
    constant c_coef_pow	   : integer := 7;

    -- component ports
    signal clk		: std_logic					:= '0';
    signal rst_n	: std_logic					:= '0';
    signal i_en		: std_logic					:= '0';
    signal i_coef_valid : std_logic					:= '0';
    signal i_coef_addr	: std_logic_vector (5 downto 0)			:= (others => '0');
    signal i_coef_data	: std_logic_vector (c_coef_length - 1 downto 0) := (others => '0');
    signal i_data	: std_logic_vector (c_data_length - 1 downto 0) := (others => '0');
    signal i_data_valid : std_logic					:= '0';
    signal o_data	: std_logic_vector (c_data_length - 1 downto 0) := (others => '0');
    signal o_data_valid : std_logic					:= '0';
    signal o_busy	: std_logic					:= '0';

    constant CLK_PERIOD	   : time   := 10 ns;
    constant SAMPLE_PERIOD : time   := 10 us;

    --this text contains a sin wave generated using matlab.
    constant sin_text	   : string := "./sin.txt";

    signal sample_clk	: std_logic					:= '0';
    signal example_data : std_logic_vector (c_data_length - 1 downto 0) := (others => '0');
    signal clk_domain	: std_logic_vector (3 downto 0)			:= (others => '0');
    signal last_data	: std_logic					:= '0';

    type t_coef_ctrl is (S_IDLE, S_LOAD);
    signal r_coef_ctrl : t_coef_ctrl := S_IDLE;

    type t_filter_coef is array (0 to c_num_coef - 1) of integer;
    signal r_filter_coef : t_filter_coef := (1, 2, 3, 5, 8, 10, 13, 14, 15, 14, 13, 10, 8, 5, 3, 2, 1);

    signal coef_load : std_logic := '0';
    signal i	     : integer	 := 0;

begin  -- architecture tb

    -- component instantiation
    DUT : entity work.convolution
	generic map (
	    c_data_length => c_data_length,
	    c_num_coef	  => c_num_coef,
	    c_coef_length => c_coef_length,
	    c_coef_pow	  => c_coef_pow)
	port map (
	    clk		  => clk,
	    rst_n	  => rst_n,
	    i_en	  => i_en,
	    i_coef_valid  => i_coef_valid,
	    i_coef_addr	  => i_coef_addr,
	    i_coef_data	  => i_coef_data,
	    i_data	  => i_data,
	    i_data_valid  => i_data_valid,
	    o_data	  => o_data,
	    o_data_valid  => o_data_valid,
	    o_busy	  => o_busy);

    -- clock generation
    clk	       <= not clk	 after CLK_PERIOD/2;
    sample_clk <= not sample_clk after SAMPLE_PERIOD/2;

    process is
    begin  -- process
	coef_load <= '0';
	wait for CLK_PERIOD * 2;
	rst_n <= '1';
	coef_load <= '1';
	wait for CLK_PERIOD;
	coef_load <= '0';
	wait;
    end process;

    PROC_FILE_READ : process (sample_clk) is
	file myfile	: text open read_mode is sin_text;
	variable myline : line;
	variable data	: integer;
    begin  -- process
	if rising_edge(sample_clk) then	 -- rising clock edge
	    if not(endfile(myfile)) then
		readline(myfile, myline);
		read(myline, data);
		example_data <= conv_std_logic_vector(data, 24);
		last_data    <= '0';
	    else
		example_data <= conv_std_logic_vector(0, 24);
		last_data    <= '1';
	    end if;
	end if;
    end process PROC_FILE_READ;

    --next two processes are about when to latch the example data into input data
    --the answer is 3 cycles after new data is written from the text file.
    process (clk) is
    begin  -- process
	if rising_edge(clk) then	-- rising clock edge
	    clk_domain <= clk_domain(2 downto 0) & sample_clk;
	end if;
    end process;

    process (clk) is
    begin  -- process
	if rising_edge(clk) then	-- rising clock edge
	    if last_data = '0' and clk_domain(3 downto 2) = "01" then
		i_data_valid <= '1';
		i_data	     <= example_data;
	    else
		i_data_valid <= '0';
		i_data	     <= (others => '0');
	    end if;
	end if;
    end process;

    PROC_COEF_LOAD : process (clk) is
    begin  -- process
	if rising_edge(clk) then	-- rising clock edge
	    i_coef_valid	    <= '0';
	    case r_coef_ctrl is
		when S_IDLE =>
		    if coef_load = '1' then
			r_coef_ctrl <= S_LOAD;
		    end if;

		when S_LOAD =>
		    i_coef_valid    <= '1';
		    i_coef_addr	    <= conv_std_logic_vector(i, 6);
		    i_coef_data	    <= conv_std_logic_vector(r_filter_coef(i), c_coef_length);
		    if i = c_num_coef - 1 then
			r_coef_ctrl <= S_IDLE;
			i	    <= 0;
			i_en	    <= '1';
		    else
			i	    <= i + 1;
		    end if;
		when others => null;
	    end case;
	end if;
    end process PROC_COEF_LOAD;

    assert last_data /= '1' report "SIM DONE" severity failure;
end architecture tb;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
