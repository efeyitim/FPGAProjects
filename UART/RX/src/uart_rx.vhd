---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   UART RX
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

entity uart_rx is
    generic (
        CLK_FREQ      : integer := 50_000_000;
        BAUD_RATE     : integer := 115_200;
        NUM_DATA_BITS : integer := 8;
        NUM_STOP_BITS : integer := 1
        );

    port (
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        rx       : in  std_logic;
        rx_dout  : out std_logic_vector (7 downto 0);
        rx_done  : out std_logic;
        rx_error : out std_logic_vector(1 downto 0)                   -- 1st bit for stop error, 0th bit for start error
        );
end uart_rx;

architecture Behavioral of uart_rx is

    constant DATA_BIT_TIME      : unsigned(31 downto 0) := to_unsigned(CLK_FREQ / BAUD_RATE, 32);
    constant HALF_DATA_BIT_TIME : unsigned(31 downto 0) := to_unsigned(CLK_FREQ / BAUD_RATE / 2, 32);
    constant STOP_BIT_TIME      : unsigned(31 downto 0) := to_unsigned((CLK_FREQ / BAUD_RATE) * NUM_STOP_BITS, 32);
    constant DATA_BITS          : unsigned(3 downto 0)  := to_unsigned(NUM_DATA_BITS - 1, 4);

    type t_state is (IDLE_S, START_S, STOP_S, DATA_S);
    signal state : t_state;

    signal bit_timer   : unsigned(31 downto 0);
    signal bit_counter : unsigned(3 downto 0);
    signal shift_reg   : std_logic_vector (7 downto 0);

begin

    PROC_UART_RX : process (clk, rst_n)
    begin
        if rst_n = '0' then
            rx_dout     <= (others => '0');
            shift_reg   <= (others => '0');
            bit_counter <= DATA_BITS;
            bit_timer   <= HALF_DATA_BIT_TIME;
            rx_error    <= (others => '0');
            rx_done     <= '0';
            state       <= IDLE_S;

        elsif (rising_edge(clk)) then

            case state is

                when IDLE_S =>
                    rx_done      <= '0';
                    if (rx = '0') then
                        rx_error <= (others => '0');
                        state    <= START_S;
                    end if;

                when START_S =>
                    if rx = '0' then
                        if (bit_timer = 0) then
                            state     <= DATA_S;
                            bit_timer <= DATA_BIT_TIME;
                        else
                            bit_timer <= bit_timer - 1;
                        end if;
                    else
                        bit_timer     <= HALF_DATA_BIT_TIME;
                        rx_error      <= "01";
                        state         <= IDLE_S;
                    end if;

                when DATA_S =>
                    if (bit_timer = 0) then
                        if (bit_counter = 0) then
                            bit_timer   <= STOP_BIT_TIME;
                            state       <= STOP_S;
                            bit_counter <= DATA_BITS;
                        else
                            bit_timer   <= DATA_BIT_TIME;
                            bit_counter <= bit_counter - 1;
                        end if;

                        shift_reg <= rx & shift_reg(7 downto 1);
                    else
                        bit_timer <= bit_timer - 1;
                    end if;

                -- TODO: wait half data bit time (a little bit more, on a new state DATA_S->NEW_STATE->STOP_S),
                -- TODO: then wait DATA_BIT_TIME*NUM_STOP_BITS (a little bit less) while
                -- TODO: sampling the rx. If rx stays at HIGH during that time,
                -- TODO: transaction is correct. If not, again wait but set the 1st bit of rx_error.
                when STOP_S =>
                    if (bit_timer = 0) then
                        rx_dout   <= shift_reg;
                        state     <= IDLE_S;
                        rx_done   <= '1';
                        bit_timer <= HALF_DATA_BIT_TIME;
                    else
                        bit_timer <= bit_timer - 1;
                    end if;

                when others =>
                    shift_reg   <= (others => '0');
                    bit_counter <= DATA_BITS;
                    bit_timer   <= HALF_DATA_BIT_TIME;
                    rx_error    <= (others => '0');
                    state       <= IDLE_S;

            end case;
        end if;
    end process PROC_UART_RX;

end Behavioral;
