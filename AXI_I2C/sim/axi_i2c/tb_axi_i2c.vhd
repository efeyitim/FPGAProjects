---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   31.08.2023
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    31.08.2023          v1.0 Initial Release
---------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_axi_i2c is

end entity tb_axi_i2c;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_axi_i2c is

    -- component generics
    constant C_FAMILY              : string  := virtex6;
    constant C_S_AXI_ADDR_WIDTH    : integer := 9;
    constant C_S_AXI_DATA_WIDTH    : integer := 32;
    constant C_I2C_FREQ            : integer := 100000;
    constant C_TEN_BIT_ADR         : integer := 0;
    constant C_GPO_WIDTH           : integer := 1;
    constant C_S_AXI_ACLK_FREQ_HZ  : integer := 25000000;
    constant C_SCL_INERTIAL_DELAY  : integer := 0;
    constant C_SDA_INTERTIAL_DELAY : integer := 0;
    constant C_SDA_LEVEL           : integer := 1;

    -- component ports
    signal clk           : std_logic                                           := '0';
    signal rst_n         : std_logic                                           := '0';
    signal I2C2INTC_Irpt : std_logic;
    signal S_AXI_AWADDR  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0)     := (others => '0');
    signal S_AXI_AWPROT  : std_logic_vector(2 downto 0)                        := (others => '0');
    signal S_AXI_AWVALID : std_logic                                           := '0';
    signal S_AXI_AWREADY : std_logic;
    signal S_AXI_WDATA   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)     := (others => '0');
    signal S_AXI_WSTRB   : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0) := (others => '1');
    signal S_AXI_WVALID  : std_logic                                           := '0';
    signal S_AXI_WREADY  : std_logic;
    signal S_AXI_BRESP   : std_logic_vector(1 downto 0);
    signal S_AXI_BVALID  : std_logic;
    signal S_AXI_BREADY  : std_logic                                           := '0';
    signal S_AXI_ARADDR  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0)     := (others => '0');
    signal S_AXI_ARPROT  : std_logic_vector(2 downto 0)                        := (others => '0');
    signal S_AXI_ARVALID : std_logic                                           := '0';
    signal S_AXI_ARREADY : std_logic;
    signal S_AXI_RDATA   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_RRESP   : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID  : std_logic;
    signal S_AXI_RREADY  : std_logic                                           := '0';
    signal SDA_I         : std_logic                                           := '0';
    signal SDA_O         : std_logic;
    signal SDA_T         : std_logic;
    signal SCL_I         : std_logic                                           := '0';
    signal SCL_O         : std_logic;
    signal SCL_T         : std_logic;
    signal GPO           : std_logic_vector(C_GPO_WIDTH - 1 downto 0);


    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

begin  -- architecture tb

    -- component instantiation
    U_DUT : entity work.axi_i2c
        generic map (
            C_FAMILY              => C_FAMILY,
            C_S_AXI_ADDR_WIDTH    => C_S_AXI_ADDR_WIDTH,
            C_S_AXI_DATA_WIDTH    => C_S_AXI_DATA_WIDTH,
            C_I2C_FREQ            => C_I2C_FREQ,
            C_TEN_BIT_ADR         => C_TEN_BIT_ADR,
            C_GPO_WIDTH           => C_GPO_WIDTH,
            C_S_AXI_ACLK_FREQ_HZ  => C_S_AXI_ACLK_FREQ_HZ,
            C_SCL_INERTIAL_DELAY  => C_SCL_INERTIAL_DELAY,
            C_SDA_INTERTIAL_DELAY => C_SDA_INTERTIAL_DELAY,
            C_SDA_LEVEL           => C_SDA_LEVEL)
        port map (
            S_AXI_ACLK            => clk,
            S_AXI_ARESETN         => rst_n,
            I2C2INTC_Irpt         => I2C2INTC_Irpt,
            S_AXI_AWADDR          => S_AXI_AWADDR,
            S_AXI_AWPROT          => S_AXI_AWPROT,
            S_AXI_AWVALID         => S_AXI_AWVALID,
            S_AXI_AWREADY         => S_AXI_AWREADY,
            S_AXI_WDATA           => S_AXI_WDATA,
            S_AXI_WSTRB           => S_AXI_WSTRB,
            S_AXI_WVALID          => S_AXI_WVALID,
            S_AXI_WREADY          => S_AXI_WREADY,
            S_AXI_BRESP           => S_AXI_BRESP,
            S_AXI_BVALID          => S_AXI_BVALID,
            S_AXI_BREADY          => S_AXI_BREADY,
            S_AXI_ARADDR          => S_AXI_ARADDR,
            S_AXI_ARPROT          => S_AXI_ARPROT,
            S_AXI_ARVALID         => S_AXI_ARVALID,
            S_AXI_ARREADY         => S_AXI_ARREADY,
            S_AXI_RDATA           => S_AXI_RDATA,
            S_AXI_RRESP           => S_AXI_RRESP,
            S_AXI_RVALID          => S_AXI_RVALID,
            S_AXI_RREADY          => S_AXI_RREADY,
            SDA_I                 => SDA_I,
            SDA_O                 => SDA_O,
            SDA_T                 => SDA_T,
            SCL_I                 => SCL_I,
            SCL_O                 => SCL_O,
            SCL_T                 => SCL_T,
            GPO                   => GPO);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        rst_n <= '0';
        waitNre(clk, 10);
        rst_n <= '1';
        waitNre(clk, 10);
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

