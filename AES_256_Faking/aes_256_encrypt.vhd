library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

library work;
use work.aes_256_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes_256_encrypt is

port ( 	
		clk 			: in  std_logic;
		rst 			: in  std_logic;
		start 		: in  std_logic;
		plaintext 	: in  std_logic_vector(127 downto 0);
		key	 		: in  std_logic_vector(255 downto 0);
		key_Mask 	: in  std_logic_vector(255 downto 0);
		ciphertext 	: out std_logic_vector(127 downto 0);
		done 			: out std_logic
			);
end aes_256_encrypt;

architecture Behavioral of aes_256_encrypt is

component top_key_scheduler_256
    port ( 	
			clk 					: in  std_logic;
			rst 					: in  std_logic;
			start 				: in  std_logic;
			key_256 				: in  std_logic_vector(255 downto 0);
			key_Mask    		: in  std_logic_vector(255 downto 0);
			keyExpandedReal 	: out keyExpandedReal;
			keyExpandedFake 	: out keyExpandedFake;
			done 					: out std_logic);
end component top_key_scheduler_256;

component add_round_key
	port(
		clock 				: in  std_logic;
		reset 				: in  std_logic;
		en 					: in  std_logic;
		en_fake_key			: in  STD_LOGIC;
		en_real_key			: in  STD_LOGIC;
		state 				: in  std_logic_vector(127 downto 0);
		round_key 			: in  std_logic_vector(127 downto 0);		
		round_key_real 	: in  std_logic_vector(127 downto 0);
		maskExpended 		: out STD_LOGIC_VECTOR(127 downto 0);		
		result 				: out std_logic_vector(127 downto 0));
end component;

component sub_byte
	port(
		clock 	: in  std_logic;
		reset 	: in  std_logic;
		en 		: in  std_logic;
		state 	: in  std_logic_vector(127 downto 0);          
		result 	: out std_logic_vector(127 downto 0));
end component;

component sub_byte_trans
	port(
		clock 				: in  STD_LOGIC;
      reset 				: in  STD_LOGIC;
      en 					: in  STD_LOGIC;
      state 				: in  STD_LOGIC_VECTOR (127 downto 0);
      round_mask 			: in  STD_LOGIC_VECTOR (127 downto 0);
      result 				: out STD_LOGIC_VECTOR (127 downto 0);
		doneSubByteTrans	: out STD_LOGIC);
end component;

component shift_rows
	port(
		clock 	: in std_logic;
		reset 	: in std_logic;
		en 		: in std_logic;
		state 	: in std_logic_vector(127 downto 0);          
		result 	: out std_logic_vector(127 downto 0));
end component;

component mix_column
	port(
		clock 	: in  std_logic;
		reset 	: in  std_logic;
		en 		: in  std_logic;
		state 	: in  std_logic_vector(127 downto 0);          
		result 	: out std_logic_vector(127 downto 0));
end component;

type state is (IDLE, STORE_RK, MROUNDS, LROUND);
signal cstate              	: state;

signal ark_in 		        		: std_logic_vector(127 downto 0);	-- Entrée module addrounkey
signal ark_sbox 	        		: std_logic_vector(127 downto 0);	-- Sortie module addroundkey / entrée module Sbox
signal sbox_shift          	: std_logic_vector(127 downto 0);	-- Sorite module Sbox / Entrée module Shiftrows
signal shift_mix 	        		: std_logic_vector(127 downto 0);	-- Sortie module Shiftrows / Entrée module Mix
signal mix_out 	         	: std_logic_vector(127 downto 0);	-- Sortie module Mix / Entrée pour addroundkey

signal sboxtrans_shifttrans	: std_logic_vector(127 downto 0);	-- Sortie module Mix / Entrée pour addroundkey
signal shifttrans_mixtrans		: std_logic_vector(127 downto 0);	-- Sortie module Mix / Entrée pour addroundkey
signal mixtrans_out				: std_logic_vector(127 downto 0);	-- Sortie module Mix / Entrée pour addroundkey

signal count_round 	      	: std_logic_vector(3 downto 0);		-- Permet de choisir les 16 premiers/derniers bytes de la clé.
signal count_op 	        		: std_logic_vector(1 downto 0);		-- Compte le nombre d'opérations ?
signal sel_ark_in 	      	: std_logic_vector(1 downto 0);		-- Permet de séléctionner pltxt/sortie Mix/sortie shift comme entrée de addroundkey.

signal round_key 	        		: std_logic_vector(127 downto 0);	-- Fausse Clé pour un round en particulier
signal round_key_real     		: std_logic_vector(127 downto 0);	-- Vraie Clé pour un round en particulier
signal round_key_mask     		: std_logic_vector(127 downto 0);	-- Masque pour un round en particulier

signal en_block 		    		: std_logic_vector(3 downto 0);		-- Pour activer/désactiver les sous-modules (les 4 opérations).
signal en_real_key 		   	: STD_LOGIC;								-- Pour activer la fausse clé pour l'addroundkey.
signal en_fake_key 		   	: STD_LOGIC;								-- Pour activer la vraie clé pour l'addroundkey.

signal done_schedule 	   	: std_logic;								-- Permet de dire si l'exécution de l'opération keyschedule est terminée.
signal alm_done_schedule   	: std_logic;								-- Sert à rien ?
signal keyExpandedReal	  		: keyExpandedReal;
signal keyExpandedFake	  		: keyExpandedFake;

signal doneSubByteTrans			: std_logic;
--signal en_test						: std_logic;

begin

	add_round_key_instance : add_round_key port map(
			clock => clk,
			reset => rst,
			en => en_block(3),	-- 3 => "1000"
			en_fake_key => en_fake_key,
			en_real_key => en_real_key,
			round_key => round_key,
			round_key_real => round_key_real,
			maskExpended => round_key_mask,
			state => ark_in,			
			result => ark_sbox);
			
	sub_byte_instance : sub_byte port map (
			clock => clk,
			reset => rst,
			en => en_block(2),	-- 2 => "0100"
			state =>  ark_sbox,
			result => sbox_shift);
			
	sub_byte_trans_instance : sub_byte_trans port map (
			clock => clk,
			reset => rst,
			en => en_block(2),	-- 2 => "0100"
			--en => en_test,	-- 2 => "0100"
			state =>  ark_sbox,
			round_mask => round_key_mask,			
			result => sboxtrans_shifttrans,
			doneSubByteTrans => doneSubByteTrans);

	shift_rows_instance : shift_rows port map (
			clock => clk,
			reset => rst,
			en => en_block(1),	-- 1 => "0010"
			state => sbox_shift,      
			result => shift_mix);
			
	shift_rows_trans_instance : shift_rows port map (
			clock => clk,
			reset => rst,
			en => en_block(1),	-- 1 => "0010"
			state => sboxtrans_shifttrans,      
			result => shifttrans_mixtrans);
			
	mix_column_instance : mix_column port map (
			clock => clk,
			reset => rst,
			en => en_block(0),	-- 0 => "0001"
			state => shift_mix,     
			result => mix_out);
			
	mix_column_trans_instance : mix_column port map (
			clock => clk,
			reset => rst,
			en => en_block(0),	-- 0 => "0001"
			state => shifttrans_mixtrans,     
			result => mixtrans_out);
			
	top_key_scheduler_256_instance : top_key_scheduler_256 port map (
		clk => clk,
		rst => rst,
		start => start,
		key_256 =>  key,
		key_Mask => key_Mask,
		keyExpandedReal => keyExpandedReal,
		keyExpandedFake => keyExpandedFake,
		done => done_schedule);

	
	with 	count_round(0) select
		round_key <= 	keyExpandedFake(conv_integer(count_round(3 downto 1)))(255 downto 128) when '0',
							keyExpandedFake(conv_integer(count_round(3 downto 1)))(127 downto 0) when '1',
							(others => '0') when others;
							
	with 	count_round(0) select
		round_key_real <= 	keyExpandedReal(conv_integer(count_round(3 downto 1)))(255 downto 128) when '0',
							keyExpandedReal(conv_integer(count_round(3 downto 1)))(127 downto 0) when '1',
							(others => '0') when others;
	
	with 	sel_ark_in select
			ark_in <= 	plaintext 			when "00",
							mix_out 				when "01",
							shift_mix 			when "10",
							(others => '0') 	when others;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				cstate 		<= IDLE;
				ciphertext  <= (others => '0');
				count_round <= (others => '0');
				count_op 	<= (others => '1');
				done 			<= '0';
				en_block 	<= (others => '0');
				sel_ark_in  <= (others => '0');
				en_real_key <= '0';
				en_fake_key <= '0';
			else
				case cstate is
					-- Idle : rien ne se passe ! Quand start passe à 1 : Idle passe à store_rk
					when 			IDLE 	=> 	cstate <= IDLE;
													done <= '0';
													sel_ark_in <= (others => '0');
													if start = '1' then
														cstate <= STORE_RK;
													-- elsif start = '1' then
														-- cstate <= MROUNDS;
														-- en_block <= "1000";														
													end if;													
					
					-- Store_rk : attend que l'opération key_schedule se termine. Dès que OK, done_schedule passe à 1 et on passe donc à Mrounds.							
					when 		STORE_RK => cstate <= STORE_RK;
												if done_schedule = '1' then
													cstate <= MROUNDS;
													en_real_key <= '0';
													en_fake_key <= '1';
													en_block <= "1000";
												end if;		
					
					-- Mrounds : exécute les 13 rounds de l'AES-256. Dès que fini, on passe à Lround.
					when 		MROUNDS 	=>		cstate <= MROUNDS;
													-- Si on a activé mixcolumn avant, on active addroundkey mtn.
													if en_block(0) = '1' then
														en_block <= "1000";
													-- On passe de 1000 à 0100 à 0010 à 0001.
													elsif en_block(2) = '1' then
														if doneSubByteTrans = '1' then
															en_block <= '0' & en_block(3 downto 1);
														end if;
													else
														en_block <= '0' & en_block(3 downto 1);
													end if;
													-- iter the count_op
													if en_block(2) = '1' then
														if doneSubByteTrans = '1' then
															count_op <= "01";
														else 
															count_op <= count_op + 1;
														end if;
													else
														count_op <= count_op + 1;
														sel_ark_in <= "01";
													end if;
													-- Dès qu'on a exécuté les 4 opérations, on remet count_op à 0 (pour les recommencer).
													if count_op = 3 then
														count_op 	<= (others => '0');
														count_round <= count_round + 1;
														if count_round = 13 then
															sel_ark_in <= "10";
															cstate <= LROUND;
														end if;
													end if;	
													
					-- Lround : exécute les 3 dernières opérations de l'AES-256.								
					when 	LROUND 	=>			count_op <= count_op + 1;
													if en_block(1) = '1' then
														en_block <= "1000";
													else
														en_block <= '0' & en_block(3 downto 1);
													end if;
													if count_op = 3 then
														ciphertext <= ark_sbox;
														count_round <= (others => '0');
														count_op <= (others => '1');
														cstate <= IDLE;
														done <= '1';
														sel_ark_in <= (others => '0');
													else
														en_real_key <= '1';
														en_fake_key <= '0';
													end if;
					when others =>				cstate <= IDLE;
				end case;
			end if;
		end if;
	end process;


end Behavioral;

