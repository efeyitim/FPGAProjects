-------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   07.08.2023
--  Short Description   :   
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    07.08.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------------------------------------------------------------------------------

entity tb_dvi_timing_gen is

end entity tb_dvi_timing_gen;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_dvi_timing_gen is

    -- component ports
    signal clk_pixel     : std_logic                    := '0';
    signal rst_n         : std_logic                    := '0';
    signal format_sel    : std_logic_vector(2 downto 0) := "000";
    signal rst_n_out     : std_logic;
    signal act_pixel_num : std_logic_vector(11 downto 0);
    signal act_line_num  : std_logic_vector(11 downto 0);
    signal active        : std_logic;
    signal hsync         : std_logic;
    signal vsync         : std_logic;

    procedure waitNre(signal clock : std_ulogic; n : positive) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clock);
        end loop;
    end procedure waitNre;

    component dvi_timing_gen is
        port (
            clk_pixel     : in  std_logic;
            rst_n         : in  std_logic;
            format_sel    : in  std_logic_vector(2 downto 0);
            act_pixel_num : out std_logic_vector(11 downto 0);
            act_line_num  : out std_logic_vector(11 downto 0);
            rst_n_out     : out std_logic;
            active        : out std_logic;
            hsync         : out std_logic;
            vsync         : out std_logic);
    end component dvi_timing_gen;

begin  -- architecture tb

    -- component instantiation
    U_DUT : dvi_timing_gen
        port map (
            clk_pixel     => clk_pixel,
            rst_n         => rst_n,
            format_sel    => format_sel,
            rst_n_out     => rst_n_out,
            act_pixel_num => act_pixel_num,
            act_line_num  => act_line_num,
            active        => active,
            hsync         => hsync,
            vsync         => vsync);

    -- clock generation
    clk_pixel <= not clk_pixel after 12.5 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        rst_n      <= '0';
        waitNre(clk_pixel, 10);
        rst_n      <= '1';
        waitNre(clk_pixel, 10);
        format_sel <= "001";

        wait until falling_edge(vsync);
        wait until falling_edge(vsync);
        wait until falling_edge(vsync);
        wait for 1 ms;

        report "SIM DONE" severity failure; wait;

    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

