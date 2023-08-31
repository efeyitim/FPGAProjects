-------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   31.08.2023
--  Short Description   :   
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    31.08.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_axi_drp is

end entity tb_axi_drp;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_axi_drp is

    -- component generics
    constant DRP_ADDR_WIDTH     : integer := 16;
    constant DRP_DATA_WIDTH     : integer := 16;
    constant C_S_AXI_DATA_WIDTH : integer := 32;
    constant C_S_AXI_ADDR_WIDTH : integer := 5;

    -- component ports
    signal drp_addr      : std_logic_vector(DRP_ADDR_WIDTH - 1 downto 0);
    signal drp_di        : std_logic_vector(DRP_DATA_WIDTH - 1 downto 0);
    signal drp_do        : std_logic_vector(DRP_DATA_WIDTH - 1 downto 0)       := (others => '0');
    signal drp_we        : std_logic;
    signal drp_en        : std_logic;
    signal drp_rdy       : std_logic                                           := '0';
    signal clk           : std_logic                                           := '0';
    signal rst_n         : std_logic                                           := '0';
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
    signal S_AXI_BREADY  : std_logic                                           := '1';
    signal S_AXI_ARADDR  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0)     := (others => '0');
    signal S_AXI_ARPROT  : std_logic_vector(2 downto 0)                        := (others => '0');
    signal S_AXI_ARVALID : std_logic                                           := '0';
    signal S_AXI_ARREADY : std_logic;
    signal S_AXI_RDATA   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_RRESP   : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID  : std_logic;
    signal S_AXI_RREADY  : std_logic                                           := '1';

    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

    procedure AXI_WRITE_ADDR(
        signal axi_awaddr   : out std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
        constant addr_value : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
        signal axi_awvalid  : out std_logic;
        signal axi_awready  : in  std_logic
        ) is
    begin
        axi_awaddr  <= addr_value;
        axi_awvalid <= '1';
        waitNre(clk, 1);
        wait until axi_awready = '1';
        waitNre(clk, 1);
        axi_awvalid <= '0';
    end AXI_WRITE_ADDR;

    procedure AXI_WRITE_DATA(
        signal axi_wdata    : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
        constant data_value : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
        signal axi_wvalid   : out std_logic;
        signal axi_wready   : in  std_logic
        ) is
    begin
        axi_wdata  <= data_value;
        axi_wvalid <= '1';
        waitNre(clk, 1);
        wait until axi_wready = '1';
        waitNre(clk, 1);
        axi_wvalid <= '0';
    end AXI_WRITE_DATA;

    procedure AXI_WRITE(
        signal axi_awaddr   : out std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
        constant addr_value : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
        signal axi_wdata    : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
        constant data_value : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
        signal axi_awvalid  : out std_logic;
        signal axi_awready  : in  std_logic;
        signal axi_wvalid   : out std_logic;
        signal axi_wready   : in  std_logic
        ) is
    begin
        axi_awaddr  <= addr_value;
        axi_awvalid <= '1';
        axi_wdata   <= data_value;
        axi_wvalid  <= '1';
        waitNre(clk, 1);
        wait until axi_awready = '1';
        waitNre(clk, 1);
        axi_awvalid <= '0';
        axi_wvalid  <= '0';
        waitNre(clk, 5);
    end AXI_WRITE;

    component axi_drp is
        generic (
            DRP_ADDR_WIDTH     :     integer;
            DRP_DATA_WIDTH     :     integer;
            C_S_AXI_DATA_WIDTH :     integer;
            C_S_AXI_ADDR_WIDTH :     integer);
        port (
            drp_addr           : out std_logic_vector(DRP_ADDR_WIDTH - 1 downto 0);
            drp_di             : out std_logic_vector(DRP_DATA_WIDTH - 1 downto 0);
            drp_do             : in  std_logic_vector(DRP_DATA_WIDTH - 1 downto 0);
            drp_we             : out std_logic;
            drp_en             : out std_logic;
            drp_rdy            : in  std_logic;
            S_AXI_ACLK         : in  std_logic;
            S_AXI_ARESETN      : in  std_logic;
            S_AXI_AWADDR       : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_AWPROT       : in  std_logic_vector(2 downto 0);
            S_AXI_AWVALID      : in  std_logic;
            S_AXI_AWREADY      : out std_logic;
            S_AXI_WDATA        : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_WSTRB        : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S_AXI_WVALID       : in  std_logic;
            S_AXI_WREADY       : out std_logic;
            S_AXI_BRESP        : out std_logic_vector(1 downto 0);
            S_AXI_BVALID       : out std_logic;
            S_AXI_BREADY       : in  std_logic;
            S_AXI_ARADDR       : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_ARPROT       : in  std_logic_vector(2 downto 0);
            S_AXI_ARVALID      : in  std_logic;
            S_AXI_ARREADY      : out std_logic;
            S_AXI_RDATA        : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_RRESP        : out std_logic_vector(1 downto 0);
            S_AXI_RVALID       : out std_logic;
            S_AXI_RREADY       : in  std_logic);
    end component axi_drp;

begin  -- architecture tb

    -- component instantiation
    U_DUT : axi_drp
        generic map (
            DRP_ADDR_WIDTH     => DRP_ADDR_WIDTH,
            DRP_DATA_WIDTH     => DRP_DATA_WIDTH,
            C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH)
        port map (
            drp_addr           => drp_addr,
            drp_di             => drp_di,
            drp_do             => drp_do,
            drp_we             => drp_we,
            drp_en             => drp_en,
            drp_rdy            => drp_rdy,
            S_AXI_ACLK         => clk,
            S_AXI_ARESETN      => rst_n,
            S_AXI_AWADDR       => S_AXI_AWADDR,
            S_AXI_AWPROT       => S_AXI_AWPROT,
            S_AXI_AWVALID      => S_AXI_AWVALID,
            S_AXI_AWREADY      => S_AXI_AWREADY,
            S_AXI_WDATA        => S_AXI_WDATA,
            S_AXI_WSTRB        => S_AXI_WSTRB,
            S_AXI_WVALID       => S_AXI_WVALID,
            S_AXI_WREADY       => S_AXI_WREADY,
            S_AXI_BRESP        => S_AXI_BRESP,
            S_AXI_BVALID       => S_AXI_BVALID,
            S_AXI_BREADY       => S_AXI_BREADY,
            S_AXI_ARADDR       => S_AXI_ARADDR,
            S_AXI_ARPROT       => S_AXI_ARPROT,
            S_AXI_ARVALID      => S_AXI_ARVALID,
            S_AXI_ARREADY      => S_AXI_ARREADY,
            S_AXI_RDATA        => S_AXI_RDATA,
            S_AXI_RRESP        => S_AXI_RRESP,
            S_AXI_RVALID       => S_AXI_RVALID,
            S_AXI_RREADY       => S_AXI_RREADY);

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

        -- write 0x10 to the address register
        AXI_WRITE(S_AXI_AWADDR, "00000", S_AXI_WDATA, x"00000010", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        -- write 0xABCD to the data register
        AXI_WRITE(S_AXI_AWADDR, "00100", S_AXI_WDATA, x"0000ABCD", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        -- enable write operation
        AXI_WRITE(S_AXI_AWADDR, "01100", S_AXI_WDATA, x"00000001", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        -- start the drp operation, this bit is self-clearing
        AXI_WRITE(S_AXI_AWADDR, "10000", S_AXI_WDATA, x"00000001", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        waitNre(clk, 10);

        -- check busy
        AXI_WRITE_ADDR(S_AXI_ARADDR, "10100", S_AXI_ARVALID, S_AXI_ARREADY);

        waitNre(clk, 10);

        drp_rdy <= '1';
        waitNre(clk, 1);
        drp_rdy <= '0';

        -- check if still busy
        AXI_WRITE_ADDR(S_AXI_ARADDR, "10100", S_AXI_ARVALID, S_AXI_ARREADY);

        waitNre(clk, 10);

        report "SIM DONE" severity failure; wait;

    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

