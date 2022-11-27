---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   26.11.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    26.11.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_controller_lm75b is

    port (
        clk        : in  std_logic;
        rst_n      : in  std_logic;
        busy       : in  std_logic;
        data_rd    : in  std_logic_vector(7 downto 0);
        ack_error  : in  std_logic;
        ena        : out std_logic;
        addr       : out std_logic_vector(6 downto 0);
        rw         : out std_logic;
        data_wr    : out std_logic_vector(7 downto 0);
        fifo_wrreq : out std_logic;
        fifo_data  : out std_logic_vector(15 downto 0)
        );

end entity i2c_controller_lm75b;

architecture rtl of i2c_controller_lm75b is

    constant LIM_100MS : unsigned(23 downto 0) := x"989680";

    signal counter_100ms : unsigned(23 downto 0);
    type state_t is (SELECT_REG_S, WAIT_S, READ_FIRST_S, READ_SECOND_S);
    signal state         : state_t;
    signal busy_prev     : std_logic;

begin  -- architecture rtl

    PROC_MAIN : process (clk, rst_n) is
    begin  -- process PROC_MAIN
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            ena           <= '0';
            addr          <= "1001000";
            rw            <= '0';
            data_wr       <= (others => '0');
            counter_100ms <= (others => '0');
            busy_prev     <= '0';
            fifo_wrreq    <= '0';
            fifo_data     <= (others => '0');
            state         <= WAIT_S;

        elsif rising_edge(clk) then                                   -- rising clock edge
            busy_prev <= busy;

            case state is

                when SELECT_REG_S =>
                    if busy = '0' then
                        ena     <= '1';
                        rw      <= '0';
                        data_wr <= x"00";
                    else
                        ena     <= '0';
                        state   <= WAIT_S;
                    end if;

                when WAIT_S =>
                    fifo_wrreq            <= '0';
                    if counter_100ms = LIM_100MS then
                        ena               <= '1';
                        rw                <= '1';
                        if busy_prev = '0' and busy = '1' then
                            counter_100ms <= (others => '0');
                            state         <= READ_FIRST_S;
                        end if;
                    else
                        counter_100ms     <= counter_100ms + 1;
                    end if;

                when READ_FIRST_S =>
                    if busy_prev = '1' and busy = '0' then
                        fifo_data(15 downto 8) <= data_rd;
                    end if;

                    if busy_prev = '0' and busy = '1' then
                        ena   <= '0';
                        state <= READ_SECOND_S;
                    end if;

                when READ_SECOND_S =>
                    if busy_prev = '1' and busy = '0' then
                        fifo_data(7 downto 0) <= data_rd;
                        fifo_wrreq            <= '1';
                        state                 <= WAIT_S;
                    end if;

                when others =>
                    ena           <= '0';
                    addr          <= "1001000";
                    rw            <= '0';
                    data_wr       <= (others => '0');
                    counter_100ms <= (others => '0');
                    busy_prev     <= '0';
                    state         <= WAIT_S;

            end case;
        end if;
    end process PROC_MAIN;
end architecture rtl;
