-------------------------------------------------------------------------------
-- Title      : ECC Decoder
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : ecc_dec_8.vhd
-- Author     : Efe  <efe@efeASUS>
-- Company    : 
-- Created    : 2022-10-12
-- Last update: 2022-10-13
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

entity ecc_dec_8 is

    port (
	clk   : in  std_logic;			    -- main clock
	rst_n : in  std_logic;			    -- active low reset
	din   : in  std_logic_vector(12 downto 0);  -- input
	dout  : out std_logic_vector(7 downto 0);   -- output
	serr  : out std_logic;			    -- single bit error
	derr  : out std_logic);			    -- double bit error

end entity ecc_dec_8;

architecture rtl of ecc_dec_8 is

    signal term1 : std_logic;
    signal term2 : std_logic;
    signal term3 : std_logic;
    signal term4 : std_logic;
    signal term5 : std_logic;

begin  -- architecture rtl

    term1 <= din(12) xor din(11) xor din(10) xor din(9) xor din(8) xor din(7) xor din(6) xor din(5) xor din(4) xor din(3) xor din(2) xor din(1) xor din(0);
    term2 <= din(12) xor din(10) xor din(8) xor din(6) xor din(4) xor din(2);
    term3 <= din(11) xor din(10) xor din(7) xor din(6) xor din(3) xor din(2);
    term4 <= din(9) xor din(8) xor din(7) xor din(6) xor din(1);
    term5 <= din(5) xor din(4) xor din(3) xor din(2) xor din(1);

    PROC_DEC : process (clk, rst_n) is
    begin  -- process PROC_DEC
	if rst_n = '0' then		-- asynchronous reset (active low)
	    dout <= (others => '0');
	    serr <= '0';
	    derr <= '0';
	elsif rising_edge(clk) then	-- rising clock edge

	    dout(7) <= (din(10) and not(term1 and ((term2 and term3) and (not(term4) and not(term5))))) or
		       (not din(10) and (term1 and ((term2 and term3) and (not(term4) and not(term5)))));


	    dout(6) <= (din(8) and not(term1 and ((term2 and not(term3)) and (term4 and not(term5))))) or
		       (not din(8) and (term1 and ((term2 and not(term3)) and (term4 and not(term5)))));

	    dout(5) <= (din(7) and not(term1 and ((not(term2) and term3) and (term4 and not(term5))))) or
		       (not din(7) and (term1 and ((not(term2) and term3) and (term4 and not(term5)))));

	    dout(4) <= (din(6) and not(term1 and ((term2 and term3) and (term4 and not(term5))))) or
		       (not din(6) and (term1 and ((term2 and term3) and (term4 and not(term5)))));

	    dout(3) <= (din(4) and not(term1 and ((term2 and not(term3)) and (not(term4) and term5)))) or
		       (not din(4) and (term1 and ((term2 and not(term3)) and (not(term4) and term5))));

	    dout(2) <= (din(3) and (not(term1 and ((not(term2) and term3) and (not(term4) and term5))))) or
		       (not din(3) and (term1 and ((not(term2) and term3) and (not(term4) and term5))));

	    dout(1) <= (din(2) and (not(term1 and ((term2 and term3) and (not(term4) and term5))))) or
		       (not din(2) and (term1 and ((term2 and term3) and (not(term4) and term5))));

	    dout(0) <= (din(1) and (not(term1 and ((not(term2) and not(term3)) and (term4 and term5))))) or
		       (not din(1) and (term1 and ((not(term2) and not(term3)) and (term4 and term5))));

	    derr <= (not term1) and (term2 or term3 or term4 or term5);

	    serr <= term1;

	end if;
    end process PROC_DEC;

end architecture rtl;
