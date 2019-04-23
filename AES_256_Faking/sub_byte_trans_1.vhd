----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:44:33 04/23/2019 
-- Design Name: 
-- Module Name:    sub_byte_trans_1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sub_byte_trans_1 is
    Port ( clock 			: in  STD_LOGIC;
           reset 			: in  STD_LOGIC;
           enable 		: in  STD_LOGIC;
           round_mask 	: in  STD_LOGIC_VECTOR (127 downto 0);
			  state 			: in  STD_LOGIC_VECTOR (127 downto 0);
           result 		: out  STD_LOGIC_VECTOR (127 downto 0)
			  );
end sub_byte_trans_1;

architecture Behavioral of sub_byte_trans_1 is

type ARRAY_256 is ARRAY (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
signal sboxtrans_table_1   : ARRAY_256;
signal sboxtrans_table_2   : ARRAY_256;
signal sboxtrans_table_3   : ARRAY_256;
signal sboxtrans_table_4   : ARRAY_256;
signal sboxtrans_table_5   : ARRAY_256;
signal sboxtrans_table_6   : ARRAY_256;
signal sboxtrans_table_7  	: ARRAY_256;
signal sboxtrans_table_8   : ARRAY_256;
signal sboxtrans_table_9   : ARRAY_256;
signal sboxtrans_table_10  : ARRAY_256;
signal sboxtrans_table_11  : ARRAY_256;
signal sboxtrans_table_12  : ARRAY_256;
signal sboxtrans_table_13  : ARRAY_256;
signal sboxtrans_table_14  : ARRAY_256;
signal sboxtrans_table_15  : ARRAY_256;
signal sboxtrans_table_16  : ARRAY_256;
signal loopround 				: std_logic;


begin

	process(clock)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			result <= (others => '0');
		else
			if en = '1' then
				for j in 0 to 255 loop
					sboxtrans_table_1(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(127 downto 120) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_2(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(119 downto 112) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_3(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(111 downto 104) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_4(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(103 downto 96) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_5(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(95 downto 88) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_6(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(87 downto 80) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_7(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(79 downto 72) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_8(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(71 downto 64) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_9(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(63 downto 56) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_10(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(55 downto 48) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_11(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(47 downto 40) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_12(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(39 downto 32) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_13(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(31 downto 24) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_14(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(23 downto 16) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_15(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(15 downto 8) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
				for j in 0 to 255 loop
					sboxtrans_table_16(j) 	<= sbox(conv_integer(j)) xor sbox(conv_integer(round_mask(7 downto 0) xor conv_std_logic_vector(j, 8))); -- conv_integer convert the arg argument to an integer.
				end loop;
					
					result(127 downto 120)	<= sboxtrans_table_1(conv_integer(state(127 downto 120)));
					result(119 downto 112)	<= sboxtrans_table_2(conv_integer(state(119 downto 112)));
					result(111 downto 104)	<= sboxtrans_table_3(conv_integer(state(111 downto 104)));
					result(103 downto 96)	<= sboxtrans_table_4(conv_integer(state(103 downto 96)));
					result(95 downto 88) 	<= sboxtrans_table_5(conv_integer(state(95 downto 88)));
					result(87 downto 80) 	<= sboxtrans_table_6(conv_integer(state(87 downto 80)));
					result(79 downto 72) 	<= sboxtrans_table_7(conv_integer(state(79 downto 72)));
					result(71 downto 64) 	<= sboxtrans_table_8(conv_integer(state(71 downto 64)));
					result(63 downto 56) 	<= sboxtrans_table_9(conv_integer(state(63 downto 56)));
					result(55 downto 48) 	<= sboxtrans_table_10(conv_integer(state(55 downto 48)));
					result(47 downto 40) 	<= sboxtrans_table_11(conv_integer(state(47 downto 40)));
					result(39 downto 32) 	<= sboxtrans_table_12(conv_integer(state(39 downto 32)));
					result(31 downto 24) 	<= sboxtrans_table_13(conv_integer(state(31 downto 24)));
					result(23 downto 16) 	<= sboxtrans_table_14(conv_integer(state(23 downto 16)));
					result(15 downto 8) 		<= sboxtrans_table_15(conv_integer(state(15 downto 8)));
					result(7 downto 0) 		<= sboxtrans_table_16(conv_integer(state(7 downto 0)));
			else
				result 				<= (others => '0');
				doneSubByteTrans	<= '0';
			end if;
		end if;
	end if;
	end process;


end Behavioral;

