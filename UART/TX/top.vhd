----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2021 12:07:08 AM
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
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
generic (
    c_clk_freq  : integer := 50_000_000;
    c_baud_rate : integer := 115_200;
    c_stop_bit  : integer := 2
);

port (
    clk             : in std_logic;
    switch_i        : in std_logic_vector (7 downto 0);
    button_i        : in std_logic;
    tx_o            : out std_logic
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

component uart_tx is
generic (
    c_clk_freq  : integer := 50_000_000;
    c_baud_rate : integer := 115_200;
    c_stop_bit  : integer := 2
);

port (
    clk             : in std_logic;
    din_i           : in std_logic_vector (7 downto 0);
    tx_start_i      : in std_logic;
    tx_o            : out std_logic;
    tx_done_tick_o  : out std_logic
);
end component;

signal button_deb       : std_logic := '0';
signal tx_start         : std_logic := '0';
signal tx_done_tick     : std_logic := '0';
signal button_deb_prev  : std_logic := '0';

begin

i_button : debounce
generic map (
c_clk_freq  => c_clk_freq,
c_deb_time  => 1000
)

port map (
clk         => clk          ,
signal_i    => button_i     ,
signal_o    => button_deb
);

i_uart_tx : uart_tx
generic map (
    c_clk_freq  => c_clk_freq ,
    c_baud_rate => c_baud_rate,
    c_stop_bit  => c_stop_bit 
)

port map (
    clk             => clk           ,
    din_i           => switch_i      ,
    tx_start_i      => tx_start      ,
    tx_o            => tx_o          ,
    tx_done_tick_o  => tx_done_tick
);

process (clk) begin
if (rising_edge(clk)) then
    button_deb_prev <= button_deb;
    tx_start <= '0';
    
    if (button_deb_prev = '0' and button_deb = '1') then
        tx_start <= '1';
    end if; 
end if;
end process;


end Behavioral;
