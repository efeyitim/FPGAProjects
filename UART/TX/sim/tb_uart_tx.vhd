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

entity tb_uart_tx is

end entity tb_uart_tx;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_uart_tx is

    -- component generics
    constant CLK_FREQ      : integer := 50_000_000;
    constant BAUD_RATE     : integer := 115_200;
    constant NUM_DATA_BITS : integer := 8;
    constant NUM_STOP_BITS : integer := 1;
    constant ENABLE_PARITY : boolean := false;
    constant ODD_PARITY    : boolean := false;

    -- component ports
    signal clk      : std_logic                                     := '0';
    signal rst_n    : std_logic                                     := '0';
    signal tx_din   : std_logic_vector (NUM_DATA_BITS - 1 downto 0) := (others => '0');
    signal tx_start : std_logic                                     := '0';
    signal tx       : std_logic;
    signal tx_busy  : std_logic;
    signal tx_done  : std_logic;


    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

    procedure send_byte (
        constant byte_in : in  std_logic_vector(NUM_DATA_BITS - 1 downto 0);
        signal busy_tx   : in  std_logic;
        signal din_tx    : out std_logic_vector(NUM_DATA_BITS - 1 downto 0);
        signal start_tx  : out std_logic
        ) is
    begin
        din_tx   <= byte_in;
        start_tx <= '1';
        wait until rising_edge(tx_busy);
        start_tx <= '0';
        wait until busy_tx = '0';
    end send_byte;

begin  -- architecture tb

    -- component instantiation
    U_DUT : entity work.uart_tx
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
            tx_din        => tx_din,
            tx_start      => tx_start,
            tx            => tx,
            tx_busy       => tx_busy,
            tx_done       => tx_done);

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
        send_byte(x"A5", tx_busy, tx_din, tx_start);
        send_byte(x"C3", tx_busy, tx_din, tx_start);
        send_byte(x"F1", tx_busy, tx_din, tx_start);
        send_byte(x"00", tx_busy, tx_din, tx_start);
        waitNre(clk, 100);
        report "SIM DONE" severity failure;
        wait;
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

