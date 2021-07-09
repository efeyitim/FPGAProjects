    ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2021 12:28:18 AM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
generic (
c_clk_freq  : integer := 50_000_000;
c_deb_time  : integer := 500
);

port (
clk         :   in std_logic;
signal_i    :   in std_logic;
signal_o    :   out std_logic
);
end debounce;

architecture Behavioral of debounce is

constant c_timer_lim : integer := c_clk_freq / c_deb_time;

signal timer        : integer range 0 to c_timer_lim := 0;
signal timer_en     : std_logic := '0';
signal timer_tick   : std_logic := '1';    

type t_state is (S_INIT, S_ONE, S_ZERO, S_TRANS);
signal state        : t_state := S_INIT;
signal next_state   : t_state := S_INIT;
signal old_state    : t_state := S_INIT;

begin

P_NEXT_STATE : process (clk) begin

    if (rising_edge(clk)) then
        
        case state is
                
            when S_INIT =>
                if (signal_i = '0') then
                    old_state <= S_ZERO;
                    next_state <= S_ZERO;
                else
                    old_state <= S_ONE;
                    next_state <= S_ONE;
                end if;
            
            when S_ONE =>
            
                signal_o <= '1';
                timer_en <= '0';
                
                if (signal_i = '0') then
                    old_state <= S_ONE;
                    next_state <= S_TRANS;
                end if; 
            
            when S_ZERO =>
            
                signal_o <= '0';
                timer_en <= '0';
                
                if (signal_i = '1') then
                    old_state <= S_ZERO;
                    next_state <= S_TRANS;
                end if; 
             
            when S_TRANS =>
            
                 if (old_state = S_ONE) then
                    signal_o <= '1';
                 else
                    signal_o <= '0';
                 end if;
                 
                 timer_en <= '1';
                 
                 if (timer_tick = '1') then
                    timer_en <= '0';
                    if (old_state = S_ONE) then
                        next_state <= S_ZERO;
                    else
                        next_state <= S_ONE;
                    end if;
                 end if;
                 
                 if (old_state = S_ONE) then
                    if (signal_i = '1') then
                        next_state <= S_ONE;
                        timer_en <= '0';
                    --else?
                    end if;
                 else
                    if (signal_i = '0') then
                        next_state <= S_ZERO;
                        timer_en <= '0';
                    --else?
                    end if;                 
                 end if;
            
        end case;
        
    end if;
end process;

P_CURR_STATE : process (clk) begin

    if (rising_edge(clk)) then
        state <= next_state;
    end if;
    
end process;

P_TIMER : process (clk) begin

    if (rising_edge(clk)) then
        if (timer_en = '1') then
            if (timer = c_timer_lim - 1) then
                timer <= 0;
                timer_tick <= '1';
            else
                timer <= timer + 1;
                timer_tick <= '0';
            end if;
        else
            timer <= 0;
            timer_tick <= '0';
        end if;
    
    end if;
end process;

end Behavioral;