----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2021 05:05:45 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- I will reset the hour at 24 myself.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
generic (
    c_clk_freq : integer := 50_000_000
);

port (
    clk         : in std_logic;
    reset_i     : in std_logic;
    setting_i   : in std_logic;
    shift_i     : in std_logic;
    leds_o      : out std_logic_vector (5 downto 0)
);
end top;

architecture Behavioral of top is

component debounce is
generic (
c_clk_freq  : integer := 50_000_000;
c_deb_time  : integer := 500
);

port (
clk         :   in std_logic;
signal_i    :   in std_logic;
signal_o    :   out std_logic
);
end component;

component bcd_increment is
generic (
    c_ones_lim  : integer := 9;
    c_tens_lim  : integer := 5
);

port (
    clk         : in std_logic;
    increment_i : in std_logic;
    reset_i     : in std_logic;
    ones_o      : out std_logic_vector (3 downto 0);
    tens_o      : out std_logic_vector (3 downto 0)
);
end component;

component bcd_to_7seg is
port (
    bcd_i   : in std_logic_vector (3 downto 0);
    sevenseg_o  : out std_logic_vector (6 downto 0)
);
end component;

------------
--CONSTANTS
------------
constant c_second_counter_lim : integer := c_clk_freq;
constant c_minute_counter_lim : integer := 60;
constant c_hour_counter_lim : integer := 60;

------------
--SIGNALS
------------
signal second_increment : std_logic := '0';
signal minute_increment : std_logic := '0';
signal hour_increment   : std_logic := '0';

signal reset_deb        : std_logic := '0';
signal setting          : std_logic := '0';
signal setting_deb      : std_logic := '0';
signal setting_deb_prev : std_logic := '0';
signal shift            : std_logic := '0';
signal shift_deb        : std_logic := '0';
signal shift_deb_prev   : std_logic := '0';

signal second_ones  : std_logic_vector (3 downto 0) := (others => '0');
signal second_tens  : std_logic_vector (3 downto 0) := (others => '0');
signal minute_ones  : std_logic_vector (3 downto 0) := (others => '0');
signal minute_tens  : std_logic_vector (3 downto 0) := (others => '0');
signal hour_ones    : std_logic_vector (3 downto 0) := (others => '0');
signal hour_tens    : std_logic_vector (3 downto 0) := (others => '0');

signal second_ones_7seg  : std_logic_vector (6 downto 0) := (others => '0');
signal second_tens_7seg  : std_logic_vector (6 downto 0) := (others => '0');
signal minute_ones_7seg  : std_logic_vector (6 downto 0) := (others => '0');
signal minute_tens_7seg  : std_logic_vector (6 downto 0) := (others => '0');
signal hour_ones_7seg    : std_logic_vector (6 downto 0) := (others => '0');
signal hour_tens_7seg    : std_logic_vector (6 downto 0) := (others => '0');

signal second_counter   : integer range 0 to c_second_counter_lim   := 0;
signal minute_counter   : integer range 0 to c_minute_counter_lim   := 0;
signal hour_counter     : integer range 0 to c_hour_counter_lim     := 0;

signal leds             : std_logic_vector (5 downto 0) := "000001";
signal second_trigger   : std_logic := '0';

begin

----------
--debounce
----------

reset_i_deb : debounce 
generic map (
c_clk_freq  => c_clk_freq,
c_deb_time  => 500
)
port map (
clk         => clk,
signal_i    => reset_i,
signal_o    => reset_deb
);

setting_i_deb : debounce 
generic map (
c_clk_freq  => c_clk_freq,
c_deb_time  => 500
)
port map (
clk         => clk,
signal_i    => setting_i,
signal_o    => setting_deb
);

shift_i_deb : debounce 
generic map (
c_clk_freq  => c_clk_freq,
c_deb_time  => 500
)
port map (
clk         => clk,
signal_i    => shift_i,
signal_o    => shift_deb
);

----------------
--bcd_increment
----------------
second_increment_module : bcd_increment
generic map (
    c_ones_lim  => 9,
    c_tens_lim  => 5
)
port map (
    clk         => clk,
    increment_i => second_increment,
    reset_i     => reset_deb,
    ones_o      => second_ones,
    tens_o      => second_tens
);

minute_increment_module : bcd_increment
generic map (
    c_ones_lim  => 9,
    c_tens_lim  => 5
)
port map (
    clk         => clk,
    increment_i => minute_increment,
    reset_i     => reset_deb,
    ones_o      => minute_ones,
    tens_o      => minute_tens
);


hour_increment_module : bcd_increment
generic map (
    c_ones_lim  => 9,
    c_tens_lim  => 9
)
port map (
    clk         => clk,
    increment_i => hour_increment,
    reset_i     => reset_deb,
    ones_o      => hour_ones,
    tens_o      => hour_tens
);

----------------
--bcd_to_7seg
----------------

second_ones_7seg_module :  bcd_to_7seg
port map (
    bcd_i   => second_ones,
    sevenseg_o  => second_ones_7seg
);

second_tens_7seg_module :  bcd_to_7seg
port map (
    bcd_i   => second_tens,
    sevenseg_o  => second_tens_7seg
);

minute_ones_7seg_module :  bcd_to_7seg
port map (
    bcd_i   => minute_ones,
    sevenseg_o  => minute_ones_7seg
);

minute_tens_7seg_module :  bcd_to_7seg
port map (
    bcd_i   => minute_tens,
    sevenseg_o  => minute_tens_7seg
);

hour_ones_7seg_module :  bcd_to_7seg
port map (
    bcd_i   => hour_ones,
    sevenseg_o  => hour_ones_7seg
);

hour_tens_7seg_module :  bcd_to_7seg
port map (
    bcd_i   => hour_tens,
    sevenseg_o  => hour_tens_7seg
);

-------------
--MAIN
-------------

P_MAIN : process(clk) begin
if (rising_edge(clk)) then

    setting_deb_prev <= setting_deb;
    shift_deb_prev <= shift_deb;
    
    
    if (setting_deb = '1' and setting_deb_prev = '0') then
        setting <= not setting;
        leds <= "000001";
        --buraya bisiler gelebilir
    end if;
    
    if (shift_deb = '1' and shift_deb_prev = '0') then
        shift <= not shift;
    end if;
    
    
    second_increment <= '0';
    minute_increment <= '0';
    hour_increment   <= '0';
    
    
    if (second_counter = c_second_counter_lim - 1) then
        second_counter <= 0;
        second_increment <= '1';
        minute_counter <= minute_counter + 1;
    else
        second_counter <= second_counter + 1;
        second_trigger <= not second_trigger;
    end if;

    if (minute_counter = c_minute_counter_lim - 1) then
        minute_counter <= 0;
        minute_increment <= '1';
        hour_counter <= hour_counter + 1;
    end if;
    
    if (hour_counter = c_hour_counter_lim - 1) then
        hour_counter <= 0;
        hour_increment <= '1';
    end if;


--    if (setting = '1') then
--        if (shift = '1') then
--            leds <= leds(5 downto 1) & '0';
--        end if;
        
--    end if;
    
    if (reset_deb = '1') then
        second_counter    <= 0;
        minute_counter    <= 0;
        hour_counter      <= 0;
    end if;
    
    leds_o <= "000000";
    if (setting = '1') then
        --leds_o <= leds and second_trigger;
        leds_o(5) <= leds(5) and second_trigger;
        leds_o(4) <= leds(4) and second_trigger;
        leds_o(3) <= leds(3) and second_trigger;
        leds_o(2) <= leds(2) and second_trigger;
        leds_o(1) <= leds(1) and second_trigger;
        leds_o(0) <= leds(0) and second_trigger;
    end if;
    
    if (hour_ones = "0100" and hour_tens = "0010") then
        hour_ones <= "0000";
        hour_tens <= "0000";
    end if;
    
end if;
end process; 


end Behavioral;