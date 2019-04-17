--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:47:45 04/02/2019
-- Design Name:   
-- Module Name:   C:/Users/Anizetho/Documents/ISE/AESTest/key_schedule_instance_testbench.vhd
-- Project Name:  AESTest
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: key_scheduler_256
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
 
ENTITY key_schedule_instance_testbench IS
END key_schedule_instance_testbench;
 
ARCHITECTURE behavior OF key_schedule_instance_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT key_scheduler_256
    PORT(
         key_256 		: IN  std_logic_vector(255 downto 0);
         round 		: IN  std_logic_vector(2 downto 0);
         round_key 	: OUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal key_256 : std_logic_vector(255 downto 0) := (others => '0');
   signal key_Mask: std_logic_vector(255 downto 0) := (others => '0');
   signal round 	: std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal round_key : std_logic_vector(255 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: key_scheduler_256 PORT MAP (
          key_256 => key_256,
          round => round,
          round_key => round_key
        );

  

   -- Stimulus process
   stim_proc: process
   begin		
		-- FAKE KEY TEST
		key_Mask <= X"102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f101";
		--key_Mask <= X"0000000000000000000000000000000000000000000000000000000000000000";
		key_256 <= X"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
		round <= "000";
		wait for 20 ns;
		key_256 <= round_key;
		round <= "001";
      wait for 20 ns;
		key_256 <= round_key;
		round <= "010";
      wait for 20 ns;
		key_256 <= round_key;
		round <= "011";
      wait for 20 ns;
		key_256 <= X"0bdc905fc27b0948ad5245a4c1871c2f45f5a66017b2d387300d4d33640a820a";
		round <= "100";
      wait for 20 ns;
		key_256 <= X"7ccff71cbeb4fe5413e6bbf0d261a7dff01afafee7a82979d7a5644ab3afe640";
		round <= "101";
      wait for 20 ns;
		key_256 <= X"2541fe719bf500258813bbd55a721c0a4e5a6699a9f24fe07e572baacdf8cdea";
		round <= "110";
		wait for 20 ns;
      
		-- REAL KEY TEST
		wait for 20 ns;
		key_256 <= X"a573c29fa176c498a97fce93a572c09c1651a8cd0244beda1a5da4c10640bade";
		round <= "001";
      wait for 20 ns;
		key_256 <= X"ae87dff00ff11b68a68ed5fb03fc15676de1f1486fa54f9275f8eb5373b8518d";
		round <= "010";
      wait for 20 ns;
		key_256 <= X"c656827fc9a799176f294cec6cd5598b3de23a75524775e727bf9eb45407cf39";
		round <= "011";
      wait for 20 ns;
		key_256 <= X"0bdc905fc27b0948ad5245a4c1871c2f45f5a66017b2d387300d4d33640a820a";
		round <= "100";
      wait for 20 ns;
		key_256 <= X"7ccff71cbeb4fe5413e6bbf0d261a7dff01afafee7a82979d7a5644ab3afe640";
		round <= "101";
      wait for 20 ns;
		key_256 <= X"2541fe719bf500258813bbd55a721c0a4e5a6699a9f24fe07e572baacdf8cdea";
		round <= "110";
		wait for 20 ns;
		-- Au-desus de 6 ("110") le programme ne fonctionne plus (en effet, voir code).
      wait;
   end process;

END;
