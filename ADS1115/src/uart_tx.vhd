---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   UART TX
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

entity uart_tx is
    generic (
        CLK_FREQ      : integer := 50_000_000;
        BAUD_RATE     : integer := 115_200;
        ENABLE_PARITY : boolean := false;
        ODD_PARITY    : boolean := true;
        NUM_DATA_BITS : integer := 8;
        NUM_STOP_BITS : integer := 1
        );

    port (
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        tx_din   : in  std_logic_vector (NUM_DATA_BITS - 1 downto 0);
        tx_start : in  std_logic;
        tx       : out std_logic;
        tx_busy  : out std_logic;
        tx_done  : out std_logic
        );
end uart_tx;

architecture Behavioral of uart_tx is

    constant DATA_BIT_TIME : unsigned(31 downto 0) := to_unsigned(CLK_FREQ / BAUD_RATE, 32);
    constant STOP_BIT_TIME : unsigned(31 downto 0) := to_unsigned((CLK_FREQ / BAUD_RATE) * NUM_STOP_BITS, 32);
    constant DATA_BITS     : unsigned(3 downto 0)  := to_unsigned(NUM_DATA_BITS - 1, 4);

    type t_state is (IDLE_S,                                          -- idle state
                     START_S,                                         -- start bit
                     STOP_S,                                          -- stop bit
                     DATA_S,                                          -- data bits
                     PARITY_S);                                       -- parity bit
    signal state : t_state;

    signal bit_timer   : unsigned(31 downto 0);
    signal bit_counter : unsigned(3 downto 0);
    signal shift_reg   : std_logic_vector (NUM_DATA_BITS - 1 downto 0);
    signal data_parity : std_logic;

    -- -2008 use unitary AND without parameter instead of call:
    function reduce_xor (inp : std_logic_vector) return std_logic is
        variable retval      : std_logic := '0';
    begin
        for i in inp'range loop
            retval                       := retval xor inp(i);
        end loop;
        return retval;
    end function;

begin

    PROC_UART_TX : process (clk, rst_n)
    begin
        if rst_n = '0' then
            shift_reg   <= (others => '0');
            bit_counter <= DATA_BITS;
            bit_timer   <= DATA_BIT_TIME;
            tx_done     <= '0';
            tx          <= '1';
            tx_busy     <= '0';
            data_parity <= '0';
            state       <= IDLE_S;

        elsif (rising_edge(clk)) then

            data_parity <= reduce_xor(shift_reg);

            case state is

                when IDLE_S =>
                    tx_done       <= '0';
                    if (tx_start = '1') then
                        state     <= START_S;
                        tx        <= '0';
                        tx_busy   <= '1';
                        shift_reg <= tx_din;
                    else
                        tx        <= '1';
                    end if;

                when START_S =>
                    if (bit_timer = 0) then
                        state                                   <= DATA_S;
                        tx                                      <= shift_reg(0);
                        shift_reg (shift_reg'high)              <= shift_reg(0);
                        shift_reg (shift_reg'high - 1 downto 0) <= shift_reg(shift_reg'high downto 1);
                        bit_timer                               <= DATA_BIT_TIME;
                    else
                        bit_timer                               <= bit_timer - 1;
                    end if;

                when DATA_S =>
                    if (bit_counter = 0) then
                        if (bit_timer = 0) then
                            bit_counter <= DATA_BITS;

                            if ENABLE_PARITY then
                                if ODD_PARITY then
                                    tx                              <= not data_parity;
                                end if;
                                if not ODD_PARITY then
                                    tx                              <= data_parity;
                                end if;
                                bit_timer                           <= DATA_BIT_TIME;
                                state                               <= PARITY_S;
                            end if;
                            if not ENABLE_PARITY then
                                tx                                  <= '1';
                                bit_timer                           <= STOP_BIT_TIME;
                                state                               <= STOP_S;
                            end if;
                        else
                            bit_timer                               <= bit_timer - 1;
                        end if;
                    else
                        if (bit_timer = 0) then
                            tx                                      <= shift_reg(0);
                            shift_reg (shift_reg'high)              <= shift_reg(0);
                            shift_reg (shift_reg'high - 1 downto 0) <= shift_reg(shift_reg'high downto 1);
                            bit_counter                             <= bit_counter - 1;
                            bit_timer                               <= DATA_BIT_TIME;
                        else
                            bit_timer                               <= bit_timer - 1;
                        end if;
                    end if;

                when PARITY_S =>
                    if (bit_timer = 0) then
                        state     <= STOP_S;
                        tx        <= '1';
                        bit_timer <= STOP_BIT_TIME;
                    else
                        bit_timer <= bit_timer - 1;
                    end if;


                when STOP_S =>
                    if (bit_timer = 0) then
                        state     <= IDLE_S;
                        tx_busy   <= '0';
                        tx_done   <= '1';
                        bit_timer <= DATA_BIT_TIME;
                    else
                        bit_timer <= bit_timer - 1;
                    end if;

                when others =>
                    shift_reg   <= (others => '0');
                    bit_counter <= DATA_BITS;
                    bit_timer   <= DATA_BIT_TIME;
                    tx_done     <= '0';
                    tx          <= '1';
                    tx_busy     <= '0';
                    data_parity <= '0';
                    state       <= IDLE_S;

            end case;
        end if;
    end process PROC_UART_TX;
end Behavioral;
