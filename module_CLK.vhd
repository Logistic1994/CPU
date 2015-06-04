----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:22:45 05/10/2015 
-- Design Name: 
-- Module Name:    MyClk - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_CLK is
	port (
		clk: in std_logic;
		nreset: in std_logic;
		clk1, nclk1: out std_logic;
		clk2, nclk2: out std_logic;
		w0, w1, w2, w3: out std_logic);
end module_CLK;

architecture Behavioral of module_CLK is
	signal count1: integer range 0 to 3;
	signal count2: integer range 0 to 3;
	signal count3: std_logic;
begin
	clk1 <= clk;
	nclk1 <= not clk;
	clk2 <= count3;
	nclk2 <= not count3;
	
	process(nreset, clk)
	begin
		if nreset = '0' then
			count1 <= 0;
			count2 <= 0;
			count3 <= '0';
			w0 <= '0';w1 <= '0';w2 <= '0';w3 <= '0';
		elsif rising_edge(clk) then
			count3 <= not count3;
			
			if count1 = 0 then
				if count2 = 0 then
					w0 <= '1';w1 <= '0';w2 <= '0';w3 <= '0';
				elsif count2 = 1 then
					w0 <= '0';w1 <= '1';w2 <= '0';w3 <= '0';
				elsif count2 = 2 then
					w0 <= '0';w1 <= '0';w2 <= '1';w3 <= '0';
				else
					w0 <= '0';w1 <= '0';w2 <= '0';w3 <= '1';
				end if;
				
				if count2 = 3 then
					count2 <= 0;
				else
					count2 <= count2 + 1;
				end if;
			end if;
			
			if count1 = 1 then
				count1 <= 0;
			else
				count1 <= count1 + 1;
			end if;
			
		end if;
	end process;
	
end Behavioral;

