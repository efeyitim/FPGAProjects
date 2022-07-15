-------------------------------------------------------------------------------
-- Title      : Testbench for design "divisor"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : divisor_tb.vhd
-- Author     : Efe  <efe@efeASUS>
-- Company    : 
-- Created    : 2022-07-16
-- Last update: 2022-07-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-07-16  1.0      efe	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

entity divisor_tb is

end entity divisor_tb;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of divisor_tb is

    -- component generics
    constant LENGTH : integer := 5;

    -- component ports
    signal clk	     : std_logic := '0';
    signal rst_n     : std_logic;
    signal en	     : std_logic;
    signal dividend  : std_logic_vector(2**LENGTH-1 downto 0);
    signal divisor   : std_logic_vector(2**LENGTH-1 downto 0);
    signal quotient  : std_logic_vector(2**LENGTH-1 downto 0);
    signal remainder : std_logic_vector(2**LENGTH-1 downto 0);
    signal busy	     : std_logic;
    signal done	     : std_logic;

begin  -- architecture tb

    -- component instantiation
    DUT: entity work.divisor
	generic map (
	    LENGTH => LENGTH)
	port map (
	    clk	      => clk,
	    rst_n     => rst_n,
	    en	      => en,
	    dividend  => dividend,
	    divisor   => divisor,
	    quotient  => quotient,
	    remainder => remainder,
	    busy      => busy,
	    done      => done);

    -- clock generation
    clk <= not clk after 10 ns;

    PROC_STIMULI: process is
	constant period : time := 20 ns;
    begin  -- process PROC_STIMULI
	rst_n		       <= '0';
	en		       <= '0';
	dividend	       <= (others => '0');
	divisor		       <= (others => '0');
	wait for 5*period;
	rst_n		       <= '1';
	wait for 5*period;
	dividend	       <= x"0000000F";
	divisor		       <= x"00000004";
	wait for 5*period;
	en		       <= '1';
	wait for period;
	en		       <= '0';
	wait for period;
	en		       <= '1';
	dividend	       <= x"0000000B";
	divisor		       <= x"00000003";
	wait for 35*period;
	en		       <= '0';
	wait on busy;
	dividend	       <= x"00010D48"; -- 68936d
	divisor		       <= x"00001119"; -- 4377d, quotient = 15, remainder = 3281
	en <= '1';
	wait on busy;
	en <= '0';
	
	wait for 10 us;	
    end process PROC_STIMULI;
    

end architecture tb;
