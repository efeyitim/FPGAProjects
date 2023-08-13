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

entity dvi_timing_gen is

    port (
        clk_pixel     : in  std_logic;                                -- pixel clock
        rst_n         : in  std_logic;                                -- active low reset
        format_upd    : in  std_logic;
        format_sel    : in  std_logic_vector(2 downto 0);             -- video format select
        rst_n_out     : out std_logic;
        act_pixel_num : out std_logic_vector(11 downto 0);
        act_line_num  : out std_logic_vector(11 downto 0);
        active        : out std_logic;
        hsync         : out std_logic;                                -- HSYNC
        vsync         : out std_logic);                               -- VSYNC

end entity dvi_timing_gen;

architecture rtl of dvi_timing_gen is

    ----------------------------------------------------------------------------
    -- ID | Video Resolution | Refresh Rate (Hz) | Pixel Clock Frequency (MHz) |
    ----------------------------------------------------------------------------
    -- 0  |     640x480      |       60          |          25.2               | 
    -- 1  |     800x600      |       60          |          40                 |
    -- 2  |     1024x768     |       60          |          65                 |
    -- 3  |     1280x720     |       60          |          74.25              |
    -- 4  |     1360x768     |       60          |          85.5               |
    -- 5  |     1366x768     |       60          |          85.5               |
    -- 6  |     1920x1080    |       60          |          148.5              |
    ----------------------------------------------------------------------------

    -- 800x525 TOTAL
    constant H_SYNC_TIME_640x480        : unsigned(11 downto 0) := to_unsigned(96-1, 12);
    constant H_BACK_PORCH_640x480       : unsigned(11 downto 0) := to_unsigned(48-1, 12);  -- h back porch + h left border
    constant H_ACTIVE_VIDEO_640x480     : unsigned(11 downto 0) := to_unsigned(640-1, 12);
    constant H_ACTIVE_VIDEO_640x480_OUT : unsigned(11 downto 0) := to_unsigned(640, 12);
    constant H_FRONT_PORCH_640x480      : unsigned(11 downto 0) := to_unsigned(16-1, 12);  -- h front porch + h right border
    constant V_SYNC_TIME_640x480        : unsigned(11 downto 0) := to_unsigned(2, 12);
    constant V_BACK_PORCH_640x480       : unsigned(11 downto 0) := to_unsigned(33, 12);    -- v back porch + v top border
    constant V_ACTIVE_VIDEO_640x480     : unsigned(11 downto 0) := to_unsigned(480, 12);
    constant V_FRONT_PORCH_640x480      : unsigned(11 downto 0) := to_unsigned(10, 12);    -- v front porch + v bottom border

    -- 1056x628 TOTAL
    constant H_SYNC_TIME_800x600        : unsigned(11 downto 0) := to_unsigned(128-1, 12);
    constant H_BACK_PORCH_800x600       : unsigned(11 downto 0) := to_unsigned(88-1, 12);  -- h back porch + h left border   
    constant H_ACTIVE_VIDEO_800x600     : unsigned(11 downto 0) := to_unsigned(800-1, 12);
    constant H_ACTIVE_VIDEO_800x600_OUT : unsigned(11 downto 0) := to_unsigned(800, 12);
    constant H_FRONT_PORCH_800x600      : unsigned(11 downto 0) := to_unsigned(40-1, 12);  -- h front porch + h right border 
    constant V_SYNC_TIME_800x600        : unsigned(11 downto 0) := to_unsigned(4, 12);
    constant V_BACK_PORCH_800x600       : unsigned(11 downto 0) := to_unsigned(23, 12);    -- v back porch + v top border    
    constant V_ACTIVE_VIDEO_800x600     : unsigned(11 downto 0) := to_unsigned(600, 12);
    constant V_FRONT_PORCH_800x600      : unsigned(11 downto 0) := to_unsigned(1, 12);     -- v front porch + v bottom border

    -- 1344x806 TOTAL
    constant H_SYNC_TIME_1024x768        : unsigned(11 downto 0) := to_unsigned(136-1, 12);
    constant H_BACK_PORCH_1024x768       : unsigned(11 downto 0) := to_unsigned(160-1, 12);  -- h back porch + h left border   
    constant H_ACTIVE_VIDEO_1024x768     : unsigned(11 downto 0) := to_unsigned(1024-1, 12);
    constant H_ACTIVE_VIDEO_1024x768_OUT : unsigned(11 downto 0) := to_unsigned(1024, 12);
    constant H_FRONT_PORCH_1024x768      : unsigned(11 downto 0) := to_unsigned(24-1, 12);   -- h front porch + h right border 
    constant V_SYNC_TIME_1024x768        : unsigned(11 downto 0) := to_unsigned(6, 12);
    constant V_BACK_PORCH_1024x768       : unsigned(11 downto 0) := to_unsigned(29, 12);     -- v back porch + v top border    
    constant V_ACTIVE_VIDEO_1024x768     : unsigned(11 downto 0) := to_unsigned(768, 12);
    constant V_FRONT_PORCH_1024x768      : unsigned(11 downto 0) := to_unsigned(3, 12);      -- v front porch + v bottom border

    -- 1650x750 TOTAL
    constant H_SYNC_TIME_1280x720        : unsigned(11 downto 0) := to_unsigned(40-1, 12);
    constant H_BACK_PORCH_1280x720       : unsigned(11 downto 0) := to_unsigned(220-1, 12);  -- h back porch + h left border   
    constant H_ACTIVE_VIDEO_1280x720     : unsigned(11 downto 0) := to_unsigned(1280-1, 12);
    constant H_ACTIVE_VIDEO_1280x720_OUT : unsigned(11 downto 0) := to_unsigned(1280, 12);
    constant H_FRONT_PORCH_1280x720      : unsigned(11 downto 0) := to_unsigned(110-1, 12);  -- h front porch + h right border 
    constant V_SYNC_TIME_1280x720        : unsigned(11 downto 0) := to_unsigned(5, 12);
    constant V_BACK_PORCH_1280x720       : unsigned(11 downto 0) := to_unsigned(20, 12);     -- v back porch + v top border    
    constant V_ACTIVE_VIDEO_1280x720     : unsigned(11 downto 0) := to_unsigned(720, 12);
    constant V_FRONT_PORCH_1280x720      : unsigned(11 downto 0) := to_unsigned(5, 12);      -- v front porch + v bottom border

    -- 1792x795 TOTAL
    constant H_SYNC_TIME_1360x768        : unsigned(11 downto 0) := to_unsigned(112-1, 12);
    constant H_BACK_PORCH_1360x768       : unsigned(11 downto 0) := to_unsigned(256-1, 12);  -- h back porch + h left border   
    constant H_ACTIVE_VIDEO_1360x768     : unsigned(11 downto 0) := to_unsigned(1360-1, 12);
    constant H_ACTIVE_VIDEO_1360x768_OUT : unsigned(11 downto 0) := to_unsigned(1360, 12);
    constant H_FRONT_PORCH_1360x768      : unsigned(11 downto 0) := to_unsigned(64-1, 12);   -- h front porch + h right border 
    constant V_SYNC_TIME_1360x768        : unsigned(11 downto 0) := to_unsigned(6, 12);
    constant V_BACK_PORCH_1360x768       : unsigned(11 downto 0) := to_unsigned(18, 12);     -- v back porch + v top border    
    constant V_ACTIVE_VIDEO_1360x768     : unsigned(11 downto 0) := to_unsigned(768, 12);
    constant V_FRONT_PORCH_1360x768      : unsigned(11 downto 0) := to_unsigned(3, 12);      -- v front porch + v bottom border

    -- 1792x798 TOTAL
    constant H_SYNC_TIME_1366x768        : unsigned(11 downto 0) := to_unsigned(143-1, 12);
    constant H_BACK_PORCH_1366x768       : unsigned(11 downto 0) := to_unsigned(213-1, 12);  -- h back porch + h left border   
    constant H_ACTIVE_VIDEO_1366x768     : unsigned(11 downto 0) := to_unsigned(1366-1, 12);
    constant H_ACTIVE_VIDEO_1366x768_OUT : unsigned(11 downto 0) := to_unsigned(1366, 12);
    constant H_FRONT_PORCH_1366x768      : unsigned(11 downto 0) := to_unsigned(70-1, 12);   -- h front porch + h right border 
    constant V_SYNC_TIME_1366x768        : unsigned(11 downto 0) := to_unsigned(3, 12);
    constant V_BACK_PORCH_1366x768       : unsigned(11 downto 0) := to_unsigned(24, 12);     -- v back porch + v top border    
    constant V_ACTIVE_VIDEO_1366x768     : unsigned(11 downto 0) := to_unsigned(768, 12);
    constant V_FRONT_PORCH_1366x768      : unsigned(11 downto 0) := to_unsigned(3, 12);      -- v front porch + v bottom border

    -- 2200x1125 TOTAL
    constant H_SYNC_TIME_1920x1080        : unsigned(11 downto 0) := to_unsigned(44-1, 12);
    constant H_BACK_PORCH_1920x1080       : unsigned(11 downto 0) := to_unsigned(148-1, 12);  -- h back porch + h left border   
    constant H_ACTIVE_VIDEO_1920x1080     : unsigned(11 downto 0) := to_unsigned(1920-1, 12);
    constant H_ACTIVE_VIDEO_1920x1080_OUT : unsigned(11 downto 0) := to_unsigned(1920, 12);
    constant H_FRONT_PORCH_1920x1080      : unsigned(11 downto 0) := to_unsigned(88-1, 12);   -- h front porch + h right border 
    constant V_SYNC_TIME_1920x1080        : unsigned(11 downto 0) := to_unsigned(5, 12);
    constant V_BACK_PORCH_1920x1080       : unsigned(11 downto 0) := to_unsigned(36, 12);     -- v back porch + v top border    
    constant V_ACTIVE_VIDEO_1920x1080     : unsigned(11 downto 0) := to_unsigned(1080, 12);
    constant V_FRONT_PORCH_1920x1080      : unsigned(11 downto 0) := to_unsigned(4, 12);      -- v front porch + v bottom border

    type pixel_state_t is (H_SYNC_TIME_S, H_BACK_PORCH_S, H_ACTIVE_VIDEO_S, H_FRONT_PORCH_S);
    signal pixel_state : pixel_state_t;

    type line_state_t is (V_SYNC_TIME_S, V_BACK_PORCH_S, V_ACTIVE_VIDEO_S, V_FRONT_PORCH_S);
    signal line_state : line_state_t;

    signal pixel_counter : unsigned(11 downto 0);
    signal line_counter  : unsigned(11 downto 0);

    signal h_sync_time    : unsigned(11 downto 0);
    signal h_back_porch   : unsigned(11 downto 0);
    signal h_active_video : unsigned(11 downto 0);
    signal h_front_porch  : unsigned(11 downto 0);
    signal v_sync_time    : unsigned(11 downto 0);
    signal v_back_porch   : unsigned(11 downto 0);
    signal v_active_video : unsigned(11 downto 0);
    signal v_front_porch  : unsigned(11 downto 0);

    signal frame_active   : std_logic;
    signal line_active    : std_logic;
    signal format_upd_buf : std_logic;

    attribute mark_debug : string;
    attribute syn_keep   : boolean;
    attribute dont_touch : string;

    attribute syn_keep of pixel_counter   : signal is true;
    attribute dont_touch of pixel_counter : signal is "true";
    attribute mark_debug of pixel_counter : signal is "true";

    attribute syn_keep of line_counter   : signal is true;
    attribute dont_touch of line_counter : signal is "true";
    attribute mark_debug of line_counter : signal is "true";

    attribute syn_keep of h_sync_time   : signal is true;
    attribute dont_touch of h_sync_time : signal is "true";
    attribute mark_debug of h_sync_time : signal is "true";

    attribute syn_keep of h_back_porch   : signal is true;
    attribute dont_touch of h_back_porch : signal is "true";
    attribute mark_debug of h_back_porch : signal is "true";

    attribute syn_keep of h_active_video   : signal is true;
    attribute dont_touch of h_active_video : signal is "true";
    attribute mark_debug of h_active_video : signal is "true";

    attribute syn_keep of h_front_porch   : signal is true;
    attribute dont_touch of h_front_porch : signal is "true";
    attribute mark_debug of h_front_porch : signal is "true";

    attribute syn_keep of v_sync_time   : signal is true;
    attribute dont_touch of v_sync_time : signal is "true";
    attribute mark_debug of v_sync_time : signal is "true";

    attribute syn_keep of v_back_porch   : signal is true;
    attribute dont_touch of v_back_porch : signal is "true";
    attribute mark_debug of v_back_porch : signal is "true";

    attribute syn_keep of v_active_video   : signal is true;
    attribute dont_touch of v_active_video : signal is "true";
    attribute mark_debug of v_active_video : signal is "true";

    attribute syn_keep of v_front_porch   : signal is true;
    attribute dont_touch of v_front_porch : signal is "true";
    attribute mark_debug of v_front_porch : signal is "true";

    attribute syn_keep of pixel_state   : signal is true;
    attribute dont_touch of pixel_state : signal is "true";
    attribute mark_debug of pixel_state : signal is "true";

    attribute syn_keep of line_state   : signal is true;
    attribute dont_touch of line_state : signal is "true";
    attribute mark_debug of line_state : signal is "true";

    attribute syn_keep of format_upd_buf   : signal is true;
    attribute dont_touch of format_upd_buf : signal is "true";
    attribute mark_debug of format_upd_buf : signal is "true";

    attribute syn_keep of rst_n_out   : signal is true;
    attribute dont_touch of rst_n_out : signal is "true";
    attribute mark_debug of rst_n_out : signal is "true";

    attribute syn_keep of act_pixel_num   : signal is true;
    attribute dont_touch of act_pixel_num : signal is "true";
    attribute mark_debug of act_pixel_num : signal is "true";

    attribute syn_keep of act_line_num   : signal is true;
    attribute dont_touch of act_line_num : signal is "true";
    attribute mark_debug of act_line_num : signal is "true";

    attribute syn_keep of active   : signal is true;
    attribute dont_touch of active : signal is "true";
    attribute mark_debug of active : signal is "true";

    attribute syn_keep of hsync   : signal is true;
    attribute dont_touch of hsync : signal is "true";
    attribute mark_debug of hsync : signal is "true";

    attribute syn_keep of vsync   : signal is true;
    attribute dont_touch of vsync : signal is "true";
    attribute mark_debug of vsync : signal is "true";

    attribute syn_keep of line_active   : signal is true;
    attribute dont_touch of line_active : signal is "true";
    attribute mark_debug of line_active : signal is "true";

    attribute syn_keep of frame_active   : signal is true;
    attribute dont_touch of frame_active : signal is "true";
    attribute mark_debug of frame_active : signal is "true";

begin  -- architecture rtl

    hsync  <= '1' when pixel_state = H_SYNC_TIME_S              else '0';
    vsync  <= '1' when line_state = V_SYNC_TIME_S               else '0';
    active <= '1' when frame_active = '1' and line_active = '1' else '0';

    PROC_TIMING : process (clk_pixel, rst_n) is
    begin  -- process PROC_TIMING
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            pixel_counter  <= (others => '0');
            pixel_state    <= H_SYNC_TIME_S;
            line_counter   <= (others => '0');
            line_state     <= V_SYNC_TIME_S;
            frame_active   <= '0';
            line_active    <= '0';
            rst_n_out      <= '0';
            format_upd_buf <= '0';
            h_sync_time    <= H_SYNC_TIME_640x480;
            h_back_porch   <= H_BACK_PORCH_640x480;
            h_active_video <= H_ACTIVE_VIDEO_640x480;
            h_front_porch  <= H_FRONT_PORCH_640x480;
            v_sync_time    <= V_SYNC_TIME_640x480;
            v_back_porch   <= V_BACK_PORCH_640x480;
            v_active_video <= V_ACTIVE_VIDEO_640x480;
            v_front_porch  <= V_FRONT_PORCH_640x480;
            act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_640x480_OUT);
            act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_640x480);


        elsif rising_edge(clk_pixel) then                             -- rising clock edge
            rst_n_out <= '1';

            case pixel_state is
                when H_SYNC_TIME_S =>
                    if pixel_counter = h_sync_time then
                        pixel_counter <= (others => '0');
                        pixel_state   <= H_BACK_PORCH_S;
                    else
                        pixel_counter <= pixel_counter + 1;
                    end if;

                when H_BACK_PORCH_S =>
                    if pixel_counter = h_back_porch then
                        pixel_counter <= (others => '0');
                        pixel_state   <= H_ACTIVE_VIDEO_S;
                        line_active   <= '1';
                    else
                        pixel_counter <= pixel_counter + 1;
                    end if;

                when H_ACTIVE_VIDEO_S =>
                    if pixel_counter = h_active_video then
                        pixel_counter <= (others => '0');
                        pixel_state   <= H_FRONT_PORCH_S;
                        line_active   <= '0';
                    else
                        pixel_counter <= pixel_counter + 1;
                    end if;

                when H_FRONT_PORCH_S =>
                    if pixel_counter = h_front_porch then
                        pixel_counter <= (others => '0');
                        line_counter  <= line_counter + 1;
                        pixel_state   <= H_SYNC_TIME_S;
                    else
                        pixel_counter <= pixel_counter + 1;
                    end if;

                when others => null;
            end case;

            case line_state is
                when V_SYNC_TIME_S =>
                    if line_counter = v_sync_time then
                        line_counter <= (others => '0');
                        line_state   <= V_BACK_PORCH_S;
                    end if;

                when V_BACK_PORCH_S =>
                    if line_counter = v_back_porch then
                        line_counter <= (others => '0');
                        line_state   <= V_ACTIVE_VIDEO_S;
                        frame_active <= '1';
                    end if;

                when V_ACTIVE_VIDEO_S =>
                    if line_counter = v_active_video then
                        line_counter <= (others => '0');
                        line_state   <= V_FRONT_PORCH_S;
                        frame_active <= '0';
                    end if;

                when V_FRONT_PORCH_S =>
                    if line_counter = v_front_porch then
                        line_counter <= (others => '0');
                        line_state   <= V_SYNC_TIME_S;
                    end if;

                when others => null;
            end case;

            format_upd_buf <= format_upd;

            if format_upd_buf = '0' and format_upd = '1' then         -- rising edge
                rst_n_out     <= '0';
                pixel_state   <= H_SYNC_TIME_S;
                pixel_counter <= (others => '0');
                line_state    <= V_SYNC_TIME_S;
                line_counter  <= (others => '0');
                line_active   <= '0';
                frame_active  <= '0';

                case format_sel is
                    when "000" =>
                        h_sync_time    <= H_SYNC_TIME_640x480;
                        h_back_porch   <= H_BACK_PORCH_640x480;
                        h_active_video <= H_ACTIVE_VIDEO_640x480;
                        h_front_porch  <= H_FRONT_PORCH_640x480;
                        v_sync_time    <= V_SYNC_TIME_640x480;
                        v_back_porch   <= V_BACK_PORCH_640x480;
                        v_active_video <= V_ACTIVE_VIDEO_640x480;
                        v_front_porch  <= V_FRONT_PORCH_640x480;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_640x480_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_640x480);

                    when "001" =>
                        h_sync_time    <= H_SYNC_TIME_800x600;
                        h_back_porch   <= H_BACK_PORCH_800x600;
                        h_active_video <= H_ACTIVE_VIDEO_800x600;
                        h_front_porch  <= H_FRONT_PORCH_800x600;
                        v_sync_time    <= V_SYNC_TIME_800x600;
                        v_back_porch   <= V_BACK_PORCH_800x600;
                        v_active_video <= V_ACTIVE_VIDEO_800x600;
                        v_front_porch  <= V_FRONT_PORCH_800x600;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_800x600_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_800x600);

                    when "010" =>
                        h_sync_time    <= H_SYNC_TIME_1024x768;
                        h_back_porch   <= H_BACK_PORCH_1024x768;
                        h_active_video <= H_ACTIVE_VIDEO_1024x768;
                        h_front_porch  <= H_FRONT_PORCH_1024x768;
                        v_sync_time    <= V_SYNC_TIME_1024x768;
                        v_back_porch   <= V_BACK_PORCH_1024x768;
                        v_active_video <= V_ACTIVE_VIDEO_1024x768;
                        v_front_porch  <= V_FRONT_PORCH_1024x768;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_1024x768_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_1024x768);

                    when "011" =>
                        h_sync_time    <= H_SYNC_TIME_1280x720;
                        h_back_porch   <= H_BACK_PORCH_1280x720;
                        h_active_video <= H_ACTIVE_VIDEO_1280x720;
                        h_front_porch  <= H_FRONT_PORCH_1280x720;
                        v_sync_time    <= V_SYNC_TIME_1280x720;
                        v_back_porch   <= V_BACK_PORCH_1280x720;
                        v_active_video <= V_ACTIVE_VIDEO_1280x720;
                        v_front_porch  <= V_FRONT_PORCH_1280x720;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_1280x720_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_1280x720);

                    when "100" =>
                        h_sync_time    <= H_SYNC_TIME_1360x768;
                        h_back_porch   <= H_BACK_PORCH_1360x768;
                        h_active_video <= H_ACTIVE_VIDEO_1360x768;
                        h_front_porch  <= H_FRONT_PORCH_1360x768;
                        v_sync_time    <= V_SYNC_TIME_1360x768;
                        v_back_porch   <= V_BACK_PORCH_1360x768;
                        v_active_video <= V_ACTIVE_VIDEO_1360x768;
                        v_front_porch  <= V_FRONT_PORCH_1360x768;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_1360x768_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_1360x768);

                    when "101" =>
                        h_sync_time    <= H_SYNC_TIME_1366x768;
                        h_back_porch   <= H_BACK_PORCH_1366x768;
                        h_active_video <= H_ACTIVE_VIDEO_1366x768;
                        h_front_porch  <= H_FRONT_PORCH_1366x768;
                        v_sync_time    <= V_SYNC_TIME_1366x768;
                        v_back_porch   <= V_BACK_PORCH_1366x768;
                        v_active_video <= V_ACTIVE_VIDEO_1366x768;
                        v_front_porch  <= V_FRONT_PORCH_1366x768;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_1366x768_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_1366x768);

                    when "110" =>
                        h_sync_time    <= H_SYNC_TIME_1920x1080;
                        h_back_porch   <= H_BACK_PORCH_1920x1080;
                        h_active_video <= H_ACTIVE_VIDEO_1920x1080;
                        h_front_porch  <= H_FRONT_PORCH_1920x1080;
                        v_sync_time    <= V_SYNC_TIME_1920x1080;
                        v_back_porch   <= V_BACK_PORCH_1920x1080;
                        v_active_video <= V_ACTIVE_VIDEO_1920x1080;
                        v_front_porch  <= V_FRONT_PORCH_1920x1080;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_1920x1080_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_1920x1080);

                    when others =>
                        h_sync_time    <= H_SYNC_TIME_640x480;
                        h_back_porch   <= H_BACK_PORCH_640x480;
                        h_active_video <= H_ACTIVE_VIDEO_640x480;
                        h_front_porch  <= H_FRONT_PORCH_640x480;
                        v_sync_time    <= V_SYNC_TIME_640x480;
                        v_back_porch   <= V_BACK_PORCH_640x480;
                        v_active_video <= V_ACTIVE_VIDEO_640x480;
                        v_front_porch  <= V_FRONT_PORCH_640x480;
                        act_pixel_num  <= std_logic_vector(H_ACTIVE_VIDEO_640x480_OUT);
                        act_line_num   <= std_logic_vector(V_ACTIVE_VIDEO_640x480);

                end case;
            end if;
        end if;
    end process PROC_TIMING;

end architecture rtl;
