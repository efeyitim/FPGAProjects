----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2021 02:18:04 AM
-- Design Name: 
-- Module Name: tb_debounce - Behavioral
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

entity tb_debounce is
generic (
c_clk_freq : integer := 50_000_000;
c_deb_time : integer := 500
);
end tb_debounce;

architecture Behavioral of tb_debounce is

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

signal clk : std_logic := '0';
signal signal_i : std_logic := '0';
signal signal_o : std_logic;

constant c_clk_period : time := 20 ns;

begin
DUT : debounce
generic map (
c_clk_freq => c_clk_freq,
c_deb_time => c_deb_time
)
port map (
clk => clk,
signal_i => signal_i,
signal_o => signal_o
);

P_CLK_GEN : process begin
    clk <= '0';
    wait for c_clk_period / 2;
    clk <= '1';
    wait for c_clk_period / 2;
end process;

P_STIMULI : process begin

    signal_i <= '0';
    wait for 500 us;
    
    signal_i <= '1';
    wait for 100 us;

    signal_i <= '0';
    wait for 80 us;
 
    signal_i <= '1';
    wait for 20 us;
 
    signal_i <= '0';
    wait for 200 us;
 
    signal_i <= '1';
    wait for 800 us;
  
    signal_i <= '0';
    wait for 200 us;
  
    signal_i <= '1';
    wait for 3 ms;
    
    
    signal_i <= '0';
    wait for 800 us;

    signal_i <= '1';
    wait for 220 us;
 
    signal_i <= '0';
    wait for 80 us;
 
    signal_i <= '1';
    wait for 200 us;
 
    signal_i <= '0';
    wait for 800 us;
  
    signal_i <= '1';
    wait for 200 us;
  
    signal_i <= '0';
    wait for 3 ms;
    
    assert false;
    report "SIM DONE"
    severity failure;
 
end process;

end Behavioral;
