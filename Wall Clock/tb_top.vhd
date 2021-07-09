----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2021 08:08:02 PM
-- Design Name: 
-- Module Name: tb_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top is
generic (
    c_clk_freq : integer := 50_000_000
);
end tb_top;

architecture Behavioral of tb_top is

component top is
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
end component;

signal clk         : std_logic := '0';
signal reset_i     : std_logic := '0';
signal setting_i   : std_logic := '0';
signal shift_i     : std_logic := '0';
signal leds_o      : std_logic_vector (5 downto 0);

constant c_clk_period : time := 20 ns;

begin

    DUT : top
    generic map (
    c_clk_freq => c_clk_freq
    )
    port map (
    clk         => clk,
    reset_i     => reset_i,
    setting_i   => setting_i,
    shift_i     => shift_i,
    leds_o      => leds_o
    );
    
    P_CLK_GEN : process begin
        clk <= '0';
        wait for c_clk_period / 2;
        clk <= '1';
        wait for c_clk_period / 2;
    end process;
    
    P_STIMULI : process begin
    
        wait for 3 sec;
        
        assert false;
        report "SIM DONE"
        severity failure;
     
    end process;


end Behavioral;
