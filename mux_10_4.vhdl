--
-- 10-bit input
-- 4 way mux 
--
library ieee;
use ieee.std_logic_1164.all;

--
-- entity section
--
entity mux10_4 is
   port(
      A,L,C,K		: in std_logic_vector(9 downto 0); 	-- 4 10-bit inputs
      M		  	 	: out std_logic_vector(9 downto 0); -- 1 10-bit output
      N		  	 	: out std_logic_vector(9 downto 0); -- 1 10-bit output
      KEY1, KEY0	: in std_logic                  		-- selectors (2-bit)
   );
end mux10_4;

--
-- architecture section
--
architecture cond_arch of mux10_4 is
begin
   M <= A when (KEY1 = '0' and KEY0 = '0') else
        L when (KEY1 = '0' and KEY0 = '1') else
        C when (KEY1 = '1' and KEY0 = '0') else
        K;
		  
	N <= A when (KEY1 = '0' and KEY0 = '0') else
        L when (KEY1 = '0' and KEY0 = '1') else
        C when (KEY1 = '1' and KEY0 = '0') else
        K;
end cond_arch;