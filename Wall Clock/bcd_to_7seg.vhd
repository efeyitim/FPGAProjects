----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2021 05:05:45 PM
-- Design Name: 
-- Module Name: bcd_to_7seg - Behavioral
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

entity bcd_to_7seg is
port (
    bcd_i   : in std_logic_vector (3 downto 0);
    sevenseg_o  : out std_logic_vector (6 downto 0)
);
end bcd_to_7seg;

architecture Behavioral of bcd_to_7seg is

begin

    SEVENSEG : process (bcd_i) begin
    
        case bcd_i is
        
            when "0000" =>
                sevenseg_o <= "1000000";
            
            when "0001" =>
                sevenseg_o <= "1111001";
                
            when "0010" =>
                sevenseg_o <= "0100100";
            
            when "0011" =>
                sevenseg_o <= "0110000";
            
            when "0100" =>
                sevenseg_o <= "0011001";
            
            when "0101" =>
                sevenseg_o <= "0010010";
            
            when "0110" =>
                sevenseg_o <= "0000010";
            
            when "0111" =>
                sevenseg_o <= "1111000";
            
            when "1000" =>
                sevenseg_o <= "0000000";
            
            when "1001" =>
                sevenseg_o <= "0010000";
                
            when others =>
                sevenseg_o <= "1111111";
            
        end case;
    
    end process;
    
end Behavioral;
