----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:37:33 05/14/2015 
-- Design Name: 
-- Module Name:    module_IR - Behavioral 
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

entity module_IR is
	port (
		clk_IR:	in std_logic;
		nreset: 	in std_logic;
		LD_IR1, LD_IR2, LD_IR3:	in std_logic; -- 控制信号
		nARen:	in std_logic;	-- ram地址控制信号
		datai:		in std_logic_vector(7 downto 0);
		IR:		out std_logic_vector(7 downto 0); -- IR指令编码
		PC:		out std_logic_vector(11 downto 0); -- PC新地址
		ARo:		out std_logic_vector(6 downto 0); -- RAM读写地址
		ao:		out std_logic;
		RS, RD:		out std_logic);		-- 源寄存器和目的寄存器
end module_IR;

architecture Behavioral of module_IR is
	signal thePC2AR: std_logic_vector(6 downto 0);
begin
	
	process(nreset, clk_IR)
	begin
		if nreset = '0' then
			thePC2AR <= (others => '0');
		elsif rising_edge(clk_IR) then
			if LD_IR1 = '1' then
				IR <= datai;
				RS <= datai(0);
				RD <= datai(1);
				ARo <= (others => 'Z');
				ao <= '0';
			elsif LD_IR2 = '1' then
				PC(11 downto 8) <= datai(3 downto 0);
				ARo <= (others => 'Z');
				ao <= '0';
			elsif LD_IR3 = '1' then
				PC(7 downto 0) <= datai(7 downto 0);
				thePC2AR <= datai(6 downto 0);
				ARo <= (others => 'Z');
				ao <= '0';
			elsif nARen = '0' then
				ARo <= thePC2AR;
				ao <= '1';
			else
				ARo <= (others => 'Z');
				ao <= '0';
			end if;
		end if;
	end process;

end Behavioral;

