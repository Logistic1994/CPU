----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:23 05/29/2015 
-- Design Name: 
-- Module Name:    module_ram - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_RAM is
	port(
		clk_RAM:	in std_logic;
		nreset:		in std_logic;
		RAM_CS:		in std_logic;	-- RAM片选
		nRAM_EN:	in std_logic;	-- RAM输出使能
		WR_nRD:		in std_logic;	-- 1为写，0为读
		ARi:			in std_logic_vector(6 downto 0);	-- RAM地址信号
		datai:		in std_logic_vector(7 downto 0);
		datao:		out std_logic_vector(7 downto 0);
		do:			out std_logic); -- 数据总线
end module_RAM;

architecture Behavioral of module_RAM is
	type matrix is array (integer range<>) of std_logic_vector(7 downto 0);	-- 定义这样的类型
	signal ram: matrix(0 to 2**7-1);
begin
	process(nreset, clk_RAM)
	begin
		if nreset = '0' then
			-- do nothing
		elsif rising_edge(clk_RAM) then
			if RAM_CS = '1' and nRAM_EN = '0' then
				if WR_nRD = '1' then
					ram(conv_integer(ARi)) <= datai;
					datao <= (others => 'Z');
					do <= '0';
				else
					datao <= ram(conv_integer(ARi));
					do <= '1';
				end if;
			else
				datao <= (others => 'Z');
				do <= '0';
			end if;
		end if;
	end process;
end Behavioral;

