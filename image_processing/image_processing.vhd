library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity image_proc is

    generic (
	c_image_row   : unsigned (8 downto 0) := "100000000";  -- image row number
	c_image_col   : unsigned (8 downto 0) := "100000000";  -- image column number
	c_data_length : integer		      := 24);	       -- data length

    port (
	clk	     : in  std_logic;					   -- main clock
	rst_n	     : in  std_logic;					   -- active low reset
	i_en	     : in  std_logic;					   -- enable signal
	i_start	     : in  std_logic;					   -- start signal
	i_opcode     : in  std_logic_vector (2 downto 0);		   -- signal to indicate operation type
	i_data	     : in  std_logic_vector (c_data_length - 1 downto 0);  -- input data
	i_data_valid : in  std_logic;					   -- indicator of data validation
	o_addr	     : out std_logic_vector (15 downto 0);		   -- pixel address
	o_addr_valid : out std_logic;					   --							    indicator of addr validatio
	o_data	     : out std_logic_vector (7 downto 0);		   -- data out
	o_data_valid : out std_logic;					   -- indicator of data validation
	o_done	     : out std_logic);					   -- done tick

end entity image_proc;

architecture rtl of image_proc is

    constant C_MIRROR	       : std_logic_vector (2 downto 0) := "000";
    constant C_REVERSE	       : std_logic_vector (2 downto 0) := "001";
    constant C_NEGATIVE	       : std_logic_vector (2 downto 0) := "010";
    constant C_THRESHOLD       : std_logic_vector (2 downto 0) := "011";
    constant C_BRIGHTNESS_UP   : std_logic_vector (2 downto 0) := "100";
    constant C_BRIGHTNESS_DOWN : std_logic_vector (2 downto 0) := "101";
    constant C_CONTRAST_UP     : std_logic_vector (2 downto 0) := "110";
    constant C_CONTRAST_DOWN   : std_logic_vector (2 downto 0) := "111";

    constant C_255 : std_logic_vector (7 downto 0) := (others => '0');
    constant C_45  : std_logic_vector (7 downto 0) := "00101101";

    type t_img_proc is (S_IDLE, S_READ, S_READWAIT, S_CALC, S_CHECKDONE, S_DONE);
    signal r_img_proc : t_img_proc;	-- state machine

    signal r_i : unsigned (7 downto 0);
    signal r_j : unsigned (7 downto 0);

    signal r_addr	: std_logic_vector (15 downto 0);
    signal r_addr_valid : std_logic;

    signal r_data	: unsigned (7 downto 0);
    signal r_data_valid : std_logic;

    signal r_done : std_logic;

begin  -- architecture rtl

    o_addr	 <= r_addr;
    o_addr_valid <= r_addr_valid;
    o_data	 <= std_logic_vector(r_data);
    o_data_valid <= r_data_valid;
    o_done	 <= r_done;

    -- purpose: image processing
    -- type   : sequential
    PROC_IMG_PROC : process (clk, rst_n) is
    begin  -- process PROC_IMG_PROC
	if rst_n = '0' then		-- asynchronous reset (active low)
	    r_img_proc	     <= S_IDLE;
	    r_i		     <= (others => '0');
	    r_j		     <= (others => '0');
	    r_addr	     <= (others => '0');
	    r_addr_valid     <= '0';
	    r_data	     <= (others => '0');
	    r_data_valid     <= '0';
	    r_done	     <= '0';
	elsif rising_edge(clk) then	-- rising clock edge
	    if i_en = '1' then
		r_data_valid <= '0';
		r_addr_valid <= '0';
		r_done	     <= '0';

		case r_img_proc is

		    when S_IDLE =>
			if i_start = '1' then
			    r_img_proc <= S_READ;
			end if;

		    when S_READ =>
			r_addr_valid <= '1';
			r_img_proc   <= S_READWAIT;
			case i_opcode is

			    when C_MIRROR =>
				r_addr <= std_logic_vector(to_unsigned(to_integer(r_i * c_image_col + (c_image_col - 1 - r_j)), r_addr'length));

			    when C_REVERSE =>
				r_addr <= std_logic_vector(to_unsigned(to_integer((c_image_row - 1 - r_i) * c_image_col + r_j), r_addr'length));

			    when C_NEGATIVE | C_THRESHOLD | C_BRIGHTNESS_UP | C_BRIGHTNESS_DOWN | C_CONTRAST_UP | C_CONTRAST_DOWN =>
				r_addr <= std_logic_vector(to_unsigned(to_integer(r_i * c_image_col + r_j), r_addr'length));

			    when others => null;

			end case;


		    when S_READWAIT =>
			if i_data_valid = '1' then
			    r_data     <= unsigned(i_data);
			    r_img_proc <= S_CALC;
			end if;

		    when S_CALC =>
			r_data_valid <= '1';
			r_img_proc   <= S_CHECKDONE;
			case i_opcode is

			    when C_MIRROR | C_REVERSE =>
				r_data <= r_data;

			    when C_NEGATIVE =>
				r_data <= 255 - r_data;

			    when C_THRESHOLD =>
				if r_data > 128 then
				    r_data <= (others => '1');
				else
				    r_data <= (others => '0');
				end if;

			    when C_BRIGHTNESS_UP =>
				if r_data > 210 then
				    r_data <= (others => '1');
				else
				    r_data <= r_data + 45;
				end if;

			    when C_BRIGHTNESS_DOWN =>
				if r_data < 45 then
				    r_data <= (others => '0');
				else
				    r_data <= r_data - 45;
				end if;

			    when C_CONTRAST_UP =>
				if r_data > 128 then
				    r_data <= (others => '1');
				else
				    r_data <= r_data(6 downto 0) & '0';
				end if;

			    when C_CONTRAST_DOWN =>
				r_data <= '0' & r_data(7 downto 1);

			    when others => null;

			end case;

		    when S_CHECKDONE =>
			if r_j = c_image_col - 1 then
			    r_j		   <= (others => '0');
			    if r_i = c_image_row - 1 then
				r_i	   <= (others => '0');
				r_img_proc <= S_DONE;
			    else
				r_i	   <= r_i + 1;
				r_img_proc <= S_READ;
			    end if;
			else
			    r_j		   <= r_j + 1;
			    r_img_proc	   <= S_READ;
			end if;

		    when S_DONE =>
			r_done	   <= '1';
			r_img_proc <= S_IDLE;

		    when others => null;

		end case;
	    end if;
	end if;
    end process PROC_IMG_PROC;
end architecture rtl;
