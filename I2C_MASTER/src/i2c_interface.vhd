---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   I2C Interface
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   26.11.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    26.11.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_interface is

    generic (
        CLK_FREQ  :       integer := 25_000_000;                      -- input clock frequency in hz
        I2C_FREQ  :       integer := 400_000);                        -- i2c clock frequency in hz
    port (
        clk       : in    std_logic;                                  -- system clock
        rst_n     : in    std_logic;                                  -- active low reset
        ena       : in    std_logic;                                  -- latch in command
        addr      : in    std_logic_vector(6 downto 0);               -- address of target slave
        rw        : in    std_logic;                                  -- '0' is write, '1' is read
        data_wr   : in    std_logic_vector(7 downto 0);               -- data to write to slave
        busy      : out   std_logic;                                  -- indicates transaction in progress
        data_rd   : out   std_logic_vector(7 downto 0);               -- data read from slave
        ack_error : out   std_logic;                                  -- flag if improper acknowledge from slave
        sda       : inout std_logic;                                  -- serial data output of i2c bus
        scl       : inout std_logic);                                 -- serial clock output of i2c bus

end entity i2c_interface;

architecture rtl of i2c_interface is

    constant CLK_1       : unsigned(11 downto 0) := to_unsigned(1*(CLK_FREQ/I2C_FREQ)/4, 12);  -- number of clocks in 1/4 cycle of scl
    constant CLK_2       : unsigned(11 downto 0) := to_unsigned(2*(CLK_FREQ/I2C_FREQ)/4, 12);  -- number of clocks in 2/4 cycle of scl
    constant CLK_3       : unsigned(11 downto 0) := to_unsigned(3*(CLK_FREQ/I2C_FREQ)/4, 12);  -- number of clocks in 3/4 cycle of scl
    constant CLK_4       : unsigned(11 downto 0) := to_unsigned(4*(CLK_FREQ/I2C_FREQ)/4, 12);  -- number of clocks in 4/4 cycle of scl
    type state_t is (READY_S, START_S, COMMAND_S, SLV_ACK1_S, WRITE_S, READ_S, SLV_ACK2_S, MASTER_ACK_S, STOP_S);  -- state machine type
    signal state         : state_t;                                   -- state machine
    signal data_clk      : std_logic;                                 -- data clock for sda
    signal data_clk_prev : std_logic;                                 -- data clock during previous system clock
    signal scl_clk       : std_logic;                                 -- constantly running internal scl
    signal scl_ena       : std_logic;                                 -- enables internal scl to output
    signal sda_int       : std_logic;                                 -- internal sda
    signal sda_ena_n     : std_logic;                                 -- enables internal sda to output
    signal addr_rw       : std_logic_vector(7 downto 0);              -- latched in address and read/write
    signal data_tx       : std_logic_vector(7 downto 0);              -- latched in data to write to slave
    signal data_rx       : std_logic_vector(7 downto 0);              -- data received from slave
    signal bit_cnt       : unsigned(2 downto 0);
    signal stretch       : std_logic;                                 -- identifies if slave is stretching scl
    signal count         : unsigned(11 downto 0);
    signal ack_error_buf : std_logic;

begin  -- architecture rtl

    --generate the timing for the bus clock (scl_clk) and the data clock (data_clk)
    PROC_CLKGEN : process(clk, rst_n)
    begin
        if rst_n = '0' then                                           --reset asserted
            stretch         <= '0';
            scl_clk         <= '0';
            data_clk        <= '0';
            data_clk_prev   <= '0';
            count           <= (others => '0');
        elsif rising_edge(clk) then
            data_clk_prev   <= data_clk;                              --store previous value of data clock
            if(count = CLK_4 - 1) then                                --end of timing cycle
                count       <= (others => '0');                       --reset timer
            elsif(stretch = '0') then                                 --clock stretching from slave not detected
                count       <= count + 1;                             --continue clock generation timing
            end if;
            if count < CLK_1 then
                scl_clk     <= '0';
                data_clk    <= '0';
            elsif count < CLK_2 then
                scl_clk     <= '0';
                data_clk    <= '1';
            elsif count < CLK_3 then
                scl_clk     <= '1';                                   --release scl
                if(scl = '0') then                                    --detect if slave is stretching clock
                    stretch <= '1';
                else
                    stretch <= '0';
                end if;
                data_clk    <= '1';
            else
                scl_clk     <= '1';
                data_clk    <= '0';
            end if;
        end if;
    end process;

    --state machine and writing to sda during scl low (data_clk rising edge)
    PROC_MAIN : process(clk, rst_n)
    begin
        if rst_n = '0' then                                           --reset asserted
            state         <= READY_S;                                 --return to initial state
            busy          <= '0';                                     --indicate not available
            scl_ena       <= '0';                                     --sets scl high impedance
            sda_int       <= '1';                                     --sets sda high impedance
            ack_error_buf <= '0';                                     --clear acknowledge error flag
            bit_cnt       <= (others => '1');                         --restarts data bit counter
            data_rd       <= (others => '0');                         --clear data read port
            data_rx       <= (others => '0');
            data_tx       <= (others => '0');
            addr_rw       <= (others => '0');
        elsif rising_edge(clk) then
            if(data_clk = '1' and data_clk_prev = '0') then           --data clock rising edge
                case state is

                    when READY_S =>                                   --idle state
                        if(ena = '1') then                            --transaction requested
                            busy    <= '1';                           --flag busy
                            addr_rw <= addr & rw;                     --collect requested slave address and command
                            data_tx <= data_wr;                       --collect requested data to write
                            state   <= START_S;                       --go to start bit
                        else                                          --remain idle
                            busy    <= '0';                           --unflag busy
                            state   <= READY_S;                       --remain idle
                        end if;

                    when START_S =>                                   --start bit of transaction
                        busy    <= '1';                               --resume busy if continuous mode
                        sda_int <= addr_rw(to_integer(bit_cnt));      --set first address bit to bus
                        state   <= COMMAND_S;                         --go to command

                    when COMMAND_S             =>                       --address and command byte of transaction
                        if(bit_cnt = 0) then                            --command transmit finished
                            sda_int <= '1';                             --release sda for slave acknowledge
                            bit_cnt <= (others => '1');                 --reset bit counter for "byte" states
                            state   <= SLV_ACK1_S;                      --go to slave acknowledge (command)
                        else                                            --next clock cycle of command state
                            bit_cnt <= bit_cnt - 1;                     --keep track of transaction bits
                            sda_int <= addr_rw(to_integer(bit_cnt-1));  --write address/command bit to bus
                            state   <= COMMAND_S;                       --continue with command
                        end if;

                    when SLV_ACK1_S =>                                --slave acknowledge bit (command)
                        if(addr_rw(0) = '0') then                     --write command
                            sda_int <= data_tx(to_integer(bit_cnt));  --write first bit of data
                            state   <= WRITE_S;                       --go to write byte
                        else                                          --read command
                            sda_int <= '1';                           --release sda from incoming data
                            state   <= READ_S;                        --go to read byte
                        end if;

                    when WRITE_S               =>                       --write byte of transaction
                        busy        <= '1';                             --resume busy if continuous mode
                        if(bit_cnt = 0) then                            --write byte transmit finished
                            sda_int <= '1';                             --release sda for slave acknowledge
                            bit_cnt <= (others => '1');                 --reset bit counter for "byte" states
                            state   <= SLV_ACK2_S;                      --go to slave acknowledge (write)             
                        else                                            --next clock cycle of write state
                            bit_cnt <= bit_cnt - 1;                     --keep track of transaction bits
                            sda_int <= data_tx(to_integer(bit_cnt-1));  --write next bit to bus
                            state   <= WRITE_S;                         --continue writing
                        end if;

                    when READ_S                    =>                   --read byte of transaction
                        busy            <= '1';                         --resume busy if continuous mode
                        if(bit_cnt = 0) then                            --read byte receive finished
                            if(ena = '1' and addr_rw = addr & rw) then  --continuing with another read at same address
                                sda_int <= '0';                         --acknowledge the byte has been received
                            else                                        --stopping or continuing with a write
                                sda_int <= '1';                         --send a no-acknowledge (before stop or repeated start)
                            end if;
                            bit_cnt     <= (others => '1');             --reset bit counter for "byte" states
                            data_rd     <= data_rx;                     --output received data
                            state       <= MASTER_ACK_S;                --go to master acknowledge            
                        else                                            --next clock cycle of read state
                            bit_cnt     <= bit_cnt - 1;                 --keep track of transaction bits
                            state       <= READ_S;                      --continue reading
                        end if;

                    when SLV_ACK2_S =>                                    --slave acknowledge bit (write)
                        if(ena = '1') then                                --continue transaction
                            busy        <= '0';                           --continue is accepted
                            addr_rw     <= addr & rw;                     --collect requested slave address and command
                            data_tx     <= data_wr;                       --collect requested data to write
                            if(addr_rw = addr & rw) then                  --continue transaction with another write
                                sda_int <= data_wr(to_integer(bit_cnt));  --write first bit of data
                                state   <= WRITE_S;                       --go to write byte
                            else                                          --continue transaction with a read or new slave
                                state   <= START_S;                       --go to repeated start
                            end if;
                        else                                              --complete transaction
                            state       <= STOP_S;                        --go to stop bit
                        end if;

                    when MASTER_ACK_S =>                              --master acknowledge bit after a read
                        if(ena = '1') then                            --continue transaction
                            busy        <= '0';                       --continue is accepted and data received is available on bus
                            addr_rw     <= addr & rw;                 --collect requested slave address and command
                            data_tx     <= data_wr;                   --collect requested data to write
                            if(addr_rw = addr & rw) then              --continue transaction with another read
                                sda_int <= '1';                       --release sda from incoming data
                                state   <= READ_S;                    --go to read byte
                            else                                      --continue transaction with a write or new slave
                                state   <= START_S;                   --repeated start
                            end if;
                        else                                          --complete transaction
                            state       <= STOP_S;                    --go to stop bit
                        end if;

                    when STOP_S =>                                    --stop bit of transaction
                        busy  <= '0';                                 --unflag busy
                        state <= READY_S;                             --go to idle state

                end case;

            elsif(data_clk = '0' and data_clk_prev = '1') then        --data clock falling edge
                case state is

                    when START_S =>
                        if(scl_ena = '0') then                        --starting new transaction
                            scl_ena       <= '1';                     --enable scl output
                            ack_error_buf <= '0';                     --reset acknowledge error output
                        end if;

                    when SLV_ACK1_S =>                                --receiving slave acknowledge (command)
                        if(sda /= '0' or ack_error_buf = '1') then    --no-acknowledge or previous no-acknowledge
                            ack_error_buf <= '1';                     --set error output if no-acknowledge
                        end if;

                    when READ_S =>                                    --receiving slave data
                        data_rx(to_integer(bit_cnt)) <= sda;          --receive current slave data bit

                    when SLV_ACK2_S =>                                --receiving slave acknowledge (write)
                        if(sda /= '0' or ack_error_buf = '1') then    --no-acknowledge or previous no-acknowledge
                            ack_error_buf <= '1';                     --set error output if no-acknowledge
                        end if;

                    when STOP_S =>
                        scl_ena <= '0';                               --disable scl

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    --set sda output
    with state select
        sda_ena_n <= data_clk_prev when START_S,                      --generate start condition
        not data_clk_prev          when STOP_S,                       --generate stop condition
        sda_int                    when others;                       --set to internal sda signal    

    --set scl and sda outputs
    scl <= '0' when (scl_ena = '1' and scl_clk = '0') else 'Z';
    sda <= '0' when sda_ena_n = '0'                   else 'Z';

    ack_error <= ack_error_buf;

end architecture rtl;
