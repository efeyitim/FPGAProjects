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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mmcme2_drp is

    generic (
        DIV_F           :     real := 5.0);
    port (
        SEN             : in  std_logic;
        SCLK            : in  std_logic;
        RST             : in  std_logic;
        SRDY            : out std_logic;
        S1_CLKOUT0      : in  std_logic_vector(35 downto 0);
        S1_CLKFBOUT     : in  std_logic_vector(35 downto 0);
        S1_DIVCLK       : in  std_logic_vector(13 downto 0);
        S1_LOCK         : in  std_logic_vector(39 downto 0);
        S1_DIGITAL_FILT : in  std_logic_vector(9 downto 0);
        REF_CLK         : in  std_logic;
        PXL_CLK         : out std_logic;
        CLKFBOUT_O      : out std_logic;
        CLKFBOUT_I      : in  std_logic;
        LOCKED_O        : out std_logic);

end entity mmcme2_drp;

architecture rtl of mmcme2_drp is

    type rom_type is array(0 to 12) of std_logic_vector(38 downto 0);
    signal rom : rom_type;

    signal rom_addr      : std_logic_vector(3 downto 0);
    signal rom_do        : std_logic_vector(38 downto 0);
    signal next_srdy     : std_logic;
    signal next_rom_addr : std_logic_vector(3 downto 0);
    signal next_daddr    : std_logic_vector(6 downto 0);
    signal next_dwe      : std_logic;
    signal next_den      : std_logic;
    signal next_rst_mmcm : std_logic;
    signal next_di       : std_logic_vector(15 downto 0);

    signal DO       : std_logic_vector(15 downto 0);
    signal DRDY     : std_logic;
    signal LOCKED   : std_logic;
    signal DWE      : std_logic;
    signal DEN      : std_logic;
    signal DADDR    : std_logic_vector(6 downto 0);
    signal DI       : std_logic_vector(15 downto 0);
    signal DCLK     : std_logic;
    signal RST_MMCM : std_logic;

    type state_t is (RESTART_S, WAIT_LOCK_S, WAIT_SEN_S,
                     ADDRESS_S, WAIT_A_DRDY_S, BITMASK_S,
                     BITSET_S, WRITE_S, WAIT_DRDY_S);

    signal current_state : state_t;
    signal next_state    : state_t;

    constant STATE_COUNT_CONST : unsigned(3 downto 0) := x"D";
    signal state_count         : unsigned(3 downto 0);
    signal next_state_count    : unsigned(3 downto 0);

begin  -- architecture rtl

    DCLK     <= SCLK;
    LOCKED_O <= LOCKED;

    process (S1_CLKOUT0, S1_DIVCLK, S1_CLKFBOUT, S1_LOCK, S1_DIGITAL_FILT) is
    begin  -- process
        -- Store the power bits
        rom(0) <= "0101000" & x"0000" & x"FFFF";

        -- Store CLKOUT0 divide and phase
        rom(1) <= "0001000" & x"1000" & S1_CLKOUT0(15 downto 0);
        rom(2) <= "0001001" & x"8000" & S1_CLKOUT0(31 downto 16);

        -- Store CLKOUT0 additional frac values
        rom(3) <= "0000111" & x"C3FF" & "00" & S1_CLKOUT0(35 downto 32) & "00" & x"00";

        -- Store CLKFBOUT additional frac values
        rom(4) <= "0010011" & x"C3FF" & "00" & S1_CLKOUT0(35 downto 32) & "00" & x"00";

        -- Store the input divider
        rom(5) <= "0010110" & x"C000" & "00" & S1_DIVCLK(13 downto 0);

        -- Store CLKFBOUT divide and phase
        rom(6) <= "0010100" & x"1000" & S1_CLKFBOUT(15 downto 0);
        rom(7) <= "0010101" & x"8000" & S1_CLKFBOUT(31 downto 16);

        -- Store the lock settings
        rom(8)  <= "0011000" & x"FC00" & "000000" & S1_LOCK(29 downto 20);
        rom(9)  <= "0011001" & x"8000" & '0' & S1_LOCK(34 downto 30) & S1_LOCK(9 downto 0);
        rom(10) <= "0011010" & x"8000" & '0' & S1_LOCK(39 downto 35) & S1_LOCK(19 downto 10);

        -- Store the filter settings
        rom(11) <= "1001110" & x"66FF" & S1_DIGITAL_FILT(9) & "00" & S1_DIGITAL_FILT(8 downto 7) & "00" & S1_DIGITAL_FILT(6) & x"00";
        rom(12) <= "1001111" & x"666F" & S1_DIGITAL_FILT(5) & "00" & S1_DIGITAL_FILT(4 downto 3) & "00" & S1_DIGITAL_FILT(2 downto 1) & "00" & S1_DIGITAL_FILT(0) & x"0";
    end process;

    process (SCLK) is
    begin  -- process
        if rising_edge(SCLK) then
            rom_do <= rom(to_integer(unsigned(rom_addr)));
        end if;
    end process;

    process (SCLK) is
    begin  -- process
        if rising_edge(SCLK) then                                     -- rising clock edge
            DADDR       <= next_daddr;
            DWE         <= next_dwe;
            DEN         <= next_den;
            RST_MMCM    <= next_rst_mmcm;
            DI          <= next_di;
            SRDY        <= next_srdy;
            rom_addr    <= next_rom_addr;
            state_count <= next_state_count;
        end if;
    end process;

    process (RST, SCLK) is
    begin  -- process
        if RST = '1' then                                             -- synchronous active high
            current_state <= RESTART_S;
        elsif rising_edge(SCLK) then                                  -- rising clock edge
            current_state <= next_state;
        end if;
    end process;

    process (DO, DADDR, DI, DRDY, LOCKED, RST_MMCM, SEN, current_state, next_rom_addr, rom_addr, rom_do(15 downto 0), rom_do(38 downto 32), state_count) is
    begin  -- process
        next_srdy        <= '0';
        next_daddr       <= DADDR;
        next_dwe         <= '0';
        next_den         <= '0';
        next_rst_mmcm    <= RST_MMCM;
        next_di          <= DI;
        next_rom_addr    <= rom_addr;
        next_state_count <= state_count;

        case current_state is

            when RESTART_S =>
                next_daddr    <= "0000000";
                next_di       <= x"0000";
                next_rom_addr <= "0000";
                next_rst_mmcm <= '1';
                next_state    <= WAIT_LOCK_S;

            when WAIT_LOCK_S =>
                next_rst_mmcm    <= '0';
                next_state_count <= STATE_COUNT_CONST;
                if LOCKED = '1' then
                    next_state   <= WAIT_SEN_S;
                    next_srdy    <= '1';
                else
                    next_state   <= WAIT_LOCK_S;
                end if;

            when WAIT_SEN_S =>
                if SEN = '1' then
                    next_rom_addr <= "0000";
                    next_state    <= ADDRESS_S;
                else
                    next_state    <= WAIT_SEN_S;
                end if;

            when ADDRESS_S =>
                next_rst_mmcm <= '1';
                next_den      <= '1';
                next_daddr    <= rom_do(38 downto 32);
                next_state    <= WAIT_A_DRDY_S;

            when WAIT_A_DRDY_S =>
                if DRDY = '1' then
                    next_state <= BITMASK_S;
                else
                    next_state <= WAIT_A_DRDY_S;
                end if;

            when BITMASK_S =>
                next_di       <= rom_do(31 downto 16) and DO;
                next_state    <= BITSET_S;

            when BITSET_S =>
                next_di <= rom_do(15 downto 0) or DI;
                next_rom_addr <= std_logic_vector(unsigned(rom_addr) + 1);
                next_state <= WRITE_S;

            when WRITE_S =>
                next_dwe         <= '1';
                next_den         <= '1';
                next_state_count <= state_count - 1;
                next_state       <= WAIT_DRDY_S;

            when WAIT_DRDY_S =>
                if DRDY = '1' then
                    if state_count > 0 then
                        next_state <= ADDRESS_S;
                    else
                        next_state <= WAIT_LOCK_S;
                    end if;
                else
                    next_state     <= WAIT_DRDY_S;
                end if;

            when others =>
                next_state <= RESTART_S;

        end case;
    end process;


-- MMCME2_ADV: Advanced Mixed Mode Clock Manager
--             7 Series
-- Xilinx HDL Language Template, version 2023.1

    MMCME2_ADV_inst : MMCME2_ADV
        generic map (
            BANDWIDTH            => "OPTIMIZED",                      -- Jitter programming (OPTIMIZED, HIGH, LOW)
            CLKFBOUT_MULT_F      => 10.0,                             -- Multiply value for all CLKOUT (2.000-64.000).
            CLKFBOUT_PHASE       => 0.0,                              -- Phase offset in degrees of CLKFB (-360.000-360.000).
            -- CLKIN_PERIOD: Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
            CLKIN1_PERIOD        => 8.0,
            CLKIN2_PERIOD        => 0.0,
            -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
            CLKOUT1_DIVIDE       => 1,
            CLKOUT2_DIVIDE       => 1,
            CLKOUT3_DIVIDE       => 1,
            CLKOUT4_DIVIDE       => 1,
            CLKOUT5_DIVIDE       => 1,
            CLKOUT6_DIVIDE       => 1,
            CLKOUT0_DIVIDE_F     => DIV_F,                            -- Divide amount for CLKOUT0 (1.000-128.000).
            -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.01-0.99).
            CLKOUT0_DUTY_CYCLE   => 0.5,
            CLKOUT1_DUTY_CYCLE   => 0.5,
            CLKOUT2_DUTY_CYCLE   => 0.5,
            CLKOUT3_DUTY_CYCLE   => 0.5,
            CLKOUT4_DUTY_CYCLE   => 0.5,
            CLKOUT5_DUTY_CYCLE   => 0.5,
            CLKOUT6_DUTY_CYCLE   => 0.5,
            -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
            CLKOUT0_PHASE        => 0.0,
            CLKOUT1_PHASE        => 0.0,
            CLKOUT2_PHASE        => 0.0,
            CLKOUT3_PHASE        => 0.0,
            CLKOUT4_PHASE        => 0.0,
            CLKOUT5_PHASE        => 0.0,
            CLKOUT6_PHASE        => 0.0,
            CLKOUT4_CASCADE      => false,                            -- Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
            COMPENSATION         => "ZHOLD",                          -- ZHOLD, BUF_IN, EXTERNAL, INTERNAL
            DIVCLK_DIVIDE        => 1,                                -- Master division value (1-106)
            -- REF_JITTER: Reference input jitter in UI (0.000-0.999).
            REF_JITTER1          => 0.0,
            REF_JITTER2          => 0.0,
            STARTUP_WAIT         => false,                            -- Delays DONE until MMCM is locked (FALSE, TRUE)
            -- Spread Spectrum: Spread Spectrum Attributes
            SS_EN                => "FALSE",                          -- Enables spread spectrum (FALSE, TRUE)
            SS_MODE              => "CENTER_HIGH",                    -- CENTER_HIGH, CENTER_LOW, DOWN_HIGH, DOWN_LOW
            SS_MOD_PERIOD        => 10000,                            -- Spread spectrum modulation period (ns) (VALUES)
            -- USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
            CLKFBOUT_USE_FINE_PS => false,
            CLKOUT0_USE_FINE_PS  => false,
            CLKOUT1_USE_FINE_PS  => false,
            CLKOUT2_USE_FINE_PS  => false,
            CLKOUT3_USE_FINE_PS  => false,
            CLKOUT4_USE_FINE_PS  => false,
            CLKOUT5_USE_FINE_PS  => false,
            CLKOUT6_USE_FINE_PS  => false
            )
        port map (
            -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
            CLKOUT0              => PXL_CLK,                          -- 1-bit output: CLKOUT0
            CLKOUT0B             => open,                             -- 1-bit output: Inverted CLKOUT0
            CLKOUT1              => open,                             -- 1-bit output: CLKOUT1
            CLKOUT1B             => open,                             -- 1-bit output: Inverted CLKOUT1
            CLKOUT2              => open,                             -- 1-bit output: CLKOUT2
            CLKOUT2B             => open,                             -- 1-bit output: Inverted CLKOUT2
            CLKOUT3              => open,                             -- 1-bit output: CLKOUT3
            CLKOUT3B             => open,                             -- 1-bit output: Inverted CLKOUT3
            CLKOUT4              => open,                             -- 1-bit output: CLKOUT4
            CLKOUT5              => open,                             -- 1-bit output: CLKOUT5
            CLKOUT6              => open,                             -- 1-bit output: CLKOUT6
            -- DRP Ports: 16-bit (each) output: Dynamic reconfiguration ports
            DO                   => DO,                               -- 16-bit output: DRP data
            DRDY                 => DRDY,                             -- 1-bit output: DRP ready
            -- Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
            PSDONE               => open,                             -- 1-bit output: Phase shift done
            -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
            CLKFBOUT             => CLKFBOUT_O,                       -- 1-bit output: Feedback clock
            CLKFBOUTB            => open,                             -- 1-bit output: Inverted CLKFBOUT
            -- Status Ports: 1-bit (each) output: MMCM status ports
            CLKFBSTOPPED         => open,                             -- 1-bit output: Feedback clock stopped
            CLKINSTOPPED         => open,                             -- 1-bit output: Input clock stopped
            LOCKED               => LOCKED,                           -- 1-bit output: LOCK
            -- Clock Inputs: 1-bit (each) input: Clock inputs
            CLKIN1               => REF_CLK,                          -- 1-bit input: Primary clock
            CLKIN2               => '0',                              -- 1-bit input: Secondary clock
            -- Control Ports: 1-bit (each) input: MMCM control ports
            CLKINSEL             => '1',                              -- 1-bit input: Clock select, High=CLKIN1 Low=CLKIN2
            PWRDWN               => '0',                              -- 1-bit input: Power-down
            RST                  => RST_MMCM,                         -- 1-bit input: Reset
            -- DRP Ports: 7-bit (each) input: Dynamic reconfiguration ports
            DADDR                => DADDR,                            -- 7-bit input: DRP address
            DCLK                 => DCLK,                             -- 1-bit input: DRP clock
            DEN                  => DEN,                              -- 1-bit input: DRP enable
            DI                   => DI,                               -- 16-bit input: DRP data
            DWE                  => DWE,                              -- 1-bit input: DRP write enable
            -- Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
            PSCLK                => '0',                              -- 1-bit input: Phase shift clock
            PSEN                 => '0',                              -- 1-bit input: Phase shift enable
            PSINCDEC             => '0',                              -- 1-bit input: Phase shift increment/decrement
            -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
            CLKFBIN              => CLKFBOUT_I                        -- 1-bit input: Feedback clock
            );

-- End of MMCME2_ADV_inst instantiation    

end architecture rtl;
