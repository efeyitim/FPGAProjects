-------------------------------------------------------------------------------
-- Title      : Testbench for design "image_proc"
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : image_proc_tb.vhd
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

entity image_proc_tb is

end entity image_proc_tb;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of image_proc_tb is

    component image_proc is
	generic (
	    c_image_row	  :	unsigned (8 downto 0);
	    c_image_col	  :	unsigned (8 downto 0);
	    c_data_length :	integer);
	port (
	    clk		  : in	std_logic;
	    rst_n	  : in	std_logic;
	    i_en	  : in	std_logic;
	    i_start	  : in	std_logic;
	    i_opcode	  : in	std_logic_vector (2 downto 0);
	    i_data	  : in	std_logic_vector (c_data_length - 1 downto 0);
	    i_data_valid  : in	std_logic;
	    o_addr	  : out std_logic_vector (15 downto 0);
	    o_addr_valid  : out std_logic;
	    o_data	  : out std_logic_vector (7 downto 0);
	    o_data_valid  : out std_logic;
	    o_done	  : out std_logic);
    end component image_proc;

    component block_ram is
	generic (
	    ram_width	 :     integer;
	    ram_depth	 :     integer);
	port (
	    clk		 : in  std_logic;
	    rst_n	 : in  std_logic;
	    i_en	 : in  std_logic;
	    i_read_en	 : in  std_logic;
	    i_write_en	 : in  std_logic;
	    i_addr	 : in  std_logic_vector (ram_depth - 1 downto 0);
	    i_data	 : in  std_logic_vector (ram_width - 1 downto 0);
	    o_data	 : out std_logic_vector (ram_width - 1 downto 0);
	    o_data_valid : out std_logic);
    end component block_ram;

    -- component generics
    constant c_image_row   : unsigned (8 downto 0) := "100000000";
    constant c_image_col   : unsigned (8 downto 0) := "100000000";
    constant c_data_length : integer		   := 8;
    constant path_read	   : string		   := "./cameraman.txt";
    constant path_write1   : string		   := "./cameraman_mirror.txt";
    constant path_write2   : string		   := "./cameraman_reverse.txt";
    constant path_write3   : string		   := "./cameraman_negative.txt";
    constant path_write4   : string		   := "./cameraman_threshold.txt";
    constant path_write5   : string		   := "./cameraman_brightnessup.txt";
    constant path_write6   : string		   := "./cameraman_brightnessdown.txt";
    constant path_write7   : string		   := "./cameraman_contrastup.txt";
    constant path_write8   : string		   := "./cameraman_contrastdown.txt";

    constant CLK_PERIOD : time	  := 20 ns;
    constant ram_depth	: integer := 16;

    constant C_MIRROR	       : std_logic_vector (2 downto 0) := "000";
    constant C_REVERSE	       : std_logic_vector (2 downto 0) := "001";
    constant C_NEGATIVE	       : std_logic_vector (2 downto 0) := "010";
    constant C_THRESHOLD       : std_logic_vector (2 downto 0) := "011";
    constant C_BRIGHTNESS_UP   : std_logic_vector (2 downto 0) := "100";
    constant C_BRIGHTNESS_DOWN : std_logic_vector (2 downto 0) := "101";
    constant C_CONTRAST_UP     : std_logic_vector (2 downto 0) := "110";
    constant C_CONTRAST_DOWN   : std_logic_vector (2 downto 0) := "111";

    type t_img_proc is (S_RAMREAD, S_RAMWRITE, S_DONE);
    signal r_img_proc : t_img_proc := S_RAMWRITE;  -- state machine


    -- component ports
    signal clk		: std_logic					:= '0';
    signal rst_n	: std_logic					:= '0';
    signal i_en		: std_logic					:= '0';
    signal i_start	: std_logic					:= '0';
    signal i_opcode	: std_logic_vector (2 downto 0)			:= C_MIRROR;
    signal i_data	: std_logic_vector (c_data_length - 1 downto 0) := (others => '0');
    signal o_addr	: std_logic_vector (15 downto 0)		:= (others => '0');
    signal o_addr_valid : std_logic					:= '0';
    signal o_data	: std_logic_vector (7 downto 0)			:= (others => '0');
    signal o_data_valid : std_logic					:= '0';
    signal o_done	: std_logic					:= '0';

    signal i_ram_en	    : std_logic					    := '1';
    signal i_read_en	    : std_logic					    := '0';
    signal i_write_en	    : std_logic					    := '0';
    signal i_ram_addr	    : std_logic_vector (ram_depth - 1 downto 0)	    := (others => '0');
    signal i_ram_data	    : std_logic_vector (c_data_length - 1 downto 0) := (others => '0');
    signal o_ram_data	    : std_logic_vector (c_data_length - 1 downto 0) := (others => '0');
    signal o_ram_data_valid : std_logic					    := '0';

    signal data_counter : integer := 0;

    signal done_flag : std_logic := '0';

begin  -- architecture tb

    -- component instantiation
    DUT : entity work.image_proc
	generic map (
	    c_image_row	  => c_image_row,
	    c_image_col	  => c_image_col,
	    c_data_length => c_data_length)
	port map (
	    clk		  => clk,
	    rst_n	  => rst_n,
	    i_en	  => i_en,
	    i_start	  => i_start,
	    i_opcode	  => i_opcode,
	    i_data	  => o_ram_data,
	    i_data_valid  => o_ram_data_valid,
	    o_addr	  => o_addr,
	    o_addr_valid  => o_addr_valid,
	    o_data	  => o_data,
	    o_data_valid  => o_data_valid,
	    o_done	  => o_done);

    block_ram_1 : entity work.block_ram
	generic map (
	    ram_width	 => c_data_length,
	    ram_depth	 => ram_depth)
	port map (
	    clk		 => clk,
	    rst_n	 => rst_n,
	    i_en	 => i_ram_en,
	    i_read_en	 => i_read_en,
	    i_write_en	 => i_write_en,
	    i_addr	 => i_ram_addr,
	    i_data	 => i_ram_data,
	    o_data	 => o_ram_data,
	    o_data_valid => o_ram_data_valid);

    -- clock generation
    clk <= not clk after CLK_PERIOD / 2;

    process is
    begin  -- process
	wait for 2 * CLK_PERIOD;
	rst_n <= '1';
	wait;
    end process;

    process (clk) is
	file file_read	   : text open read_mode is path_read;
	file file_write	   : text open write_mode is path_write1;
	variable row_read  : line;
	variable row_write : line;
	variable data_read : integer;
    begin  -- process
	if rising_edge(clk) then	-- rising clock edge
	    if o_data_valid = '1' then
		write(row_write, to_integer(unsigned(o_data)));
		writeline(file_write, row_write);
	    end if;

	    case r_img_proc is

		when S_RAMWRITE =>
		    if not endfile(file_read) then
			readline(file_read, row_read);
			read(row_read, data_read);
			i_ram_data   <= std_logic_vector(to_unsigned(data_read, c_data_length));
			i_ram_addr   <= std_logic_vector(to_unsigned(data_counter, i_ram_addr'length));
			i_en	     <= '0';
			i_write_en   <= '1';
			data_counter <= data_counter + 1;
		    else
			r_img_proc   <= S_RAMREAD;
			i_write_en   <= '0';
		    end if;

		when S_RAMREAD =>
		    i_start	   <= '1';
		    i_en	   <= '1';
		    i_ram_addr	   <= o_addr;
		    i_read_en	   <= o_addr_valid;
		    if o_done = '1' then
			i_start	   <= '0';
			r_img_proc <= S_DONE;
		    end if;

		when S_DONE =>
		    i_opcode		   <= std_logic_vector(unsigned(i_opcode) + 1);
		    if i_opcode = C_CONTRAST_DOWN then
			done_flag	   <= '1';
		    else
			r_img_proc	   <= S_RAMREAD;
			case i_opcode is
			    when "000" =>
				file_close(file_write);
				file_open(file_write, path_write2, write_mode);

			    when "001" =>
				file_close(file_write);
				file_open(file_write, path_write3, write_mode);

			    when "010" =>
				file_close(file_write);
				file_open(file_write, path_write4, write_mode);

			    when "011" =>
				file_close(file_write);
				file_open(file_write, path_write5, write_mode);

			    when "100" =>
				file_close(file_write);
				file_open(file_write, path_write6, write_mode);

			    when "101" =>
				file_close(file_write);
				file_open(file_write, path_write7, write_mode);

			    when "110" =>
				file_close(file_write);
				file_open(file_write, path_write8, write_mode);

			    when others => null;
			end case;
		    end if;

		when others =>
		    null;

	    end case;
	end if;
    end process;

    assert done_flag /= '1' report "SIM DONE" severity failure;

end architecture tb;
