-------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   18.07.2023
--  Short Description   :   
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    18.07.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_delay is

    port (
        clk       : in  std_logic;                                    -- main clock
        rst_n     : in  std_logic;                                    -- active low reset
        rst_n_out : out std_logic);                                   -- active low reset output

end entity reset_delay;

architecture rtl of reset_delay is
    constant TWO_SECONDS : unsigned(27 downto 0) := x"5F5E100";       -- 2 seconds
    signal counter       : unsigned(27 downto 0);
begin  -- architecture rtl

    PROC_DELAY : process (clk, rst_n) is
    begin  -- process PROC_DELAY
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            counter       <= (others => '0');
            rst_n_out     <= '0';
        elsif rising_edge(clk) then                                   -- rising clock edge
            if counter = TWO_SECONDS then
                rst_n_out <= '1';
            else
                counter   <= counter + 1;
            end if;
        end if;
    end process PROC_DELAY;

end architecture rtl;
