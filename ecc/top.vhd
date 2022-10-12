library ieee;
use ieee.std_logic_1164.all;

entity top is

    port (
	clk   : in  std_logic;			   -- main clock
	rst_n : in  std_logic;			   -- active low reset
	dout  : out std_logic_vector(7 downto 0);  -- output
	serr  : out std_logic;			   -- single error
	derr  : out std_logic);			   -- double error

end entity top;

architecture rtl of top is

    component ecc_enc_8 is
	port (
	    clk	  : in	std_logic;
	    rst_n : in	std_logic;
	    din	  : in	std_logic_vector(7 downto 0);
	    dout  : out std_logic_vector(12 downto 0));
    end component ecc_enc_8;

    component ecc_dec_8 is
	port (
	    clk	  : in	std_logic;
	    rst_n : in	std_logic;
	    din	  : in	std_logic_vector(12 downto 0);
	    dout  : out std_logic_vector(7 downto 0);
	    serr  : out std_logic;
	    derr  : out std_logic);
    end component ecc_dec_8;

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

    signal enc_out  : std_logic_vector(12 downto 0);
    signal lfsr_out : std_logic_vector(7 downto 0);
    constant seed   : std_logic_vector(7 downto 0) := x"EF";
    constant poly   : std_logic_vector(7 downto 0) := x"D3";

begin  -- architecture rtl

    U_ENC : entity work.ecc_enc_8
	port map (
	    clk	  => clk,
	    rst_n => rst_n,
	    din	  => lfsr_out,
	    dout  => enc_out);

    U_DEC : entity work.ecc_dec_8
	port map (
	    clk	  => clk,
	    rst_n => rst_n,
	    din	  => enc_out,
	    dout  => dout,
	    serr  => serr,
	    derr  => derr);

    U_LFSR : entity work.lfsr_generic
	generic map (
	    WIDTH    => 8)
	port map (
	    clk	     => clk,
	    rst_n    => rst_n,
	    seed     => seed,
	    poly     => poly,
	    lfsr_out => lfsr_out);

end architecture rtl;
