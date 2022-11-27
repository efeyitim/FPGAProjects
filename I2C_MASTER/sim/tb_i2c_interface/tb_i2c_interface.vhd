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
    constant CLK_FREQ : integer := 25_000_000;
    constant I2C_FREQ : integer := 400_000;

    -- component ports
    signal clk       : std_logic                    := '0';
    signal rst_n     : std_logic                    := '0';
    signal ena       : std_logic                    := '0';
    signal addr      : std_logic_vector(6 downto 0) := (others => '0');
    signal rw        : std_logic                    := '0';
    signal data_wr   : std_logic_vector(7 downto 0) := (others => '0');
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

begin  -- architecture tb

    -- component instantiation
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
        waitNre(clk, 5);
        ena     <= '1';
        addr    <= "0101010";
        rw      <= '0';                                               -- write        
        data_wr <= x"C3";
        wait until rising_edge(busy);
        ena     <= '0';
        wait until falling_edge(busy);
        waitNre(clk, 10);
        report "SIM DONE" severity failure;
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

