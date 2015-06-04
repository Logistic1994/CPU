----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:44:13 05/29/2015 
-- Design Name: 
-- Module Name:    module_sp - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_SP is
	port(
		clk_SP:		in std_logic;
		nreset:		in std_logic;
		SP_CS:		in std_logic;	--片选
		SP_UP:		in std_logic;   -- +1，即出栈
		SP_DN:		in std_logic;	-- -1，即入栈
		nSP_EN:		in std_logic;   --当这个为0时，up与down有效；当这个为1时表示需要更新SP了
		ARo:			out std_logic_vector(6 downto 0);
		ao:			out std_logic;
		datai: 		in std_logic_vector(7 downto 0));
end module_SP;

architecture Behavioral of module_SP is
	signal SP:	std_logic_vector(6 downto 0);
begin
	process(clk_SP, nreset)
	begin
		if nreset = '0' then
			SP <= (others => '1'); -- 初始时sp应该在7F处，即最底下
		elsif rising_edge(clk_SP) then
			if SP_CS = '1' then
				if nSP_EN = '1' then -- 更新SP
					SP <= datai(6 downto 0);
					ARo <= (others => 'Z');
					ao <= '0';
				else
					if SP_UP = '1' then	-- 上升
						ARo <= SP;	-- 这样是对的
						ao <= '1';
						SP <= std_logic_vector(unsigned(SP) - 1);
					elsif SP_DN = '1' then -- 下降
						ARo <= std_logic_vector(unsigned(SP) + 1);	-- 这样是对的
						ao <= '1';
						SP <= std_logic_vector(unsigned(SP) + 1);
					else
						ARo <= (others => 'Z');
						ao <= '0';
					end if;
				end if;
			else
				ARo <= (others => 'Z');
				ao <= '0';
			end if;
		end if;
	end process;
end Behavioral;

