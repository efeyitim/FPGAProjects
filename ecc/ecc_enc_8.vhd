-------------------------------------------------------------------------------
-- Title      : ECC Encoder
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : ecc_enc_8.vhd
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

entity ecc_enc_8 is

    port (
	clk   : in  std_logic;			     -- main clock
	rst_n : in  std_logic;			     -- active low reset
	din   : in  std_logic_vector(7 downto 0);    -- input
	dout  : out std_logic_vector(12 downto 0));  -- output

end entity ecc_enc_8;

architecture rtl of ecc_enc_8 is

begin  -- architecture rtl

    PROC_ENC : process (clk, rst_n) is
    begin  -- process PROC_ENC
	if rst_n = '0' then		-- asynchronous reset (active low)
	    dout	     <= (others => '0');
	elsif rising_edge(clk) then	-- rising clock edge
	    dout(12)	     <= din(7) xor din(6) xor din(4) xor din(3) xor din(1);
	    dout(11)	     <= din(7) xor din(5) xor din(4) xor din(2) xor din(1);
	    dout(10)	     <= din(7);
	    dout(9)	     <= din(6) xor din(5) xor din(4) xor din(0);
	    dout(8 downto 6) <= din(6 downto 4);
	    dout(5)	     <= din(3) xor din(2) xor din(1) xor din(0);
	    dout(4 downto 1) <= din(3 downto 0);
	    dout(0)	     <= din(7) xor din(6) xor din(5) xor din(3) xor din(2) xor din(0);
	end if;
    end process PROC_ENC;

end architecture rtl;
