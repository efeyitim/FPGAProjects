---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   10.08.2023
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    10.08.2023          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity leds is

    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        leds_o  : out std_logic_vector(3 downto 0));

end entity leds;

architecture rtl of leds is

    signal counter  : unsigned(31 downto 0);
    signal leds_int : unsigned(3 downto 0);

begin  -- architecture rtl

    leds_o <= std_logic_vector(leds_int);

    PROC_LEDS : process (clk, rst_n) is
    begin  -- process PROC_LEDS
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            counter      <= (others => '0');
            leds_int     <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge
            if counter = to_unsigned(100000000, 32) then
                counter  <= (others => '0');
                leds_int <= leds_int + 1;
            else
                counter  <= counter + 1;
            end if;
        end if;
    end process PROC_LEDS;


end architecture rtl;
