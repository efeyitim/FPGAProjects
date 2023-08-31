-------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   cdc_single_bit_sync
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   12.01.2023
--  Short Description   :   Bit synchronizer for Altera devices.
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    14.12.2022      Initial Release
--  v1.1    efeyitim    12.01.2023      Polarity is added.
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity cdc_single_bit_sync is
    generic (
        POLARITY   :     std_logic := '0';
        SYNC_DEPTH :     integer   := 3
        );
    port (
        clk        : in  std_logic;                                   -- output clock domain
        rst_n      : in  std_logic;                                   -- active low reset
        input      : in  std_logic;                                   -- @async:  input bits
        output     : out std_logic                                    -- @clk:  output bits
        );
end entity;

architecture rtl of cdc_single_bit_sync is
    attribute PRESERVE         : boolean;
    attribute ALTERA_ATTRIBUTE : string;

    signal Data_async : std_logic;
    signal Data_meta  : std_logic;
    signal Data_sync  : std_logic_vector(SYNC_DEPTH - 2 downto 0);

    -- preserve both registers (no optimization, shift register extraction, ...)
    attribute PRESERVE of Data_meta         : signal is true;
    attribute PRESERVE of Data_sync         : signal is true;
    -- Notify the synthesizer / timing analysator to identity a synchronizer circuit
    attribute ALTERA_ATTRIBUTE of Data_meta : signal is "-name SYNCHRONIZER_IDENTIFICATION ""FORCED IF ASYNCHRONOUS""";
    attribute ALTERA_ATTRIBUTE of Data_sync : signal is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF";

    -- Apply a SDC constraint to meta stable flip flop
    attribute ALTERA_ATTRIBUTE of rtl : architecture is "-name SDC_STATEMENT ""set_false_path -to [get_registers {cdc_single_bit_sync:*|Data_meta}]"";" &
        "-name SDC_STATEMENT ""set_false_path -to [get_registers {*|cdc_single_bit_sync:*|Data_meta}]""";
begin
    Data_async <= input;

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            Data_meta <= POLARITY;
            Data_sync <= (others => POLARITY);
        elsif rising_edge(clk) then
            Data_meta <= Data_async;
            Data_sync <= Data_sync(Data_sync'high - 1 downto 0) & Data_meta;
        end if;
    end process;

    output <= Data_sync(Data_sync'high);
end architecture;
