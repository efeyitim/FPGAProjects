library ieee;
use ieee.std_logic_1164.all;

entity edid_top is
    port( 
        FPGA_MAIN_CLK : in     std_logic  := '0';
        HPD           : in     std_logic;
        dp_tx_rout    : in     std_logic;
        dp_tx_de      : out    std_logic;
        dp_tx_din     : out    std_logic;
        dp_tx_ren     : out    std_logic
    );
end edid_top ;


architecture struct of edid_top is

    signal HPD_sync  : std_logic;
    signal clk       : std_logic;
    signal hpd_filt  : std_logic;
    signal locked    : std_logic;
    signal logic_0   : std_logic := '0';
    signal ram_addr  : std_logic_vector(7 downto 0);
    signal ram_data  : std_logic_vector(7 downto 0);
    signal ram_wren  : std_logic;
    signal rst_n     : std_logic;
    signal rst_n_hpd : std_logic;
    signal rx_data   : std_logic_vector(7 downto 0);
    signal rx_empty  : std_logic;
    signal rx_rd_en  : std_logic;
    signal tx_data   : std_logic_vector(7 downto 0);
    signal tx_wr_en  : std_logic;

    component aux_controller
    port (
        clk      : in     std_logic;
        rst_n    : in     std_logic;
        rx_data  : in     std_logic_vector (7 downto 0);
        rx_empty : in     std_logic;
        ram_addr : out    std_logic_vector (7 downto 0);
        ram_data : out    std_logic_vector (7 downto 0);
        ram_wren : out    std_logic;
        rx_rd_en : out    std_logic;
        tx_data  : out    std_logic_vector (7 downto 0);
        tx_wr_en : out    std_logic
    );
    end component;
    component aux_interface
    generic (
        clock_period_in_ns : integer := 10
    );
    port (
        clk         : in     std_logic;
        dp_tx_rout  : in     std_logic;
        rst_n       : in     std_logic;
        rx_rd_en    : in     std_logic;
        tx_data     : in     std_logic_vector (7 downto 0);
        tx_wr_en    : in     std_logic;
        busy        : out    std_logic;
        dp_tx_de    : out    std_logic;
        dp_tx_din   : out    std_logic;
        dp_tx_ren   : out    std_logic;
        rx_data     : out    std_logic_vector (7 downto 0);
        rx_empty    : out    std_logic;
        timeout     : out    std_logic;
        tx_full     : out    std_logic;
        dp_tx_aux_p : inout  std_logic
    );
    end component;
    component cdc_single_bit_sync
    generic (
        POLARITY   : std_logic := '0';
        SYNC_DEPTH : integer   := 3
    );
    port (
        clk    : in     std_logic;
        input  : in     std_logic;
        rst_n  : in     std_logic;
        output : out    std_logic
    );
    end component;
    component debounce_filter
    generic (
        INIT_VAL : std_logic := '1';        -- expected inital value
        DB_TIME  : natural   := 500
    );
    port (
        clk          : in     std_logic;
        rst_n        : in     std_logic;
        sin          : in     std_logic;
        sin_filtered : out    std_logic
    );
    end component;
    component edid_ram
    port (
        address : in     STD_LOGIC_VECTOR (7 downto 0);
        clock   : in     STD_LOGIC  := '1';
        data    : in     STD_LOGIC_VECTOR (7 downto 0);
        wren    : in     STD_LOGIC;
        q       : out    STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
    component pll_50
    port (
        refclk   : in     std_logic  := '0';
        rst      : in     std_logic  := '0';
        locked   : out    std_logic;
        outclk_0 : out    std_logic
    );
    end component;
    component reset_delay
    port (
        clk       : in     std_logic;
        rst_n     : in     std_logic;
        rst_n_out : out    std_logic
    );
    end component;
    component reset_synchronizer
    port (
        clk         : in     std_logic;
        input_rst_n : in     std_logic;
        rst         : out    std_logic;
        rst_n       : out    std_logic
    );
    end component;

begin                                 
    logic_0   <= '0';

    U_6 : aux_controller
        port map (
            clk      => clk,
            rst_n    => rst_n_hpd,
            tx_wr_en => tx_wr_en,
            tx_data  => tx_data,
            rx_rd_en => rx_rd_en,
            rx_data  => rx_data,
            rx_empty => rx_empty,
            ram_addr => ram_addr,
            ram_data => ram_data,
            ram_wren => ram_wren
        );
    U_0 : aux_interface
        generic map (
            clock_period_in_ns => 10
        )
        port map (
            clk         => clk,
            rst_n       => rst_n_hpd,
            dp_tx_aux_p => open,
            dp_tx_de    => dp_tx_de,
            dp_tx_ren   => dp_tx_ren,
            dp_tx_din   => dp_tx_din,
            dp_tx_rout  => dp_tx_rout,
            tx_wr_en    => tx_wr_en,
            tx_data     => tx_data,
            tx_full     => open,
            rx_rd_en    => rx_rd_en,
            rx_data     => rx_data,
            rx_empty    => rx_empty,
            busy        => open,
            timeout     => open
        );
    U_7 : cdc_single_bit_sync
        generic map (
            POLARITY   => '1',
            SYNC_DEPTH => 3
        )
        port map (
            clk    => clk,
            rst_n  => rst_n,
            input  => HPD,
            output => HPD_sync
        );
    U_4 : debounce_filter
        generic map (
            INIT_VAL => '1',            -- expected inital value
            DB_TIME  => 500
        )
        port map (
            clk          => clk,
            rst_n        => rst_n,
            sin          => HPD_sync,
            sin_filtered => hpd_filt
        );
    U_2 : edid_ram
        port map (
            address => ram_addr,
            clock   => clk,
            data    => ram_data,
            wren    => ram_wren,
            q       => open
        );
    U_1 : pll_50
        port map (
            refclk   => FPGA_MAIN_CLK,
            rst      => logic_0,
            outclk_0 => clk,
            locked   => locked
        );
    U_5 : reset_delay
        port map (
            clk       => clk,
            rst_n     => hpd_filt,
            rst_n_out => rst_n_hpd
        );
    U_3 : reset_synchronizer
        port map (
            clk         => clk,
            input_rst_n => locked,
            rst         => open,
            rst_n       => rst_n
        );

end struct;
