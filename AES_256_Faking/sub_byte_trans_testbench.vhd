--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:35:31 04/21/2019
-- Design Name:   
-- Module Name:   C:/Users/Anizetho/Documents/ISE/AES_256_Faking/sub_byte_trans_testbench.vhd
-- Project Name:  AES_256_Faking
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sub_byte_trans
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;
use work.aes_256_package.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY sub_byte_trans_testbench IS
END sub_byte_trans_testbench;
 
ARCHITECTURE behavior OF sub_byte_trans_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sub_byte_trans
    PORT(
         clock 				: IN  std_logic;
         reset 				: IN  std_logic;
         en 					: IN  std_logic;
         state 				: IN  STD_LOGIC_VECTOR (127 downto 0);
         round_mask 			: IN  STD_LOGIC_VECTOR (127 downto 0);
         result 				: OUT STD_LOGIC_VECTOR (127 downto 0);
			doneSubByteTrans 	: OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock 		: std_logic := '0';
   signal reset 		: std_logic := '0';
   signal en 			: std_logic := '0';
   signal state 		: std_logic_vector(127 downto 0) := (others => '0');
   signal round_mask : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal result 					: std_logic_vector(127 downto 0) := (others => '0');
   signal doneSubByteTrans 	: std_logic := '0';
	
   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sub_byte_trans PORT MAP (
          clock => clock,
          reset => reset,
          en => en,
          state => state,
          round_mask => round_mask,
          result => result, 
			 doneSubByteTrans => doneSubByteTrans
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
		reset <= '1';
		en <= '0';
		
		wait for clock_period*3;
		
		reset <= '0';
		en <= '1';
		--state <= X"00102030405060708090a0b0c0d0e0f0";
		state <= X"10301070103010F010301070103011F1";
		round_mask <= X"102030405060708090A0B0C0D0E0F101";
		
      wait for clock_period*5;
		
		en <= '0';
		
      wait for clock_period*1;

		en <= '1';
		state <= X"10301070103010F010301070103011F1";
		round_mask <= X"102030405060708090A0B0C0D0E0F101";
      wait for clock_period*5;
      wait;
   end process;

END;
