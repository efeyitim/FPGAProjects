-------------------------------------------------------------------------------
-- Title      : LFSR
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : lfsr.vhd
-- Author     : Efe  <efe@efeASUS>
-- Company    : 
-- Created    : 2022-10-09
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
-- 2022-10-09  1.0	efe	Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity lfsr_generic is

    generic (
	WIDTH : integer := 16);		-- width

    port (
	clk	 : in  std_logic;			     -- main clock
	rst_n	 : in  std_logic;			     -- active low reset
	seed	 : in  std_logic_vector(WIDTH-1 downto 0);   -- seed
	poly	 : in  std_logic_vector(WIDTH-1 downto 0);   -- polynomial, x"D008" for x16+x15+x13+1
	lfsr_out : out std_logic_vector(WIDTH-1 downto 0));  -- lfsr output

end entity lfsr_generic;

architecture rtl of lfsr_generic is

    -- -2008 use unitary AND without parameter instead of call:
    function reduce_xor (inp : std_logic_vector) return std_logic is
	variable retval	     : std_logic := '0';
    begin
	for i in inp'range loop
	    retval			 := retval xor inp(i);
	end loop;
	return retval;
    end function;

    signal lfsr_poly	: std_logic_vector(WIDTH-1 downto 0);
    signal lfsr_out_buf : std_logic_vector(WIDTH-1 downto 0);
    signal feedback	: std_logic;

begin  -- architecture rtl

    feedback  <= reduce_xor(lfsr_poly);
    lfsr_poly <= poly and lfsr_out_buf;
    lfsr_out  <= lfsr_out_buf;

    PROC_LFSR : process (clk, rst_n) is
    begin  -- process PROC_LFSR
	if rst_n = '0' then		-- asynchronous reset (active low)
	    lfsr_out_buf <= seed;
	elsif rising_edge(clk) then	-- rising clock edge
	    lfsr_out_buf <= lfsr_out_buf(WIDTH-2 downto 0) & feedback;
	end if;
    end process PROC_LFSR;

end architecture rtl;
