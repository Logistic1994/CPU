----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:20:36 05/29/2015 
-- Design Name: 
-- Module Name:    module_P0 - Behavioral 
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

entity module_P0 is
	port(
		clk_P0:		in std_logic;
		nreset:		in std_logic;
		P0_CS:		in std_logic;
		nP0_IEN:		in std_logic;	--输入使能
		nP0_OEN:		in std_logic;	--输出使能
		P0_IN:		in std_logic_vector(7 downto 0);
		P0_OUT:		out std_logic_vector(7 downto 0);
		datai:		in std_logic_vector(7 downto 0);
		datao:		out std_logic_vector(7 downto 0);
		do:			out std_logic);
end module_P0;

architecture Behavioral of module_P0 is
begin
	process(nreset, clk_P0)
	begin
		if nreset = '0' then
			P0_OUT <= (others => '0');
		elsif rising_edge(clk_P0) then
			if P0_CS = '1' then
				if nP0_IEN = '0' then
					datao <= P0_IN;
					do <= '1';
				elsif nP0_OEN = '0' then
					P0_OUT <= datai;
					datao <= (others => 'Z');
					do <= '0';
				else
					datao <= (others => 'Z');
					do <= '0';
				end if;
			end if;
		end if;
	end process;
end Behavioral;

