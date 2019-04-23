library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aes_256_package.all;

entity top_key_scheduler_256 is
    port ( 	clk 					: in  std_logic;
				rst 					: in  std_logic;
				start 				: in  std_logic;
				key_256 				: in  std_logic_vector(255 downto 0);
				key_Mask 			: in  std_logic_vector(255 downto 0);
				keyExpandedReal	: out keyExpandedReal;
				keyExpandedFake 	: out keyExpandedFake;
				done 					: out std_logic);
end top_key_scheduler_256;

architecture behavioral of top_key_scheduler_256 is

component key_scheduler_256
	port(	
			key_256 		: in std_logic_vector(255 downto 0);
			round 		: in std_logic_vector(2 downto 0);
			round_key 	: out std_logic_vector(255 downto 0)
			);
end component;

signal counter 			: std_logic_vector(2 downto 0);
signal round_key_in 		: std_logic_vector(255 downto 0);
signal round_key_out 	: std_logic_vector(255 downto 0);
signal done_key_real		: std_logic;
signal enable_Key_Real	: std_logic;
signal enable_Key_Fake	: std_logic;
signal done_enable		: std_logic;

type state is (IDLE, WORKING);
signal cr_state : state ;

begin

	key_scheduler_256_instance : key_scheduler_256 PORT MAP (
				key_256 => round_key_in,
				round => counter,
				round_key => round_key_out);

	process (clk)
	begin
	if rising_edge(clk) then
		if rst = '1' then
			counter <= (others => '0');
			cr_state <= IDLE;
			done <= '0';
			round_key_in <= (others => '0');
			keyExpandedReal <= (others => (others => '0'));
			keyExpandedFake <= (others => (others => '0'));
			enable_Key_Real <= '0';
			enable_Key_Fake <= '0';
			done_enable <= '0';
			done_key_real <= '0';
		else
		  case 	cr_state is
				when IDLE =>	done <= '0';
									round_key_in <= (others => '0');
									if start = '1' then
										counter <= (others => '0');
										cr_state <= WORKING;
										round_key_in <= key_256 ;
										enable_Key_Real <= '1';
										keyExpandedReal <= (others => (others => '0'));
										keyExpandedReal(conv_integer(0)) <= key_256;
									elsif done_key_real = '1' then
										counter <= (others => '0');
										cr_state <= WORKING;
										round_key_in <= key_256 XOR key_Mask;
										enable_Key_Fake <= '1';
										keyExpandedFake <= (others => (others => '0'));
										keyExpandedFake(conv_integer(0)) <= key_256 XOR key_Mask;
										done_enable <= '1';
									else
										cr_state <= IDLE;
									end if;

				when WORKING =>
									if counter = "110" then  -- Compteur à 6
										cr_state <= IDLE;
										done_Key_real <= '1';
										enable_Key_Real <= '0';
										if done_enable = '1' then
											enable_Key_Fake <= '0';
											done_key_real <= '0';
											done_enable <= '0';
											counter <= (others => '0');
--											cr_state <= MASKING;
--											round_key_real <= keyExpandedReal(conv_integer(0));
--											round_key_fake <= keyExpandedFake(conv_integer(0));
--											maskExpended <= (others => (others => '0'));
--											maskExpended(conv_integer(0)) <= round_key_real XOR round_key_fake;
											done <= '1';
										end if;
									else
										counter <= counter + '1';
									end if;
									if counter < "111" then	-- Compteur < 7
										round_key_in <= round_key_out;
										if enable_Key_Real = '1' then
											keyExpandedReal(conv_integer(counter + '1')) <= round_key_out;
										elsif enable_Key_Fake = '1' then
											keyExpandedFake(conv_integer(counter + '1')) <= round_key_out;
										end if;
									end if;
									
--				when MASKING =>
--									if counter = "110" then  -- Compteur à 6
--										cr_state <= IDLE;
--										done <= '1';
--									else
--										counter <= counter + '1';
--									end if;
--									if counter < "111" then	-- Compteur < 7
--										round_key_real <= keyExpandedReal(conv_integer(counter + '1'));
--										round_key_fake <= keyExpandedFake(conv_integer(counter + '1'));
--										maskExpended(conv_integer(counter + '1')) <= round_key_real XOR round_key_fake;
--									end if;
									
				when others =>	cr_state <= IDLE;
		  end case;
		end if;
	end if;
	end process;

end behavioral;