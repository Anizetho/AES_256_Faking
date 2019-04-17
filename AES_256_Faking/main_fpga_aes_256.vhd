-- Top level Main FPGA with AES-256-CBC and AES-256-CBC
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_UNSIGNED.all;

entity main_fpga_aes_256 is
    port (	clk 		: in std_logic;
			lbus_rdy 	: out std_logic;            			-- MAIN FPGA ready
			lbus_rstn 	: in std_logic;          				-- Local bus(Main FPGA) reset low
			lbus_clk 	: in std_logic;           				-- Local bus clock(1.5MHz)
			lbus_wd 		: in std_logic_vector(7 downto 0);  -- Local bus write data
			lbus_we 		: in std_logic;              			-- Local bus write enable
			lbus_ful		: out std_logic;             			-- Local bus full
			lbus_rd 		: out std_logic_vector(7 downto 0); -- Local bus read data
			lbus_re 		: in std_logic;             			-- Local bus read enable
			lbus_emp 	: out std_logic;             			-- Local bus empty
			trigger 		: out std_logic;
			led 			: out std_logic_vector(9 downto 0));
end main_fpga_aes_256;

architecture behavioral of main_fpga_aes_256 is

component controller_fpga_if
    port ( 	clk 				:  in  std_logic;
			rstn 					: in  std_logic;
			DEVRDY 				: out std_logic;   			-- Device ready
			RRDYn 				: out std_logic;    			-- Read data empty
			WRDYn 				: out std_logic;    			-- Write buffer almost full
			HRE 					: in std_logic;      		-- Host read enable
			HWE 					: in std_logic;      		-- Host write enable
			HDIN 					: in std_logic_vector(7 downto 0);
			HDOUT 				: out std_logic_vector(7 downto 0);
			packet 				: out std_logic_vector(135 downto 0); 
			packet_received 	: out std_logic; 
			done 					: in std_logic;
			out_text : in std_logic_vector (127 downto 0)
			
		);
end component;

component aes_256_encrypt
    port ( 	clk 		: in  std_logic;
			rst 			: in  std_logic;
			start 		: in  std_logic;
			plaintext 	: in std_logic_vector (127 downto 0);
			key 			: in std_logic_vector (255 downto 0);
			key_Mask    : in  std_logic_vector(255 downto 0);
			ciphertext 	: out std_logic_vector (127 downto 0);
			done 			: out std_logic);
end component;

--component clk_2MHz
--    Port (
--        clk_in : in  STD_LOGIC;
--        rst  : in  STD_LOGIC;
--        clk_out: out STD_LOGIC
--    );
--end component;

signal rst 			: std_logic;
signal start 		: std_logic;
signal start_aes 	: std_logic;
signal new_key 	: std_logic;
signal done_aes 	: std_logic;
--signal clk_2 : std_logic;

signal key 			: std_logic_vector(255 downto 0);
signal key_Mask 	: std_logic_vector(255 downto 0);
signal plaintext 	: std_logic_vector(127 downto 0);
signal ciphertext : std_logic_vector(127 downto 0);

signal packet_received 	: std_logic;
signal packet 				: std_logic_vector(135 downto 0);

signal key_ok 	: std_logic;
signal pt_ok 	: std_logic;
signal ct_ok 	: std_logic;

signal trigger_buff 	: std_logic;
signal start_buff 	: std_logic;
signal en3 				: std_logic;
signal en2 				: std_logic;
signal cnt 				: std_logic_vector(4 downto 0);
signal cnt2 			: std_logic_vector(5 downto 0);

begin
	rst <= not(lbus_rstn);
	
--	clk_2MHz_inst : clk_2MHz port map(
--        clk_in => clk,
--        rst => rst,
--        clk_out => clk_2
--			);
	aes_256_encrypt_inst : aes_256_encrypt PORT MAP (
		clk => clk,
		rst => rst,
		start => start,
		plaintext => plaintext,
		key => key,
		key_Mask => key_Mask,
		ciphertext => ciphertext,
		done => done_aes);
	
	controller_fpga_if_instance : controller_fpga_if PORT MAP (
		clk 	=> lbus_clk,
		rstn	=> lbus_rstn,

		DEVRDY 	=> lbus_rdy,
		RRDYn  	=> lbus_emp,
		WRDYn  	=> lbus_ful,
		HRE  	=> lbus_re,
		HWE  	=> lbus_we,
		HDIN  	=> lbus_wd,
		HDOUT  	=> lbus_rd,
		
		packet  => packet,
		packet_received => packet_received,
		done 	=> done_aes,
		out_text  => ciphertext
		
);
		
	rx_process : process(clk)
	begin
	if rising_edge(clk) then
		if lbus_rstn = '0' then
			key <= (others => '0');
			key_Mask <= (others => '0');
			plaintext <= (others => '0');
			start_buff <= '0';
			new_key <= '0';
		else
			start_buff <= '0';
			new_key <= '0';
			if packet_received = '1' then
				if packet(130 downto 128) = "000" then
					key(255 downto 128) <= packet(127 downto 0);
				elsif packet(130 downto 128) = "001" then
					key(127 downto 0) <= packet(127 downto 0);
					new_key <= '1';
				elsif packet(130 downto 128) = "010" then
					key_Mask(255 downto 128) <= packet(127 downto 0);
				elsif packet(130 downto 128) = "011" then
					key_Mask(127 downto 0) <= packet(127 downto 0);
				elsif packet(130 downto 128) = "100" then -- ct or pt
					plaintext <= packet(127 downto 0);
					start_buff <= not(packet(131)) and not(packet(132));
--				elsif packet(130 downto 128) = "100" then -- aad
--					plaintext <= packet(127 downto 0);
				end if;
			end if;
		end if;
	end if;
	end process;
	
	
	process(clk)
	begin
	if rising_edge(clk) then
				if lbus_rstn = '0' then
					cnt <= (others => '0');
					en2 <= '0';
					trigger_buff <= '0';
				else
					if start_buff = '1' or en2 = '1' then
						en2 <= '1';
						cnt <= cnt + '1';
						trigger_buff <= '1';
						if cnt = 10 then
							cnt <= (others => '0');
							en2 <= '0';
							trigger_buff <= '0';
						end if;
					end if;
				end if;
	end if;
	end process;
	
	process(clk)
	begin
	if rising_edge(clk) then
		if lbus_rstn = '0' then
			cnt2 <= (others => '0');
			en3 <= '0';
			start <= '0';
		else
			start <= '0';
			if trigger_buff = '1' or en3 = '1' then
				en3 <= '1';
				cnt2 <= cnt2 + '1';
				if cnt2 = 30 then
					cnt2 <= (others => '0');
					en3 <= '0';
					start <= '1';
				end if;
			end if;
		end if;
	end if;
	end process;
	
	trigger <= trigger_buff;
	
	led_process : process(clk)
	begin
	if rising_edge(clk) then
		if lbus_rstn = '0' then		
			led(9 downto 5) <= (others => '0');
			led(4 downto 0) <= (others => '1');
			key_ok <= '0';
			pt_ok <= '0';
			ct_ok <= '0';
		else
			if key = X"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f" then
				key_ok <= '1';
			else
				key_ok <= '0';
			end if;	
			
			if plaintext = X"00112233445566778899aabbccddeeff" then
				pt_ok <= '1';
			else
				pt_ok <= '0';
			end if;
			
			if ciphertext = X"8ea2b7ca516745bfeafc49904b496089" then
				ct_ok <= '1';
			else
				ct_ok <= '0';
			end if;
			

			led <= key_ok & pt_ok & ct_ok & "0000000";
		end if;
	end if;
	end process;
	
end behavioral;