---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   12.08.2023
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    12.08.2023          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library UNISIM;
use UNISIM.VComponents.all;

entity output_serdes is

    port (
        clk_pixel  : in  std_logic;
        clk_serial : in  std_logic;
        rst_n      : in  std_logic;
        pin        : in  std_logic_vector(9 downto 0);
        sout_p     : out std_logic;
        sout_n     : out std_logic);

end entity output_serdes;

architecture rtl of output_serdes is

    signal sout   : std_logic;
    signal shift1 : std_logic;
    signal shift2 : std_logic;
    signal rst    : std_logic;

begin  -- architecture rtl
    rst <= not rst_n;

    U_OBUFDS : OBUFDS
        generic map (
            IOSTANDARD => "TMDS_33")
        port map (
            O          => sout_p,
            OB         => sout_n,
            I          => sout);

-- Serializer, 10:1 (5:1 DDR), master-slave cascaded
    SerializerMaster : OSERDESE2
        generic map (
            DATA_RATE_OQ   => "DDR",
            DATA_RATE_TQ   => "SDR",
            DATA_WIDTH     => 10,
            TRISTATE_WIDTH => 1,
            TBYTE_CTL      => "FALSE",
            TBYTE_SRC      => "FALSE",
            SERDES_MODE    => "MASTER")
        port map (
            OFB            => open,                                   -- 1-bit output: Feedback path for data
            OQ             => sout,                                   -- 1-bit output: Data path output
            -- SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
            SHIFTOUT1      => open,
            SHIFTOUT2      => open,
            TBYTEOUT       => open,                                   -- 1-bit output: Byte group tristate
            TFB            => open,                                   -- 1-bit output: 3-state control
            TQ             => open,                                   -- 1-bit output: 3-state control
            CLK            => SerialClk,                              -- 1-bit input: High speed clock
            CLKDIV         => PixelClk,                               -- 1-bit input: Divided clock
            -- D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
            D1             => pin(0),
            D2             => pin(1)
            D3             => pin(2),
            D4             => pin(3),
            D5             => pin(4),
            D6             => pin(5),
            D7             => pin(6),
            D8             => pin(7),
            OCE            => '1',                                    -- 1-bit input: Output data clock enable
            RST            => rst,                                    -- 1-bit input: Reset
            -- SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
            SHIFTIN1       => shift1,
            SHIFTIN2       => shift2,
            -- T1 - T4: 1-bit (each) input: Parallel 3-state inputs
            T1             => '0',
            T2             => '0',
            T3             => '0',
            T4             => '0',
            TBYTEIN        => '0',                                    -- 1-bit input: Byte group tristate
            TCE            => '0'                                     -- 1-bit input: 3-state clock enable
            );

    SerializerSlave : OSERDESE2
        generic map (
            DATA_RATE_OQ   => "DDR",
            DATA_RATE_TQ   => "SDR",
            DATA_WIDTH     => kParallelWidth,
            TRISTATE_WIDTH => 1,
            TBYTE_CTL      => "FALSE",
            TBYTE_SRC      => "FALSE",
            SERDES_MODE    => "SLAVE")
        port map (
            OFB            => open,                                   -- 1-bit output: Feedback path for data
            OQ             => open,                                   -- 1-bit output: Data path output
            -- SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
            SHIFTOUT1      => shift1,
            SHIFTOUT2      => shift2,
            TBYTEOUT       => open,                                   -- 1-bit output: Byte group tristate
            TFB            => open,                                   -- 1-bit output: 3-state control
            TQ             => open,                                   -- 1-bit output: 3-state control
            CLK            => clk_serial,                             -- 1-bit input: High speed clock
            CLKDIV         => clk_pixel,                              -- 1-bit input: Divided clock
            -- D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
            D1             => '0',
            D2             => '0',
            D3             => pin(8),
            D4             => pin(9),
            D5             => '0',
            D6             => '0',
            D7             => '0',
            D8             => '0',
            OCE            => '1',                                    -- 1-bit input: Output data clock enable
            RST            => rst,                                    -- 1-bit input: Reset
            -- SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
            SHIFTIN1       => '0',
            SHIFTIN2       => '0',
            -- T1 - T4: 1-bit (each) input: Parallel 3-state inputs
            T1             => '0',
            T2             => '0',
            T3             => '0',
            T4             => '0',
            TBYTEIN        => '0',                                    -- 1-bit input: Byte group tristate
            TCE            => '0'                                     -- 1-bit input: 3-state clock enable
            );

end architecture rtl;
