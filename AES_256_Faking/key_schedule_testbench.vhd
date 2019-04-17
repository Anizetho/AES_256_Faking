--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:34:59 04/02/2019
-- Design Name:   
-- Module Name:   C:/Users/Anizetho/Documents/ISE/AESTest/key_schedule_testbench.vhd
-- Project Name:  AESTest
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_key_scheduler_256
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
 
ENTITY key_schedule_testbench IS
END key_schedule_testbench;
 
ARCHITECTURE behavior OF key_schedule_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_key_scheduler_256
    PORT(
         clk 				: IN  std_logic;
         rst 				: IN  std_logic;
         start 			: IN  std_logic;
         key_256 			: IN  std_logic_vector(255 downto 0);
			key_Mask 		: IN  std_logic_vector(255 downto 0);
         keyExpanded 	: OUT  std_logic_vector(0 to 7);
         done 				: OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk 		: std_logic := '0';
   signal rst 		: std_logic := '0';
   signal start 	: std_logic := '0';
   signal key_256 : std_logic_vector(255 downto 0) := (others => '0');
	constant key_Mask : std_logic_vector(255 downto 0) := X"020406080A0C0E10121416181A1C1E20222426282A2C2E30323436383A3C3E40";

 	--Outputs
   signal keyExpanded 	: std_logic_vector(0 to 7);
   signal done 			: std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_key_scheduler_256 PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          key_256 => key_256,
			 key_Mask => key_Mask,
          keyExpanded => keyExpanded,
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
		rst <= '1';
		start <= '0';
		key_256 <= X"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
      wait for 100 ns;
		rst <= '0';
      wait for clk_period*10;
      wait;
   end process;

END;
