--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:12:32 04/03/2019
-- Design Name:   
-- Module Name:   C:/Users/Anizetho/Documents/ISE/AES-256/shift_rows_testbench.vhd
-- Project Name:  AES-256
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_rows
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
 
ENTITY shift_rows_testbench IS
END shift_rows_testbench;
 
ARCHITECTURE behavior OF shift_rows_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shift_rows
    PORT(
         clock 	: IN  std_logic;
         reset 	: IN  std_logic;
         en 		: IN  std_logic;
         state 	: IN  std_logic_vector(127 downto 0);
         result 	: OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock 	: std_logic := '0';
   signal reset 	: std_logic := '0';
   signal en 		: std_logic := '0';
   signal state 	: std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shift_rows PORT MAP (
          clock => clock,
          reset => reset,
          en => en,
          state => state,
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
		reset <= '1';
		en <= '0';
		wait for 50 ns;
		reset <= '0';
		en <= '1';
		state <= X"63cab7040953d051cd60e0e7ba70e18c";
      wait for 100 ns;	

      wait for clock_period*10;

      wait;
   end process;

END;
