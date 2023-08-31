-------------------------------------------------------------------------------------------
--  Project Name        :   DP AUX
--  System/Block Name   :   aux_interface.vhd
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   19.07.2023
--  Short Description   :   This block implements AUX interface for DP AUX. It contains
--                          one TX and one RX FIFO. It implements Manchester Encoding.
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    19.07.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aux_interface is

    generic (
        clock_period_in_ns : integer := 10);

    port (
        clk         : in    std_logic;                                -- main clock
        rst_n       : in    std_logic;                                -- active low reset
        dp_tx_aux_p : inout std_logic;                                -- TX AUX P
        dp_tx_de    : out   std_logic;
        dp_tx_ren   : out   std_logic;
        dp_tx_din   : out   std_logic;
        dp_tx_rout  : in    std_logic;
        -- dp_tx_aux_n : inout std_logic;                                -- TX AUX N
        -- dp_rx_aux_p : inout std_logic;                                -- RX AUX P
        -- dp_rx_aux_n : inout std_logic;                                -- RX AUX N
        tx_wr_en    : in    std_logic;                                -- TX FIFO Write Enable
        tx_data     : in    std_logic_vector(7 downto 0);             -- TX FIFO input data
        tx_full     : out   std_logic;                                -- TX FIFO full
        rx_rd_en    : in    std_logic;                                -- RX FIFO Read Enable
        rx_data     : out   std_logic_vector(7 downto 0);             -- RX FIFO output data
        rx_empty    : out   std_logic;                                -- RX FIFO Empty
        busy        : out   std_logic;                                -- AUX Interface busy
        timeout     : out   std_logic);                               -- AUX Interface timeout

end entity aux_interface;

architecture rtl of aux_interface is

    type fifo_type is array (0 to 31) of std_logic_vector(7 downto 0);

    -- TX FIFO
    signal tx_fifo          : fifo_type;
    signal tx_rd_ptr        : unsigned(4 downto 0);
    signal tx_wr_ptr        : unsigned(4 downto 0);
    signal tx_wr_ptr_plus_1 : unsigned(4 downto 0);

    signal tx_empty   : std_logic;
    signal tx_full_i  : std_logic;
    signal tx_rd_data : std_logic_vector(7 downto 0);
    signal tx_rd_en   : std_logic;

    -- RX FIFO
    signal rx_fifo          : fifo_type;
    signal rx_wr_ptr        : unsigned(4 downto 0);
    signal rx_wr_ptr_plus_1 : unsigned(4 downto 0);
    signal rx_rd_ptr        : unsigned(4 downto 0);

    signal rx_empty_i : std_logic;
    signal rx_full    : std_logic;
    signal rx_wr_data : std_logic_vector(7 downto 0);
    signal rx_wr_en   : std_logic;

    signal timeout_count   : unsigned(15 downto 0) := (others => '0');
    constant timeout_limit : unsigned(15 downto 0) := to_unsigned((400000 / clock_period_in_ns) - 1, 16);  -- 400 us

    signal bit_counter_tx       : unsigned(7 downto 0);
    signal bit_counter_rx       : unsigned(7 downto 0);
    constant bit_counter_limit  : unsigned(7 downto 0) := to_unsigned((1000 / 2 / clock_period_in_ns) - 1, 8);  -- 1 Mbit (/ 2 because half baud)
    constant bit_counter_limit2 : unsigned(7 downto 0) := to_unsigned((1000 / 2 / clock_period_in_ns / 2), 8);  -- 1 Mbit (/ 2 because half baud,
    constant bit_counter_limit3  : unsigned(7 downto 0) := to_unsigned((1000 / 2 / clock_period_in_ns), 8);  -- 1 Mbit (/ 2 because half baud)
                                                                                                                -- /2 because half bit)

    signal serial_data : std_logic;
    signal tristate    : std_logic;

    signal data_sr : std_logic_vector(15 downto 0);
    signal busy_sr : std_logic_vector(15 downto 0);

    type t_tx_state is (TX_IDLE_S, TX_SYNC_S, TX_START_S, TX_SEND_DATA_S, TX_STOP_S, TX_WAIT_S);
    signal tx_state : t_tx_state;

    type t_rx_state is (RX_WAIT_S, RX_RECEIVING_DATA_S);
    signal rx_state : t_rx_state;

    signal rx_finished : std_logic;
    signal rx_holdoff  : std_logic_vector(9 downto 0);
    signal rx_meta1    : std_logic;
    signal rx_meta2    : std_logic;
    signal rx_sync     : std_logic;
    signal rx_sync_buf : std_logic;
    signal rx_sample   : std_logic;
    signal rx_buffer   : std_logic_vector(15 downto 0);
    signal rx_bits     : std_logic_vector(15 downto 0);
    signal rx_raw      : std_logic;
    signal rx_start    : std_logic;

begin  -- architecture rtl

    rx_wr_ptr_plus_1 <= rx_wr_ptr+1;
    tx_wr_ptr_plus_1 <= tx_wr_ptr+1;
    rx_empty_i       <= '1' when rx_wr_ptr = rx_rd_ptr        else '0';
    rx_full          <= '1' when rx_wr_ptr_plus_1 = rx_rd_ptr else '0';
    tx_empty         <= '1' when tx_wr_ptr = tx_rd_ptr        else '0';
    tx_full_i        <= '1' when tx_wr_ptr_plus_1 = tx_rd_ptr else '0';
    rx_empty         <= rx_empty_i;
    tx_full          <= tx_full_i;

    -- rx_raw      <= dp_tx_aux_p;                                       -- when tristate = '1' else 'Z';
    rx_raw      <= dp_tx_rout;                                        -- when tristate = '1' else 'Z';
    dp_tx_aux_p <= serial_data when tristate = '0' else 'Z';

    dp_tx_de  <= not tristate;
    -- dp_tx_ren <= not tristate;
    dp_tx_ren <= '0';
    dp_tx_din <= serial_data when busy_sr(busy_sr'high) = '1'             else '0';
    busy      <= '0'         when tx_empty = '1' and tx_state = TX_IDLE_S else '1';

    PROC_TX_FIFO : process (clk, rst_n) is
    begin  -- process PROC_TX_FIFO
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            tx_fifo                            <= (others => (others => '0'));
            tx_wr_ptr                          <= (others => '0');
            tx_rd_ptr                          <= (others => '0');
            tx_rd_data                         <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge
            if tx_full_i = '0' and tx_wr_en = '1' then
                tx_fifo(to_integer(tx_wr_ptr)) <= tx_data;
                tx_wr_ptr                      <= tx_wr_ptr+1;
            end if;

            if tx_empty = '0' and tx_rd_en = '1' then
                tx_rd_data <= tx_fifo(to_integer(tx_rd_ptr));
                tx_rd_ptr  <= tx_rd_ptr + 1;
            end if;
        end if;
    end process PROC_TX_FIFO;

    PROC_RX_FIFO : process (clk, rst_n) is
    begin  -- process PROC_RX_FIFO
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            rx_fifo                            <= (others => (others => '0'));
            rx_wr_ptr                          <= (others => '0');
            rx_rd_ptr                          <= (others => '0');
            rx_data                            <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge
            if rx_full = '0' and rx_wr_en = '1' then
                rx_fifo(to_integer(rx_wr_ptr)) <= rx_wr_data;
                rx_wr_ptr                      <= rx_wr_ptr+1;
            end if;

            if rx_empty_i = '0' and rx_rd_en = '1' then
                rx_data   <= rx_fifo(to_integer(rx_rd_ptr));
                rx_rd_ptr <= rx_rd_ptr + 1;
            end if;
        end if;
    end process PROC_RX_FIFO;

    PROC_TIMEOUT : process (clk, rst_n) is
    begin  -- process PROC_BIT
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            timeout_count             <= (others => '0');
            timeout                   <= '0';
        elsif rising_edge(clk) then                                   -- rising clock edge
            if bit_counter_tx = bit_counter_limit then
                if tx_state = TX_WAIT_S and rx_state = RX_WAIT_S then
                    if timeout_count = timeout_limit then
                        timeout       <= '1';
                    else
                        timeout_count <= timeout_count + 1;
                    end if;
                else
                    timeout           <= '0';
                    timeout_count     <= (others => '0');
                end if;
            end if;
        end if;
    end process PROC_TIMEOUT;

    PROC_TX : process (clk, rst_n) is
    begin  -- process PROC_TX
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            bit_counter_tx     <= (others => '0');
            serial_data        <= '0';
            tristate           <= '0';
            data_sr            <= (others => '0');
            busy_sr            <= (others => '0');
            rx_holdoff         <= (others => '1');
            tx_state           <= TX_IDLE_S;
            rx_start           <= '0';
        elsif rising_edge(clk) then                                   -- rising clock edge
            tx_rd_en           <= '0';
            if bit_counter_tx = bit_counter_limit then
                bit_counter_tx <= (others => '0');
                serial_data    <= data_sr(data_sr'high);
                tristate       <= not busy_sr(busy_sr'high);
                data_sr        <= data_sr(data_sr'high - 1 downto 0) & '0';
                busy_sr        <= busy_sr(busy_sr'high - 1 downto 0) & '0';

                if tx_state = TX_WAIT_S then
                    rx_holdoff <= rx_holdoff(rx_holdoff'high-1 downto 0) & '0';
                else
                    rx_holdoff <= (others => '1');
                end if;


                if busy_sr(busy_sr'high - 1) = '0' then
                    case tx_state is
                        -- start sending SYNC if fifo is not empty
                        when TX_IDLE_S =>
                            if tx_empty = '0' then
                                data_sr  <= "0101010101010101";
                                busy_sr  <= "1111111111111111";
                                tx_state <= TX_SYNC_S;
                            end if;
                        -- continue sending SYNC
                        when TX_SYNC_S =>
                            data_sr      <= "0101010101010101";
                            busy_sr      <= "1111111111111111";
                            tx_state     <= TX_START_S;
                        -- send start pattern
                        when TX_START_S =>
                            data_sr      <= "1111000000000000";
                            busy_sr      <= "1111111100000000";
                            tx_rd_en     <= '1';
                            tx_state     <= TX_SEND_DATA_S;
                        -- send data
                        when TX_SEND_DATA_S =>
                            data_sr      <= tx_rd_data(7) & not tx_rd_data(7) & tx_rd_data(6) & not tx_rd_data(6) &
                                       tx_rd_data(5) & not tx_rd_data(5) & tx_rd_data(4) & not tx_rd_data(4) &
                                       tx_rd_data(3) & not tx_rd_data(3) & tx_rd_data(2) & not tx_rd_data(2) &
                                       tx_rd_data(1) & not tx_rd_data(1) & tx_rd_data(0) & not tx_rd_data(0);
                            busy_sr      <= "1111111111111111";
                            if tx_empty = '1' then
                                -- Send this word, and follow it up with a STOP
                                tx_state <= TX_STOP_S;
                            else
                                -- Send this word, and also read the next one from the FIFO
                                tx_rd_en <= '1';
                            end if;
                        -- send stop pattern
                        when TX_STOP_S =>
                            data_sr      <= "1111000000000000";
                            busy_sr      <= "1111111100000000";
                            tx_state     <= TX_WAIT_S;

                        when TX_WAIT_S =>
                            rx_start <= '1';

                        when others =>
                            bit_counter_tx <= (others => '0');
                            serial_data    <= '0';
                            tristate       <= '0';
                            data_sr        <= (others => '0');
                            busy_sr        <= (others => '0');
                            tx_state       <= TX_IDLE_S;

                    end case;
                end if;
            else
                bit_counter_tx <= bit_counter_tx + 1;
            end if;

            if tx_state = TX_WAIT_S and rx_finished = '1' then
                rx_start <= '0';
                tx_state <= TX_IDLE_S;
            end if;
        end if;
    end process PROC_TX;

    PROC_RX : process (clk, rst_n) is
    begin  -- process PROC_RX
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            rx_meta1       <= '0';
            rx_meta2       <= '0';
            rx_sync        <= '0';
            rx_sync_buf    <= '0';
            rx_sample      <= '0';
            rx_buffer      <= (others => '0');
            rx_bits        <= (others => '0');
            bit_counter_rx <= (others => '0');
            rx_finished    <= '0';
            rx_wr_en       <= '0';
            rx_wr_data     <= (others => '0');
            rx_state       <= RX_WAIT_S;
        elsif rising_edge(clk) then                                   -- rising clock edge
            rx_meta1       <= rx_raw;
            rx_meta2       <= rx_meta1;
            rx_sync        <= rx_meta2;
            rx_sync_buf    <= rx_sync;
            rx_finished    <= '0';
            rx_wr_en       <= '0';

            if bit_counter_rx = bit_counter_limit then
                rx_sample      <= '1';
                rx_buffer      <= rx_buffer(rx_buffer'high - 1 downto 0) & rx_sync;
                rx_bits        <= rx_bits(rx_bits'high - 1 downto 0) & '1';
                bit_counter_rx <= (others => '0');
            else
                bit_counter_rx <= bit_counter_rx + 1;
                rx_sample      <= '0';
            end if;

            if rx_sync /= rx_sync_buf then
                bit_counter_rx <= bit_counter_limit2;
            end if;

            if rx_sample = '1' then
                case rx_state is
                    when RX_WAIT_S =>
                        if rx_buffer = "0101010111110000" then
                            rx_bits      <= (others => '0');
                            if rx_holdoff(rx_holdoff'high-1) = '0' then
                                rx_state <= RX_RECEIVING_DATA_S;
                            end if;
                        end if;

                    when RX_RECEIVING_DATA_S =>
                        if rx_bits(rx_bits'high) = '1' then
                            rx_bits             <= (others => '0');
                            if rx_buffer(15) = rx_buffer(14) or rx_buffer(13) = rx_buffer(12) or
                                rx_buffer(11) = rx_buffer(10) or rx_buffer(9) = rx_buffer(8) or
                                rx_buffer(7) = rx_buffer(6) or rx_buffer(5) = rx_buffer(4) or
                                rx_buffer(3) = rx_buffer(2) or rx_buffer(1) = rx_buffer(0) then
                                rx_state        <= RX_WAIT_S;
                                if rx_holdoff(rx_holdoff'high) = '0' then
                                    rx_finished <= '1';
                                end if;
                            else
                                rx_wr_data      <= rx_buffer(15) & rx_buffer(13) & rx_buffer(11) & rx_buffer(9) &
                                              rx_buffer(7) & rx_buffer(5) & rx_buffer(3) & rx_buffer(1);
                                rx_wr_en        <= '1';
                            end if;
                        end if;

                    when others => null;
                end case;
            end if;

        end if;
    end process PROC_RX;
    
end architecture rtl;
