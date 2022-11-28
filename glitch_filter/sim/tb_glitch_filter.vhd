---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   28.11.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    28.11.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_glitch_filter is

end entity tb_glitch_filter;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_glitch_filter is

    -- component generics
    constant NUM_CYCLE : integer := 5000;

    -- component ports
    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal din   : std_logic := '0';
    signal dout  : std_logic;


    procedure waitNre(signal clock: std_ulogic; n: positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

begin  -- architecture tb

    -- component instantiation
    U_DUT: entity work.glitch_filter
        generic map (
            NUM_CYCLE => NUM_CYCLE)
        port map (
            clk   => clk,
            rst_n => rst_n,
            din   => din,
            dout  => dout);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI: process
    begin
        -- insert signal assignments here
        rst_n <= '0';
        wait for 100 ns;
        rst_n <= '1';
        din <= '1';
        waitNre(clk, 3000);
        din <= '0';
        waitNre(clk, 3000);
        din <= '1';
        waitNre(clk, 6000);
        din <= '0';
        waitNre(clk, 4000);
        din <= '1';
        waitNre(clk, 100);
        din <= '0';
        waitNre(clk, 5500);
        report "SIM DONE" severity failure;
        wait;
    end process PROC_STIMULI;
    

end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------
    
