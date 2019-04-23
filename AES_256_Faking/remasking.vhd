library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aes_256_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity remasking is
    Port ( clock 			: in  STD_LOGIC;
           reset 			: in  STD_LOGIC;
           en 				: in  STD_LOGIC;
           state_normal : in  STD_LOGIC_VECTOR (127 downto 0);
           state_trans 	: in  STD_LOGIC_VECTOR (127 downto 0);
           result 		: out  STD_LOGIC_VECTOR (127 downto 0)
			  );
end remasking;

architecture Behavioral of remasking is

begin

process(clock)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			result 			<= (others => '0'); -- others => 0 signifie que les 128 bits sont mis à 0.
		else
			if en = '1' then
				result 		<= state_normal XOR state_trans;
			else
				result <= (others => '0');
			end if;
		end if;
	end if;
	end process;	



end Behavioral;

