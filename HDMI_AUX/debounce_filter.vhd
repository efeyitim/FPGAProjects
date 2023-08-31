---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   debounce_filter
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   29.12.2022
--  Short Description   :   Debounce filter.
-------------------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------------------
--  v1.0    efeyitim    29.12.2022      v1.0 Initial Release
-------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_filter is

    generic (
        INIT_VAL : std_logic := '1';                                  -- expected inital value
        DB_TIME  : natural   := 500);                                 -- number of clock cycles

    port(
        clk          : in  std_logic;                                 -- clock
        rst_n        : in  std_logic;                                 -- active low reset
        sin          : in  std_logic;                                 -- serial data input
        sin_filtered : out std_logic                                  -- filtered serial data
        );

end debounce_filter;

--
architecture arch of debounce_filter is

    --## Compute the total number of bits needed to represent a number in binary.
    function bit_size(n        : positive) return natural is
        variable log, residual : natural;
    begin
        if n = 0 then
            return 1;
        else
            residual     := n;
            log          := 0;
            while residual > 1 loop
                residual := residual / 2;
                log      := log + 1;
            end loop;
            return log;
        end if;
    end function;

    type STATE_TYPE is (RESET, WAIT_ZERO, CHECK_ZERO, WAIT_ONE, CHECK_ONE);  -- State names for debounce_filter entity
    signal filt_state   : STATE_TYPE;                                        -- State signal
    signal count_filter : unsigned (bit_size(DB_TIME) downto 0);
    signal sin_buf      : std_logic;

    constant TIME_LIM : unsigned(count_filter'length - 1 downto 0) := to_unsigned(DB_TIME, count_filter'length);

begin

    sin_filtered <= sin_buf;

    -- This process is written to prevent unexpected bounces in incoming serial data. 
    -- It waits four clock cycles before changing the state of the filtered output.
    PROC_DEBOUNCE : process (clk, rst_n)
    begin

        if rst_n = '0' then
            filt_state   <= RESET;
            sin_buf      <= INIT_VAL;
            count_filter <= (others => '0');

        elsif rising_edge (clk) then

            case filt_state is

                when RESET =>
                    if sin_buf = '1' then
                        filt_state   <= WAIT_ZERO;
                    else
                        filt_state   <= WAIT_ONE;
                    end if;
                -- If '0' is received continue to CHECK_ZERO state
                when WAIT_ZERO =>
                    sin_buf          <= '1';
                    if sin = '0' then
                        filt_state   <= CHECK_ZERO;
                        count_filter <= (others => '0');
                    end if;

                -- Check "sin" whether it is '0' for more than 4 clock cycles
                when CHECK_ZERO =>
                    if sin = '0' then
                        if count_filter = TIME_LIM then
                            filt_state   <= WAIT_ONE;
                            sin_buf      <= '0';
                        else
                            count_filter <= count_filter + 1;
                        end if;
                    else
                        filt_state       <= WAIT_ZERO;
                    end if;

                -- If '1' is received continue to CHECK_ONE state
                when WAIT_ONE =>
                    sin_buf          <= '0';
                    if sin = '1' then
                        filt_state   <= CHECK_ONE;
                        count_filter <= (others => '0');
                    end if;

                -- Check "sin" whether it is '1' for more than 4 clock cycles
                when CHECK_ONE =>
                    if sin = '1' then
                        if count_filter = TIME_LIM then
                            filt_state   <= WAIT_ZERO;
                            sin_buf      <= '1';
                        else
                            count_filter <= count_filter + 1;
                        end if;
                    else
                        filt_state       <= WAIT_ONE;
                    end if;

                -- invalid state, return to RESET
                when others =>
                    filt_state <= RESET;
                    sin_buf    <= INIT_VAL;

            end case;
        end if;
    end process PROC_DEBOUNCE;
end architecture arch;

