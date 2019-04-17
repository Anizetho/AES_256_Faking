--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:06:03 04/02/2019
-- Design Name:   
-- Module Name:   C:/Users/Anizetho/Documents/ISE/AES_256/aes_256_encrypt_testbench.vhd
-- Project Name:  AES_256
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: aes_256_encrypt
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY aes_256_encrypt_testbench IS
END aes_256_encrypt_testbench;
 
ARCHITECTURE behavior OF aes_256_encrypt_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT aes_256_encrypt
    PORT(
         clk 			: IN  std_logic;
         rst 			: IN  std_logic;
         start 		: IN  std_logic;
         plaintext 	: IN  std_logic_vector(127 downto 0);
         key 			: IN  std_logic_vector(255 downto 0);
			key_Mask 	: IN  std_logic_vector(255 downto 0);
         ciphertext 	: OUT  std_logic_vector(127 downto 0);
         done 			: OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal start : std_logic := '0';
   signal plaintext : std_logic_vector(127 downto 0) := (others => '0');
   signal key : std_logic_vector(255 downto 0) := (others => '0');
   signal key_Mask : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal ciphertext : std_logic_vector(127 downto 0);
   signal done : std_logic;

	-- Others
	signal key_256 : std_logic := '0';
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: aes_256_encrypt PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          plaintext => plaintext,
          key => key,
			 key_Mask => key_Mask,
          ciphertext => ciphertext,
          done => done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '0';
      wait for 100 ns;
		rst <= '1';
		plaintext <= X"00112233445566778899aabbccddeeff";
		key_Mask <= X"102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F101";
		key <= X"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
		start <= '0';
      wait for 50 ns;
		rst <= '0';
		start <= '1';
		wait for clk_period;
		start <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
