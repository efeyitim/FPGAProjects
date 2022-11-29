---------------------------------------------------------------------------------------------------
--  Project Name        :   Generic
--  System/Block Name   :   Synchronous FIFO
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

entity sync_fifo is

    generic (
        FWFT_EN    : boolean := false;
        DATA_WIDTH : integer := 4;
        ADDR_WIDTH : integer := 4);

    port (
        clk   : in  std_logic;
        aclr  : in  std_logic;
        wrreq : in  std_logic;
        data  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        rdreq : in  std_logic;
        q     : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        empty : out std_logic;
        full  : out std_logic;
        usedw : out std_logic_vector(ADDR_WIDTH - 1 downto 0));

end entity sync_fifo;

architecture rtl of sync_fifo is

    type mem_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    signal mem : mem_type := (others => (others => '0'));

    signal usedw_buf : std_logic_vector(ADDR_WIDTH - 1 downto 0);

    signal waddr, raddr : std_logic_vector(ADDR_WIDTH - 1 downto 0);

    signal full_buf, empty_buf : std_logic;

begin  -- architecture rtl

    full_buf <= '1' when unsigned(usedw_buf) = 2**ADDR_WIDTH - 1 else '0';
    full     <= full_buf;

    empty_buf <= '1' when unsigned(usedw_buf) = 0 else '0';
    empty     <= empty_buf;

    usedw <= usedw_buf;
    -------------------------------------
    -- WRITE LOGIC
    -------------------------------------

    -- Write pointer
    PROC_WRITE_ADDR : process (clk, aclr) is
    begin  -- process PROC_WRITE_ADDR
        if aclr = '0' then                                            -- asynchronous reset (active low)
            waddr     <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge
            if wrreq = '1' and full_buf = '0' then
                waddr <= std_logic_vector(unsigned(waddr) + 1);
            end if;
        end if;
    end process PROC_WRITE_ADDR;

    -- Write to the FIFO on a clock
    PROC_WRITE_FIFO : process (clk) is
    begin  -- process PROC_WRITE_FIFO
        if rising_edge(clk) then                                      -- rising clock edge
            if wrreq = '1' and full_buf = '0' then
                mem(to_integer(unsigned(waddr))) <= data;
            end if;
        end if;
    end process PROC_WRITE_FIFO;

    PROC_USEDW : process (clk, aclr) is
    begin  -- process PROC_USEDW
        if aclr = '0' then                                            -- asynchronous reset (active low)
            usedw_buf     <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge
            if wrreq = '1' and rdreq = '0' and full_buf = '0' then
                usedw_buf <= std_logic_vector(unsigned(usedw_buf) + 1);
            elsif wrreq = '0' and rdreq = '1' and empty_buf = '0' then
                usedw_buf <= std_logic_vector(unsigned(usedw_buf) - 1);
            end if;
        end if;
    end process PROC_USEDW;

    -------------------------------------
    -- READ LOGIC
    -------------------------------------

    -- READ pointer
    PROC_READ_ADDR : process (clk, aclr) is
    begin  -- process PROC_READ_ADDR
        if aclr = '0' then                                            -- asynchronous reset (active low)
            raddr     <= (others => '0');
        elsif rising_edge(clk) then                                   -- rising clock edge
            if rdreq = '1' and empty_buf = '0' then
                raddr <= std_logic_vector(unsigned(raddr) + 1);
            end if;
        end if;
    end process PROC_READ_ADDR;

    FWFT_TRUE_GENERATE : if FWFT_EN generate
        q <= mem(to_integer(unsigned(raddr)));
    end generate FWFT_TRUE_GENERATE;    

    FWFT_FALSE_GENERATE   : if not FWFT_EN generate
        FWFT_FALSE_BLOCK  : block
        begin
            PROC_PIPELINE : process (clk, aclr) is
            begin  -- process PROC_PIPELINE
                if aclr = '0' then                                    -- asynchronous reset (active low)
                    q     <= (others => '0');
                elsif rising_edge(clk) then                           -- rising clock edge
                    if rdreq = '1' and empty_buf = '0' then
                        q <= mem(to_integer(unsigned(raddr)));
                    end if;
                end if;
            end process PROC_PIPELINE;
        end block FWFT_FALSE_BLOCK;
    end generate FWFT_FALSE_GENERATE;

end architecture rtl;
