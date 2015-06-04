----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:39:06 05/11/2015 
-- Design Name: 
-- Module Name:    module_rom - Behavioral 
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
use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_ROM is
	port (
		clk_ROM: in std_logic;
		M_ROM:	in std_logic;
		nROM_EN:	in std_logic;
		addr:		in std_logic_vector(11 downto 0);
		datao:		out std_logic_vector(7 downto 0);
		do:		out std_logic);
end module_rom;

architecture Behavioral of module_ROM is
	type matrix is array (integer range<>) of std_logic_vector(7 downto 0);
	signal rom:matrix (0 to 2**12-1);
	procedure load_rom(signal data_word:out matrix) is
		file romfile: text open read_mode is "romfile2.dat";
		variable lbuf: line;
		variable i: integer := 0;
		variable fdata: std_logic_vector(7 downto 0);
	begin
		for m in 0 to 15 loop
			for n in 0 to 15 loop
				for o in 0 to 15 loop
					if not endfile(romfile) then
						readline(romfile, lbuf);
						read(lbuf, fdata);
						data_word(i) <= fdata;
						i := i + 1;
					end if;
				end loop;
			end loop;
		end loop;
	end procedure;
begin
	load_rom(rom);
	process(clk_ROM, M_ROM, nROM_EN)
	begin
		if rising_edge(clk_ROM) then
			if M_ROM = '1' and nROM_EN = '0' then
				datao <= rom(conv_integer(addr));
				do <= '1';
			else
				datao <= (others => 'Z');
				do <= '0';
			end if;
		end if;
	end process;
end Behavioral;

