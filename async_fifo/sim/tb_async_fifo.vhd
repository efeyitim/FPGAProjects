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

entity tb_async_fifo is

end entity tb_async_fifo;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_async_fifo is

    -- component generics
    constant FWFT_EN    : boolean := true;
    constant DATA_WIDTH : integer := 4;
    constant ADDR_WIDTH : integer := 4;

    -- component ports
    signal wraclr  : std_logic                                  := '0';
    signal rdaclr  : std_logic                                  := '0';
    signal data    : std_logic_vector (DATA_WIDTH - 1 downto 0) := (others => '0');
    signal rdclk   : std_logic                                  := '0';
    signal rdreq   : std_logic                                  := '0';
    signal wrclk   : std_logic                                  := '0';
    signal wrreq   : std_logic                                  := '0';
    signal q       : std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal rdempty : std_logic;
    signal rdusedw : std_logic_vector (ADDR_WIDTH - 1 downto 0);
    signal wrfull  : std_logic;
    signal wrusedw : std_logic_vector (ADDR_WIDTH - 1 downto 0);


    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

    procedure write_fifo(
        constant byte  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        signal wr_req  : out std_logic;
        signal wr_data : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        ) is
    begin
        wait until rising_edge(wrclk);
        wr_req  <= '1';
        wr_data <= byte;
        wait until rising_edge(wrclk);
        wr_req  <= '0';
    end procedure write_fifo;

    procedure read_fifo(
        signal rd_req : out std_logic
        ) is
    begin
        wait until rising_edge(rdclk);
        rd_req <= '1';
        wait until rising_edge(rdclk);
        rd_req <= '0';
    end procedure read_fifo;

begin  -- architecture tb

    -- component instantiation
    U_DUT : entity work.async_fifo
        generic map (
            FWFT_EN    => FWFT_EN,
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH)
        port map (
            wraclr     => wraclr,
            rdaclr     => rdaclr,
            data       => data,
            rdclk      => rdclk,
            rdreq      => rdreq,
            wrclk      => wrclk,
            wrreq      => wrreq,
            q          => q,
            rdempty    => rdempty,
            rdusedw    => rdusedw,
            wrfull     => wrfull,
            wrusedw    => wrusedw);

    -- clock generation
    wrclk <= not wrclk after 10 ns;                                   -- 50 MHz
    rdclk <= not rdclk after 8 ns;                                    -- 62.5 MHz

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        wraclr <= '0';
        rdaclr <= '0';
        wait for 80 ns;
        wraclr <= '1';
        rdaclr <= '1';
        wait for 500 ns;

        write_fifo(x"5", wrreq, data);
        write_fifo(x"4", wrreq, data);
        write_fifo(x"3", wrreq, data);
        write_fifo(x"2", wrreq, data);
        wait for 25 ns;
        write_fifo(x"1", wrreq, data);
        wait for 100 ns;
        read_fifo(rdreq);
        read_fifo(rdreq);
        read_fifo(rdreq);
        wait for 200 ns;
        read_fifo(rdreq);
        report "SIM DONE" severity failure;
        wait;
    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

