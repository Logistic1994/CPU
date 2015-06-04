----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:29:59 05/29/2015 
-- Design Name: 
-- Module Name:    micro_controller - Behavioral 
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
use IEEE.STD_LOGIC_TEXTIO.ALL;
library STD;
use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_MC is
	port(
		clk_MC:	in std_logic;
		nreset:	in std_logic;
		IR:		in std_logic_vector(7 downto 2);
		M_uA:		in std_logic;	-- 微地址控制信号
		CMROM_CS:	in std_logic;	-- 控制存储器选通信号
		CM:		out std_logic_vector(47 downto 0)); -- 微控制输出
end module_MC;

architecture Behavioral of module_MC is
	type matrix is array (integer range<>) of std_logic_vector(47 downto 0);
	signal ir_table: matrix(0 to 255);
	-- 从文件中读取微操作与ir指令的对照表
	procedure load_ir_table(signal data_word: out matrix) is 
		file tablefile: text open read_mode is "micro.txt";
		variable lbuf: line; -- 行缓存
		variable i: integer := 0; -- 行计数器
		variable fdata: std_logic_vector(47 downto 0); -- 从每一行中读出48位
	begin
		for m in 0 to 9 loop
			for n in 0 to 9 loop
				for o in 0 to 1 loop 
					if not endfile(tablefile) then
						readline(tablefile, lbuf);
						hread(lbuf, fdata);
						data_word(i) <= fdata;
						i := i + 1;
					end if;
				end loop;
			end loop;
		end loop; -- 10 * 10 * 2 = 200;
	end procedure;
	
	signal u8: std_logic_vector(7 downto 0);
begin
	load_ir_table(ir_table); -- 一次性读取出ir_table
	
	process(clk_MC, nreset)
	begin
		if nreset = '0' then
			CM <= (others => 'Z');
			u8 <= (others => '0');
		elsif rising_edge(clk_MC) then
			if M_uA = '1' and CMROM_CS = '1' then
				CM <= ir_table(conv_integer(u8));
				u8 <= ir_table(conv_integer(u8))(7 downto 0);
			else
				CM <= ir_table(conv_integer(IR & '0' & '0'));
				u8 <= ir_table(conv_integer(IR & '0' & '0'))(7 downto 0);
			end if;
		end if;
	end process;

end Behavioral;

