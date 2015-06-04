----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:16:20 05/20/2015 
-- Design Name: 
-- Module Name:    module_ALU - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_ALU is
	port(
		clk_ALU:		in std_logic;
		nreset:		in std_logic;
		M_A, M_B:	in std_logic;	-- �ݴ��������ź�
		M_F:			in std_logic;	-- ��λ�Ŀ����ź�
		nALU_EN:		in std_logic;	-- ALU������ʹ��
		nPSW_EN:		in std_logic;	-- PSW���ʹ��
		C0:			in std_logic;	-- ��λ����
		S:				in std_logic_vector(4 downto 0); -- �������ͺͲ���ѡ��
		F_in:			in std_logic_vector(1 downto 0); -- ��λ����ѡ��
		datai:		in std_logic_vector(7 downto 0); -- ����
		datao:		out std_logic_vector(7 downto 0);
		do:			out std_logic;
		AC:			out std_logic;
		CY:			out std_logic;
		ZN:			out std_logic;
		OV:			out std_logic);
end module_ALU;

architecture Behavioral of module_ALU is
	component module_74181
		port (
			M: in std_logic; -- ѡ���߼���������
			A: in std_logic_vector(3 downto 0); -- ������A
			B: in std_logic_vector(3 downto 0); -- ������B
			S: in std_logic_vector(3 downto 0); -- op
			C0: in std_logic; -- ��λ����
			result: out std_logic_vector(3 downto 0); -- ���
			CN: out std_logic); -- ��λ���		
	end component;

	signal center_C: std_logic; -- �м��λ
	signal final_C: std_logic; -- ���ս�λ
	signal d_A, d_B: std_logic_vector(7 downto 0);
	signal result: std_logic_vector(7 downto 0);
	signal result_shifted: std_logic_vector(7 downto 0);
	signal tmp_AC, tmp_CY, tmp_ZN, tmp_OV: std_logic;
begin
	tmp_AC <= center_C;
	tmp_CY <= final_C;
	tmp_ZN <= '1' when result_shifted = X"00" else '0';
	tmp_OV <= '1' when (d_A(7) = d_B(7) and d_A(7) /= result(7)) else '0';
	
	
	
	result_shifted <= 
		(result(6 downto 0) & '0') when F_in = "11" and M_F = '1' else 
		(result(0) & result(7 downto 1)) when F_in = "01" and M_F = '1' else
		(result(6 downto 0) & result(7)) when F_in = "10" and M_F = '1' else
		result;
	
	process(nreset, clk_ALU)
	begin
		if nreset = '0' then
			d_A <= (others => '0');
			d_B <= (others => '0');
			ZN <= '0';
		elsif rising_edge(clk_ALU) then
			if M_A = '1' then
				d_A <= datai;
				datao <= (others => 'Z');
				do <= '0';
			elsif M_B = '1' then
				d_B <= datai;
				datao <= (others => 'Z');
				do <= '0';
			elsif nALU_EN = '0' then
				datao <= result_shifted;
				AC <= tmp_AC; CY <= tmp_CY; ZN <= tmp_ZN; OV <= tmp_OV;
				do <= '1';
			elsif nPSW_EN = '0' then
				datao <= "0000" & tmp_AC & tmp_CY & tmp_ZN & tmp_OV;
				do <= '1';
			else
				datao <= (others => 'Z');
				do <= '0';
			end if;
		end if;
	end process;
-- ��һ��
U1:
	module_74181
		port map(
			M => S(4),
			A => d_A(3 downto 0),
			B => d_B(3 downto 0),
			S => S(3 downto 0),
			C0 => C0,
			result => result(3 downto 0),
			CN => center_C);
-- �ڶ���
U2:
	module_74181
		port map(
			M => S(4),
			A => d_A(7 downto 4),
			B => d_B(7 downto 4),
			S => S(3 downto 0),
			C0 =>center_C,
			result => result(7 downto 4),
			CN => final_C);
end Behavioral;

