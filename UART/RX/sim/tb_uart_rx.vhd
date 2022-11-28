---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
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

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_uart_rx is

end entity tb_uart_rx;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_uart_rx is

    -- component generics
    constant CLK_FREQ      : integer := 50_000_000;
    constant BAUD_RATE     : integer := 115_200;
    constant NUM_DATA_BITS : integer := 8;
    constant NUM_STOP_BITS : integer := 1;
    constant ENABLE_PARITY : boolean := true;
    constant ODD_PARITY    : boolean := true;
    constant DATA_BIT_TIME : integer := CLK_FREQ / BAUD_RATE;

    -- component ports
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    signal rx       : std_logic := '1';
    signal rx_dout  : std_logic_vector (NUM_DATA_BITS - 1 downto 0);
    signal rx_done  : std_logic;
    signal rx_error : std_logic_vector(2 downto 0);

    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

    -- -2008 use unitary AND without parameter instead of call:
    function reduce_xor (inp : std_logic_vector) return std_logic is
        variable retval      : std_logic := '0';
    begin
        for i in inp'range loop
            retval                       := retval xor inp(i);
        end loop;
        return retval;
    end function;

    procedure send_byte (
        constant byte_in : in  std_logic_vector;
        signal rx_p      : out std_logic
        ) is
    begin
        rx_p         <= '0';
        waitNre(clk, DATA_BIT_TIME);
        for i in byte_in'range loop
            rx_p     <= byte_in(i);
            waitNre(clk, DATA_BIT_TIME);
        end loop;
        if ENABLE_PARITY then
            if ODD_PARITY then
                rx_p <= not reduce_xor(byte_in);
            end if;
            if not ODD_PARITY then
                rx_p <= reduce_xor(byte_in);
            end if;
            waitNre(clk, DATA_BIT_TIME);
        end if;
        rx_p         <= '1';
        waitNre(clk, DATA_BIT_TIME);
    end send_byte;

begin  -- architecture tb

    -- component instantiation
    U_DUT : entity work.uart_rx
        generic map (
            CLK_FREQ      => CLK_FREQ,
            BAUD_RATE     => BAUD_RATE,
            ENABLE_PARITY => ENABLE_PARITY,
            ODD_PARITY    => ODD_PARITY,
            NUM_DATA_BITS => NUM_DATA_BITS,
            NUM_STOP_BITS => NUM_STOP_BITS)
        port map (
            clk           => clk,
            rst_n         => rst_n,
            rx            => rx,
            rx_dout       => rx_dout,
            rx_done       => rx_done,
            rx_error      => rx_error);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        rst_n <= '0';
        waitNre(clk, 5);
        rst_n <= '1';
        waitNre(clk, 100);
        rx    <= '0';
        waitNre(clk, 50);
        rx    <= '1';
        waitNre(clk, 1000);
        send_byte(x"A5", rx);
        waitNre(clk, 100);
        send_byte(x"C3", rx);
        waitNre(clk, 100);
        send_byte(x"F1", rx);
        waitNre(clk, 100);
        send_byte(x"00", rx);
        waitNre(clk, 100);
        report "SIM DONE" severity failure;
        wait;
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

