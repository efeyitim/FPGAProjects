library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library xpm;
use xpm.vcomponents.all;

entity AXIR_FIFO is
    generic (
        -- Users to add parameters here
        READ_WIDTH       : natural := 32;
        READ_DEPTH       : natural := 1024;
        READ_COUNT_BITS  : natural := 10;
        WRITE_WIDTH      : natural := 32;
        WRITE_DEPTH      : natural := 1024;
        WRITE_COUNT_BITS : natural := 10;
        -- User parameters ends
        -- Do not modify the parameters beyond this line

        -- Width of ID for for write address, write data, read address and read data
        C_S_AXI_ID_WIDTH     :     integer := 1;
        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH   :     integer := 32;
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH   :     integer := 6;
        -- Width of optional user defined signal in write address channel
        C_S_AXI_AWUSER_WIDTH :     integer := 0;
        -- Width of optional user defined signal in read address channel
        C_S_AXI_ARUSER_WIDTH :     integer := 0;
        -- Width of optional user defined signal in write data channel
        C_S_AXI_WUSER_WIDTH  :     integer := 0;
        -- Width of optional user defined signal in read data channel
        C_S_AXI_RUSER_WIDTH  :     integer := 0;
        -- Width of optional user defined signal in write response channel
        C_S_AXI_BUSER_WIDTH  :     integer := 0
        );
    port (
        -- Users to add ports here
        core_clk             : in  std_logic;                         -- core clock
        wrreq                : in  std_logic;
        data                 : in  std_logic_vector(WRITE_WIDTH - 1 downto 0);
        wrcount              : out std_logic_vector(WRITE_COUNT_BITS - 1 downto 0);
        rdcount              : out std_logic_vector(READ_COUNT_BITS - 1 downto 0);
        empty                : out std_logic;
        full                 : out std_logic;
        -- User ports ends
        -- Do not modify the ports beyond this line

        -- Global Clock Signal
        S_AXI_ACLK     : in  std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN  : in  std_logic;
        -- Write Address ID
        S_AXI_AWID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
        -- Write address
        S_AXI_AWADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Burst length. The burst length gives the exact number of transfers in a burst
        S_AXI_AWLEN    : in  std_logic_vector(7 downto 0);
        -- Burst size. This signal indicates the size of each transfer in the burst
        S_AXI_AWSIZE   : in  std_logic_vector(2 downto 0);
        -- Burst type. The burst type and the size information, 
        -- determine how the address for each transfer within the burst is calculated.
        S_AXI_AWBURST  : in  std_logic_vector(1 downto 0);
        -- Lock type. Provides additional information about the
        -- atomic characteristics of the transfer.
        S_AXI_AWLOCK   : in  std_logic;
        -- Memory type. This signal indicates how transactions
        -- are required to progress through a system.
        S_AXI_AWCACHE  : in  std_logic_vector(3 downto 0);
        -- Protection type. This signal indicates the privilege
        -- and security level of the transaction, and whether
        -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT   : in  std_logic_vector(2 downto 0);
        -- Quality of Service, QoS identifier sent for each
        -- write transaction.
        S_AXI_AWQOS    : in  std_logic_vector(3 downto 0);
        -- Region identifier. Permits a single physical interface
        -- on a slave to be used for multiple logical interfaces.
        S_AXI_AWREGION : in  std_logic_vector(3 downto 0);
        -- Optional User-defined signal in the write address channel.
        S_AXI_AWUSER   : in  std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
        -- Write address valid. This signal indicates that
        -- the channel is signaling valid write address and
        -- control information.
        S_AXI_AWVALID  : in  std_logic;
        -- Write address ready. This signal indicates that
        -- the slave is ready to accept an address and associated
        -- control signals.
        S_AXI_AWREADY  : out std_logic;
        -- Write Data
        S_AXI_WDATA    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte
        -- lanes hold valid data. There is one write strobe
        -- bit for each eight bits of the write data bus.
        S_AXI_WSTRB    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write last. This signal indicates the last transfer
        -- in a write burst.
        S_AXI_WLAST    : in  std_logic;
        -- Optional User-defined signal in the write data channel.
        S_AXI_WUSER    : in  std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
        -- Write valid. This signal indicates that valid write
        -- data and strobes are available.
        S_AXI_WVALID   : in  std_logic;
        -- Write ready. This signal indicates that the slave
        -- can accept the write data.
        S_AXI_WREADY   : out std_logic;
        -- Response ID tag. This signal is the ID tag of the
        -- write response.
        S_AXI_BID      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
        -- Write response. This signal indicates the status
        -- of the write transaction.
        S_AXI_BRESP    : out std_logic_vector(1 downto 0);
        -- Optional User-defined signal in the write response channel.
        S_AXI_BUSER    : out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
        -- Write response valid. This signal indicates that the
        -- channel is signaling a valid write response.
        S_AXI_BVALID   : out std_logic;
        -- Response ready. This signal indicates that the master
        -- can accept a write response.
        S_AXI_BREADY   : in  std_logic;
        -- Read address ID. This signal is the identification
        -- tag for the read address group of signals.
        S_AXI_ARID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
        -- Read address. This signal indicates the initial
        -- address of a read burst transaction.
        S_AXI_ARADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Burst length. The burst length gives the exact number of transfers in a burst
        S_AXI_ARLEN    : in  std_logic_vector(7 downto 0);
        -- Burst size. This signal indicates the size of each transfer in the burst
        S_AXI_ARSIZE   : in  std_logic_vector(2 downto 0);
        -- Burst type. The burst type and the size information, 
        -- determine how the address for each transfer within the burst is calculated.
        S_AXI_ARBURST  : in  std_logic_vector(1 downto 0);
        -- Lock type. Provides additional information about the
        -- atomic characteristics of the transfer.
        S_AXI_ARLOCK   : in  std_logic;
        -- Memory type. This signal indicates how transactions
        -- are required to progress through a system.
        S_AXI_ARCACHE  : in  std_logic_vector(3 downto 0);
        -- Protection type. This signal indicates the privilege
        -- and security level of the transaction, and whether
        -- the transaction is a data access or an instruction access.
        S_AXI_ARPROT   : in  std_logic_vector(2 downto 0);
        -- Quality of Service, QoS identifier sent for each
        -- read transaction.
        S_AXI_ARQOS    : in  std_logic_vector(3 downto 0);
        -- Region identifier. Permits a single physical interface
        -- on a slave to be used for multiple logical interfaces.
        S_AXI_ARREGION : in  std_logic_vector(3 downto 0);
        -- Optional User-defined signal in the read address channel.
        S_AXI_ARUSER   : in  std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
        -- Write address valid. This signal indicates that
        -- the channel is signaling valid read address and
        -- control information.
        S_AXI_ARVALID  : in  std_logic;
        -- Read address ready. This signal indicates that
        -- the slave is ready to accept an address and associated
        -- control signals.
        S_AXI_ARREADY  : out std_logic;
        -- Read ID tag. This signal is the identification tag
        -- for the read data group of signals generated by the slave.
        S_AXI_RID      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
        -- Read Data
        S_AXI_RDATA    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of
        -- the read transfer.
        S_AXI_RRESP    : out std_logic_vector(1 downto 0);
        -- Read last. This signal indicates the last transfer
        -- in a read burst.
        S_AXI_RLAST    : out std_logic;
        -- Optional User-defined signal in the read address channel.
        S_AXI_RUSER    : out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
        -- Read valid. This signal indicates that the channel
        -- is signaling the required read data.
        S_AXI_RVALID   : out std_logic;
        -- Read ready. This signal indicates that the master can
        -- accept the read data and response information.
        S_AXI_RREADY   : in  std_logic
        );
end AXI_Bloom_Filter_v1_0_S00_AXI;

architecture arch_imp of AXI_Bloom_Filter_v1_0_S00_AXI is

    -- AXI4FULL signals
    signal axi_arready      : std_logic;
    signal axi_rdata        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp        : std_logic_vector(1 downto 0);
    signal axi_rlast        : std_logic;
    signal axi_ruser        : std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
    signal axi_rvalid       : std_logic;
    --The axi_arv_arr_flag flag marks the presence of read address valid
    signal axi_arv_arr_flag : std_logic;
    --The axi_arlen_cntr internal read address counter to keep track of beats in a burst transaction
    signal axi_arlen_cntr   : std_logic_vector(7 downto 0);
    signal axi_arlen        : std_logic_vector(8-1 downto 0);
    ------------------------------------------------
    ---- Signals for user logic memory space example
    --------------------------------------------------
    signal fifo_rdreq       : std_logic;
    signal data_out         : std_logic_vector(WRITE_FIFO_WIDTH - 1 downto 0);
    signal wrcount_buf      : std_logic_vector(WRITE_COUNT_BITS - 1 downto 0);
    signal rdcount_buf      : std_logic_vector(READ_COUNT_BITS - 1 downto 0);
    signal full_buf         : std_logic;
    signal empty_buf        : std_logic;
    signal rst              : std_logic;

begin
    -- I/O Connections assignments

    S_AXI_AWREADY <= '0';
    S_AXI_WREADY  <= '0';
    S_AXI_BRESP   <= (others => '0');
    S_AXI_BUSER   <= (others => '0');
    S_AXI_BVALID  <= '0';
    S_AXI_ARREADY <= axi_arready;
    S_AXI_RDATA   <= axi_rdata;
    S_AXI_RRESP   <= axi_rresp;
    S_AXI_RLAST   <= axi_rlast;
    S_AXI_RUSER   <= axi_ruser;
    S_AXI_RVALID  <= axi_rvalid;
    S_AXI_BID     <= S_AXI_AWID;
    S_AXI_RID     <= S_AXI_ARID;
    rst           <= not S_AXI_ARESETN;
    -- Implement axi_arready generation

    -- axi_arready is asserted for one S_AXI_ACLK clock cycle when
    -- S_AXI_ARVALID is asserted. axi_awready is 
    -- de-asserted when reset (active low) is asserted. 
    -- The read address is also latched when S_AXI_ARVALID is 
    -- asserted. axi_araddr is reset to zero on reset assertion.

    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN = '0' then
                axi_arready          <= '0';
                axi_arv_arr_flag     <= '0';
            else
                if (axi_arready = '0' and S_AXI_ARVALID = '1' and axi_arv_arr_flag = '0') then
                    axi_arready      <= '1';
                    axi_arv_arr_flag <= '1';
                elsif (axi_rvalid = '1' and S_AXI_RREADY = '1' and (axi_arlen_cntr = axi_arlen)) then
                    -- preparing to accept next address after current read completion
                    axi_arv_arr_flag <= '0';
                else
                    axi_arready      <= '0';
                end if;
            end if;
        end if;
    end process;
    -- Implement axi_araddr latching

    --This process is used to latch the address when both 
    --S_AXI_ARVALID and S_AXI_RVALID are valid. 
    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN = '0' then
                axi_arlen             <= (others => '0');
                axi_arlen_cntr        <= (others => '0');
                axi_rlast             <= '0';
                axi_ruser             <= (others => '0');
            -- fifo_rdreq <= '0';
            else
                if (axi_arready = '0' and S_AXI_ARVALID = '1' and axi_arv_arr_flag = '0') then
                    -- address latching 
                    axi_arlen_cntr    <= (others => '0');
                    axi_rlast         <= '0';
                    axi_arlen         <= S_AXI_ARLEN;
                -- fifo_rdreq <= '0';
                elsif((axi_arlen_cntr <= axi_arlen) and axi_rvalid = '1' and S_AXI_RREADY = '1') then
                    axi_arlen_cntr    <= std_logic_vector (unsigned(axi_arlen_cntr) + 1);
                    -- fifo_rdreq <= '1';
                    axi_rlast         <= '0';
                elsif((axi_arlen_cntr = axi_arlen) and axi_rlast = '0' and axi_arv_arr_flag = '1') then
                    axi_rlast         <= '1';
                elsif (S_AXI_RREADY = '1') then
                    axi_rlast         <= '0';
                end if;
            end if;
        end if;
    end process;
    -- Implement axi_arvalid generation

    -- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
    -- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    -- data are available on the axi_rdata bus at this instance. The 
    -- assertion of axi_rvalid marks the validity of read data on the 
    -- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    -- is deasserted on reset (active low). axi_rresp and axi_rdata are 
    -- cleared to zero on reset (active low).  

    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN = '0' then
                axi_rvalid     <= '0';
                axi_rresp      <= "00";
            else
                if (axi_arv_arr_flag = '1' and axi_rvalid = '0') then
                    axi_rvalid <= '1';
                    axi_rresp  <= "00";                               -- 'OKAY' response
                elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
                    axi_rvalid <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Add user logic here
    fifo_rdreq <= axi_arv_arr_flag;

    --Output register or memory read data    
    process(data_out, axi_rvalid) is
    begin
        if (axi_rvalid = '1') then
            -- When there is a valid read address (S_AXI_ARVALID) with 
            -- acceptance of read address by the slave (axi_arready), 
            -- output the read dada 
            axi_rdata <= data_out;                                    -- memory range 0 read data
        else
            axi_rdata <= (others => '0');
        end if;
    end process;

    FIFO : xpm_fifo_async
        generic map (
            CDC_SYNC_STAGES     => 2,                                 -- DECIMAL
            DOUT_RESET_VALUE    => "0",                               -- String
            ECC_MODE            => "no_ecc",                          -- String
            FIFO_MEMORY_TYPE    => "auto",                            -- String
            FIFO_READ_LATENCY   => 1,                                 -- DECIMAL
            FIFO_WRITE_DEPTH    => WRITE_DEPTH,                       -- DECIMAL
            FULL_RESET_VALUE    => 0,                                 -- DECIMAL
            PROG_EMPTY_THRESH   => 10,                                -- DECIMAL
            PROG_FULL_THRESH    => 10,                                -- DECIMAL
            RD_DATA_COUNT_WIDTH => READ_COUNT_BITS,                   -- DECIMAL
            READ_DATA_WIDTH     => READ_WIDTH,                        -- DECIMAL
            read_mode           => "std",                             -- String
            RELATED_CLOCKS      => 0,                                 -- DECIMAL
            USE_ADV_FEATURES    => "0404",                            -- String
            WAKEUP_TIME         => 0,                                 -- DECIMAL
            WRITE_DATA_WIDTH    => WRITE_WIDTH,                       -- DECIMAL
            WR_DATA_COUNT_WIDTH => WRITE_COUNT_BITS                   -- DECIMAL
            )
        port map (
            almost_empty        => open,
            almost_full         => open,
            data_valid          => open,
            dbiterr             => open,
            dout                => data_out,
            empty               => empty_buf,
            full                => full_buf,
            overflow            => open,
            prog_empty          => open,
            prog_full           => open,
            rd_data_count       => rdcount_buf,
            rd_rst_busy         => open,
            sbiterr             => open,
            underflow           => open,
            wr_ack              => open,
            wr_data_count       => wrcount_buf,
            wr_rst_busy         => open,
            din                 => data,
            injectdbiterr       => logic_0,
            injectsbiterr       => logic_0,
            rd_clk              => S_AXI_ACLK,
            rd_en               => fifo_rdreq,
            rst                 => rst,
            sleep               => logic_0,
            wr_clk              => core_clk,
            wr_en               => fifo_wrreq
            );

    wrcount <= wrcount_buf;
    rdcount <= rdcount_buf;
    empty   <= empty_buf;
    full    <= full_buf;

    -- User logic ends

end arch_imp;
