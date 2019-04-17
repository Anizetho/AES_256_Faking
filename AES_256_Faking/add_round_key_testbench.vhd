--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:20:48 04/02/2019
-- Design Name:   
-- Module Name:   C:/Users/Anizetho/Documents/ISE/AESTest/add_round_key_testbench.vhd
-- Project Name:  AESTest
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: add_round_key
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
 
ENTITY add_round_key_testbench IS
END add_round_key_testbench;
 
ARCHITECTURE behavior OF add_round_key_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT add_round_key
    PORT(
         clock 		: IN  std_logic;
         reset 		: IN  std_logic;
         en 			: IN  std_logic;
         state 		: IN  std_logic_vector(127 downto 0);
         round_key 	: IN  std_logic_vector(127 downto 0);
         result 		: OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock 		: std_logic := '0';
   signal reset 		: std_logic := '0';
   signal en 			: std_logic := '0';
   signal state 		: std_logic_vector(127 downto 0) := (others => '0');
   signal round_key 	: std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: add_round_key PORT MAP (
          clock => clock,
          reset => reset,
          en => en,
          state => state,
          round_key => round_key,
          result => result
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		en <= '1';
		state <= X"00112233445566778899aabbccddeeff";
		round_key <= X"000102030405060708090a0b0c0d0e0f"; 
		reset <= '1';
      wait for 100 ns;
		reset <= '0';
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
