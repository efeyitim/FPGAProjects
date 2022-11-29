---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   29.11.2022
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    29.11.2022          v1.0 Initial Release
---------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_sync_fifo is

end entity tb_sync_fifo;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_sync_fifo is

    -- component generics
    constant FWFT_EN    : boolean := false;
    constant DATA_WIDTH : integer := 4;
    constant ADDR_WIDTH : integer := 4;

    -- component ports
    signal clk   : std_logic                                 := '0';
    signal aclr  : std_logic                                 := '0';
    signal wrreq : std_logic                                 := '0';
    signal data  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal rdreq : std_logic                                 := '0';
    signal q     : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal empty : std_logic;
    signal full  : std_logic;
    signal usedw : std_logic_vector(ADDR_WIDTH - 1 downto 0);


    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

begin  -- architecture tb

    -- component instantiation
    U_DUT : entity work.sync_fifo
        generic map (
            FWFT_EN    => FWFT_EN,
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH)
        port map (
            clk        => clk,
            aclr       => aclr,
            wrreq      => wrreq,
            data       => data,
            rdreq      => rdreq,
            q          => q,
            empty      => empty,
            full       => full,
            usedw      => usedw);

    -- clock generation
    clk <= not clk after 10 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        aclr  <= '0';
        waitNre(clk, 5);
        aclr  <= '1';
        waitNre(clk, 5);
        wrreq <= '1';
        data  <= x"5";
        wait until rising_edge(clk);
        data  <= x"4";
        wait until rising_edge(clk);
        data  <= x"3";
        wait until rising_edge(clk);
        data  <= x"2";
        wait until rising_edge(clk);
        data  <= x"1";
        wait until rising_edge(clk);
        wrreq <= '0';
        waitNre(clk, 20);
        rdreq <= '1';
        waitNre(clk, 3);
        rdreq <= '0';
        waitNre(clk, 20);
        report "SIM DONE" severity failure;
        wait;
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

