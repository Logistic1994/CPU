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
		SP_CS:		in std_logic;	--Ƭѡ
		SP_UP:		in std_logic;   -- +1������ջ
		SP_DN:		in std_logic;	-- -1������ջ
		nSP_EN:		in std_logic;   --�����Ϊ0ʱ��up��down��Ч�������Ϊ1ʱ��ʾ��Ҫ����SP��
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
			SP <= (others => '1'); -- ��ʼʱspӦ����7F�����������
		elsif rising_edge(clk_SP) then
			if SP_CS = '1' then
				if nSP_EN = '1' then -- ����SP
					SP <= datai(6 downto 0);
					ARo <= (others => 'Z');
					ao <= '0';
				else
					if SP_UP = '1' then	-- ����
						ARo <= SP;	-- �����ǶԵ�
						ao <= '1';
						SP <= std_logic_vector(unsigned(SP) - 1);
					elsif SP_DN = '1' then -- �½�
						ARo <= std_logic_vector(unsigned(SP) + 1);	-- �����ǶԵ�
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

