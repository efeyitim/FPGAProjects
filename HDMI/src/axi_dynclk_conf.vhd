---------------------------------------------------------------------------------------------------
--  Project Name        :
--  System/Block Name   :
--  Design Engineer     :   Efe Berkay YITIM
--  Date                :   12.08.2023
--  Short Description   :   
---------------------------------------------------------------------------------------------------
--  Revisions
--  Designer            Date            Description
--  -----------         ----------      -----------------------------------------------------------
--  Efe Berkay YITIM    12.08.2023          v1.0 Initial Release
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_dynclk_conf is

    port (
        axi_aclk    : in  std_logic;
        axi_aresetn : in  std_logic;
        res_upd     : in  std_logic;
        res_sel     : in  std_logic_vector(2 downto 0);
        axi_awaddr  : out std_logic_vector(4 downto 0);
        axi_awprot  : out std_logic_vector(2 downto 0);
        axi_awvalid : out std_logic;
        axi_awready : in  std_logic;
        axi_wdata   : out std_logic_vector(31 downto 0);
        axi_wstrb   : out std_logic_vector(3 downto 0);
        axi_wvalid  : out std_logic;
        axi_wready  : in  std_logic;
        axi_bresp   : in  std_logic_vector(1 downto 0);
        axi_bvalid  : in  std_logic;
        axi_bready  : out std_logic;
        axi_araddr  : out std_logic_vector(4 downto 0);
        axi_arprot  : out std_logic_vector(2 downto 0);
        axi_arvalid : out std_logic;
        axi_arready : in  std_logic;
        axi_rdata   : in  std_logic_vector(31 downto 0);
        axi_rresp   : in  std_logic_vector(1 downto 0);
        axi_rvalid  : in  std_logic;
        axi_rready  : out std_logic);

end entity axi_dynclk_conf;

architecture rtl of axi_dynclk_conf is

    type state_t is (IDLE_S,
                     WRITE_1_S, WAIT_1_S, WAIT_1_ADR_S, WAIT_1_WR_S,
                     WRITE_2_S, WAIT_2_S, WAIT_2_ADR_S, WAIT_2_WR_S,
                     WRITE_3_S, WAIT_3_S, WAIT_3_ADR_S, WAIT_3_WR_S,
                     WRITE_4_S, WAIT_4_S, WAIT_4_ADR_S, WAIT_4_WR_S,
                     WRITE_5_S, WAIT_5_S, WAIT_5_ADR_S, WAIT_5_WR_S,
                     WRITE_6_S, WAIT_6_S, WAIT_6_ADR_S, WAIT_6_WR_S,
                     WRITE_7_S, WAIT_7_S, WAIT_7_ADR_S, WAIT_7_WR_S,
                     READ_1_S, WAIT_READ_S,
                     WRITE_8_S, WAIT_8_S, WAIT_8_ADR_S, WAIT_8_WR_S);
    signal state        : state_t;
    signal power_up     : std_logic;
    signal res_upd_buf  : std_logic;
    signal res_upd_flag : std_logic;
    signal res_sel_buf  : std_logic_vector(2 downto 0);

begin  -- architecture rtl

    process (axi_aclk, axi_aresetn) is
    begin  -- process
        if axi_aresetn = '0' then                                     -- asynchronous reset (active low)
            axi_awaddr       <= (others => '0');
            axi_awprot       <= (others => '0');
            axi_awvalid      <= '0';
            axi_wdata        <= (others => '0');
            axi_wstrb        <= (others => '0');
            axi_wvalid       <= '0';
            axi_bready       <= '0';
            axi_araddr       <= (others => '0');
            axi_arprot       <= (others => '0');
            axi_arvalid      <= '0';
            axi_rready       <= '0';
            power_up         <= '0';
            res_upd_buf      <= '0';
            res_upd_flag     <= '0';
            res_sel_buf      <= (others => '0');
            state            <= IDLE_S;
        elsif rising_edge(axi_aclk) then                              -- rising clock edge
            axi_awprot       <= "001";
            axi_wstrb        <= "1111";
            axi_bready       <= '1';
            axi_arprot       <= "001";
            res_upd_buf      <= res_upd;
            if res_upd_buf = '0' and res_upd = '1' then               -- rising edge
                res_sel_buf  <= res_sel;
                res_upd_flag <= '1';
            end if;

            case state is

                when IDLE_S =>
                    if res_upd_flag = '1' or power_up = '0' then
                        state        <= WRITE_1_S;
                        power_up     <= '1';
                        res_upd_flag <= '0';
                    end if;

                when WRITE_1_S =>
                    axi_awaddr        <= "01000";
                    axi_awvalid       <= '1';
                    case res_sel_buf is
                        when "001" =>
                            axi_wdata <= x"00000104";
                        when "010" =>
                            axi_wdata <= x"00800042";
                        when "011" =>
                            axi_wdata <= x"00000041";
                        when "100" =>
                            axi_wdata <= x"00000041";
                        when "101" =>
                            axi_wdata <= x"00400041";
                        when others =>
                            axi_wdata <= x"00000104";
                    end case;
                    axi_wvalid        <= '1';
                    state             <= WAIT_1_S;

                when WAIT_1_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_1_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_1_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= WRITE_2_S;
                    end if;

                when WAIT_1_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= WRITE_2_S;
                    end if;

                when WAIT_1_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= WRITE_2_S;
                    end if;

                ------------------------------------------
                when WRITE_2_S =>
                    axi_awaddr        <= "01100";
                    axi_awvalid       <= '1';
                    case res_sel_buf is
                        when "001" =>
                            axi_wdata <= x"00000145";
                        when "010" =>
                            axi_wdata <= x"008000C3";
                        when "011" =>
                            axi_wdata <= x"0000069A";
                        when "100" =>
                            axi_wdata <= x"000006DB";
                        when "101" =>
                            axi_wdata <= x"0000069A";
                        when others =>
                            axi_wdata <= x"00000145";
                    end case;
                    axi_wvalid        <= '1';
                    state             <= WAIT_2_S;

                when WAIT_2_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_2_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_2_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= WRITE_3_S;
                    end if;

                when WAIT_2_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= WRITE_3_S;
                    end if;

                when WAIT_2_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= WRITE_3_S;
                    end if;

                    ------------------------------------------

                when WRITE_3_S =>
                    axi_awaddr  <= "10000";
                    axi_awvalid <= '1';
                    axi_wdata   <= x"00000000";
                    axi_wvalid  <= '1';
                    state       <= WAIT_3_S;

                when WAIT_3_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_3_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_3_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= WRITE_4_S;
                    end if;

                when WAIT_3_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= WRITE_4_S;
                    end if;

                when WAIT_3_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= WRITE_4_S;
                    end if;

                    ------------------------------------------

                when WRITE_4_S =>
                    axi_awaddr        <= "10100";
                    axi_awvalid       <= '1';
                    case res_sel_buf is
                        when "001" =>
                            axi_wdata <= x"00001041";
                        when "010" =>
                            axi_wdata <= x"00001041";
                        when "011" =>
                            axi_wdata <= x"000020C4";
                        when "100" =>
                            axi_wdata <= x"00002083";
                        when "101" =>
                            axi_wdata <= x"000020C4";
                        when others =>
                            axi_wdata <= x"00001041";
                    end case;

                    axi_wvalid <= '1';
                    state      <= WAIT_4_S;

                when WAIT_4_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_4_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_4_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= WRITE_5_S;
                    end if;

                when WAIT_4_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= WRITE_5_S;
                    end if;

                when WAIT_4_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= WRITE_5_S;
                    end if;

                    ------------------------------------------

                when WRITE_5_S =>
                    axi_awaddr        <= "11000";
                    axi_awvalid       <= '1';
                    case res_sel_buf is
                        when "001" =>
                            axi_wdata <= x"3E8FA401";
                        when "010" =>
                            axi_wdata <= x"7E8FA401";
                        when "011" =>
                            axi_wdata <= x"CFAFA401";
                        when "100" =>
                            axi_wdata <= x"CFAFA401";
                        when "101" =>
                            axi_wdata <= x"CFAFA401";
                        when others =>
                            axi_wdata <= x"3E8FA401";
                    end case;
                    axi_wvalid        <= '1';
                    state             <= WAIT_5_S;

                when WAIT_5_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_5_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_5_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= WRITE_6_S;
                    end if;

                when WAIT_5_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= WRITE_6_S;
                    end if;

                when WAIT_5_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= WRITE_6_S;
                    end if;

                    ------------------------------------------

                when WRITE_6_S =>
                    axi_awaddr        <= "11100";
                    axi_awvalid       <= '1';
                    case res_sel_buf is
                        when "001" =>
                            axi_wdata <= x"004B00E7";
                        when "010" =>
                            axi_wdata <= x"0073008C";
                        when "011" =>
                            axi_wdata <= x"00A300FF";
                        when "100" =>
                            axi_wdata <= x"00A300FF";
                        when "101" =>
                            axi_wdata <= x"00A300FF";
                        when others =>
                            axi_wdata <= x"004B00E7";
                    end case;
                    axi_wvalid        <= '1';
                    state             <= WAIT_6_S;

                when WAIT_6_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_6_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_6_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= WRITE_7_S;
                    end if;

                when WAIT_6_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= WRITE_7_S;
                    end if;

                when WAIT_6_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= WRITE_7_S;
                    end if;

                    ------------------------------------------

                when WRITE_7_S =>
                    axi_awaddr  <= "00000";
                    axi_awvalid <= '1';
                    axi_wdata   <= x"00000000";
                    axi_wvalid  <= '1';
                    state       <= WAIT_7_S;

                when WAIT_7_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_7_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_7_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= READ_1_S;
                    end if;

                when WAIT_7_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= READ_1_S;
                    end if;

                when WAIT_7_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= READ_1_S;
                    end if;

                    ------------------------------------------

                when READ_1_S =>
                    axi_araddr  <= "00100";
                    axi_arvalid <= '1';
                    axi_rready  <= '1';
                    state       <= WAIT_READ_S;

                when WAIT_READ_S =>
                    if axi_arready = '1' then
                        axi_arvalid <= '0';
                    end if;
                    if axi_rvalid = '1' then
                        axi_rready  <= '0';
                        if axi_rdata /= x"00000000" then
                            state   <= READ_1_S;
                        else
                            state   <= WRITE_8_S;
                        end if;
                    end if;

                    ------------------------------------------

                when WRITE_8_S =>
                    axi_awaddr  <= "00000";
                    axi_awvalid <= '1';
                    axi_wdata   <= x"00000001";
                    axi_wvalid  <= '1';
                    state       <= WAIT_8_S;

                when WAIT_8_S =>
                    if axi_awready = '1' and axi_wready = '0' then
                        axi_awvalid <= '0';
                        state       <= WAIT_8_WR_S;
                    end if;
                    if axi_awready = '0' and axi_wready = '1' then
                        axi_wvalid  <= '0';
                        state       <= WAIT_8_ADR_S;
                    end if;
                    if axi_awready = '1' and axi_wready = '1' then
                        axi_awvalid <= '0';
                        axi_wvalid  <= '0';
                        state       <= IDLE_S;
                    end if;

                when WAIT_8_WR_S =>
                    if axi_wready = '1' then
                        axi_wvalid <= '0';
                        state      <= IDLE_S;
                    end if;

                when WAIT_8_ADR_S =>
                    if axi_awready = '1' then
                        axi_awvalid <= '0';
                        state       <= IDLE_S;
                    end if;

                    ------------------------------------------



                when others => null;
            end case;
        end if;
    end process;


end architecture rtl;
