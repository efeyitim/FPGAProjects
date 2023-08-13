---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   Glitch Filter
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
use ieee.numeric_std.all;

entity glitch_filter is

    generic (
        NUM_CYCLE : integer := 5000000);                              -- number of clock cycles,  5000000 for 100 ms at 50MHz

    port (
        clk   : in  std_logic;                                        -- main clock
        rst_n : in  std_logic;                                        -- active low reset
        din   : in  std_logic;                                        -- input data
        dout  : out std_logic);                                       -- output data

end entity glitch_filter;

architecture rtl of glitch_filter is

    constant GLITCH_TIME : unsigned(31 downto 0) := to_unsigned(NUM_CYCLE, 32);
    type state_t is (ZERO, ONE, ZERO_TO_ONE, ONE_TO_ZERO);
    signal state         : state_t;
    signal counter       : unsigned(31 downto 0);

begin  -- architecture rtl

    PROC_GLITCH : process (clk, rst_n) is
    begin  -- process PROC_GLITCH
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            state   <= ZERO;
            counter <= (others => '0');
            dout    <= '0';
        elsif rising_edge(clk) then                                   -- rising clock edge
            case state is

                when ZERO =>
                    dout      <= '0';
                    if din = '1' then
                        state <= ZERO_TO_ONE;
                    end if;

                when ZERO_TO_ONE =>
                    if din = '0' then
                        counter     <= (others => '0');
                        state       <= ZERO;
                    else
                        if counter = GLITCH_TIME then
                            counter <= (others => '0');
                            state   <= ONE;
                        else
                            counter <= counter + 1;
                        end if;
                    end if;

                when ONE =>
                    dout      <= '1';
                    if din = '0' then
                        state <= ONE_TO_ZERO;
                    end if;

                when ONE_TO_ZERO =>
                    if din = '1' then
                        counter     <= (others => '0');
                        state       <= ONE;
                    else
                        if counter = GLITCH_TIME then
                            counter <= (others => '0');
                            state   <= ZERO;
                        else
                            counter <= counter + 1;
                        end if;
                    end if;

                when others =>
                    state   <= ZERO;
                    counter <= (others => '0');
                    dout    <= '0';

            end case;
        end if;
    end process PROC_GLITCH;

end architecture rtl;
