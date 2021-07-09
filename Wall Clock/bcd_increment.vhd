----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2021 05:05:45 PM
-- Design Name: 
-- Module Name: bcd_increment - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_increment is
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
end bcd_increment;

architecture Behavioral of bcd_increment is

    signal ones : std_logic_vector (3 downto 0) := (others => '0');
    signal tens : std_logic_vector (3 downto 0) := (others => '0');

begin

    process (clk) begin
    if (rising_edge(clk)) then
    
        if (increment_i = '1') then
            if (ones = c_ones_lim) then
                if (tens = c_tens_lim) then
                    ones <= x"0";
                    tens <= x"0";
                else
                    ones <= x"0";
                    tens <= tens + 1;
                end if;
            else
                ones <= ones + 1;
            end if;
        end if;
        
        if (reset_i = '1') then
            ones <= x"0";
            tens <= x"0";
        end if;
        
    end if;
    end process;
    
    ones_o <= ones;
    tens_o <= tens;

end Behavioral;
