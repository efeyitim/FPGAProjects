---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   Asynchronous FIFO
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
use ieee.numeric_std.all;

entity async_fifo is

    generic (
        FWFT_EN    : boolean := true;
        DATA_WIDTH : integer := 4;
        ADDR_WIDTH : integer := 4);

    port
        (
            wraclr  : in  std_logic := '1';
            rdaclr  : in  std_logic := '1';
            data    : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
            rdclk   : in  std_logic;
            rdreq   : in  std_logic;
            wrclk   : in  std_logic;
            wrreq   : in  std_logic;
            q       : out std_logic_vector (DATA_WIDTH - 1 downto 0);
            rdempty : out std_logic;
            rdusedw : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
            wrfull  : out std_logic;
            wrusedw : out std_logic_vector (ADDR_WIDTH - 1 downto 0)
            );

end async_fifo;

architecture rtl of async_fifo is

    signal waddr, raddr                                   : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal wfull_next, rempty_next                        : std_logic;
    signal wgray, wbin, wq2_rgray, wq1_rgray, wrusedw_dif : std_logic_vector(ADDR_WIDTH downto 0);
    signal rgray, rbin, rq2_wgray, rq1_wgray, rdusedw_dif : std_logic_vector(ADDR_WIDTH downto 0);

    signal wgraynext, wbinnext : std_logic_vector(ADDR_WIDTH downto 0);
    signal rgraynext, rbinnext : std_logic_vector(ADDR_WIDTH downto 0);

    signal wq2_rdreq, wq1_rdreq : std_logic;
    signal rq2_wrreq, rq1_wrreq : std_logic;

    signal wrusedw_buf : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal rdusedw_buf : std_logic_vector(ADDR_WIDTH - 1 downto 0);

    type mem_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    signal mem : mem_type := (others => (others => '0'));

    constant ALL_ZEROS_AW : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');

    signal wrfull_buf  : std_logic;
    signal rdempty_buf : std_logic;

begin  -- architecture rtl

    -------------------------------------
    -- WRITE LOGIC
    -------------------------------------

    -- Cross clock domains
    -- Cross the read Gray pointer into the write clock domain
    PROC_WRITE_CDC : process (wrclk, wraclr) is
    begin  -- process PROC_WRITE_CDC
        if wraclr = '0' then                                          -- asynchronous reset (active low)
            wq1_rgray <= (others => '0');
            wq2_rgray <= (others => '0');
        elsif rising_edge(wrclk) then                                 -- rising clock edge
            wq1_rgray <= rgray;
            wq2_rgray <= wq1_rgray;
        end if;
    end process PROC_WRITE_CDC;

    -- Calculate the next write address, and the next graycode pointer.
    wbinnext  <= std_logic_vector(unsigned(wbin) + unsigned(ALL_ZEROS_AW & (wrreq and (not wrfull_buf))));
    wgraynext <= ('0' & wbinnext(wbinnext'high downto 1)) xor wbinnext;
    waddr     <= wbin(ADDR_WIDTH - 1 downto 0);

    -- Register these two values, the address and its Gray code representation
    PROC_WRITE_REG : process (wrclk, wraclr) is
    begin  -- process PROC_WRITE_REG
        if wraclr = '0' then                                          -- asynchronous reset (active low)
            wgray <= (others => '0');
            wbin  <= (others => '0');
        elsif rising_edge(wrclk) then                                 -- rising clock edge
            wgray <= wgraynext;
            wbin  <= wbinnext;
        end if;
    end process PROC_WRITE_REG;

    -- Calculate whether or not the FIFO will be full on the next clock.
    PROC_WRITE_FULL : process (wrclk, wraclr) is
    begin  -- process PROC_WRITE_FULL
        if wraclr = '0' then                                          -- asynchronous reset (active low)
            wrfull_buf <= '0';
        elsif rising_edge(wrclk) then                                 -- rising clock edge
            wrfull_buf <= wfull_next;
        end if;
    end process PROC_WRITE_FULL;

    wfull_next <= '1' when (wgraynext = ((not wq2_rgray(ADDR_WIDTH downto ADDR_WIDTH - 1)) & wq2_rgray(ADDR_WIDTH - 2 downto 0))) else '0';
    wrfull     <= wrfull_buf;

    PROC_WRITE_RDREQ : process (wrclk, wraclr) is
    begin  -- process PROC_WRITE_RDREQ
        if wraclr = '0' then                                          -- asynchronous reset (active low)
            wq1_rdreq <= '0';
            wq2_rdreq <= '0';
        elsif rising_edge(wrclk) then                                 -- rising clock edge
            wq1_rdreq <= rdreq;
            wq2_rdreq <= wq1_rdreq;
        end if;
    end process PROC_WRITE_RDREQ;

    PROC_WRITE_WRUSEDW : process (wrclk, wraclr) is
    begin  -- process PROC_WRITE_WRUSEDW
        if wraclr = '0' then                                          -- asynchronous reset (active low)
            wrusedw_buf     <= (others => '0');
        elsif rising_edge(wrclk) then                                 -- rising clock edge
            if wrreq = '1' and wq2_rdreq = '0' then
                wrusedw_buf <= std_logic_vector(unsigned(wrusedw_buf) + 1);
            elsif wrreq = '0' and wq2_rdreq = '1' then
                wrusedw_buf <= std_logic_vector(unsigned(wrusedw_buf) - 1);
            end if;
        end if;
    end process PROC_WRITE_WRUSEDW;

    wrusedw <= wrusedw_buf;

    -- Write to the FIFO on a clock
    PROC_WRITE_FIFO : process (wrclk) is
    begin  -- process PROC_WRITE_FIFO
        if rising_edge(wrclk) then                                    -- rising clock edge
            if wrreq = '1' and wrfull_buf = '0' then
                mem(to_integer(unsigned(waddr))) <= data;
            end if;
        end if;
    end process PROC_WRITE_FIFO;

    -------------------------------------
    -- READ LOGIC
    -------------------------------------

    -- Cross clock domains
    -- Cross the write Gray pointer into the read clock domain
    PROC_READ_CDC : process (rdclk, rdaclr) is
    begin  -- process PROC_READ_CDC
        if rdaclr = '0' then                                          -- asynchronous reset (active low)
            rq1_wgray <= (others => '0');
            rq2_wgray <= (others => '0');
        elsif rising_edge(rdclk) then                                 -- rising clock edge
            rq1_wgray <= wgray;
            rq2_wgray <= rq1_wgray;
        end if;
    end process PROC_READ_CDC;

    -- Calculate the next read address, and the next graycode pointer.
    rbinnext  <= std_logic_vector(unsigned(rbin) + unsigned(ALL_ZEROS_AW & (rdreq and (not rdempty_buf))));
    rgraynext <= ('0' & rbinnext(rbinnext'high downto 1)) xor rbinnext;
    raddr     <= rbin(ADDR_WIDTH - 1 downto 0);

    -- Register these two values, the address and its Gray code representation
    PROC_READ_REG : process (rdclk, rdaclr) is
    begin  -- process PROC_READ_REG
        if rdaclr = '0' then                                          -- asynchronous reset (active low)
            rgray <= (others => '0');
            rbin  <= (others => '0');
        elsif rising_edge(rdclk) then                                 -- rising clock edge
            rgray <= rgraynext;
            rbin  <= rbinnext;
        end if;
    end process PROC_READ_REG;

    -- Calculate whether or not the FIFO will be empty on the next clock.
    PROC_READ_EMPTY : process (rdclk, rdaclr) is
    begin  -- process PROC_READ_EMPTY
        if rdaclr = '0' then                                          -- asynchronous reset (active low)
            rdempty_buf <= '0';
        elsif rising_edge(wrclk) then                                 -- rising clock edge
            rdempty_buf <= rempty_next;
        end if;
    end process PROC_READ_EMPTY;

    rempty_next <= '1' when (rgraynext = rq2_wgray) else '0';
    rdempty     <= rdempty_buf;

    PROC_READ_WRREQ : process (rdclk, rdaclr) is
    begin  -- process PROC_READ_WRREQ
        if rdaclr = '0' then                                          -- asynchronous reset (active low)
            rq1_wrreq <= '0';
            rq2_wrreq <= '0';
        elsif rising_edge(rdclk) then                                 -- rising clock edge
            rq1_wrreq <= wrreq;
            rq2_wrreq <= rq1_wrreq;
        end if;
    end process PROC_READ_WRREQ;

    PROC_READ_RDUSEDW : process (rdclk, rdaclr) is
    begin  -- process PROC_READ_RDUSEDW
        if rdaclr = '0' then                                          -- asynchronous reset (active low)
            rdusedw_buf     <= (others => '0');
        elsif rising_edge(rdclk) then                                 -- rising clock edge
            if rdreq = '1' and rq2_wrreq = '0' then
                rdusedw_buf <= std_logic_vector(unsigned(rdusedw_buf) - 1);
            elsif rdreq = '0' and rq2_wrreq = '1' then
                rdusedw_buf <= std_logic_vector(unsigned(rdusedw_buf) + 1);
            end if;
        end if;
    end process PROC_READ_RDUSEDW;

    rdusedw <= rdusedw_buf;

    FWFT_FALSE_GENERATE   : if FWFT_EN generate
        FWFT_FALSE_BLOCK  : block
        begin
            PROC_PIPELINE : process (rdclk, rdaclr) is
            begin  -- process PROC_PIPELINE
                if rdaclr = '0' then                                  -- asynchronous reset (active low)
                    q     <= (others => '0');
                elsif rising_edge(rdclk) then                         -- rising clock edge
                    if rdreq = '1' and rdempty_buf = '0' then
                        q <= mem(to_integer(unsigned(raddr)));
                    end if;
                end if;
            end process PROC_PIPELINE;
        end block FWFT_FALSE_BLOCK;
    end generate FWFT_FALSE_GENERATE;

    FWFT_TRUE_GENERATE : if not FWFT_EN generate
        q <= mem(to_integer(unsigned(raddr)));
    end generate FWFT_TRUE_GENERATE;

end architecture rtl;

