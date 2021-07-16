----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2021 11:18:44 PM
-- Design Name: 
-- Module Name: tb_uart_tx - Behavioral
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
--use IEEE.numeric_std;

entity tb_uart_tx is
generic (
    c_clk_freq  : integer := 50_000_000;
    c_baud_rate : integer := 5_000_000;
    c_stop_bit  : integer := 2
);
end tb_uart_tx;

architecture Behavioral of tb_uart_tx is

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

signal    clk             : std_logic := '0';
signal    din_i           : std_logic_vector (7 downto 0) := (others => '0');
signal    tx_start_i      : std_logic := '0';
signal    tx_o            : std_logic;
signal    tx_done_tick_o  : std_logic;

constant c_clk_period     : time := 1000 ms / c_clk_freq;

begin

DUT : uart_tx 
generic map(
    c_clk_freq  => c_clk_freq   ,
    c_baud_rate => c_baud_rate  ,
    c_stop_bit  => c_stop_bit   
)

port map(
    clk             => clk              ,
    din_i           => din_i            ,
    tx_start_i      => tx_start_i       ,
    tx_o            => tx_o             ,
    tx_done_tick_o  => tx_done_tick_o   
);

P_CLKGEN : process begin
    clk <= '0';
    wait for c_clk_period / 2;
    clk <= '1';
    wait for c_clk_period / 2;
end process P_CLKGEN;

P_STIMULI : process begin

    din_i <= x"00";
    tx_start_i <= '0';
    
    wait for c_clk_period * 10;
    
    din_i <= x"37";
    tx_start_i <= '1';
    
    wait for c_clk_period;
    
    tx_start_i <= '0';
    
    wait for 2.3 us;

    din_i <= x"EF";
    tx_start_i <= '1';
    
    wait for c_clk_period;
    
    tx_start_i <= '0';
    
    wait until (rising_edge(tx_done_tick_o));
    
    wait for 1 us;
    
    assert false
    report "SIM DONE"
    severity failure;
end process;




end Behavioral;
