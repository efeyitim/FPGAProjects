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

entity tb_tmds_encoder is

end entity tb_tmds_encoder;

------------------------------------------------------------------------------------------------------------------------------------------------------

architecture tb of tb_tmds_encoder is

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

    signal tp_sel : std_logic_vector(2 downto 0) := "101";
    signal box_en : std_logic                    := '1';
    signal rgb    : std_logic_vector(23 downto 0);

    signal tmds_ch0  : std_logic_vector(9 downto 0);
    signal tmds_ch1  : std_logic_vector(9 downto 0);
    signal tmds_ch2  : std_logic_vector(9 downto 0);
    signal ctrl_data : std_logic_vector(1 downto 0);

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

    component tmds_encoder is
        generic (
            CH_NUM     :     integer);
        port (
            clk_pixel  : in  std_logic;
            rst_n      : in  std_logic;
            active     : in  std_logic;
            video_data : in  std_logic_vector(7 downto 0);
            ctrl_data  : in  std_logic_vector(1 downto 0);
            aux_data   : in  std_logic_vector(3 downto 0);
            tmds       : out std_logic_vector(9 downto 0));
    end component tmds_encoder;

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

    ctrl_data <= vsync & hsync;

    U_TMDS_CH0 : tmds_encoder
        generic map (
            CH_NUM     => 0)
        port map (
            clk_pixel  => clk_pixel,
            rst_n      => rst_n_out,
            active     => active,
            video_data => rgb(7 downto 0),
            ctrl_data  => ctrl_data,
            aux_data   => "0000",
            tmds       => tmds_ch0);

    U_TMDS_CH1 : tmds_encoder
        generic map (
            CH_NUM     => 1)
        port map (
            clk_pixel  => clk_pixel,
            rst_n      => rst_n_out,
            active     => active,
            video_data => rgb(15 downto 8),
            ctrl_data  => "00",
            aux_data   => "0000",
            tmds       => tmds_ch1);

    U_TMDS_CH2 : tmds_encoder
        generic map (
            CH_NUM     => 2)
        port map (
            clk_pixel  => clk_pixel,
            rst_n      => rst_n_out,
            active     => active,
            video_data => rgb(23 downto 16),
            ctrl_data  => "00",
            aux_data   => "0000",
            tmds       => tmds_ch2);


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

