----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2021 06:41:04 PM
-- Design Name: 
-- Module Name: uart_rx - Behavioral
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

entity uart_rx is
generic (
    c_clk_freq      : integer := 50_000_000;
    c_baud_rate     : integer := 115_200
);

port (
    clk             : in std_logic;
    rx_i            : in std_logic;
    dout_o          : out std_logic_vector (7 downto 0);
    rx_done_tick_o  : out std_logic
);
end uart_rx;

architecture Behavioral of uart_rx is

constant c_bit_timer_lim  : integer := c_clk_freq / c_baud_rate;

type t_state is (S_IDLE, S_START, S_STOP, S_DATA);
signal state        : t_state := S_IDLE;

--signal next_state        : t_state := S_IDLE;

signal bit_timer  : integer range 0 to c_bit_timer_lim := 0;
signal bit_counter : integer range 0 to 7 := 0;
signal shift_reg    : std_logic_vector (7 downto 0) := x"00";

begin

    P_MAIN : process (clk) begin
    if (rising_edge(clk)) then
        
        case state is
        
            when S_IDLE =>
            
                rx_done_tick_o  <= '0';
                bit_timer       <= 0;   
                
                if (rx_i = '0') then
                    state <= S_START;
                end if;
                
            when S_START =>
            
                if (bit_timer = c_bit_timer_lim / 2 - 1) then
                    state       <= S_DATA;
                    bit_timer   <= 0;
                else
                    bit_timer   <= bit_timer + 1;
                end if;
            
            when S_DATA =>
            
                if (bit_counter = 7) then
                    if (bit_timer = c_bit_timer_lim - 1) then
                        state <= S_STOP;
                        shift_reg               <= rx_i & shift_reg(7 downto 1);
                        bit_counter <= 0;
                        bit_timer   <= 0;
                    else
                        bit_timer   <= bit_timer + 1;
                    end if;     
                else
                    if (bit_timer = c_bit_timer_lim - 1) then
                        shift_reg               <= rx_i & shift_reg(7 downto 1);
                        bit_counter             <= bit_counter + 1;
                        bit_timer               <= 0;
                    else
                        bit_timer               <= bit_timer + 1;
                    end if;
                end if;
    
    --this is also good            
    --            if (bit_timer = c_bit_timer_lim - 1) then
    --                if (bit_counter = 7) then
    --                    state       <= S_STOP;
    --                    bit_counter <= 0;
    --                else
    --                    bit_counter <= bit_counter + 1;
    --                end if;
    --                bit_timer       <= 0;
    --                shift_reg       <= rx_i & shift_reg(7 downto 1);
    --            else
    --                bit_timer       <= bit_timer + 1;
    --            end if;
            
            when S_STOP =>
            
                if (bit_timer = c_bit_timer_lim - 1) then
                    state <= S_IDLE;
                    rx_done_tick_o  <= '1';
                    bit_timer       <= 0;
                else
                    bit_timer       <= bit_timer + 1;
                end if;
        
        end case;
        
    end if;
    end process;

dout_o <= shift_reg;

end Behavioral;