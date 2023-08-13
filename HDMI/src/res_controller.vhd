---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   12.08.2023
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    12.08.2023          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity res_controller is

    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        button  : in  std_logic;
        res_upd : out std_logic;
        res_sel : out std_logic_vector(2 downto 0));

end entity res_controller;

architecture rtl of res_controller is

    signal button_buf     : std_logic;
    signal counter        : unsigned(31 downto 0);
    signal button_counter : unsigned(2 downto 0);
    signal active         : std_logic;
    signal res_upd_int    : std_logic;
    signal pulse_counter  : unsigned(3 downto 0);

begin  -- architecture rtl
    res_sel <= std_logic_vector(button_counter);
    res_upd <= res_upd_int;

    process (clk, rst_n) is
    begin  -- process
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            counter        <= (others => '0');
            button_counter <= (others => '0');
            button_buf     <= '0';
            res_upd_int    <= '0';
            active         <= '0';
            pulse_counter  <= (others => '0');

        elsif rising_edge(clk) then                                   -- rising clock edge
            button_buf <= button;

            if active = '1' then
                if counter = 300000000 then
                    counter     <= (others => '0');
                    active      <= '0';
                    res_upd_int <= '1';
                else
                    counter     <= counter + 1;
                end if;
            end if;

            if button_buf = '0' and button = '1' then                 -- rising edge
                active         <= '1';
                button_counter <= button_counter + 1;
                counter        <= (others => '0');
            end if;

            if res_upd_int = '1' then
                if pulse_counter = 10 then
                    pulse_counter  <= (others => '0');
                    button_counter <= (others => '0');
                    res_upd_int    <= '0';
                else
                    pulse_counter  <= pulse_counter + 1;
                end if;
            end if;
        end if;
    end process;

end architecture rtl;
