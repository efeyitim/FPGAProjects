---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   Reset Synchronizer
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   27.11.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    27.11.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_sync is

    port (
        clk         : in  std_logic;                                  -- main clock
        async_rst_n : in  std_logic;                                  -- reset to be synchronized
        rst_n       : out std_logic;                                  -- active low reset
        rst         : out std_logic);                                 -- active high reset

end entity reset_sync;

architecture rtl of reset_sync is

    signal rst_n_buf2 : std_logic;
    signal rst_n_buf1 : std_logic;
    signal rst_buf2   : std_logic;
    signal rst_buf1   : std_logic;

begin  -- architecture rtl

    PROC_SYNC : process (clk, async_rst_n) is
    begin  -- process PROC_SYNC
        if async_rst_n = '0' then                                     -- asynchronous reset (active low)
            rst_n_buf2 <= '0';
            rst_n_buf1 <= '0';
            rst_n      <= '0';
            rst_buf2   <= '1';
            rst_buf1   <= '1';
            rst        <= '1';
        elsif rising_edge(clk) then                                   -- rising clock edge
            rst_n_buf2 <= '1';
            rst_n_buf1 <= rst_n_buf2;
            rst_n      <= rst_n_buf1;
            rst_buf2   <= '0';
            rst_buf1   <= rst_buf2;
            rst        <= rst_buf1;
        end if;
    end process PROC_SYNC;

end architecture rtl;
