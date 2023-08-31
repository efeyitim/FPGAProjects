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

entity axi_i2c is

    generic (
        C_FAMILY              :     string  := virtex6;
        C_S_AXI_ADDR_WIDTH    :     integer := 9;
        C_S_AXI_DATA_WIDTH    :     integer := 32;
        C_I2C_FREQ            :     integer := 100000;
        C_TEN_BIT_ADR         :     integer := 0;
        C_GPO_WIDTH           :     integer := 1;
        C_S_AXI_ACLK_FREQ_HZ  :     integer := 25000000;
        C_SCL_INERTIAL_DELAY  :     integer := 0;
        C_SDA_INTERTIAL_DELAY :     integer := 0;
        C_SDA_LEVEL           :     integer := 1
        );
    port (
        -- Global Clock Signal
        S_AXI_ACLK            : in  std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN         : in  std_logic;
        -- System Interrupt Output
        I2C2INTC_Irpt         : out std_logic;
        -- Write address (issued by master, acceped by Slave)
        S_AXI_AWADDR          : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Write channel Protection type. This signal indicates the
        -- privilege and security level of the transaction, and whether
        -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT          : in  std_logic_vector(2 downto 0);
        -- Write address valid. This signal indicates that the master signaling
        -- valid write address and control information.
        S_AXI_AWVALID         : in  std_logic;
        -- Write address ready. This signal indicates that the slave is ready
        -- to accept an address and associated control signals.
        S_AXI_AWREADY         : out std_logic;
        -- Write data (issued by master, acceped by Slave) 
        S_AXI_WDATA           : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte lanes hold
        -- valid data. There is one write strobe bit for each eight
        -- bits of the write data bus.    
        S_AXI_WSTRB           : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write valid. This signal indicates that valid write
        -- data and strobes are available.
        S_AXI_WVALID          : in  std_logic;
        -- Write ready. This signal indicates that the slave
        -- can accept the write data.
        S_AXI_WREADY          : out std_logic;
        -- Write response. This signal indicates the status
        -- of the write transaction.
        S_AXI_BRESP           : out std_logic_vector(1 downto 0);
        -- Write response valid. This signal indicates that the channel
        -- is signaling a valid write response.
        S_AXI_BVALID          : out std_logic;
        -- Response ready. This signal indicates that the master
        -- can accept a write response.
        S_AXI_BREADY          : in  std_logic;
        -- Read address (issued by master, acceped by Slave)
        S_AXI_ARADDR          : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Protection type. This signal indicates the privilege
        -- and security level of the transaction, and whether the
        -- transaction is a data access or an instruction access.
        S_AXI_ARPROT          : in  std_logic_vector(2 downto 0);
        -- Read address valid. This signal indicates that the channel
        -- is signaling valid read address and control information.
        S_AXI_ARVALID         : in  std_logic;
        -- Read address ready. This signal indicates that the slave is
        -- ready to accept an address and associated control signals.
        S_AXI_ARREADY         : out std_logic;
        -- Read data (issued by slave)
        S_AXI_RDATA           : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of the
        -- read transfer.
        S_AXI_RRESP           : out std_logic_vector(1 downto 0);
        -- Read valid. This signal indicates that the channel is
        -- signaling the required read data.
        S_AXI_RVALID          : out std_logic;
        -- Read ready. This signal indicates that the master can
        -- accept the read data and response information.
        S_AXI_RREADY          : in  std_logic;
        -- I2C Serial Data Input from 3-state buffer
        SDA_I                 : in  std_logic;
        -- I2C Serial Data Output to 3-state buffer
        SDA_O                 : out std_logic;
        -- I2C Serial Data Output Enable to 3-state buffer
        SDA_T                 : out std_logic;
        -- I2C Serial Clock Input from 3-state buffer
        SCL_I                 : in  std_logic;
        -- I2C Serial Clock Output to 3-state buffer
        SCL_O                 : out std_logic;
        -- I2C Serial Clock Output Enable to 3-state buffer
        SCL_T                 : out std_logic;
        --
        GPO                   : out std_logic_vector(C_GPO_WIDTH - 1 downto 0)
        );

end entity axi_i2c;

architecture rtl of axi_i2c is

begin  -- architecture rtl



end architecture rtl;
