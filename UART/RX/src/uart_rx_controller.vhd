---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   FIFO Controller for UART RX module
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   27.11.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    27.11.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_controller is

    generic (
        IGNORE_ERROR  : boolean := false;                             -- ignore error
        NUM_DATA_BITS : integer := 8);                                -- number of data bits

    port (
        clk         : in  std_logic;                                     -- main clock
        rst_n       : in  std_logic;                                     -- active low reset
        rx_dout     : in  std_logic_vector(NUM_DATA_BITS - 1 downto 0);  -- uart parallel data
        rx_done     : in  std_logic;                                     -- uart rx busy signal
        rx_error    : in  std_logic_vector(1 downto 0);                  -- uart rx error
        fifo_wrfull : in  std_logic;                                     -- fifo write full signal
        fifo_data   : out std_logic_vector(NUM_DATA_BITS - 1 downto 0);  -- fifo input
        fifo_wrreq  : out std_logic);                                    -- fifo write request signal


end entity uart_rx_controller;

architecture rtl of uart_rx_controller is

    signal rx_done_prev : std_logic;
begin  -- architecture rtl

    PROC_UART_RX_CNT : process (clk, rst_n) is
    begin  -- process PROC_UART_RX_CNT
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            fifo_wrreq   <= '0';
            fifo_data    <= (others => '0');
            rx_done_prev <= '0';

        elsif rising_edge(clk) then                                   -- rising clock edge
            if IGNORE_ERROR then
                if fifo_wrfull = '0' and (rx_done_prev = '0' and rx_done = '1') then
                    fifo_wrreq <= '1';
                    fifo_data  <= rx_dout;
                else
                    fifo_wrreq <= '0';
                end if;
            end if;

            if not IGNORE_ERROR then
                if fifo_wrfull = '0' and (rx_done_prev = '0' and rx_done = '1') and rx_error = "00" then
                    fifo_wrreq <= '1';
                    fifo_data  <= rx_dout;
                else
                    fifo_wrreq <= '0';
                end if;
            end if;
        end if;
    end process PROC_UART_RX_CNT;

end architecture rtl;
