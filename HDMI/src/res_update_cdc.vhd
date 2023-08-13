---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   13.08.2023
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    13.08.2023          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity res_update_cdc is

    port (
        clk            : in  std_logic;
        rst_n          : in  std_logic;
        locked         : in  std_logic;
        res_update_in  : in  std_logic;
        res_sel_in     : in  std_logic_vector(2 downto 0);
        res_update_out : out std_logic;
        res_sel_out    : out std_logic_vector(2 downto 0));

end entity res_update_cdc;

architecture rtl of res_update_cdc is
    type state_t is (IDLE_S, WAIT_LOCKED_FALL_S, WAIT_LOCKED_RISE_S, DELAY_S);
    signal state           : state_t;
    signal delay_counter   : unsigned(31 downto 0);
    signal timeout_counter : unsigned(31 downto 0);

begin  -- architecture rtl

    process (clk, rst_n) is
    begin  -- process
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            res_sel_out     <= (others => '0');
            state           <= IDLE_S;
            delay_counter   <= (others => '0');
            timeout_counter <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge

            case state is

                when IDLE_S =>
                    if res_update_in = '1' then
                        case res_sel_in is
                            when "001" =>
                                res_sel_out <= "000";
                            when "010" =>
                                res_sel_out <= "001";
                            when "011" =>
                                res_sel_out <= "011";
                            when "101" =>
                                res_sel_out <= "110";
                            when others =>
                                res_sel_out <= "000";
                        end case;
                        state               <= WAIT_LOCKED_FALL_S;
                    end if;

                when WAIT_LOCKED_FALL_S =>
                    if timeout_counter = 100000000 then               -- 1 sec
                        timeout_counter <= (others => '0');
                        state           <= IDLE_S;
                    else
                        timeout_counter <= timeout_counter + 1;
                    end if;

                    if locked = '0' then
                        state <= WAIT_LOCKED_RISE_S;
                    end if;

                when WAIT_LOCKED_RISE_S =>
                    if locked = '1' then
                        state <= DELAY_S;
                    end if;

                when DELAY_S =>
                    if delay_counter = 100000 then                    -- 1 ms
                        res_update_out <= '0';
                        delay_counter  <= (others => '0');
                        state          <= IDLE_S;
                    elsif delay_counter = 90000 then
                        res_update_out <= '1';
                        delay_counter  <= delay_counter + 1;
                    else
                        delay_counter  <= delay_counter + 1;
                    end if;

                when others => null;
            end case;
        end if;
    end process;

end architecture rtl;
