--------------------------------------------------------------
-- program to implement the overall 4 bit computer based on
-- unit entities defined for logic, arithmetic, comparison, magic
-- to run on DE10 Lite Board
--
-- inputs
-- Key0, Key1 (push buttons) to choose one of the main function  - std_logic;
-- SW9,SW8 (to choose the operation in the individual function) - std_logic;
-- SW7,6,5,4 (4 bit input number1) - std_logic_vector
-- SW3,2,1,0 (4 bit input number2) - std_logic_vector
-- Max10_CLK1_50 - onboard 50MHz clock for magic 
--
-- outputs
-- Hex0, Hex1 - two seven segment displays - std_logic_vector(6 downto 0)
-- LEDR9,8,...0 - Ten output leds - 
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

--
-- define top level entity
--
entity computer_4bit is 
	port (
		key0, key1 : in std_logic;
		number1	  : in std_logic_vector (3 Downto 0);  -- SW 3,2,1,0
		number2	  : in std_logic_vector (3 Downto 0);  -- SW 7,6,5,4
		SW9, SW8   : in STD_LOGIC;
		clock50 	  : in std_logic;
		number_out : out std_logic_vector (9 downto 0);
		-- led9, led8, led7, led6, led5 : out STD_LOGIC;
      -- led4, led3, led2, led1, led0 : out STD_LOGIC;
		hex0 		  : out std_logic_vector (6 Downto 0);    -- 7 segment display
		hex1 		  : out std_logic_vector (6 Downto 0)     -- 7 segment display
	);
end computer_4bit;

--
-- architecture section
--
architecture behaviour of computer_4bit is
	--
	-- add signals here
	--
	signal A, C, L, K : STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal Output     : std_logic_vector (9 downto 0);
	
	--
	-- add components here
	--
	-- arithmetic 
	component arithmetic is
		port(
			number1  : in std_logic_vector(3 downto 0);
			number2  : in std_logic_vector(3 downto 0);
			SW9, SW8 : in std_logic;
			A		   : out std_logic_vector(9 downto 0) 
		);
	end component;

	-- logical
	component logical is
		port(
			number1  :  IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			number2  :  IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			SW8, SW9 :  IN STD_LOGIC;
			L   	   :  OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
      );
	end component;

	-- comparison4bit
	component comparison4bit is
		port (
			-- define inputs and outputs
			number1 	: IN std_logic_vector(3 downto 0);  -- sw 3,2,1,0
			number2 	: IN std_logic_vector(3 downto 0);  -- sw 7,6,5,4
			SW8, SW9 : IN std_logic;
			C 			: OUT std_logic_vector(9 downto 0)
		);
	end component;

	-- magic2clk
	component magic2clk is
		Port ( 
           refclk : in  std_logic;
           K 		: out std_logic_vector (9 downto 0)
		);
	end component;

	-- hexToSevenSegment
	component hexToSevenSegment is
		port(
			hexNumber 												 : in std_logic_vector(3 downto 0);
			sevenSegmentActiveLow, sevenSegmentActiveHigh : out std_logic_vector(6 downto 0)
		);
	end component;

	-- mux10_4
	component mux10_4 is
		port(
			A,L,C,K		: in std_logic_vector(9 downto 0); 	-- 4 10-bit inputs
			M		  	 	: out std_logic_vector(9 downto 0); -- 10-bit output
			N		  	 	: out std_logic_vector(9 downto 0); -- 1 10-bit output
			KEY1, KEY0	: in std_logic                  		-- selectors (2-bit)
		);
	end component;

begin
	-- can use components here with map command
	-- maps signals/ports in component to signals/ports in this program
	
	-- arithmetic
	arith: entity work.arithmetic port map ( 
		number1 => number1, 
		number2 => number2,  
		SW9 => SW9, 
		SW8 => SW8, 
		A => A
	);
	
	-- logical
	logic: entity work.logical port map ( 
		number1 => number1, 
		number2 => number2,  
		SW9 => SW9, 
		SW8 => SW8, 
		L => L
	);
		
	-- comparison
	compa: entity work.comparison4bit port map ( 
		number1 => number1, 
		number2 => number2,  
		SW9 => SW9, 
		SW8 => SW8, 
		C => C
	);   
		
	-- magic
	magic: entity work.magic2clk port map (
		refclk => clock50,
		K => K
	);   
	
	-- multiplexor
	mux10: entity work.mux10_4 port map (
		A => A,
		L => L,
		C => C,
		K => K,
		KEY1 => KEY1,
		KEY0 => KEY0,
		M => number_out,
		N => Output
	);
		
	-- hex digits - map to the two input 4 bit numbers
	hex71: entity work.hexToSevenSegment port map (
		hexNumber => Output(7 downto 4),
		sevenSegmentActiveLow => hex1	
	);
	
	hex70: entity work.hexToSevenSegment port map (
		hexNumber => Output(3 downto 0),
		sevenSegmentActiveLow => hex0	
	);

end behaviour;
