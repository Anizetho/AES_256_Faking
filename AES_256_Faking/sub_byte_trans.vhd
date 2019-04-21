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

entity sub_byte_trans is
    Port ( clock 			: in  STD_LOGIC;
           reset 			: in  STD_LOGIC;
           en 				: in  STD_LOGIC;
           state 			: in  STD_LOGIC_VECTOR (127 downto 0);
           round_mask 	: in  STD_LOGIC_VECTOR (127 downto 0);
           result 		: out STD_LOGIC_VECTOR (127 downto 0));
end sub_byte_trans;

architecture Behavioral of sub_byte_trans is

signal sboxtrans_table   : std_logic_vector(127 downto 0);	-- Masque pour un round en particulier
--type ARRAY_256 is ARRAY (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
constant test : std_logic_vector(7 downto 0) := "00000001";


begin

	process(clock)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			result <= (others => '0');
		else
			if en = '1' then
				--for j in 0 to 255 loop
					--result(conv_integer(j)) <= sbox(conv_integer(j)) xor sbox(conv_integer(j) xor conv_integer(round_mask(127 downto 120)));
				--end loop;
				result(127 downto 120) 	<= sbox(conv_integer(round_mask(127 downto 120))) ;
				result(119 downto 112) 	<= sbox(conv_integer(round_mask(127 downto 120))) ; --xor conv_integer(round_mask(127 downto 120)));
				result(111 downto 104)	<= sbox(conv_integer(state(111 downto 104)));
				result(103 downto 96) 	<= sbox(conv_integer(state(103 downto 96)));
				result(95 downto 88) 	<= sbox(conv_integer(state(95 downto 88)));
				result(87 downto 80) 	<= sbox(conv_integer(state(87 downto 80)));
				result(79 downto 72) 	<= sbox(conv_integer(state(79 downto 72)));
				result(71 downto 64) 	<= sbox(conv_integer(state(71 downto 64)));
				result(63 downto 56) 	<= sbox(conv_integer(state(63 downto 56)));
				result(55 downto 48) 	<= sbox(conv_integer(state(55 downto 48)));
				result(47 downto 40) 	<= sbox(conv_integer(state(47 downto 40)));
				result(39 downto 32) 	<= sbox(conv_integer(state(39 downto 32)));
				result(31 downto 24) 	<= sbox(conv_integer(state(31 downto 24)));
				result(23 downto 16) 	<= sbox(conv_integer(state(23 downto 16)));
				result(15 downto 8) 		<= sbox(conv_integer(state(15 downto 8)));
				result(7 downto 0) 		<= sbox(conv_integer(state(7 downto 0)));
			else
				result <= (others => '0');
			end if;
		end if;
	end if;
	end process;

end Behavioral;

