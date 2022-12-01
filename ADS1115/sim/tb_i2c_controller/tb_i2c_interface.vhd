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

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_i2c_interface is

end entity tb_i2c_interface;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_i2c_interface is

    -- component generics
    constant CLK_FREQ : integer := 50_000_000;
    constant I2C_FREQ : integer := 200_000;

    -- component ports
    signal clk       : std_logic                    := '0';
    signal rst_n     : std_logic                    := '0';
    signal ena       : std_logic;
    signal addr      : std_logic_vector(6 downto 0);
    signal rw        : std_logic;
    signal data_wr   : std_logic_vector(7 downto 0);
    signal busy      : std_logic;
    signal data_rd   : std_logic_vector(7 downto 0);
    signal ack_error : std_logic;
    signal sda       : std_logic;
    signal scl       : std_logic;


    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

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

    signal logic_0    : std_logic := '0';
    signal fifo_wrreq : std_logic;
    signal fifo_data  : std_logic_vector(15 downto 0);

begin  -- architecture tb

    -- component instantiation
    U_0 : i2c_controller_ads1115
        port map (
            clk        => clk,
            rst_n      => rst_n,
            busy       => busy,
            data_rd    => data_rd,
            fifo_full  => logic_0,
            ena        => ena,
            addr       => addr,
            rw         => rw,
            data_wr    => data_wr,
            fifo_wrreq => fifo_wrreq,
            fifo_data  => fifo_data);

    U_DUT : i2c_interface
        generic map (
            CLK_FREQ  => CLK_FREQ,
            I2C_FREQ  => I2C_FREQ)
        port map (
            clk       => clk,
            rst_n     => rst_n,
            ena       => ena,
            addr      => addr,
            rw        => rw,
            data_wr   => data_wr,
            busy      => busy,
            data_rd   => data_rd,
            ack_error => ack_error,
            sda       => sda,
            scl       => scl);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        rst_n   <= '0';
        sda     <= 'Z';
        scl     <= 'Z';
        waitNre(clk, 5);
        rst_n   <= '1';
        waitNre(clk, 100000);
        report "SIM DONE" severity failure;
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

