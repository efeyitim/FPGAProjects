-------------------------------------------------------------------------------
-- Title      : Testbench for design "top"
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : top_tb.vhd
-- Author     : Efe  <efe@efeASUS>
-- Company    : 
-- Created    : 2022-10-12
-- Last update: 2022-10-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-12  1.0	efe	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

entity top_tb is

end entity top_tb;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of top_tb is

    -- component ports
    signal clk	 : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal dout	 : std_logic_vector(7 downto 0);
    signal serr	 : std_logic;
    signal derr	 : std_logic;

    procedure waitNre(signal clock : std_logic; n : positive) is
    begin
	for i in 1 to n loop
	    wait until rising_edge(clk);
	end loop;  -- i in l to n loop
    end procedure waitNre;

begin  -- architecture tb

    -- component instantiation
    U_DUT : entity work.top
	port map (
	    clk	  => clk,
	    rst_n => rst_n,
	    dout  => dout,
	    serr  => serr,
	    derr  => derr);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
	-- insert signal assignments here
	waitNre(clk, 5);
	rst_n <= '1';
	waitNre(clk, 5);
	wait until dout = x"EF";
	assert false report "SEED FOUND";
	waitNre(clk, 5);
	assert false report "SIM DONE" severity failure;
    end process PROC_STIMULI;



end architecture tb;
