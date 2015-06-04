----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:00 05/25/2015 
-- Design Name: 
-- Module Name:    module_74181 - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_74181 is
	port (
		M: in std_logic; -- 选择逻辑或者算术
		A: in std_logic_vector(3 downto 0); -- 输入数A
		B: in std_logic_vector(3 downto 0); -- 输入数B
		S: in std_logic_vector(3 downto 0); -- op
		C0: in std_logic; -- 进位输入
		result: out std_logic_vector(3 downto 0); -- 结果
		CN: out std_logic); -- 进位输出
end module_74181;

architecture Behavioral of module_74181 is
	signal lres: std_logic_vector(3 downto 0);
	signal ares: std_logic_vector(4 downto 0);
	signal aA, aB: std_logic_vector(4 downto 0);
begin
	result <= 
		ares(3 downto 0) when M = '0' else	
		lres;
	CN <= 
		'0' when M = '1' else
		'1' when S = "0000" and ares(4) = '0' else
		'0' when S = "0000" and ares(4) = '1' else
		'1' when S = "1111" and ares(4) = '0' else
		'0' when S = "1111" and ares(4) = '1' else
		ares(4);
		
	process(M, A, B, S, C0)
	begin
		if M = '1' then
		-- 逻辑运算
			ares <= (others => '0');
			aA <= (others => '0');
			aB <= (others => '0');
			case S is
				when "0000" =>
					lres <= not A;
				when "0001" =>
					lres <= not (A or B);
				when "0010" =>
					lres <= (not A) and B;
				when "0011" =>
					lres <= (others => '0');
				when "0100" =>
					lres <= not (A and B);
				when "0101" =>
					lres <= not B;
				when "0110" =>
					lres <= A xor B;
				when "0111" =>
					lres <= A and (not B);
				when "1000" =>
					lres <= A or B;
				when "1001" => 
					lres <= not (A xor B);
				when "1010" =>
					lres <= B;
				when "1011" =>
					lres <= A and B;
				when "1100" =>
					lres <= (others => '1');
				when "1101" =>
					lres <= A or (not B);
				when "1110" =>
					lres <= A or B;
				when others =>
					lres <= A;
			end case;
			-- 输出
			--result <= lres;
			--CN <= '0';
		elsif M = '0' then
		-- 算术运算
			lres <= (others => '0');
			aA <= '0' & A;
			aB <= '0' & B;
			case S is
				when "0000" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) + 1);
					else
						ares <= std_logic_vector(unsigned(aA));
					end if;
				when "0001" =>
					if C0 = '0' then
						ares <= aA or aB;
					else
						ares <= std_logic_vector(unsigned(aA or aB) + 1);
					end if;
				when "0010" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA or (not aB)));
					else
						ares <= std_logic_vector(unsigned(aA or (not aB)) + 1);
					end if;
				when "0011" =>
					if C0 = '0' then
						ares <= (others => '1');
					else
						ares <= (others => '0');
					end if;
				when "0100" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) + unsigned(aA and (not aB)));
					else
						ares <= std_logic_vector(unsigned(aA) + unsigned(aA and (not aB)) + 1);
					end if;
				when "0101" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA or aB) + unsigned(aA and (not aB)));
					else
						ares <= std_logic_vector(unsigned(aA or aB) + unsigned(aA and (not aB)) + 1);
					end if;
				when "0110" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) - unsigned(aB));
					else
						ares <= std_logic_vector(unsigned(aA) - unsigned(aB) - 1);
					end if;
				when "0111" =>
					if C0 = '0' then	
						ares <= std_logic_vector(unsigned(aA and (not aB)) - 1);
					else
						ares <= std_logic_vector(unsigned(aA and (not aB)));
					end if;
				when "1000" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) + unsigned(aA and aB)); 
					else
						ares <= std_logic_vector(unsigned(aA) + unsigned(aA and aB) + 1);
					end if;
				when "1001" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) + unsigned(aB));
					else
						ares <= std_logic_vector(unsigned(aA) + unsigned(aB) + 1);
					end if;
				when "1010" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA or (not aB)) + unsigned(aA and aB));
					else
						ares <= std_logic_vector(unsigned(aA or (not aB)) + unsigned(aA and aB) + 1);
					end if;
				when "1011" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA and aB) - 1);
					else
						ares <= std_logic_vector(unsigned(aA and aB));
					end if;
				when "1100" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) + unsigned(aA));
					else
						ares <= std_logic_vector(unsigned(aA) + unsigned(aA) + 1);
					end if;
				when "1101" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA or aB) + unsigned(aA));
					else
						ares <= std_logic_vector(unsigned(aA or aB) + unsigned(aA) + 1);
					end if;
				when "1110" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA or (not aB)) + unsigned(aA));
					else
						ares <= std_logic_vector(unsigned(aA or (not aB)) + unsigned(aA) + 1);
					end if;
				when "1111" =>
					if C0 = '0' then
						ares <= std_logic_vector(unsigned(aA) - 1);
					else
						ares <= aA;
					end if;
				when others =>
					ares <= (others => '0');
			end case;
			-- 输出
			--result <= ares(3 downto 0);
			--CN <= ares(4);
		end if;
	end process;

end Behavioral;

