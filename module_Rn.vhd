----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:07:20 05/20/2015 
-- Design Name: 
-- Module Name:    module_Rn - Behavioral 
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

entity module_Rn is
	port(
		clk_RN: 	in std_logic;
		nreset: 	in std_logic;
		Rn_CS:		in std_logic; -- 当Rn_CS='0'并且处于读的时候，读取RD里面的数据
		nRi_EN:		in std_logic; -- 低电平有效
		RDRi, WRRi:	in std_logic; -- 高电平有效
		RS:			in std_logic;
		RD:			in std_logic;
		datai:		in  std_logic_vector(7 downto 0);
		datao:		out std_logic_vector(7 downto 0);
		do:			out std_logic);
end module_Rn;

architecture Behavioral of module_Rn is
	signal d0, d1: std_logic_vector(7 downto 0);
begin
	process(nreset, clk_RN)
	begin
		if nreset = '0' then
			d0 <= (others => '0');
			d1 <= (others => '0');
		elsif rising_edge(clk_RN) then
			if nRi_EN = '0' then
				if RDRi = '1' then
					if Rn_CS = '1' then
						if RS = '0' then
							datao <= d0;
							do <= '1';
						else
							datao <= d1;
							do <= '1';
						end if;
					else
						if RD = '0' then
							datao <= d0;
							do <= '1';
						else
							datao <= d1;
							do <= '1';
						end if;
					end if;
				elsif WRRi = '1' then
					if RD = '0' then
						d0 <= datai;
					else
						d1 <= datai;
					end if;
					datao <= (others => 'Z');
					do <= '0';
				else
					datao <= (others => 'Z');
					do <= '0';
				end if;
			else
				datao <= (others => 'Z');
				do <= '0';
			end if;
		end if;
	end process;

end Behavioral;

