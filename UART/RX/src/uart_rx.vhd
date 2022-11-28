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
        ENABLE_PARITY : boolean := false;
        ODD_PARITY    : boolean := true;
        NUM_DATA_BITS : integer := 8;
        NUM_STOP_BITS : integer := 1
        );

    port (
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        rx       : in  std_logic;
        rx_dout  : out std_logic_vector (NUM_DATA_BITS - 1 downto 0);
        rx_done  : out std_logic;
        rx_error : out std_logic_vector(2 downto 0)                   -- 2nd bit parity error, 1st bit for stop error, 0th bit for start error
        );
end uart_rx;

architecture Behavioral of uart_rx is

    constant DATA_BIT_TIME      : unsigned(31 downto 0) := to_unsigned(CLK_FREQ / BAUD_RATE, 32);
    constant HALF_DATA_BIT_TIME : unsigned(31 downto 0) := to_unsigned(CLK_FREQ / BAUD_RATE / 2, 32);
    constant STOP_BIT_TIME      : unsigned(31 downto 0) := to_unsigned((CLK_FREQ / BAUD_RATE) * NUM_STOP_BITS, 32);
    constant DATA_BITS          : unsigned(3 downto 0)  := to_unsigned(NUM_DATA_BITS - 1, 4);

    type t_state is (IDLE_S,                                          -- idle state
                     START_S,                                         -- wait half baud rate before start bit
                     STOP_S,                                          -- stop bit
                     DATA_S,                                          -- data bits
                     PARITY_S,                                        -- parity bit
                     WAIT_STOP_S);                                    -- wait half baud rate before stop bit
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

    PROC_UART_RX : process (clk, rst_n)
    begin
        if rst_n = '0' then
            rx_dout     <= (others => '0');
            shift_reg   <= (others => '0');
            bit_counter <= DATA_BITS;
            bit_timer   <= HALF_DATA_BIT_TIME;
            rx_error    <= (others => '0');
            rx_done     <= '0';
            data_parity <= '0';
            state       <= IDLE_S;

        elsif (rising_edge(clk)) then

            data_parity <= reduce_xor(shift_reg);

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
                        rx_error(0)   <= '1';
                        state         <= IDLE_S;
                    end if;

                when DATA_S =>
                    if (bit_timer = 0) then
                        if (bit_counter = 0) then
                            if ENABLE_PARITY then
                                bit_timer   <= DATA_BIT_TIME;
                                state       <= PARITY_S;
                                bit_counter <= DATA_BITS;
                            end if;

                            if not ENABLE_PARITY then
                                bit_timer   <= HALF_DATA_BIT_TIME;
                                state       <= WAIT_STOP_S;
                                bit_counter <= DATA_BITS;
                            end if;
                        else
                            bit_timer       <= DATA_BIT_TIME;
                            bit_counter     <= bit_counter - 1;
                        end if;
                        shift_reg           <= rx & shift_reg(shift_reg'high downto 1);
                    else
                        bit_timer           <= bit_timer - 1;
                    end if;

                when PARITY_S =>
                    if bit_timer = 0 then
                        if ODD_PARITY then
                            if not ((data_parity = '0' and rx = '1') or (data_parity = '1' and rx = '0')) then
                                rx_error(2) <= '1';
                            end if;
                            bit_timer       <= HALF_DATA_BIT_TIME;
                            state           <= WAIT_STOP_S;
                        end if;
                        if not ODD_PARITY then
                            if (data_parity = '0' and rx = '1') or (data_parity = '1' and rx = '0') then
                                rx_error(2) <= '1';
                            end if;
                            bit_timer       <= HALF_DATA_BIT_TIME;
                            state           <= WAIT_STOP_S;
                        end if;
                    else
                        bit_timer           <= bit_timer - 1;
                    end if;

                when WAIT_STOP_S =>
                    if (bit_timer = 0) then
                        bit_timer <= STOP_BIT_TIME;
                        state     <= STOP_S;
                    else
                        bit_timer <= bit_timer - 1;
                    end if;

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
                    rx_dout     <= (others => '0');
                    shift_reg   <= (others => '0');
                    bit_counter <= DATA_BITS;
                    bit_timer   <= HALF_DATA_BIT_TIME;
                    rx_error    <= (others => '0');
                    rx_done     <= '0';
                    data_parity <= '0';
                    state       <= IDLE_S;

            end case;
        end if;
    end process PROC_UART_RX;

end Behavioral;
