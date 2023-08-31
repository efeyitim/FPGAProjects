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

entity tb_axi4_lite_slave is

end entity tb_axi4_lite_slave;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_axi4_lite_slave is

    -- component generics
    constant C_S_AXI_DATA_WIDTH : integer := 32;
    constant C_S_AXI_ADDR_WIDTH : integer := 5;

    -- component ports
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
        -- report "AXI_WRITE_ADDR: BEFORE WAIT" severity note;
        if axi_awready /= '1' then
            wait until axi_awready = '1';            
        end if;
        -- report "AXI_WRITE_ADDR: AFTER WAIT" severity note;
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
        if axi_wready /= '1' then
            wait until axi_wready = '1';            
        end if;
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
        if axi_awready /= '1' then
            wait until axi_awready = '1';            
        end if;
        waitNre(clk, 1);
        axi_awvalid <= '0';
        axi_wvalid  <= '0';
        waitNre(clk, 5);
    end AXI_WRITE;        

    component axi4_lite_slave is
        generic (
            C_S_AXI_DATA_WIDTH :     integer;
            C_S_AXI_ADDR_WIDTH :     integer);
        port (
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
    end component axi4_lite_slave;

begin  -- architecture tb

    -- component instantiation
    U_DUT : axi4_lite_slave
        generic map (
            C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH)
        port map (
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

        -- select 0th register
        AXI_WRITE_ADDR(S_AXI_AWADDR, "00000", S_AXI_AWVALID, S_AXI_AWREADY);

        -- write 0x00112233 to 1st register
        AXI_WRITE_DATA(S_AXI_WDATA, x"00112233", S_AXI_WVALID, S_AXI_WREADY);

        -- select 1st register
        AXI_WRITE_ADDR(S_AXI_AWADDR, "00100", S_AXI_AWVALID, S_AXI_AWREADY);

        -- write 0x44556677 to 2md register
        AXI_WRITE_DATA(S_AXI_WDATA, x"44556677", S_AXI_WVALID, S_AXI_WREADY);

        -- select 2th register
        AXI_WRITE_ADDR(S_AXI_AWADDR, "01000", S_AXI_AWVALID, S_AXI_AWREADY);

        -- write 0x8899AABB to 3rd register
        AXI_WRITE_DATA(S_AXI_WDATA, x"8899AABB", S_AXI_WVALID, S_AXI_WREADY);

        -- select 0th register
        AXI_WRITE_ADDR(S_AXI_AWADDR, "01100", S_AXI_AWVALID, S_AXI_AWREADY);

        -- write 0xCCDDEEFF to 4th register
        AXI_WRITE_DATA(S_AXI_WDATA, x"CCDDEEFF", S_AXI_WVALID, S_AXI_WREADY);

        -- write 0x33221100 to the 1st register
        AXI_WRITE(S_AXI_AWADDR, "00000", S_AXI_WDATA, x"33221100", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        -- write 0x77665544 to the 1st register
        AXI_WRITE(S_AXI_AWADDR, "00100", S_AXI_WDATA, x"77665544", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        -- write 0xBBAA9988 to the 2nd register
        AXI_WRITE(S_AXI_AWADDR, "01000", S_AXI_WDATA, x"BBAA9988", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        -- write 0xFFEEDDCC to the 4th register
        AXI_WRITE(S_AXI_AWADDR, "01100", S_AXI_WDATA, x"FFEEDDCC", S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WVALID, S_AXI_WREADY);

        waitNre(clk, 10);

        report "WRITE DONE" severity note;

        -- read 1st register
        AXI_WRITE_ADDR(S_AXI_ARADDR, "00000", S_AXI_ARVALID, S_AXI_ARREADY);
        wait until S_AXI_RVALID = '1';

        -- read 2nd register
        AXI_WRITE_ADDR(S_AXI_ARADDR, "00100", S_AXI_ARVALID, S_AXI_ARREADY);
        wait until S_AXI_RVALID = '1';

        -- read 3rd register
        AXI_WRITE_ADDR(S_AXI_ARADDR, "01000", S_AXI_ARVALID, S_AXI_ARREADY);
        wait until S_AXI_RVALID = '1';

        -- read 4th register
        AXI_WRITE_ADDR(S_AXI_ARADDR, "01100", S_AXI_ARVALID, S_AXI_ARREADY);
        wait until S_AXI_RVALID = '1';

        report "READ DONE" severity note;

        waitNre(clk, 10);
        
        report "SIM DONE" severity failure; wait;        

    end process PROC_STIMULI;


end architecture tb;
