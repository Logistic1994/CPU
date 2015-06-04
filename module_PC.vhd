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
		clk_PC: in std_logic; -- ʱ��
		nreset: in std_logic; -- ȫ�ָ�λ�ź�
		nLD_PC: in std_logic; -- ��ַ����
		M_PC:   in std_logic; -- PC��һ
		nPCH:   in std_logic; -- PC��������ߵĿ����ź�
		nPCL:   in std_logic; -- PC��������ߵĿ����ź�
		PC:     in std_logic_vector(11 downto 0); -- 12λ��PC
		ADDR:   out std_logic_vector(11 downto 0); -- ROM����ַ���
		datao:  out std_logic_vector(7 downto 0);
		do:	  out std_logic); -- PC��ֵ�������������
end module_PC;


architecture Behavioral of module_PC is
	signal thePC: std_logic_vector(11 downto 0);
begin
	
	ADDR <= thePC; -- ��������ط���׼ȷ�ģ���ΪֻҪthePCһ�仯����ôADDR�ͻ����������仯

	process(clk_PC, nreset)
	begin
		if nreset = '0' then
			thePC <= X"000";
		elsif rising_edge(clk_PC) then
			-- ��һ�����͵���ַ������
			if M_PC = '1' then 
				if thePC = X"FFF" then
					thePC <= X"000";
				else
					thePC <= std_logic_vector(unsigned(thePC) + 1);
				end if;
				datao <= (others => 'Z');
				do <= '0';
			-- �����µ�ַ�����͵���ַ������ȥ
			elsif nLD_PC = '0' then
				thePC <= PC;
				datao <= (others => 'Z');
				do <= '0';
			-- ���������������ȥ
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


