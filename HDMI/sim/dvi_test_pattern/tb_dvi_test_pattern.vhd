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

entity tb_dvi_test_pattern is

end entity tb_dvi_test_pattern;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_dvi_test_pattern is

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

    signal tp_sel : std_logic_vector(2 downto 0) := "110";
    signal box_en : std_logic                    := '1';
    signal rgb    : std_logic_vector(23 downto 0);

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

    component dvi_test_pattern_gen is
        port (
            clk_pixel     : in  std_logic;
            rst_n         : in  std_logic;
            hsync         : in  std_logic;
            vsync         : in  std_logic;
            active        : in  std_logic;
            tp_sel        : in  std_logic_vector(2 downto 0);
            box_en        : in  std_logic;
            act_pixel_num : in  std_logic_vector(11 downto 0);
            act_line_num  : in  std_logic_vector(11 downto 0);
            rgb           : out std_logic_vector(23 downto 0));
    end component dvi_test_pattern_gen;

begin  -- architecture tb

    -- component instantiation
    U_TIME : dvi_timing_gen
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

    U_TP : dvi_test_pattern_gen
        port map (
            clk_pixel     => clk_pixel,
            rst_n         => rst_n_out,
            hsync         => hsync,
            vsync         => vsync,
            active        => active,
            tp_sel        => tp_sel,
            box_en        => box_en,
            act_pixel_num => act_pixel_num,
            act_line_num  => act_line_num,
            rgb           => rgb);

    -- clock generation
    clk_pixel <= not clk_pixel after 3.37 ns;

    -- waveform generation
    PROC_STIMULI : process
    begin
        -- insert signal assignments here
        rst_n      <= '0';
        waitNre(clk_pixel, 10);
        rst_n      <= '1';
        waitNre(clk_pixel, 10);
        format_sel <= "110";
        wait until falling_edge(vsync);
        wait until falling_edge(vsync);
        wait until falling_edge(vsync);
        wait for 1 ms;

        report "SIM DONE" severity failure; wait;

    end process PROC_STIMULI;


end architecture tb;

------------------------------------------------------------------------------------------------------------------------------------------------------

