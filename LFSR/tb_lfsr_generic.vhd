-------------------------------------------------------------------------------
-- Title      : LFSR
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : tb_lfsr_generic.vhd
-- Author     : Efe  <efe@efeASUS>
-- Company    : 
-- Created    : 2022-10-10
-- Last update: 2022-10-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-10  1.0	efe	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_lfsr_generic is

end entity tb_lfsr_generic;

architecture tb of tb_lfsr_generic is

    -- component generics
    constant WIDTH : integer := 16;

    -- component ports
    signal clk	    : std_logic				 := '0';
    signal rst_n    : std_logic				 := '0';
    signal seed	    : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal poly	    : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal lfsr_out : std_logic_vector(WIDTH-1 downto 0);

    procedure waitNre(signal clock : std_logic; n : positive) is
    begin
	for i in 1 to n loop
	    wait until rising_edge(clk);
	end loop;  -- i in l to n loop
    end procedure waitNre;

    component lfsr_generic is
	generic (
	    WIDTH    :	   integer);
	port (
	    clk	     : in  std_logic;
	    rst_n    : in  std_logic;
	    seed     : in  std_logic_vector(WIDTH-1 downto 0);
	    poly     : in  std_logic_vector(WIDTH-1 downto 0);
	    lfsr_out : out std_logic_vector(WIDTH-1 downto 0));
    end component lfsr_generic;

begin  -- architecture tb

-- component instantiation
    U_DUT : lfsr_generic
	generic map (
	    WIDTH    => WIDTH)
	port map (
	    clk	     => clk,
	    rst_n    => rst_n,
	    seed     => seed,
	    poly     => poly,
	    lfsr_out => lfsr_out);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI : process is
    begin  -- process PROC_STIMULI
	-- inster signal assignments here
	rst_n <= '0';
	seed  <= x"5EED";
	poly  <= x"D008";
	waitNre(clk, 5);
	rst_n <= '1';
	waitNre(clk, 5);
	wait until lfsr_out = x"5EED";
	assert false report "SEED FOUND";
	waitNre(clk, 5);
	assert false report "SIM DONE" severity failure;
    end process PROC_STIMULI;

end architecture tb;
