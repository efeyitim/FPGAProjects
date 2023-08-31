-------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   19.07.2023
--  Short Description   :   
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    19.07.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aux_controller is

    port (
        clk      : in  std_logic;                                     -- main clock
        rst_n    : in  std_logic;                                     -- active low reset
        tx_wr_en : out std_logic;                                     -- tx fifo write
        tx_data  : out std_logic_vector(7 downto 0);                  -- tx fifo data
        rx_rd_en : out std_logic;                                     -- rx fifo read
        rx_data  : in  std_logic_vector(7 downto 0);                  -- rx fifo data
        rx_empty : in  std_logic;                                     -- rx fifo empty
        ram_addr : out std_logic_vector(7 downto 0);                  -- ram address
        ram_data : out std_logic_vector(7 downto 0);                  -- ram data
        ram_wren : out std_logic);                                    -- ram write enable

end entity aux_controller;

architecture rtl of aux_controller is

    signal counter : unsigned(16 downto 0);

    type state_t is (IDLE_S, ADDR_S, WRITE_S, READ_S, RAM_WRITE_S);
    signal state         : state_t;
    signal ram_addr_int  : unsigned(7 downto 0);
    signal addr_done     : std_logic;
    signal write_counter : unsigned(2 downto 0);
    signal write_cycle   : unsigned(3 downto 0);
    signal dont_read     : std_logic;

begin  -- architecture rtl

    ram_data <= rx_data;
    ram_addr <= std_logic_vector(ram_addr_int);

    PROC_CNTRL : process (clk, rst_n) is
    begin  -- process PROC_CNTRL
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            counter       <= (others => '0');
            state         <= IDLE_S;
            addr_done     <= '0';
            ram_addr_int  <= (others => '0');
            write_cycle   <= (others => '0');
            write_counter <= (others => '0');
            tx_data       <= (others => '0');
            tx_wr_en      <= '0';
            ram_wren      <= '0';
            rx_rd_en      <= '0';
            dont_read     <= '0';

        elsif rising_edge(clk) then                                   -- rising clock edge

            case state is
                when IDLE_S =>
                    ram_wren          <= '0';
                    tx_wr_en          <= '0';
                    if counter(16) = '1' then
                        counter       <= (others => '0');
                        if addr_done = '0' then
                            state     <= ADDR_S;
                        else
                            if write_cycle(3) /= '1' then
                                state <= WRITE_S;
                            end if;
                        end if;
                    else
                        if write_cycle(3) /= '1' then
                            counter   <= counter + 1;
                        end if;
                        if rx_empty = '0' then
                            rx_rd_en  <= '1';
                            state     <= READ_S;
                        end if;
                    end if;

                when ADDR_S =>
                    case write_counter is
                        when "000" =>
                            tx_data       <= x"40";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "001" =>
                            tx_data       <= x"00";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "010" =>
                            tx_data       <= x"50";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "011" =>
                            tx_data       <= x"00";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "100" =>
                            tx_data       <= x"00";
                            tx_wr_en      <= '1';
                            addr_done     <= '1';
                            write_counter <= (others => '0');
                            dont_read     <= '1';
                            state         <= IDLE_S;

                        when others => null;
                    end case;

                when WRITE_S =>
                    case write_counter is
                        when "000" =>
                            tx_data       <= x"50";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "001" =>
                            tx_data       <= x"00";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "010" =>
                            tx_data       <= x"50";
                            tx_wr_en      <= '1';
                            write_counter <= write_counter + 1;

                        when "011" =>
                            tx_data       <= x"0F";
                            tx_wr_en      <= '1';
                            addr_done     <= '1';
                            write_counter <= (others => '0');
                            write_cycle   <= write_cycle + 1;
                            dont_read     <= '1';
                            state         <= IDLE_S;

                        when others => null;
                    end case;

                when READ_S =>
                    rx_rd_en      <= '0';
                    if dont_read = '1' then
                        dont_read <= '0';
                        state     <= IDLE_S;
                    else
                        ram_wren  <= '1';
                        state     <= RAM_WRITE_S;
                    end if;

                when RAM_WRITE_S =>
                    ram_wren     <= '0';
                    ram_addr_int <= ram_addr_int + 1;
                    state        <= IDLE_S;

                when others => null;
            end case;
        end if;
    end process PROC_CNTRL;

end architecture rtl;
