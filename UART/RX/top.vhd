
library IEEE;
use IEEE.std_logic_1164.ALL;

entity top is
generic (
    c_clk_freq      : integer := 50_000_000;
    c_baud_rate     : integer := 9600
);

port (
    clk             : in std_logic;
    rx_i            : in std_logic;
    leds_o          : out std_logic_vector (7 downto 0)
);
end top;

architecture Behavioral of top is

component uart_rx is
generic (
    c_clk_freq      : integer := 50_000_000;
    c_baud_rate     : integer := 9600
);

port (
    clk             : in std_logic;
    rx_i            : in std_logic;
    dout_o          : out std_logic_vector (7 downto 0);
    rx_done_tick_o  : out std_logic
);
end component;

signal led          : std_logic_vector (7 downto 0) := (others => '0');
signal dout         : std_logic_vector (7 downto 0) := (others => '0');
signal rx_done_tick : std_logic := '0';

begin

    i_uart_tx : uart_rx 
    generic map (
        c_clk_freq   => c_clk_freq ,
        c_baud_rate  => c_baud_rate
    )
    
    port map(
        clk             => clk           ,
        rx_i            => rx_i          ,
        dout_o          => dout          ,
        rx_done_tick_o  => rx_done_tick
    );
    
    P_MAIN : process (clk) begin
    if (rising_edge(clk)) then
    
        if (rx_done_tick = '1') then
            
            led <= dout;
            
        end if;
    
    end if;
    end process;
    
    leds_o <= led;

end Behavioral;
