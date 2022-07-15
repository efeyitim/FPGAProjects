library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor is

    generic (
	LENGTH : integer := 5);		-- length of dividend and divisor in log2(X) form

    port (
	clk	  : in	std_logic;				 -- clk
	rst_n	  : in	std_logic;				 -- active low reset
	en	  : in	std_logic;				 -- enable signal
	dividend  : in	std_logic_vector(2**LENGTH-1 downto 0);	 -- dividend
	divisor	  : in	std_logic_vector(2**LENGTH-1 downto 0);	 -- divisor
	quotient  : out std_logic_vector(2**LENGTH-1 downto 0);	 -- quotient
	remainder : out std_logic_vector(2**LENGTH-1 downto 0);	 -- remainder
	busy	  : out std_logic;				 -- busy signal
	done	  : out std_logic);				 -- done signal

end entity divisor;


architecture rtl of divisor is

    type state_t is (IDLE, DIV, RESULT);
    signal state	: state_t;
    signal en_buf	: std_logic;
    signal en_redge	: std_logic;
    signal dividend_buf : signed(2**(LENGTH+1)-1 downto 0);
    signal divisor_buf	: signed(2**(LENGTH+1)-1 downto 0);
    signal quotient_buf : std_logic_vector(2**LENGTH-1 downto 0);
    signal counter	: unsigned(LENGTH downto 0);
    constant LIMIT	: unsigned(LENGTH downto 0) := '1' & (LENGTH - 1 downto 0 => '0');  --(LENGTH => '1', others => '0');

begin  -- architecture rtl

    PROC_DIV : process (clk, rst_n) is
    begin  -- process PROC_DIV
	if rst_n = '0' then		       -- asynchronous reset (active low)
	    en_buf	 <= '0';
	    dividend_buf <= (others => '0');
	    divisor_buf	 <= (others => '0');
	    counter	 <= (others => '0');
	    quotient_buf <= (others => '0');
	    quotient	 <= (others => '0');
	    remainder	 <= (others => '0');
	    en_redge	 <= '0';
	    busy	 <= '0';
	    done	 <= '0';
	    state	 <= IDLE;
	elsif rising_edge(clk) then	       -- rising clock edge
	    en_buf	 <= en;
	    if en_buf = '0' and en = '1' then  -- rising edge of enable
		en_redge <= '1';
	    end if;

	    case state is

		when IDLE =>
		    done						 <= '0';
		    busy						 <= '0';
		    if en_redge = '1' then  -- rising edge of enable
			busy						 <= '1';
			en_redge					 <= '0';
			dividend_buf(2**(LENGTH+1)-1 downto 2**(LENGTH)) <= (others => '0');
			dividend_buf(2**(LENGTH)-1 downto 0)		 <= signed(dividend);
			divisor_buf(2**(LENGTH+1)-1 downto 2**(LENGTH))	 <= signed(divisor);
			divisor_buf(2**(LENGTH)-1 downto 0)		 <= (others => '0');
			state						 <= DIV;
		    end if;

		when DIV =>
		    done <= '0';

		    -- shift the quotient to left
		    quotient_buf(2**LENGTH-1 downto 1) <= quotient_buf(2**LENGTH-2 downto 0);

		    -- if dividend is larger than divisor, subtract and append 1 to quotient
		    if dividend_buf - divisor_buf > 0 then
			dividend_buf	<= dividend_buf - divisor_buf;
			quotient_buf(0) <= '1';
		    -- if dividend is smaller than divisor, append 0 to quotient			
		    else
			dividend_buf	<= dividend_buf;
			quotient_buf(0) <= '0';
		    end if;

		    --shift the divisor to right
		    divisor_buf <= '0' & divisor_buf(2**(LENGTH+1)-1 downto 1);

		    if counter = LIMIT then
			counter <= (others => '0');
			state	<= RESULT;
		    else
			counter <= counter + 1;
		    end if;

		when RESULT =>
		    done						 <= '1';
		    quotient						 <= quotient_buf(2**LENGTH-1 downto 0);
		    remainder						 <= std_logic_vector(dividend_buf(2**LENGTH-1 downto 0));
		    if en_redge = '1' then  -- rising edge of enable
			en_redge					 <= '0';
			busy						 <= '1';
			dividend_buf(2**(LENGTH+1)-1 downto 2**(LENGTH)) <= (others => '0');
			dividend_buf(2**(LENGTH)-1 downto 0)		 <= signed(dividend);
			divisor_buf(2**(LENGTH+1)-1 downto 2**(LENGTH))	 <= signed(divisor);
			divisor_buf(2**(LENGTH)-1 downto 0)		 <= (others => '0');
			state						 <= DIV;
		    else
			busy						 <= '0';
			state						 <= IDLE;
		    end if;

		when others =>
		    en_buf	 <= '0';
		    dividend_buf <= (others => '0');
		    divisor_buf	 <= (others => '0');
		    counter	 <= (others => '0');
		    quotient_buf <= (others => '0');
		    quotient	 <= (others => '0');
		    remainder	 <= (others => '0');
		    en_redge	 <= '0';
		    busy	 <= '0';
		    done	 <= '0';
		    state	 <= IDLE;

	    end case;
	end if;
    end process PROC_DIV;
end architecture rtl;
