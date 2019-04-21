library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity add_round_key IS
    port( 	
			clock 			: in  STD_LOGIC;
			reset 			: in  STD_LOGIC;
			en 				: in  STD_LOGIC;
			en_fake_key		: in  STD_LOGIC;
			en_real_key		: in  STD_LOGIC;
			state 			: in  STD_LOGIC_VECTOR (127 downto 0);
			round_key 		: in  STD_LOGIC_VECTOR (127 downto 0);
			round_key_real : in  STD_LOGIC_VECTOR (127 downto 0);
			maskExpended 	: out STD_LOGIC_VECTOR (127 downto 0);
			result 			: out STD_LOGIC_VECTOR (127 downto 0)
			);
end add_round_key;

architecture behavioral of add_round_key is

begin

	process(clock)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			result 			<= (others => '0'); -- others => 0 signifie que les 128 bits sont mis à 0.
			maskExpended 	<= (others => '0'); -- others => 0 signifie que les 128 bits sont mis à 0.
		else
			if en = '1' then
				if en_fake_key = '1' then
					result 			<= state XOR round_key;
					maskExpended 	<= round_key XOR round_key_real;
				elsif en_real_key = '1' then
					result 			<= state XOR round_key_real;
					maskExpended 	<= round_key XOR round_key_real;
				end if;
				-- result 			<= state XOR round_key;
				-- maskExpended 	<= round_key XOR round_key_real;
			else
				result <= (others => '0');
			end if;
		end if;
	end if;
	end process;	

end behavioral;