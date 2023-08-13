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
use ieee.numeric_std.all;

entity dvi_test_pattern_gen is

    port (
        clk_pixel     : in  std_logic;                                -- pixel clock
        rst_n         : in  std_logic;                                -- active low reset
        hsync         : in  std_logic;                                -- HSYNC
        vsync         : in  std_logic;                                -- VSYNC
        active        : in  std_logic;                                -- active signal
        tp_sel        : in  std_logic_vector(2 downto 0);             -- test pattern select signal
        box_en        : in  std_logic;                                -- box enable signal
        act_pixel_num : in  std_logic_vector(11 downto 0);            -- number of active pixels in a line
        act_line_num  : in  std_logic_vector(11 downto 0);            -- number of active lines in a frame
        hsync_out     : out std_logic;                                -- HSYNC
        vsync_out     : out std_logic;                                -- VSYNC
        active_out    : out std_logic;                                -- active signal        
        rgb           : out std_logic_vector(23 downto 0));           -- RGB output

end entity dvi_test_pattern_gen;

architecture rtl of dvi_test_pattern_gen is

    constant COLOR_WHITE   : std_logic_vector(23 downto 0) := x"FFFFFF";
    constant COLOR_YELLOW  : std_logic_vector(23 downto 0) := x"FFFF00";
    constant COLOR_CYAN    : std_logic_vector(23 downto 0) := x"00FFFF";
    constant COLOR_GREEN   : std_logic_vector(23 downto 0) := x"00FF00";
    constant COLOR_MAGENTA : std_logic_vector(23 downto 0) := x"FF00FF";
    constant COLOR_RED     : std_logic_vector(23 downto 0) := x"FF0000";
    constant COLOR_BLUE    : std_logic_vector(23 downto 0) := x"0000FF";
    constant COLOR_BLACK   : std_logic_vector(23 downto 0) := x"000000";
    constant COLOR_BOX     : std_logic_vector(23 downto 0) := x"808080";

    signal pixel_counter : unsigned(11 downto 0);
    signal line_counter  : unsigned(11 downto 0);

    signal act_pixel_num_div8 : unsigned(11 downto 0);
    signal act_pixel_num_div4 : unsigned(11 downto 0);
    signal act_pixel_num_div2 : unsigned(11 downto 0);
    signal act_pixel_num_div1 : unsigned(11 downto 0);
    signal act_pixel_num_min1 : unsigned(11 downto 0);

    signal first_bar_limit_h   : unsigned(11 downto 0);
    signal second_bar_limit_h  : unsigned(11 downto 0);
    signal third_bar_limit_h   : unsigned(11 downto 0);
    signal fourth_bar_limit_h  : unsigned(11 downto 0);
    signal fifth_bar_limit_h   : unsigned(11 downto 0);
    signal sixth_bar_limit_h   : unsigned(11 downto 0);
    signal seventh_bar_limit_h : unsigned(11 downto 0);

    signal act_line_num_div8 : unsigned(11 downto 0);
    signal act_line_num_div4 : unsigned(11 downto 0);
    signal act_line_num_div2 : unsigned(11 downto 0);
    signal act_line_num_div1 : unsigned(11 downto 0);
    signal act_line_num_min1 : unsigned(11 downto 0);

    signal first_bar_limit_v   : unsigned(11 downto 0);
    signal second_bar_limit_v  : unsigned(11 downto 0);
    signal third_bar_limit_v   : unsigned(11 downto 0);
    signal fourth_bar_limit_v  : unsigned(11 downto 0);
    signal fifth_bar_limit_v   : unsigned(11 downto 0);
    signal sixth_bar_limit_v   : unsigned(11 downto 0);
    signal seventh_bar_limit_v : unsigned(11 downto 0);

    signal rgb_tp1      : std_logic_vector(23 downto 0);
    signal rgb_tp2      : std_logic_vector(23 downto 0);
    signal rgb_tp3      : std_logic_vector(23 downto 0);
    signal rgb_tp4      : std_logic_vector(23 downto 0);
    signal rgb_tp5      : std_logic_vector(23 downto 0);
    signal rgb_tp6      : std_logic_vector(23 downto 0);
    signal rgb_tp7      : std_logic_vector(23 downto 0);
    signal rgb_tp8      : std_logic_vector(23 downto 0);
    signal rgb_wout_box : std_logic_vector(23 downto 0);

    signal frame_flag : std_logic;


    constant box_v_speed : unsigned(11 downto 0) := x"004";
    constant box_h_speed : unsigned(11 downto 0) := x"008";

    signal box_h_lim_low  : unsigned(11 downto 0);
    signal box_h_lim_high : unsigned(11 downto 0);
    signal box_h_dir      : std_logic;
    signal box_v_lim_low  : unsigned(11 downto 0);
    signal box_v_lim_high : unsigned(11 downto 0);
    signal box_v_dir      : std_logic;

    attribute mark_debug : string;
    attribute syn_keep   : boolean;
    attribute dont_touch : string;

    attribute syn_keep of pixel_counter   : signal is true;
    attribute dont_touch of pixel_counter : signal is "true";
    attribute mark_debug of pixel_counter : signal is "true";

    attribute syn_keep of line_counter   : signal is true;
    attribute dont_touch of line_counter : signal is "true";
    attribute mark_debug of line_counter : signal is "true";
    
    attribute syn_keep of hsync_out   : signal is true;
    attribute dont_touch of hsync_out : signal is "true";
    attribute mark_debug of hsync_out : signal is "true";
    
    attribute syn_keep of vsync_out   : signal is true;
    attribute dont_touch of vsync_out : signal is "true";
    attribute mark_debug of vsync_out : signal is "true";
    
    attribute syn_keep of active_out   : signal is true;
    attribute dont_touch of active_out : signal is "true";
    attribute mark_debug of active_out : signal is "true";
    
    attribute syn_keep of rgb   : signal is true;
    attribute dont_touch of rgb : signal is "true";
    attribute mark_debug of rgb : signal is "true";
    
    attribute syn_keep of box_h_lim_low   : signal is true;
    attribute dont_touch of box_h_lim_low : signal is "true";
    attribute mark_debug of box_h_lim_low : signal is "true";
    
    attribute syn_keep of box_h_lim_high   : signal is true;
    attribute dont_touch of box_h_lim_high : signal is "true";
    attribute mark_debug of box_h_lim_high : signal is "true";
    
    attribute syn_keep of box_h_dir   : signal is true;
    attribute dont_touch of box_h_dir : signal is "true";
    attribute mark_debug of box_h_dir : signal is "true";
    
    attribute syn_keep of box_v_lim_low   : signal is true;
    attribute dont_touch of box_v_lim_low : signal is "true";
    attribute mark_debug of box_v_lim_low : signal is "true";
    
    attribute syn_keep of box_v_lim_high   : signal is true;
    attribute dont_touch of box_v_lim_high : signal is "true";
    attribute mark_debug of box_v_lim_high : signal is "true";
    
    attribute syn_keep of box_v_dir   : signal is true;
    attribute dont_touch of box_v_dir : signal is "true";
    attribute mark_debug of box_v_dir : signal is "true";

    attribute syn_keep of frame_flag   : signal is true;
    attribute dont_touch of frame_flag : signal is "true";
    attribute mark_debug of frame_flag : signal is "true";
    
    attribute syn_keep of first_bar_limit_h   : signal is true;
    attribute dont_touch of first_bar_limit_h : signal is "true";
    attribute mark_debug of first_bar_limit_h : signal is "true";
    
    attribute syn_keep of second_bar_limit_h   : signal is true;
    attribute dont_touch of second_bar_limit_h : signal is "true";
    attribute mark_debug of second_bar_limit_h : signal is "true";
    
    attribute syn_keep of third_bar_limit_h   : signal is true;
    attribute dont_touch of third_bar_limit_h : signal is "true";
    attribute mark_debug of third_bar_limit_h : signal is "true";
    
    attribute syn_keep of fourth_bar_limit_h   : signal is true;
    attribute dont_touch of fourth_bar_limit_h : signal is "true";
    attribute mark_debug of fourth_bar_limit_h : signal is "true";
    
    attribute syn_keep of fifth_bar_limit_h   : signal is true;
    attribute dont_touch of fifth_bar_limit_h : signal is "true";
    attribute mark_debug of fifth_bar_limit_h : signal is "true";
    
    attribute syn_keep of sixth_bar_limit_h   : signal is true;
    attribute dont_touch of sixth_bar_limit_h : signal is "true";
    attribute mark_debug of sixth_bar_limit_h : signal is "true";
    
    attribute syn_keep of seventh_bar_limit_h   : signal is true;
    attribute dont_touch of seventh_bar_limit_h : signal is "true";
    attribute mark_debug of seventh_bar_limit_h : signal is "true";
    
    attribute syn_keep of first_bar_limit_v   : signal is true;
    attribute dont_touch of first_bar_limit_v : signal is "true";
    attribute mark_debug of first_bar_limit_v : signal is "true";
    
    attribute syn_keep of second_bar_limit_v   : signal is true;
    attribute dont_touch of second_bar_limit_v : signal is "true";
    attribute mark_debug of second_bar_limit_v : signal is "true";
    
    attribute syn_keep of third_bar_limit_v   : signal is true;
    attribute dont_touch of third_bar_limit_v : signal is "true";
    attribute mark_debug of third_bar_limit_v : signal is "true";
    
    attribute syn_keep of fourth_bar_limit_v   : signal is true;
    attribute dont_touch of fourth_bar_limit_v : signal is "true";
    attribute mark_debug of fourth_bar_limit_v : signal is "true";
    
    attribute syn_keep of fifth_bar_limit_v   : signal is true;
    attribute dont_touch of fifth_bar_limit_v : signal is "true";
    attribute mark_debug of fifth_bar_limit_v : signal is "true";
    
    attribute syn_keep of sixth_bar_limit_v   : signal is true;
    attribute dont_touch of sixth_bar_limit_v : signal is "true";
    attribute mark_debug of sixth_bar_limit_v : signal is "true";
    
    attribute syn_keep of seventh_bar_limit_v   : signal is true;
    attribute dont_touch of seventh_bar_limit_v : signal is "true";
    attribute mark_debug of seventh_bar_limit_v : signal is "true";
    
begin  -- architecture rtl

    act_pixel_num_div8 <= unsigned("000" & act_pixel_num(11 downto 3));
    act_pixel_num_div4 <= unsigned("00" & act_pixel_num(11 downto 2));
    act_pixel_num_div2 <= unsigned("0" & act_pixel_num(11 downto 1));
    act_pixel_num_div1 <= unsigned(act_pixel_num(11 downto 0));

    act_line_num_div8 <= unsigned("000" & act_line_num(11 downto 3));
    act_line_num_div4 <= unsigned("00" & act_line_num(11 downto 2));
    act_line_num_div2 <= unsigned("0" & act_line_num(11 downto 1));
    act_line_num_div1 <= unsigned(act_line_num(11 downto 0));

    PROC_TP : process (clk_pixel, rst_n) is
    begin  -- process PROC_TP
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            pixel_counter <= (others => '0');
            line_counter  <= (others => '0');

            first_bar_limit_h   <= (others => '0');
            second_bar_limit_h  <= (others => '0');
            third_bar_limit_h   <= (others => '0');
            fourth_bar_limit_h  <= (others => '0');
            fifth_bar_limit_h   <= (others => '0');
            sixth_bar_limit_h   <= (others => '0');
            seventh_bar_limit_h <= (others => '0');

            first_bar_limit_v   <= (others => '0');
            second_bar_limit_v  <= (others => '0');
            third_bar_limit_v   <= (others => '0');
            fourth_bar_limit_v  <= (others => '0');
            fifth_bar_limit_v   <= (others => '0');
            sixth_bar_limit_v   <= (others => '0');
            seventh_bar_limit_v <= (others => '0');

            rgb_tp1      <= (others => '0');
            rgb_tp2      <= (others => '0');
            rgb_tp3      <= (others => '0');
            rgb_tp4      <= (others => '0');
            rgb_tp5      <= (others => '0');
            rgb_tp6      <= (others => '0');
            rgb_tp7      <= (others => '0');
            rgb_tp8      <= (others => '0');
            rgb_wout_box <= (others => '0');

            frame_flag <= '0';

            box_h_lim_low  <= (others => '0');
            box_h_lim_high <= x"03F";
            box_h_dir      <= '0';
            box_v_lim_low  <= (others => '0');
            box_v_lim_high <= x"03F";
            box_v_dir      <= '0';

            hsync_out  <= '0';
            vsync_out  <= '0';
            active_out <= '0';

            act_pixel_num_min1 <= (others => '0');
            act_line_num_min1  <= (others => '0');
            rgb <= (others => '0');

        elsif rising_edge(clk_pixel) then                             -- rising clock edge
            active_out <= active;
            hsync_out  <= hsync;
            vsync_out  <= vsync;

            first_bar_limit_h   <= act_pixel_num_div8;
            second_bar_limit_h  <= act_pixel_num_div4;
            third_bar_limit_h   <= act_pixel_num_div8 + act_pixel_num_div4;
            fourth_bar_limit_h  <= act_pixel_num_div2;
            fifth_bar_limit_h   <= act_pixel_num_div2 + act_pixel_num_div8;
            sixth_bar_limit_h   <= act_pixel_num_div4 + act_pixel_num_div2;
            seventh_bar_limit_h <= act_pixel_num_div1 - act_pixel_num_div8;

            first_bar_limit_v   <= act_line_num_div8;
            second_bar_limit_v  <= act_line_num_div4;
            third_bar_limit_v   <= act_line_num_div8 + act_line_num_div4;
            fourth_bar_limit_v  <= act_line_num_div2;
            fifth_bar_limit_v   <= act_line_num_div2 + act_line_num_div8;
            sixth_bar_limit_v   <= act_line_num_div4 + act_line_num_div2;
            seventh_bar_limit_v <= act_line_num_div1 - act_line_num_div8;

            -- TODO: burada hsync ve vsync'e gore line_counter ve pixel_counter arttir/resetle
            frame_flag            <= '0';
            act_pixel_num_min1    <= act_pixel_num_div1 - 1;
            act_line_num_min1     <= act_line_num_div1 - 1;
            if active = '1' then
                if pixel_counter = act_pixel_num_min1 then
                    pixel_counter <= (others => '0');
                    line_counter  <= line_counter + 1;
                else
                    pixel_counter <= pixel_counter + 1;
                end if;
            end if;
            if line_counter = act_line_num_div1 then
                line_counter      <= (others => '0');
                frame_flag        <= '1';
            end if;

            rgb_tp1 <= COLOR_BLACK;
            rgb_tp2 <= COLOR_WHITE;
            rgb_tp3 <= COLOR_RED;
            rgb_tp4 <= COLOR_GREEN;
            rgb_tp5 <= COLOR_BLUE;

            if pixel_counter < first_bar_limit_h then
                rgb_tp6 <= COLOR_WHITE;                               -- first vertical bar
            elsif pixel_counter >= first_bar_limit_h and pixel_counter < second_bar_limit_h then
                rgb_tp6 <= COLOR_YELLOW;                              -- second vertical bar
            elsif pixel_counter >= second_bar_limit_h and pixel_counter < third_bar_limit_h then
                rgb_tp6 <= COLOR_CYAN;                                -- third vertical bar
            elsif pixel_counter >= third_bar_limit_h and pixel_counter < fourth_bar_limit_h then
                rgb_tp6 <= COLOR_GREEN;                               -- fourth vertical bar
            elsif pixel_counter >= fourth_bar_limit_h and pixel_counter < fifth_bar_limit_h then
                rgb_tp6 <= COLOR_MAGENTA;                             -- fifth vertical  bar
            elsif pixel_counter >= fifth_bar_limit_h and pixel_counter < sixth_bar_limit_h then
                rgb_tp6 <= COLOR_RED;                                 -- sixth vertical bar
            elsif pixel_counter >= sixth_bar_limit_h and pixel_counter < seventh_bar_limit_h then
                rgb_tp6 <= COLOR_BLUE;                                -- seventh vertical bar
            else
                rgb_tp6 <= COLOR_BLACK;                               -- eighth vertical bar     
            end if;

            if line_counter < first_bar_limit_v then
                rgb_tp7 <= COLOR_WHITE;                               -- first vertical bar
            elsif line_counter >= first_bar_limit_v and line_counter < second_bar_limit_v then
                rgb_tp7 <= COLOR_YELLOW;                              -- second vertical bar
            elsif line_counter >= second_bar_limit_v and line_counter < third_bar_limit_v then
                rgb_tp7 <= COLOR_CYAN;                                -- third vertical bar
            elsif line_counter >= third_bar_limit_v and line_counter < fourth_bar_limit_v then
                rgb_tp7 <= COLOR_GREEN;                               -- fourth vertical bar
            elsif line_counter >= fourth_bar_limit_v and line_counter < fifth_bar_limit_v then
                rgb_tp7 <= COLOR_MAGENTA;                             -- fifth vertical  bar
            elsif line_counter >= fifth_bar_limit_v and line_counter < sixth_bar_limit_v then
                rgb_tp7 <= COLOR_RED;                                 -- sixth vertical bar
            elsif line_counter >= sixth_bar_limit_v and line_counter < seventh_bar_limit_v then
                rgb_tp7 <= COLOR_BLUE;                                -- seventh vertical bar
            else
                rgb_tp7 <= COLOR_BLACK;                               -- eighth vertical bar     
            end if;

            if line_counter < first_bar_limit_v then
                rgb_tp8     <= COLOR_WHITE;                           -- first horizontal bar
            elsif line_counter >= first_bar_limit_v and line_counter < second_bar_limit_v then
                rgb_tp8     <= COLOR_GREEN;                           -- second horizontal bar
            elsif line_counter >= second_bar_limit_v and line_counter < third_bar_limit_v then
                rgb_tp8     <= COLOR_RED;                             -- third horizontal bar
            elsif line_counter >= third_bar_limit_v and line_counter < fourth_bar_limit_v then
                rgb_tp8     <= COLOR_BLUE;                            -- fourth horizontal bar
            else
                if pixel_counter < first_bar_limit_h then
                    rgb_tp8 <= COLOR_WHITE;                           -- first vertical bar
                elsif pixel_counter >= first_bar_limit_h and pixel_counter < second_bar_limit_h then
                    rgb_tp8 <= COLOR_YELLOW;                          -- second vertical bar
                elsif pixel_counter >= second_bar_limit_h and pixel_counter < third_bar_limit_h then
                    rgb_tp8 <= COLOR_CYAN;                            -- third vertical bar
                elsif pixel_counter >= third_bar_limit_h and pixel_counter < fourth_bar_limit_h then
                    rgb_tp8 <= COLOR_GREEN;                           -- fourth vertical bar
                elsif pixel_counter >= fourth_bar_limit_h and pixel_counter < fifth_bar_limit_h then
                    rgb_tp8 <= COLOR_MAGENTA;                         -- fifth vertical  bar
                elsif pixel_counter >= fifth_bar_limit_h and pixel_counter < sixth_bar_limit_h then
                    rgb_tp8 <= COLOR_RED;                             -- sixth vertical bar
                elsif pixel_counter >= sixth_bar_limit_h and pixel_counter < seventh_bar_limit_h then
                    rgb_tp8 <= COLOR_BLUE;                            -- seventh vertical bar
                else
                    rgb_tp8 <= COLOR_BLACK;                           -- eighth vertical bar     
                end if;
            end if;

            case tp_sel is
                when "000" =>
                    rgb_wout_box <= rgb_tp1;
                when "001" =>
                    rgb_wout_box <= rgb_tp2;
                when "010" =>
                    rgb_wout_box <= rgb_tp3;
                when "011" =>
                    rgb_wout_box <= rgb_tp4;
                when "100" =>
                    rgb_wout_box <= rgb_tp5;
                when "101" =>
                    rgb_wout_box <= rgb_tp6;
                when "110" =>
                    rgb_wout_box <= rgb_tp7;
                when "111" =>
                    rgb_wout_box <= rgb_tp8;
                when others =>
                    rgb_wout_box <= (others => '0');
            end case;

            -- TODO: A_NUMBER_HERE olan yerleri doldur
            -- TODO: frame'in sonunda yapacaksin bu isleri, vsync transition olabilir
            if frame_flag = '1' then
                if box_v_dir = '0' then                               -- down
                    box_v_lim_high <= box_v_lim_high + box_v_speed;
                    box_v_lim_low  <= box_v_lim_low + box_v_speed;
                    if box_v_lim_high = act_line_num_min1 - box_v_speed then
                        box_v_dir  <= '1';
                    end if;
                else                                                  -- up
                    box_v_lim_high <= box_v_lim_high - box_v_speed;
                    box_v_lim_low  <= box_v_lim_low - box_v_speed;
                    if box_v_lim_low = box_v_speed then
                        box_v_dir  <= '0';
                    end if;
                end if;

                if box_h_dir = '0' then                               -- right
                    box_h_lim_high <= box_h_lim_high + box_h_speed;
                    box_h_lim_low  <= box_h_lim_low + box_h_speed;
                    if box_h_lim_high = act_pixel_num_min1 - box_h_speed then
                        box_h_dir  <= '1';
                    end if;
                else                                                  -- left
                    box_h_lim_high <= box_h_lim_high - box_h_speed;
                    box_h_lim_low  <= box_h_lim_low - box_h_speed;
                    if box_h_lim_low = box_h_speed then
                        box_h_dir  <= '0';
                    end if;
                end if;
            end if;

            if box_en = '0' then
                rgb         <= rgb_wout_box;
            else
                if line_counter >= box_v_lim_low and line_counter <= box_v_lim_high then
                    if pixel_counter >= box_h_lim_low and pixel_counter <= box_h_lim_high then
                        rgb <= COLOR_BOX;
                    else
                        rgb <= rgb_wout_box;
                    end if;
                else
                    rgb     <= rgb_wout_box;
                end if;
            end if;

        end if;
    end process PROC_TP;

end architecture rtl;
