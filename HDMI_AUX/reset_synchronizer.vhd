---------------------------------------------------------------------------------------------------
--  Project Name        :   GENERIC
--  System/Block Name   :   reset_synchronizer
--  Design Engineer     :   Cudi KILINC
--  Date                :   25.04.2018
--  Short Description   :   This block creates synchronous reset output from asynchronous reset source.
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Cudi KILINC         25.04.2018      v1.0 Initial Release
--  Efe Berkay YITIM    15.12.2022      v1.1 Modified for Altera devices.
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reset_synchronizer is
    port(
        clk         : in  std_logic;                                  -- System clock
        input_rst_n : in  std_logic;                                  -- Asynchronous reset input
        rst         : out std_logic;                                  -- Active HIGH reset output
        rst_n       : out std_logic                                   -- Active LOW reset output
        );
end entity;

architecture arch of reset_synchronizer is

    attribute PRESERVE         : boolean;
    attribute ALTERA_ATTRIBUTE : string;

    -- Apply a SDC constraint to meta stable flip flop
    attribute ALTERA_ATTRIBUTE of arch : architecture is "-name SDC_STATEMENT ""set_false_path -to [get_registers {reset_synchronizer:*|rst*}]"";" &
        "-name SDC_STATEMENT ""set_false_path -to [get_registers {*|reset_synchronizer:*|rst*}]""";

    signal rst_n_buff_1 : std_logic;                                  -- Reset buffer
    signal rst_n_buff_2 : std_logic;                                  -- Reset buffer
    signal rst_buff_1   : std_logic;                                  -- Reset buffer
    signal rst_buff_2   : std_logic;                                  -- Reset buffer

    -- preserve both registers (no optimization, shift register extraction, ...)
    attribute PRESERVE of rst_n_buff_1 : signal is true;
    attribute PRESERVE of rst_n_buff_2 : signal is true;
    attribute PRESERVE of rst_n        : signal is true;
    attribute PRESERVE of rst_buff_1   : signal is true;
    attribute PRESERVE of rst_buff_2   : signal is true;
    attribute PRESERVE of rst          : signal is true;

begin

    -- Reset Synchronization Process
    PROC_RESET : process(input_rst_n, clk)
    begin
        if input_rst_n = '0' then
            rst_buff_1   <= '1';
            rst_buff_2   <= '1';
            rst          <= '1';
            rst_n_buff_1 <= '0';
            rst_n_buff_2 <= '0';
            rst_n        <= '0';

        elsif rising_edge(clk) then
            rst_buff_1   <= '0';
            rst_buff_2   <= rst_buff_1;
            rst          <= rst_buff_2;
            rst_n_buff_1 <= '1';
            rst_n_buff_2 <= rst_n_buff_1;
            rst_n        <= rst_n_buff_2;
        end if;
    end process;

end architecture;
