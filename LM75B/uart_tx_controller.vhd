---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   FIFO Controller for UART TX module
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

entity uart_tx_controller is

    generic (
        NUM_DATA_BITS : integer := 8);                                -- number of data bits

    port (
        clk          : in  std_logic;                                     -- main clock
        rst_n        : in  std_logic;                                     -- active low reset
        tx_busy      : in  std_logic;                                     -- uart tx busy signal                
        fifo_rdempty : in  std_logic;                                     -- fifo read empty signal
        fifo_q       : in  std_logic_vector(NUM_DATA_BITS - 1 downto 0);  -- fifo output
        fifo_rdreq   : out std_logic;                                     -- fifo read request signal
        tx_din       : out std_logic_vector(NUM_DATA_BITS - 1 downto 0);  -- uart parallel data
        tx_start     : out std_logic);                                    -- uart tx start signal

end entity uart_tx_controller;

architecture rtl of uart_tx_controller is

    type state_t is (IDLE_S, WAIT_CYCLE_S, SEND_S);
    signal state : state_t;

begin  -- architecture rtl

    PROC_UART_TX_CNT : process (clk, rst_n) is
    begin  -- process PROC_UART_TX_CNT
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            fifo_rdreq <= '0';
            tx_din     <= (others => '0');
            tx_start   <= '0';
            state      <= IDLE_S;

        elsif rising_edge(clk) then                                   -- rising clock edge

            case state is

                when IDLE_S =>
                    if tx_busy = '0' and fifo_rdempty = '0' then
                        fifo_rdreq <= '1';
                        state      <= WAIT_CYCLE_S;
                    end if;

                when WAIT_CYCLE_S =>
                    fifo_rdreq <= '0';
                    state      <= SEND_S;

                when SEND_S =>
                    tx_din       <= fifo_q;
                    if tx_busy = '0' then
                        tx_start <= '1';
                    else
                        tx_start <= '0';
                        state    <= IDLE_S;
                    end if;

                when others =>
                    fifo_rdreq <= '0';
                    tx_din     <= (others => '0');
                    tx_start   <= '0';
                    state      <= IDLE_S;

            end case;
        end if;
    end process PROC_UART_TX_CNT;

end architecture rtl;
