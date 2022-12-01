---------------------------------------------------------------------------------------------------
--  Project Name        :   ADS1115
--  System/Block Name   :   I2C Controller for ADS1115
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   01.12.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    01.12.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_controller_ads1115 is

    port (
        clk        : in  std_logic;                                   -- main clock
        rst_n      : in  std_logic;                                   -- active low reset
        busy       : in  std_logic;
        data_rd    : in  std_logic_vector(7 downto 0);
        fifo_full  : in  std_logic;
        ena        : out std_logic;
        addr       : out std_logic_vector(6 downto 0);
        rw         : out std_logic;
        data_wr    : out std_logic_vector(7 downto 0);
        fifo_wrreq : out std_logic;
        fifo_data  : out std_logic_vector(15 downto 0)
        );

end entity i2c_controller_ads1115;

architecture rtl of i2c_controller_ads1115 is
    attribute mark_debug : string;
    
    type state_t is (CONFIG_ADDR_S, CONFIG_WRITE1_S, CONFIG_WRITE2_S, READ_CMD_S, READ_FIRST_S, READ_SECOND_S);
    signal state     : state_t;
    attribute mark_debug of state : signal is "true";    
    signal busy_prev : std_logic;
    signal ain_mux   : std_logic;                                     -- signal to select which analog input to sample
    attribute mark_debug of ain_mux : signal is "true";

    constant CONV_REG_ADDR   : std_logic_vector(7 downto 0) := x"00";
    constant CONFIG_REG_ADDR : std_logic_vector(7 downto 0) := x"01";
    constant CONFIG_MSB1     : std_logic_vector(7 downto 0) := x"44";  -- 0100_0100 AIN0
    constant CONFIG_MSB2     : std_logic_vector(7 downto 0) := x"54";  -- 0101_0100 AIN1    
    constant CONFIG_LSB      : std_logic_vector(7 downto 0) := x"E0";  -- 1110_0000

begin  -- architecture rtl

    PROC_MAIN : process (clk, rst_n) is
    begin  -- process PROC_MAIN
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            ena        <= '0';
            addr       <= "1001000";
            rw         <= '0';
            data_wr    <= (others => '0');
            busy_prev  <= '0';
            fifo_wrreq <= '0';
            fifo_data  <= (others => '0');
            ain_mux    <= '0';
            state      <= CONFIG_ADDR_S;

        elsif rising_edge(clk) then                                   -- rising clock edge
            busy_prev <= busy;

            case state is

                when CONFIG_ADDR_S =>
                    fifo_wrreq      <= '0';
                    if busy = '0' then
                        ena         <= '1';
                        rw          <= '0';                           -- write
                        data_wr     <= CONFIG_REG_ADDR;
                    else
                        if ain_mux = '0' then
                            data_wr <= CONFIG_MSB1;
                        else
                            data_wr <= CONFIG_MSB2;
                        end if;
                        state       <= CONFIG_WRITE1_S;
                    end if;

                when CONFIG_WRITE1_S =>
                    if busy_prev = '0' and busy = '1' then
                        data_wr <= CONFIG_LSB;
                        state   <= CONFIG_WRITE2_S;
                    end if;

                when CONFIG_WRITE2_S =>
                    if busy_prev = '0' and busy = '1' then
                        ena     <= '0';
                        ain_mux <= not ain_mux;
                        state   <= READ_CMD_S;
                    end if;

                when READ_CMD_S =>
                    if busy_prev = '1' and busy = '0' then
                        ena     <= '1';
                        rw      <= '1';                               -- read
                        data_wr <= CONV_REG_ADDR;
                    end if;

                    if busy_prev = '0' and busy = '1' then
                        state <= READ_FIRST_S;
                    end if;

                when READ_FIRST_S =>
                    if busy_prev = '1' and busy = '0' then
                        fifo_data(15 downto 8) <= data_rd;
                    end if;

                    if busy_prev = '0' and busy = '1' then
                        ena   <= '0';
                        state <= READ_SECOND_S;
                    end if;

                when READ_SECOND_S =>
                    if busy_prev = '1' and busy = '0' then
                        fifo_data(7 downto 0) <= data_rd;
                        if fifo_full = '0' then
                            fifo_wrreq        <= '1';
                        end if;
                        state                 <= CONFIG_ADDR_S;
                    end if;

                when others =>
                    ena        <= '0';
                    addr       <= "1001000";
                    rw         <= '0';
                    data_wr    <= (others => '0');
                    busy_prev  <= '0';
                    fifo_wrreq <= '0';
                    fifo_data  <= (others => '0');
                    ain_mux    <= '0';
                    state      <= CONFIG_ADDR_S;

            end case;
        end if;
    end process PROC_MAIN;
end architecture rtl;
