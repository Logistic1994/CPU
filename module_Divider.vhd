----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:28 06/03/2015 
-- Design Name: 
-- Module Name:    module_Divider - Behavioral 
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

entity module_Divider is
	port(
		clk: in std_logic;
		nreset: in std_logic;
		clk2: out std_logic);
end module_Divider;

architecture Behavioral of module_Divider is
	signal clk_t: std_logic;
begin
	process(nreset, clk)
	begin
		if nreset = '0' then
			clk_t <= '0';
		elsif rising_edge(clk) then
			clk_t <= not clk_t;
			clk2 <= clk_t;
		end if;
	end process;
end Behavioral;

