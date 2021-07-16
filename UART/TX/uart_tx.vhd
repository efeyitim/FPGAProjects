----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/10/2021 10:18:53 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
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
end uart_tx;

architecture Behavioral of uart_tx is

constant c_bit_counter_lim  : integer := c_clk_freq / c_baud_rate;
constant c_stop_bit_lim 	: integer := (c_clk_freq / c_baud_rate) * c_stop_bit;

type t_state is (S_IDLE, S_START, S_STOP, S_DATA);
signal state        : t_state := S_IDLE;

signal bit_timer  : integer range 0 to c_stop_bit_lim := 0;
signal bit_counter : integer range 0 to 7 := 0;
signal shift_reg    : std_logic_vector (7 downto 0) := x"00";

begin

P_DATAPATH : process (clk) begin
if (rising_edge(clk)) then
    case state is
    
        when S_IDLE =>
        
            tx_o <= '1';
            tx_done_tick_o <= '0';
            bit_counter <= 0;   
            
            if (tx_start_i = '1') then
                state <= S_START;
                tx_o        <= '0';
                shift_reg   <= din_i;
            end if;
            
        when S_START =>
        
            if (bit_timer = c_bit_counter_lim - 1) then
                state <= S_DATA;
                tx_o                    <= shift_reg(0);
                shift_reg (7)           <= shift_reg(0);
                shift_reg (6 downto 0)  <= shift_reg(7 downto 1);
                bit_timer               <= 0;
            else
                bit_timer               <= bit_timer + 1;
            end if;
        
        when S_DATA =>
        
            
            if (bit_counter = 7) then
                if (bit_timer = c_bit_counter_lim - 1) then
                    state <= S_STOP;
                    bit_counter <= 0;
                    tx_o        <= '1';
                    bit_timer   <= 0;
                else
                    bit_timer   <= bit_timer + 1;
                end if;     
            else
                if (bit_timer = c_bit_counter_lim - 1) then
                    shift_reg (7)           <= shift_reg(0);
                    shift_reg (6 downto 0)  <= shift_reg(7 downto 1);
                    tx_o                    <= shift_reg(0);
                    bit_counter             <= bit_counter + 1;
                    bit_timer               <= 0;
                else
                    bit_timer               <= bit_timer + 1;
                end if;
            end if;
        
        when S_STOP =>
        
            if (bit_timer = c_stop_bit_lim - 1) then
                state <= S_IDLE;
                tx_done_tick_o  <= '1';
                bit_timer       <= 0;
            else
                bit_timer       <= bit_timer + 1;
            end if;
    
    end case;
end if;
end process;


end Behavioral;
