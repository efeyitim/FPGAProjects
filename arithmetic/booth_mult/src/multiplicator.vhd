library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicator is

    generic (
	LENGTH : integer := 5);		-- length of multiplicand and multiplier in log2(X) form

    port (
	clk	     : in  std_logic;					-- clk
	rst_n	     : in  std_logic;					-- active low reset
	en	     : in  std_logic;					-- enable signal
	multiplicand : in  std_logic_vector(2**LENGTH-1 downto 0);	-- dividend
	multiplier   : in  std_logic_vector(2**LENGTH-1 downto 0);	-- divisor
	product	     : out std_logic_vector(2**(LENGTH+1)-1 downto 0);	-- quotient
	busy	     : out std_logic;					-- busy signal
	done	     : out std_logic);					-- done signal

end entity multiplicator;


architecture rtl of multiplicator is

    type state_t is (IDLE, MULT, RESULT);
    signal en_buf	    : std_logic;
    signal en_redge	    : std_logic;
    signal state	    : state_t;
    signal accumulator	    : signed(2**LENGTH-1 downto 0);
    signal multiplier_buf   : signed(2**LENGTH downto 0);
    signal multiplicand_buf : signed(2**LENGTH-1 downto 0);
    signal counter	    : unsigned(LENGTH downto 0);
    constant LIMIT	    : unsigned(LENGTH-1 downto 0) := (others => '1');

begin  -- architecture rtl

    PROC_MULT			  : process (clk, rst_n) is
	variable accumulator_temp : signed(2**LENGTH-1 downto 0);
    begin  -- process PROC_MULT
	if rst_n = '0' then		       -- asynchronous reset (active low)
	    product	     <= (others => '0');
	    busy	     <= '0';
	    done	     <= '0';
	    state	     <= IDLE;
	    en_buf	     <= '0';
	    en_redge	     <= '0';
	    accumulator	     <= (others => '0');
	    multiplier_buf   <= (others => '0');
	    multiplicand_buf <= (others => '0');
	    counter	     <= (others => '0');
	elsif rising_edge(clk) then	       -- rising clock edge
	    en_buf	     <= en;
	    if en_buf = '0' and en = '1' then  -- rising edge of enable
		en_redge     <= '1';
	    end if;

	    case state is

		when IDLE =>
		    done		 <= '0';
		    busy		 <= '0';
		    if en_redge = '1' then  -- rising edge of enable
			busy		 <= '1';
			en_redge	 <= '0';
			accumulator	 <= (others => '0');
			counter		 <= (others => '0');
			multiplier_buf	 <= signed(multiplier) & '0';
			multiplicand_buf <= signed(multiplicand);
			state		 <= MULT;
		    end if;

		when MULT =>
		    done		     <= '0';
		    case multiplier_buf(1 downto 0) is
			when "10" =>	-- subtract
			    accumulator_temp := accumulator - multiplicand_buf;
			    accumulator	     <= accumulator_temp(2**LENGTH-1) & accumulator_temp(2**LENGTH-1 downto 1);
			    multiplier_buf   <= accumulator_temp(0) & multiplier_buf(2**LENGTH downto 1);
			when "01" =>	-- add
			    accumulator_temp := accumulator + multiplicand_buf;
			    accumulator	     <= accumulator_temp(2**LENGTH-1) & accumulator_temp(2**LENGTH-1 downto 1);
			    multiplier_buf   <= accumulator_temp(0) & multiplier_buf(2**LENGTH downto 1);
			when others =>
			    accumulator	     <= accumulator(2**LENGTH-1) & accumulator(2**LENGTH-1 downto 1);
			    multiplier_buf   <= accumulator(0) & multiplier_buf(2**LENGTH downto 1);
		    end case;

		    if counter = LIMIT then
			counter <= (others => '0');
			state	<= RESULT;
		    else
			counter <= counter + 1;
		    end if;

		when RESULT =>
		    done		 <= '1';
		    product		 <= std_logic_vector(accumulator & multiplier_buf(2**LENGTH downto 1));
		    if en_redge = '1' then  -- rising edge of enable
			busy		 <= '1';
			en_redge	 <= '0';
			accumulator	 <= (others => '0');
			counter		 <= (others => '0');
			multiplier_buf	 <= signed(multiplier) & '0';
			multiplicand_buf <= signed(multiplicand);
			state		 <= MULT;
		    else
			busy		 <= '0';
			state		 <= IDLE;
		    end if;

		when others =>
		    product	<= (others => '0');
		    busy	<= '0';
		    done	<= '0';
		    state	<= IDLE;
		    en_buf	<= '0';
		    en_redge	<= '0';
		    accumulator <= (others => '0');
		    counter	<= (others => '0');

	    end case;

	end if;
    end process PROC_MULT;
end architecture rtl;
