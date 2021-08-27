----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2021 19:09:44 PM
-- Design Name: 
-- Module Name: tb_uart_rx - Behavioral
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

entity tb_uart_rx is
generic (
    c_clk_freq  : integer := 50_000_000;
    c_baud_rate : integer := 115_200
);
end tb_uart_rx;

architecture Behavioral of tb_uart_rx is

component uart_rx is
generic (
    c_clk_freq  : integer := 50_000_000;
    c_baud_rate : integer := 115_200
);

port (
    clk             : in std_logic;
    rx_i            : in std_logic;
    dout_o          : out std_logic_vector (7 downto 0);
    rx_done_tick_o  : out std_logic
);
end component;

signal    clk             : std_logic := '0';
signal    rx_i            : std_logic := '0';
signal    dout_o          : std_logic_vector (7 downto 0);
signal    rx_done_tick_o  : std_logic;

constant c_clk_period   : time := 1000 ms / c_clk_freq;
constant c_baud115200   : time := 1000 ms / c_baud_rate; --8.68 us;
constant c_hex37        : std_logic_vector (9 downto 0) := '1' & x"37" & '0'; --1_0011_0111_0 ___ 0_1110_1100_1
constant c_hexEF        : std_logic_vector (9 downto 0) := '1' & x"EF" & '0';

begin

DUT : uart_rx
generic map(
    c_clk_freq  => c_clk_freq ,
    c_baud_rate => c_baud_rate
)

port map(
    clk             => clk           ,
    rx_i            => rx_i          ,
    dout_o          => dout_o        ,
    rx_done_tick_o  => rx_done_tick_o
);

P_CLKGEN : process begin
    clk <= '0';
    wait for c_clk_period / 2;
    clk <= '1';
    wait for c_clk_period / 2;
end process P_CLKGEN;

P_STIMULI : process begin

    rx_i <= '1';

    wait for 10 * c_clk_period;
    
    for i in 0 to 9 loop
    
        rx_i <= c_hex37(i);
        wait for c_baud115200;
    
    end loop;
    
    wait for 10 us;
    
    for i in 0 to 9 loop
    
        rx_i <= c_hexEF(i);
        wait for c_baud115200;
    
    end loop;
    
    wait for 20 us;
    --wait until rising_edge(rx_done_tick_o);
    
    assert false
    report "SIM DONE"
    severity failure;
end process;

end Behavioral;
