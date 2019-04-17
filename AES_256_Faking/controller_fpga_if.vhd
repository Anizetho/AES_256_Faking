library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity controller_fpga_if is
    port ( 	clk :  in  std_logic;
			rstn : in  std_logic;

			DEVRDY : out std_logic;   							-- Device ready
			RRDYn : out std_logic;    							-- Read data empty
			WRDYn : out std_logic;    							-- Write buffer almost full
			HRE : in std_logic;      							-- Host read enable
			HWE : in std_logic;      							-- Host write enable
			HDIN : in std_logic_vector(7 downto 0);     		-- Host data input
			HDOUT : out std_logic_vector(7 downto 0);    		-- Host data output
			packet : out std_logic_vector(135 downto 0);
			packet_received : out std_logic;
			done : in std_logic;
			out_text : in std_logic_vector (127 downto 0)

		);
end controller_fpga_if;

architecture behavioral of controller_fpga_if is

type state is (IDLE, READ1, S_START, S_WAIT, PROCESSING, WRITE1); 
signal cr_state, cw_state : state ;

signal index_write : STD_LOGIC_VECTOR(4 downto 0);
signal index_read : STD_LOGIC_VECTOR(3 downto 0);
--signal cnt : STD_LOGIC_VECTOR(4 downto 0);

signal HWE_delayed : std_logic;
signal HRE_delayed : std_logic;

signal empty : std_logic;
signal packet_received_in : std_logic;
signal header : std_logic_vector(7 downto 0);

begin 
	DEVRDY <= '1';
	
	process(clk)
	begin
	if rising_edge(clk) then
		if rstn = '0' then
			index_write <= (others => '0');
			HWE_delayed <= '0';
			packet <= (others => '0');
			packet_received_in <= '0';
		else
			packet_received_in <= '0';
			HWE_delayed <= HWE;
			if HWE_delayed	= '1' then
				index_write <= index_write + '1';
				
				if index_write = X"00" then			packet(135 downto 128) 	<= HDIN;
																header <= HDIN;
				elsif index_write = X"01" then		packet(127 downto 120) 	<= HDIN;
				elsif index_write = X"02" then		packet(119 downto 112) 	<= HDIN;
				elsif index_write = X"03" then		packet(111 downto 104) 	<= HDIN;
				elsif index_write = X"04" then		packet(103 downto 96) 	<= HDIN;
				elsif index_write = X"05" then		packet(95 downto 88) 	<= HDIN;
				elsif index_write = X"06" then		packet(87 downto 80) 	<= HDIN;
				elsif index_write = X"07" then		packet(79 downto 72) 	<= HDIN;
				elsif index_write = X"08" then		packet(71 downto 64) 	<= HDIN;
				elsif index_write = X"09" then		packet(63 downto 56) 	<= HDIN;
				elsif index_write = X"0A" then		packet(55 downto 48) 	<= HDIN;
				elsif index_write = X"0B" then		packet(47 downto 40) 	<= HDIN;
				elsif index_write = X"0C" then		packet(39 downto 32) 	<= HDIN;
				elsif index_write = X"0D" then		packet(31 downto 24) 	<= HDIN;
				elsif index_write = X"0E" then		packet(23 downto 16) 	<= HDIN;
				elsif index_write = X"0F" then		packet(15 downto 8) 	<= HDIN;
				elsif index_write = X"10" then		packet(7 downto 0) 		<= HDIN;
				end if;

				if index_write = "10000" then
					index_write <= (others => '0');
					packet_received_in <= '1';
				end if;
				
			end if;
		end if;
	end if;
	end process;
		

	process(clk)
	begin
	if rising_edge(clk) then
		if rstn = '0' then
			index_read <= (others => '0');
			HDOUT <= (others => '0');
			empty <= '1';
		else
			empty <= '1';
			if HRE = '1' then
				index_read <= index_read + '1';
				if 		index_read = X"00" then		HDOUT <= out_text(127 downto 120);
				elsif 	index_read = X"01" then		HDOUT <= out_text(119 downto 112);
				elsif 	index_read = X"02" then		HDOUT <= out_text(111 downto 104);
				elsif 	index_read = X"03" then		HDOUT <= out_text(103 downto 96);
				elsif 	index_read = X"04" then		HDOUT <= out_text(95 downto 88);
				elsif 	index_read = X"05" then 	HDOUT <= out_text(87 downto 80);
				elsif 	index_read = X"06" then		HDOUT <= out_text(79 downto 72);
				elsif 	index_read = X"07" then		HDOUT <= out_text(71 downto 64);
				elsif 	index_read = X"08" then		HDOUT <= out_text(63 downto 56);
				elsif 	index_read = X"09" then		HDOUT <= out_text(55 downto 48);
				elsif 	index_read = X"0A" then		HDOUT <= out_text(47 downto 40);
				elsif 	index_read = X"0B" then		HDOUT <= out_text(39 downto 32);
				elsif 	index_read = X"0C" then		HDOUT <= out_text(31 downto 24);
				elsif 	index_read = X"0D" then		HDOUT <= out_text(23 downto 16);
				elsif 	index_read = X"0E" then		HDOUT <= out_text(15 downto 8);
				elsif 	index_read = X"0F" then		HDOUT <= out_text(7 downto 0);							
				end if;
				
				if index_read = "1111" then
					index_read <= (others => '0');
					empty <= '0';
				end if;
				
			end if;
		end if;
	end if;
	end process;
	
	
	WRITE_PROCESS : process (clk)
	begin
	if rising_edge(clk) then
		if rstn = '0' then
		  cw_state 	<= IDLE;
		  WRDYn 	<= '1';
		  packet_received <= '0';
--		  cnt <= (others => '0');
		else
		  case 	cw_state is
				when IDLE => 	WRDYn <= '0';
								packet_received <= '0';
								cw_state <= IDLE;
								if packet_received_in = '1' then
									WRDYn <= '1';
									packet_received <= '1';
									cw_state <= S_START;
								end if;

				when S_START 	=>	WRDYn <= '1';
									packet_received <= '1';
--									cnt <= cnt + '1';
									cw_state <= IDLE;
--									cnt <= (others => '0');
									-- cw_state <= S_WAIT;
									
				-- when S_WAIT => 	WRDYn <= '1';
								-- packet_received <= '0';
								-- if done = '1' then
									-- cw_state <= IDLE;
								-- end if;
	
				when others => 	WRDYn <= '1';
										packet_received <= '0';
										cw_state <= IDLE;
		  end case;
		end if;
	end if;
	end process;
	
	READ_PROCESS : process (clk)
	begin
	if rising_edge(clk) then
		if rstn = '0' then
		  cr_state <= IDLE;
		  RRDYn <= '1';
		else
		  case 	cr_state is
				when IDLE => 	RRDYn <= '1';
								cr_state <= IDLE;
								if done = '1' then
									RRDYn <= '0';
									cr_state <= WRITE1;
								end if;
				
				when WRITE1 =>  RRDYn <= '0';
								cr_state <= WRITE1;
								if empty <= '0' then
									RRDYn <= '1';
									cr_state <= IDLE;
								end if;

				when others => 	RRDYn <= '1';
								cr_state <= IDLE;
		  end case;
		end if;
	end if;
	end process;
  
end behavioral;






  -- process (clk, rstn)
  -- begin
    -- if ( RSTn = '0' ) then
      -- lbus_we_reg <= '0';
      -- lbus_din_reg <= (others => '0');
    -- elsif rising_edge(clk) then
      -- lbus_we_reg <= HWE;

      -- if ( HWE == '1' ) then
			-- lbus_din_reg <= HDIN;
      -- else 
			-- lbus_din_reg <= lbus_din_reg;
	  -- end if;
    -- end if;
   -- process;
  -- State machine register
  -- process (clk, rstn)
    -- if ( RSTn = '0' ) then
      -- now_if_state <= CMD;
    -- elsif rising_edge(clk) then
      -- now_if_state <= next_if_state;
    -- end if;
  -- end process;

  -- State machine control
  -- process (now_if_state, lbus_we_reg, lbus_din_reg, HRE)
  -- begin
    -- case ( now_if_state ) is
      -- when CMD => 	if ( lbus_we_reg = '1' ) then
						-- if ( lbus_din_reg = X"00" ) then
							-- next_if_state <= READ1;
						-- else if ( lbus_din_reg = X"01" ) then 
							-- next_if_state <= WRITE1;
						-- else 
							-- next_if_state <= CMD;
						-- end if;
					-- else 
						-- next_if_state <= CMD;
					-- end if;

      -- when READ1 => if ( lbus_we_reg = '1' ) then 
						-- next_if_state <= READ2;   -- Address High read
					-- else 
						-- next_if_state <= READ1;
					-- end if;
      -- when READ2 => if ( lbus_we_reg = '1' ) then
						-- next_if_state <= READ3;   -- Address Low read
					-- else 
						-- next_if_state <= READ2;
					-- end if;
      -- when READ3 => if ( HRE = '1' ) then
						-- next_if_state <= READ4;           -- Data High read
					-- else  
						-- next_if_state = READ3;
					-- end if;
      -- when READ4 => if ( HRE = '1' ) then
						-- next_if_state <= CMD;            -- Data Low read
					-- else  
						-- next_if_state <= READ4;
					-- end if;

      -- when WRITE1 => 	if ( lbus_we_reg = '1' ) then 
							-- next_if_state <= WRITE2;  -- Address High read
						-- else 
							-- next_if_state <= WRITE1; 
						-- end if;
      -- when WRITE2 => 	if ( lbus_we_reg = '1' ) then
							-- next_if_state <= WRITE3;  -- Address Low read
						-- else 
							-- next_if_state <= WRITE2;
						-- end if;
      -- when WRITE3 => 	if ( lbus_we_reg == '1' ) then
							-- next_if_state <= WRITE4;  -- Data High write
						-- else 
							-- next_if_state <= WRITE3;
						-- end if;
      -- when WRITE4 => 	if ( lbus_we_reg == '1' ) then
							-- next_if_state <= CMD;    -- Data Low write
						-- else 
							-- next_if_state <= WRITE4;
						-- end if;
     -- when others => 	next_if_state <= CMD; 
	 -- end case;
  -- end process;