-------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   08.08.2023
--  Short Description   :   
-------------------------------------------------------------------------------------------
--  Rev     Designer    Date            Description
--  ----    --------    ----------      ---------------------------------------------------
--  v1.0    efeyitim    08.08.2023      Initial Release
-------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tmds_encoder is

    generic (
        CH_NUM     :     integer := 0);
    port (
        clk_pixel  : in  std_logic;
        rst_n      : in  std_logic;
        active     : in  std_logic;
        video_data : in  std_logic_vector(7 downto 0);
        ctrl_data  : in  std_logic_vector(1 downto 0);
        aux_data   : in  std_logic_vector(3 downto 0);
        tmds       : out std_logic_vector(9 downto 0));

end entity tmds_encoder;

architecture rtl of tmds_encoder is

    signal video_encoded    : std_logic_vector(9 downto 0);
    signal control_encoded  : std_logic_vector(9 downto 0);
    signal video_guard_band : std_logic_vector(9 downto 0);


    -- Figure 5-7 under Section 5.4.4.1
    signal N1D       : unsigned(3 downto 0);                          -- number of 1s in video_data(7:0)
    signal N1q_m07   : signed(4 downto 0);                            -- number of 1s in q_m(7:0)
    signal N0q_m07   : signed(4 downto 0);                            -- number of 0s in q_m(7:0)
    signal q_m       : std_logic_vector(8 downto 0);
    signal q_out     : std_logic_vector(9 downto 0);
    signal q_out_reg : std_logic_vector(9 downto 0);
    signal cnt       : signed(4 downto 0);
    signal cnt_add   : signed(4 downto 0);

begin  -- architecture rtl

    GEN_VGB1 : if CH_NUM = 0 or CH_NUM = 1 generate
        video_guard_band <= "1011001100";
    end generate GEN_VGB1;

    GEN_VGB2 : if CH_NUM /= 0 and CH_NUM /= 1 generate
        video_guard_band <= "0100110011";
    end generate GEN_VGB2;

    video_encoded <= q_out_reg;

    control_encoded <= "1101010100" when ctrl_data = "00" else
                       "0010101011" when ctrl_data = "01" else
                       "0101010100" when ctrl_data = "10" else
                       "1010101011";

    tmds <= video_encoded when active = '1' else control_encoded;

    -- Figure 5-7 under Section 5.4.4.1
    process(video_data)
        variable count : unsigned(3 downto 0) := (others => '0');

    begin
        count     := (others => '0');                                 --initialize count variable.
        for i in 0 to 7 loop                                          --for all the bits.
            count := count + ("000" & video_data(i));                 --Add the bit to the count.
        end loop;
        N1D       <= count;                                           --assign the count to output.
    end process;

    process(q_m(7 downto 0))
        variable count_1 : signed(4 downto 0) := (others => '0');
        variable count_0 : signed(4 downto 0) := (others => '0');

    begin
        count_1     := (others => '0');                               --initialize count variable.
        count_0     := (others => '0');                               --initialize count variable.
        for i in 0 to 7 loop                                          --for all the bits.
            count_1 := count_1 + ("0000" & q_m(i));                   --Add the bit to the count.
            count_0 := count_0 + ("0000" & not q_m(i));               --Add the bit to the count.
        end loop;
        N1q_m07     <= count_1;                                       --assign the count to output.
        N0q_m07     <= count_0;                                       --assign the count to output.
    end process;

    process (clk_pixel, rst_n) is
    begin  -- process
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            q_out_reg <= (others => '0');
        elsif rising_edge(clk_pixel) then                             -- rising clock edge
            q_out_reg <= q_out;
        end if;
    end process;

    process (N0q_m07, N1D, N1q_m07, cnt, q_m, video_data) is
    begin  -- process
        if N1D > 4 or (N1D = 4 and video_data(0) = '0') then
            q_m(0)                <= video_data(0);
            q_m(1)                <= q_m(0) xnor video_data(1);
            q_m(2)                <= q_m(1) xnor video_data(2);
            q_m(3)                <= q_m(2) xnor video_data(3);
            q_m(4)                <= q_m(3) xnor video_data(4);
            q_m(5)                <= q_m(4) xnor video_data(5);
            q_m(6)                <= q_m(5) xnor video_data(6);
            q_m(7)                <= q_m(6) xnor video_data(7);
            q_m(8)                <= '0';
        else
            q_m(0)                <= video_data(0);
            q_m(1)                <= q_m(0) xor video_data(1);
            q_m(2)                <= q_m(1) xor video_data(2);
            q_m(3)                <= q_m(2) xor video_data(3);
            q_m(4)                <= q_m(3) xor video_data(4);
            q_m(5)                <= q_m(4) xor video_data(5);
            q_m(6)                <= q_m(5) xor video_data(6);
            q_m(7)                <= q_m(6) xor video_data(7);
            q_m(8)                <= '1';
        end if;
        if cnt = 0 or N1q_m07 = N0q_m07 then
            q_out(9)              <= not q_m(8);
            q_out(8)              <= q_m(8);
            if q_m(8) = '1' then
                q_out(7 downto 0) <= q_m(7 downto 0);
                cnt_add           <= N1q_m07 - N0q_m07;
            else
                q_out(7 downto 0) <= not q_m(7 downto 0);
                cnt_add           <= N0q_m07 - N1q_m07;
            end if;
        else
            if (cnt > 0 and N1q_m07 > N0q_m07) or (cnt < 0 and N0q_m07 > N1q_m07) then
                q_out(9)          <= '1';
                q_out(8)          <= q_m(8);
                q_out(7 downto 0) <= not q_m(7 downto 0);
                if q_m(8) = '1' then
                    cnt_add       <= N0q_m07 - N1q_m07 + 2;
                else
                    cnt_add       <= N0q_m07 - N1q_m07;
                end if;
            else
                q_out(9)          <= '0';
                q_out(8)          <= q_m(8);
                q_out(7 downto 0) <= q_m(7 downto 0);
                if q_m(8) = '1' then
                    cnt_add       <= N1q_m07 - N0q_m07;
                else
                    cnt_add       <= N1q_m07 - N0q_m07 - 2;
                end if;
            end if;
        end if;
    end process;


    PROC_CNT : process (clk_pixel, rst_n) is
    begin  -- process PROC_CNT
        if rst_n = '0' then                                           -- asynchronous reset (active low)
            cnt     <= (others => '0');
        elsif rising_edge(clk_pixel) then                             -- rising clock edge
            if active = '1' then
                cnt <= cnt + cnt_add;
            else
                cnt <= (others => '0');
            end if;
        end if;
    end process PROC_CNT;

end architecture rtl;
