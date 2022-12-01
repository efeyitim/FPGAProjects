---------------------------------------------------------------------------------------------------
--  Project Name        :   ADS1115
--  System/Block Name   :   Top module for ADS1115
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   01.12.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    01.12.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADS1115_top is

    port (
        sys_clk : in    std_logic;                                    -- system clock
        tx      : out   std_logic;
        scl     : inout std_logic;                                    -- sda
        sda     : inout std_logic                                     -- scl
        );

end entity ADS1115_top;

architecture rtl of ADS1115_top is

    attribute mark_debug        : string;
    attribute mark_debug of tx  : signal is "true";

    component i2c_controller_ads1115 is
        port (
            clk        : in  std_logic;
            rst_n      : in  std_logic;
            busy       : in  std_logic;
            data_rd    : in  std_logic_vector(7 downto 0);
            fifo_full  : in  std_logic;
            ena        : out std_logic;
            addr       : out std_logic_vector(6 downto 0);
            rw         : out std_logic;
            data_wr    : out std_logic_vector(7 downto 0);
            fifo_wrreq : out std_logic;
            fifo_data  : out std_logic_vector(15 downto 0));
    end component i2c_controller_ads1115;

    component i2c_interface is
        generic (
            CLK_FREQ  :       integer;
            I2C_FREQ  :       integer);
        port (
            clk       : in    std_logic;
            rst_n     : in    std_logic;
            ena       : in    std_logic;
            addr      : in    std_logic_vector(6 downto 0);
            rw        : in    std_logic;
            data_wr   : in    std_logic_vector(7 downto 0);
            busy      : out   std_logic;
            data_rd   : out   std_logic_vector(7 downto 0);
            ack_error : out   std_logic;
            sda       : inout std_logic;
            scl       : inout std_logic);
    end component i2c_interface;

    component uart_tx is
        generic (
            CLK_FREQ      :     integer;
            BAUD_RATE     :     integer;
            ENABLE_PARITY :     boolean := false;
            ODD_PARITY    :     boolean := true;
            NUM_DATA_BITS :     integer;
            NUM_STOP_BITS :     integer);
        port (
            clk           : in  std_logic;
            rst_n         : in  std_logic;
            tx_din        : in  std_logic_vector (7 downto 0);
            tx_start      : in  std_logic;
            tx            : out std_logic;
            tx_busy       : out std_logic;
            tx_done       : out std_logic);
    end component uart_tx;

    component uart_tx_controller is
        generic (
            NUM_DATA_BITS :     integer);
        port (
            clk           : in  std_logic;
            rst_n         : in  std_logic;
            tx_busy       : in  std_logic;
            fifo_rdempty  : in  std_logic;
            fifo_q        : in  std_logic_vector(NUM_DATA_BITS - 1 downto 0);
            fifo_rdreq    : out std_logic;
            tx_din        : out std_logic_vector(NUM_DATA_BITS - 1 downto 0);
            tx_start      : out std_logic);
    end component uart_tx_controller;

    component uart_tx_fifo is
        port (
            clk   : in  std_logic;
            srst  : in  std_logic;
            din   : in  std_logic_vector(15 downto 0);
            wr_en : in  std_logic;
            rd_en : in  std_logic;
            dout  : out std_logic_vector(7 downto 0);
            full  : out std_logic;
            empty : out std_logic);
    end component uart_tx_fifo;

    component pll_125_to_100 is
        port (
            clk_in1  : in  std_logic;
            reset    : in  std_logic;
            clk_out1 : out std_logic;
            locked   : out std_logic);
    end component pll_125_to_100;

    signal logic_0 : std_logic;
    signal clk     : std_logic;
    signal rst_n   : std_logic;

    signal i2c_busy                       : std_logic;
    attribute mark_debug of i2c_busy      : signal is "true";
    signal i2c_data_rd                    : std_logic_vector(7 downto 0);
    attribute mark_debug of i2c_data_rd   : signal is "true";
    signal i2c_ack_error                  : std_logic;
    attribute mark_debug of i2c_ack_error : signal is "true";
    signal i2c_ena                        : std_logic;
    attribute mark_debug of i2c_ena       : signal is "true";
    signal i2c_addr                       : std_logic_vector(6 downto 0);
    attribute mark_debug of i2c_addr      : signal is "true";
    signal i2c_rw                         : std_logic;
    attribute mark_debug of i2c_rw        : signal is "true";
    signal i2c_data_wr                    : std_logic_vector(7 downto 0);
    attribute mark_debug of i2c_data_wr   : signal is "true";

    signal fifo_wrreq                    : std_logic;
    attribute mark_debug of fifo_wrreq   : signal is "true";
    signal fifo_wrfull                   : std_logic;
    attribute mark_debug of fifo_wrfull  : signal is "true";
    signal fifo_data                     : std_logic_vector(15 downto 0);
    attribute mark_debug of fifo_data    : signal is "true";
    signal fifo_rdreq                    : std_logic;
    attribute mark_debug of fifo_rdreq   : signal is "true";
    signal fifo_rdempty                  : std_logic;
    attribute mark_debug of fifo_rdempty : signal is "true";
    signal fifo_q                        : std_logic_vector(7 downto 0);
    attribute mark_debug of fifo_q       : signal is "true";

    signal tx_start                  : std_logic;
    attribute mark_debug of tx_start : signal is "true";
    signal tx_busy                   : std_logic;
    attribute mark_debug of tx_busy  : signal is "true";
    signal tx_done                   : std_logic;
    attribute mark_debug of tx_done  : signal is "true";
    signal tx_din                    : std_logic_vector(7 downto 0);
    attribute mark_debug of tx_din   : signal is "true";

    signal rst : std_logic;

begin

    logic_0 <= '0';
    rst     <= not rst_n;

    U_0 : i2c_controller_ads1115
        port map (
            clk        => clk,
            rst_n      => rst_n,
            busy       => i2c_busy,
            data_rd    => i2c_data_rd,
            fifo_full  => fifo_wrfull,
            ena        => i2c_ena,
            addr       => i2c_addr,
            rw         => i2c_rw,
            data_wr    => i2c_data_wr,
            fifo_wrreq => fifo_wrreq,
            fifo_data  => fifo_data);

    U_1 : i2c_interface
        generic map (
            CLK_FREQ  => 100000000,
            I2C_FREQ  => 200000)
        port map (
            clk       => clk,
            rst_n     => rst_n,
            ena       => i2c_ena,
            addr      => i2c_addr,
            rw        => i2c_rw,
            data_wr   => i2c_data_wr,
            busy      => i2c_busy,
            data_rd   => i2c_data_rd,
            ack_error => i2c_ack_error,
            sda       => sda,
            scl       => scl);

    U_2 : uart_tx
        generic map (
            CLK_FREQ      => 100000000,
            BAUD_RATE     => 115200,
            ENABLE_PARITY => false,
            ODD_PARITY    => true,
            NUM_DATA_BITS => 8,
            NUM_STOP_BITS => 1)
        port map (
            clk           => clk,
            rst_n         => rst_n,
            tx_din        => tx_din,
            tx_start      => tx_start,
            tx            => tx,
            tx_busy       => tx_busy,
            tx_done       => tx_done);

    U_3 : uart_tx_controller
        generic map (
            NUM_DATA_BITS => 8)
        port map (
            clk           => clk,
            rst_n         => rst_n,
            tx_busy       => tx_busy,
            fifo_rdempty  => fifo_rdempty,
            fifo_q        => fifo_q,
            fifo_rdreq    => fifo_rdreq,
            tx_din        => tx_din,
            tx_start      => tx_start);

    U_4 : uart_tx_fifo
        port map (
            clk   => clk,
            srst  => rst,
            din   => fifo_data,
            wr_en => fifo_wrreq,
            rd_en => fifo_rdreq,
            dout  => fifo_q,
            full  => fifo_wrfull,
            empty => fifo_rdempty);

    U_5 : pll_125_to_100
        port map (
            clk_in1  => sys_clk,
            reset    => logic_0,
            clk_out1 => clk,
            locked   => rst_n);

end architecture rtl;
