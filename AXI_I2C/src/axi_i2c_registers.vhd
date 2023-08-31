-------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   31.08.2023
--  Short Description   :   AXI4 Lite Slave Interface
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    31.08.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_i2c_registers is
    generic (
        -- User Generics Start --

        -- User Generics End   --        
        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH : integer := 32;
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH : integer := 9
        );
    port (
        -- User Ports Start --

        -- User Ports End   --
        -- Global Clock Signal
        S_AXI_ACLK    : in  std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN : in  std_logic;
        -- Write address (issued by master, acceped by Slave)
        S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Write channel Protection type. This signal indicates the
        -- privilege and security level of the transaction, and whether
        -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
        -- Write address valid. This signal indicates that the master signaling
        -- valid write address and control information.
        S_AXI_AWVALID : in  std_logic;
        -- Write address ready. This signal indicates that the slave is ready
        -- to accept an address and associated control signals.
        S_AXI_AWREADY : out std_logic;
        -- Write data (issued by master, acceped by Slave) 
        S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte lanes hold
        -- valid data. There is one write strobe bit for each eight
        -- bits of the write data bus.    
        S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write valid. This signal indicates that valid write
        -- data and strobes are available.
        S_AXI_WVALID  : in  std_logic;
        -- Write ready. This signal indicates that the slave
        -- can accept the write data.
        S_AXI_WREADY  : out std_logic;
        -- Write response. This signal indicates the status
        -- of the write transaction.
        S_AXI_BRESP   : out std_logic_vector(1 downto 0);
        -- Write response valid. This signal indicates that the channel
        -- is signaling a valid write response.
        S_AXI_BVALID  : out std_logic;
        -- Response ready. This signal indicates that the master
        -- can accept a write response.
        S_AXI_BREADY  : in  std_logic;
        -- Read address (issued by master, acceped by Slave)
        S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Protection type. This signal indicates the privilege
        -- and security level of the transaction, and whether the
        -- transaction is a data access or an instruction access.
        S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
        -- Read address valid. This signal indicates that the channel
        -- is signaling valid read address and control information.
        S_AXI_ARVALID : in  std_logic;
        -- Read address ready. This signal indicates that the slave is
        -- ready to accept an address and associated control signals.
        S_AXI_ARREADY : out std_logic;
        -- Read data (issued by slave)
        S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of the
        -- read transfer.
        S_AXI_RRESP   : out std_logic_vector(1 downto 0);
        -- Read valid. This signal indicates that the channel is
        -- signaling the required read data.
        S_AXI_RVALID  : out std_logic;
        -- Read ready. This signal indicates that the master can
        -- accept the read data and response information.
        S_AXI_RREADY  : in  std_logic
        );
end entity axi_i2c_registers;

architecture rtl of axi_i2c_registers is

    -- AXI4LITE signals
    signal axi_awaddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_awready : std_logic;
    signal axi_wready  : std_logic;
    signal axi_bresp   : std_logic_vector(1 downto 0);
    signal axi_bvalid  : std_logic;
    signal axi_araddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_arready : std_logic;
    signal axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_wdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp   : std_logic_vector(1 downto 0);
    signal axi_rvalid  : std_logic;

    -- Example-specific design signals
    -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    -- ADDR_LSB is used for addressing 32/64 bit registers/memories
    -- ADDR_LSB = 2 for 32 bits (n downto 2)
    -- ADDR_LSB = 3 for 64 bits (n downto 3)
    constant ADDR_LSB      : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
    constant MEM_ADDR_BITS : integer := 8;

    type write_state_t is (RESET_S, IDLE_S, WAIT_WVALID_S, WRITE_TRANSFER_S, WAIT_BREADY_S);
    signal write_state : write_state_t;

    type read_state_t is (RESET_S, IDLE_S, READ_TRANSFER_S, WAIT_RREADY_S);
    signal read_state : read_state_t;

    -- User declarations start --
    -- Register addresses
    constant GIE_ADDR          : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '0' & x"1C";
    constant ISR_ADDR          : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '0' & x"20";
    constant IER_ADDR          : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '0' & x"28";
    constant SOFTR_ADDR        : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '0' & x"40";
    constant CR_ADDR           : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"00";
    constant SR_ADDR           : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"04";
    constant TX_FIFO_ADDR      : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"08";
    constant RX_FIFO_ADDR      : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"0C";
    constant ADR_ADDR          : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"10";
    constant TX_FIFO_OCY_ADDR  : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"14";
    constant RX_FIFO_OCY       : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"18";
    constant TEN_ADR_ADDR      : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"1C";
    constant RX_FIFO_PIRQ_ADDR : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"20";
    constant GPO_ADDR          : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"24";
    constant TSUSTA_ADDR       : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"28";
    constant TSUSTO_ADDR       : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"2C";
    constant THDSTA_ADDR       : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"30";
    constant TSUDAT_ADDR       : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"34";
    constant TBUF_ADDR         : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"38";
    constant THIGH_ADDR        : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"3C";
    constant TLOW_ADDR         : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"40";
    constant THDDAT_ADDR       : std_logic_vector(MEM_ADDR_BITS - 1 downto 0) := '1' & x"44";

    -- Registers
    signal GIE_reg          : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal ISR_reg          : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- R/TOW
    signal IER_reg          : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal SOFTR_reg        : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- W
    signal CR_reg           : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal SR_reg           : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- R
    signal TX_FIFO_reg      : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal RX_FIFO_reg      : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- R
    signal ADR_reg          : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal TX_FIFO_OCY_reg  : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- R
    signal RX_FIFO_OCY      : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- R
    signal TEN_ADR_reg      : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal RX_FIFO_PIRQ_reg : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal GPO_reg          : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW
    signal TSUSTA_reg       : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    signal TSUSTO_reg       : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    signal THDSTA_reg       : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    signal TSUDAT_reg       : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW   
    signal TBUF_reg         : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    signal THIGH_reg        : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    signal TLOW_reg         : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    signal THDDAT_reg       : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  -- RW 
    -- User declarations end   --

begin  -- architecture rtl
    axi_bresp     <= "00";
    S_AXI_AWREADY <= axi_awready;
    S_AXI_WREADY  <= axi_wready;
    S_AXI_BRESP   <= axi_bresp;
    S_AXI_BVALID  <= axi_bvalid;
    S_AXI_ARREADY <= axi_arready;
    S_AXI_RDATA   <= axi_rdata;
    S_AXI_RRESP   <= axi_rresp;
    S_AXI_RVALID  <= axi_rvalid;

    PROC_WRITE            : process (S_AXI_ACLK, S_AXI_ARESETN) is
        variable reg_addr : std_logic_vector(MEM_ADDR_BITS - 1 downto 0);
    begin  -- process PROC_WRITE
        if S_AXI_ARESETN = '0' then                                   -- asynchronous reset (active low)
            -- User logic start --
            reg1        <= (others => '0');
            reg2        <= (others => '0');
            reg3        <= (others => '0');
            reg4        <= (others => '0');
            -- User logic end   --
            axi_wready  <= '0';
            axi_awready <= '0';
            axi_awaddr  <= (others => '0');
            axi_wdata   <= (others => '0');
            axi_bresp   <= "00";
            axi_bvalid  <= '0';
            write_state <= RESET_S;
        elsif rising_edge(S_AXI_ACLK) then                            -- rising clock edge
            reg_addr    := axi_awaddr(ADDR_LSB + MEM_ADDR_BITS - 1 downto ADDR_LSB);

            case write_state is

                when RESET_S =>
                    axi_wready  <= '1';
                    axi_awready <= '1';
                    write_state <= IDLE_S;

                when IDLE_S =>
                    if S_AXI_AWVALID = '1' then
                        axi_awaddr      <= S_AXI_AWADDR;
                        axi_awready     <= '0';
                        if S_AXI_WVALID = '1' then
                            axi_wdata   <= S_AXI_WDATA;
                            axi_wready  <= '0';
                            write_state <= WRITE_TRANSFER_S;
                        else
                            write_state <= WAIT_WVALID_S;
                        end if;
                    end if;

                when WAIT_WVALID_S =>
                    if S_AXI_WVALID = '1' then
                        axi_wdata   <= S_AXI_WDATA;
                        axi_wready  <= '0';
                        axi_bresp   <= "00";
                        axi_bvalid  <= '1';
                        write_state <= WRITE_TRANSFER_S;
                    end if;

                when WRITE_TRANSFER_S =>
                    if S_AXI_BREADY = '1' then
                        write_state <= IDLE_S;
                        axi_wready  <= '1';
                        axi_awready <= '1';
                        axi_bvalid  <= '0';
                    else
                        write_state <= WAIT_BREADY_S;
                    end if;

                    -- User logic start --
                    case reg_addr is

                        when REG1_ADDR =>
                            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                                if (S_AXI_WSTRB(byte_index) = '1') then
                                    -- Respective byte enables are asserted as per write strobes           
                                    -- slave registor 0
                                    reg1(byte_index*8+7 downto byte_index*8) <= axi_wdata(byte_index*8+7 downto byte_index*8);
                                end if;
                            end loop;

                        when REG2_ADDR =>
                            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                                if (S_AXI_WSTRB(byte_index) = '1') then
                                    -- Respective byte enables are asserted as per write strobes           
                                    -- slave registor 0
                                    reg2(byte_index*8+7 downto byte_index*8) <= axi_wdata(byte_index*8+7 downto byte_index*8);
                                end if;
                            end loop;

                        when REG3_ADDR =>
                            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                                if (S_AXI_WSTRB(byte_index) = '1') then
                                    -- Respective byte enables are asserted as per write strobes           
                                    -- slave registor 0
                                    reg3(byte_index*8+7 downto byte_index*8) <= axi_wdata(byte_index*8+7 downto byte_index*8);
                                end if;
                            end loop;

                        when REG4_ADDR =>
                            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                                if (S_AXI_WSTRB(byte_index) = '1') then
                                    -- Respective byte enables are asserted as per write strobes           
                                    -- slave registor 0
                                    reg4(byte_index*8+7 downto byte_index*8) <= axi_wdata(byte_index*8+7 downto byte_index*8);
                                end if;
                            end loop;

                        when others =>
                            reg1 <= reg1;
                            reg2 <= reg2;
                            reg3 <= reg3;
                            reg4 <= reg4;

                    end case;
                    -- User logic end   --

                when WAIT_BREADY_S =>
                    if S_AXI_BREADY = '1' then
                        write_state <= IDLE_S;
                        axi_wready  <= '1';
                        axi_awready <= '1';
                        axi_bvalid  <= '0';
                    end if;

                when others =>
                    axi_wready  <= '1';
                    axi_awready <= '1';
                    write_state <= IDLE_S;
            end case;
        end if;
    end process PROC_WRITE;

    PROC_READ             : process (S_AXI_ACLK, S_AXI_ARESETN) is
        variable reg_addr : std_logic_vector(MEM_ADDR_BITS - 1 downto 0);
    begin  -- process PROC_READ
        if S_AXI_ARESETN = '0' then                                   -- asynchronous reset (active low)
            -- User logic start --
            -- User logic end   --
            axi_rvalid  <= '0';
            axi_arready <= '0';
            axi_araddr  <= (others => '0');
            axi_rdata   <= (others => '0');
            axi_rresp   <= "00";
            read_state  <= RESET_S;

        elsif rising_edge(S_AXI_ACLK) then                            -- rising clock edge
            reg_addr := axi_araddr(ADDR_LSB + MEM_ADDR_BITS - 1 downto ADDR_LSB);

            case read_state is

                when RESET_S =>
                    axi_arready <= '1';
                    read_state  <= IDLE_S;

                when IDLE_S =>
                    if S_AXI_ARVALID = '1' then
                        axi_arready <= '0';
                        axi_araddr  <= S_AXI_ARADDR;
                        read_state  <= READ_TRANSFER_S;
                    end if;

                when READ_TRANSFER_S =>
                    axi_rvalid <= '1';
                    axi_rresp  <= "00";
                    read_state <= WAIT_RREADY_S;
                    -- User logic start --
                    case reg_addr is

                        when REG1_ADDR =>
                            axi_rdata <= reg1;

                        when REG2_ADDR =>
                            axi_rdata <= reg2;

                        when REG3_ADDR =>
                            axi_rdata <= reg3;

                        when REG4_ADDR =>
                            axi_rdata <= reg4;

                        when others =>
                            axi_rdata <= (others => '0');

                    end case;
                    -- User logic end   --

                when WAIT_RREADY_S =>
                    if S_AXI_RREADY = '1' then
                        axi_rvalid  <= '0';
                        axi_arready <= '1';
                        read_state  <= IDLE_S;
                    end if;

                when others =>
                    axi_rvalid  <= '0';
                    axi_arready <= '1';
                    read_state  <= IDLE_S;

            end case;
        end if;
    end process PROC_READ;

end architecture rtl;
