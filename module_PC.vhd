----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:11:18 05/11/2015 
-- Design Name: 
-- Module Name:    module_PC - Behavioral 
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
use ieee.numeric_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_PC is
	port (
		clk_PC: in std_logic; -- 时钟
		nreset: in std_logic; -- 全局复位信号
		nLD_PC: in std_logic; -- 地址更新
		M_PC:   in std_logic; -- PC加一
		nPCH:   in std_logic; -- PC输出到总线的控制信号
		nPCL:   in std_logic; -- PC输出到总线的控制信号
		PC:     in std_logic_vector(11 downto 0); -- 12位的PC
		ADDR:   out std_logic_vector(11 downto 0); -- ROM读地址输出
		datao:  out std_logic_vector(7 downto 0);
		do:	  out std_logic); -- PC数值输出到数据总线
end module_PC;


architecture Behavioral of module_PC is
	signal thePC: std_logic_vector(11 downto 0);
begin
	
	ADDR <= thePC; -- 放在这个地方是准确的，因为只要thePC一变化，那么ADDR就会立即发生变化

	process(clk_PC, nreset)
	begin
		if nreset = '0' then
			thePC <= X"000";
		elsif rising_edge(clk_PC) then
			-- 加一并且送到地址总线上
			if M_PC = '1' then 
				if thePC = X"FFF" then
					thePC <= X"000";
				else
					thePC <= std_logic_vector(unsigned(thePC) + 1);
				end if;
				datao <= (others => 'Z');
				do <= '0';
			-- 载入新地址并且送到地址总线上去
			elsif nLD_PC = '0' then
				thePC <= PC;
				datao <= (others => 'Z');
				do <= '0';
			-- 输出到数据总线上去
			elsif nPCH = '0' then
				datao(7 downto 4) <= X"0";
				datao(3 downto 0) <= thePC(11 downto 8);
				do <= '1';
			elsif nPCL = '0' then
				datao <= thePC(7 downto 0);
				do <= '1';
			else
				datao <= (others => 'Z');
				do <= '0';
			end if;
		end if;
	end process;
end Behavioral;


