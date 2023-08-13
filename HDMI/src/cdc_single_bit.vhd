library ieee;
use ieee.std_logic_1164.all;

entity cdc_single_bit is

    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        din   : in  std_logic;
        dout  : out std_logic);

end entity cdc_single_bit;

architecture rtl of cdc_single_bit is

    signal cdc_reg1 : std_logic;
    signal cdc_reg2 : std_logic;

begin  -- architecture rtl

    process (clk, rst_n) is
    begin  -- process
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            cdc_reg1 <= '0';
            cdc_reg2 <= '0';
            dout     <= '0';
        elsif rising_edge(clk) then                                   -- rising clock edge
            cdc_reg1 <= din;
            cdc_reg2 <= cdc_reg1;
            dout     <= cdc_reg2;
        end if;
    end process;

end architecture rtl;

