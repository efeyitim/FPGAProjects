library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity convolution is

    generic (
	c_data_length : integer := 24;	-- data length
	c_num_coef    : integer := 5;
	c_coef_length : integer := 8;
	c_coef_pow    : integer := 3);

    port (
	clk	     : in  std_logic;	-- main clock
	rst_n	     : in  std_logic;	-- active low reset
	i_en	     : in  std_logic;	-- enable signal
	i_coef_valid : in  std_logic;	-- coef valid signal
	i_coef_addr  : in  std_logic_vector (5 downto 0);
	i_coef_data  : in  std_logic_vector (c_coef_length - 1 downto 0);
	i_data	     : in  std_logic_vector (c_data_length - 1 downto 0);
	i_data_valid : in  std_logic;
	o_data	     : out std_logic_vector (c_data_length - 1 downto 0);
	o_data_valid : out std_logic;
	o_busy	     : out std_logic);

end entity convolution;

architecture rtl of convolution is

    type t_shift_ctrl is (S_IDLE, S_SHIFT);
    signal r_shift_ctrl : t_shift_ctrl;

    type t_filter_calc is (S_IDLE, S_CALC, S_DONE);
    signal r_filter_calc : t_filter_calc;

    type t_coef_ram is array (0 to c_num_coef - 1) of std_logic_vector (c_coef_length - 1 downto 0);
    signal r_coef_ram : t_coef_ram;

    type t_data_ram is array (0 to c_num_coef - 1) of std_logic_vector (c_data_length - 1 downto 0);
    signal r_data_ram : t_data_ram;

    function f_ram_shift (
	r_data_ram	    : t_data_ram;
	data_in		    : std_logic_vector (c_data_length - 1 downto 0))
	return t_data_ram is
	variable v_data_ram : t_data_ram;
    begin  -- function f_ram_shift
	v_data_ram	      := r_data_ram;
	for i in c_num_coef - 2 downto 0 loop
	    v_data_ram(i + 1) := v_data_ram(i);
	end loop;  -- i
	v_data_ram(0)	      := data_in;
	return v_data_ram;
    end function f_ram_shift;

    signal r_calc_start	    : std_logic;
    signal r_data	    : std_logic_vector (c_data_length - 1 downto 0);
    signal r_sum	    : std_logic_vector (c_data_length + c_coef_length + 2 downto 0);
    signal r_data_out	    : std_logic_vector (c_data_length - 1 downto 0);
    signal r_data_out_valid : std_logic;
    signal r_busy	    : std_logic;
    signal i		    : integer;

begin  -- architecture rtl

    o_data	 <= r_data_out;
    o_data_valid <= r_data_out_valid;
    o_busy	 <= r_busy;

    PROC_COEF_RAM : process (clk, rst_n) is
    begin  -- process PROC_RAM
	if rst_n = '0' then		-- asynchronous reset (active low)
	    r_coef_ram				      <= (others => (others => '0'));
	elsif rising_edge(clk) then	-- rising clock edge
	    if i_coef_valid = '1' then
		r_coef_ram(conv_integer(i_coef_addr)) <= i_coef_data;
	    end if;
	end if;
    end process PROC_COEF_RAM;

    PROC_DATA_RAM : process (clk, rst_n) is
    begin  -- process
	if rst_n = '0' then		-- asynchronous reset (active low)
	    r_shift_ctrl <= S_IDLE;
	    r_data_ram	 <= (others => (others => '0'));
	    r_calc_start <= '0';
	    r_data	 <= (others => '0');
	elsif rising_edge(clk) then	-- rising clock edge
	    r_calc_start <= '0';
	    case r_shift_ctrl is

		when S_IDLE =>
		    if i_data_valid = '1' then
			r_data	     <= i_data;
			r_shift_ctrl <= S_SHIFT;
		    end if;

		when S_SHIFT =>
		    r_data_ram	 <= f_ram_shift(r_data_ram, r_data);
		    r_shift_ctrl <= S_IDLE;
		    r_calc_start <= '1';

		when others => null;

	    end case;
	end if;
    end process PROC_DATA_RAM;

    PROC_CALC : process (clk, rst_n) is
    begin  -- process
	if rst_n = '0' then		-- asynchronous reset (active low)
	    r_filter_calc	      <= S_IDLE;
	    r_sum		      <= (others => '0');
	    r_data_out_valid	      <= '0';
	    r_data_out		      <= (others => '0');
	    r_busy		      <= '0';
	    i			      <= 0;
	elsif rising_edge(clk) then	-- rising clock edge
	    r_data_out_valid	      <= '0';
	    case r_filter_calc is
		when S_IDLE =>
		    r_busy	      <= '0';
		    if r_calc_start = '1' and i_en = '1' then
			r_filter_calc <= S_CALC;
			r_busy	      <= '1';
		    end if;

		when S_CALC =>
		    r_sum	      <= r_sum + sxt((r_data_ram(i)) * (r_coef_ram(c_num_coef - 1 - i)), r_sum'length);
		    i		      <= i + 1;
		    if i = c_num_coef - 1 then
			i	      <= 0;
			r_filter_calc <= S_DONE;
		    end if;

		when S_DONE =>
		    r_sum	     <= (others => '0');
		    r_busy	     <= '0';
		    r_data_out_valid <= '1';
		    r_data_out	     <= r_sum(c_coef_pow + c_data_length - 1 downto c_coef_pow);
		    r_filter_calc    <= S_IDLE;

		when others => null;

	    end case;
	end if;
    end process PROC_CALC;
end architecture rtl;
