----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:35:09 06/03/2015 
-- Design Name: 
-- Module Name:    module_CPU - Behavioral 
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

entity module_CPU is
	port (
		clk: in std_logic; -- 时钟
		nreset: in std_logic;
		io_input: in std_logic_vector(7 downto 0);
		io_output: out std_logic_vector(7 downto 0);
		data_test: out std_logic_vector(7 downto 0);
		ar_test: out std_logic_vector(6 downto 0);
		cm_test: out std_logic_vector(47 downto 0);
		addr_test: out std_logic_vector(11 downto 0);
		ir_test: out std_logic_vector(7 downto 0);
		pc_test: out std_logic_vector(11 downto 0);
		c1_test, c2_test, n1_test, n2_test, w0_test, w1_test, w2_test, w3_test: out std_logic;
		ir_ctest: out std_logic;
		rs_test, rd_test: out std_logic;
		pc_ntest: out std_logic;
		nload_test, x_test, z_test: out std_logic;
		count_test: out integer);
end module_CPU;

architecture Behavioral of module_CPU is
-- 申明所有的模块
-- 二分频器
	component module_Divider
		port(
			clk: in std_logic;
			nreset: in std_logic;
			clk2: out std_logic);
	end component;
-- MC
	component module_MC
		port(
			clk_MC:	in std_logic;
			nreset:	in std_logic;
			IR:		in std_logic_vector(7 downto 2);
			M_uA:		in std_logic;	-- 微地址控制信号
			CMROM_CS:	in std_logic;	-- 控制存储器选通信号
			CM:		out std_logic_vector(47 downto 0)); -- 微控制输出
	end component;
-- ROM
	component module_ROM
		port (
			clk_ROM: in std_logic;
			M_ROM:	in std_logic;
			nROM_EN:	in std_logic;
			addr:		in std_logic_vector(11 downto 0);
			datao:	out std_logic_vector(7 downto 0);
			do:		out std_logic);
	end component;
-- IR
	component module_IR
		port (
			clk_IR:	in std_logic;
			nreset: 	in std_logic;
			LD_IR1, LD_IR2, LD_IR3:	in std_logic; -- 控制信号
			nARen:	in std_logic;	-- ram地址控制信号
			datai:	in std_logic_vector(7 downto 0);
			IR:		out std_logic_vector(7 downto 0); -- IR指令编码
			PC:		out std_logic_vector(11 downto 0); -- PC新地址
			ARo:		out std_logic_vector(6 downto 0); -- RAM读写地址
			ao:		out std_logic;
			RS, RD:		out std_logic);		-- 源寄存器和目的寄存器
	end component;
-- PC
	component module_PC
		port (
			clk_PC: in std_logic; -- 时钟
			nreset: in std_logic; -- 全局复位信号
			nLD_PC: in std_logic; -- 地址更新
			M_PC:   in std_logic; -- PC加一
			nPCH:   in std_logic; -- PC输出到总线的控制信号
			nPCL:   in std_logic; -- PC输出到总线的控制信号
			PC:     in std_logic_vector(11 downto 0); -- 12位的PC
			ADDR:   out std_logic_vector(11 downto 0); -- ROM读地址输出
			datao:  out std_logic_vector(7 downto 0);-- PC数值输出到数据总线	
			do:		out std_logic); 
	end component;
-- P0
	component module_P0
		port(
			clk_P0:		in std_logic;
			nreset:		in std_logic;
			P0_CS:		in std_logic;
			nP0_IEN:		in std_logic;	--输入使能
			nP0_OEN:		in std_logic;	--输出使能
			P0_IN:		in std_logic_vector(7 downto 0);
			P0_OUT:		out std_logic_vector(7 downto 0);
			datai:		in std_logic_vector(7 downto 0);
			datao: 		out std_logic_vector(7 downto 0);
			do:		out std_logic);
	end component;
-- SP
	component module_SP
		port(
			clk_SP:		in std_logic;
			nreset:		in std_logic;
			SP_CS:		in std_logic;	--片选
			SP_UP:		in std_logic;   -- +1，即出栈
			SP_DN:		in std_logic;	-- -1，即入栈
			nSP_EN:		in std_logic;   --当这个为0时，up与down有效；当这个为1时表示需要更新SP了
			ARo:			out std_logic_vector(6 downto 0);
			ao:		out std_logic;
			datai: 		in std_logic_vector(7 downto 0));
	end component;
-- RAM
	component module_RAM
		port(
			clk_RAM:	in std_logic;
			nreset:		in std_logic;
			RAM_CS:		in std_logic;	-- RAM片选
			nRAM_EN:	in std_logic;	-- RAM输出使能
			WR_nRD:		in std_logic;	-- 1为写，0为读
			ARi:			in std_logic_vector(6 downto 0);	-- RAM地址信号
			datai:		in std_logic_vector(7 downto 0);
			datao: 		out std_logic_vector(7 downto 0); -- 数据总线
			do:		out std_logic);
	end component;
-- RN
	component module_Rn
		port(
			clk_RN: 	in std_logic;
			nreset: 	in std_logic;
			Rn_CS:		in std_logic; -- 当Rn_CS='0'并且处于读的时候，读取RD里面的数据
			nRi_EN:		in std_logic; -- 低电平有效
			RDRi, WRRi:	in std_logic; -- 高电平有效
			RS:			in std_logic;
			RD:			in std_logic;
			datai:		in  std_logic_vector(7 downto 0);
			datao: 		out std_logic_vector(7 downto 0);
			do:		out std_logic);
	end component;
-- ALU
	component module_ALU
		port(
			clk_ALU:		in std_logic;
			nreset:		in std_logic;
			M_A, M_B:	in std_logic;	-- 暂存器控制信号
			M_F:			in std_logic;	-- 移位的控制信号
			nALU_EN:		in std_logic;	-- ALU结果输出使能
			nPSW_EN:		in std_logic;	-- PSW输出使能
			C0:			in std_logic;	-- 进位输入
			S:				in std_logic_vector(4 downto 0); -- 运算类型和操作选择
			F_in:			in std_logic_vector(1 downto 0); -- 移位功能选择
			datai:		in std_logic_vector(7 downto 0); -- 数据
			datao: 		out std_logic_vector(7 downto 0);
			do:		out std_logic;
			AC:			out std_logic;
			CY:			out std_logic;
			ZN:			out std_logic;
			OV:			out std_logic);
	end component;
-- CLK
	component module_CLK
		port (
			clk: in std_logic;
			nreset: in std_logic;
			clk1, nclk1: out std_logic;
			clk2, nclk2: out std_logic;
			w0, w1, w2, w3: out std_logic);	
	end component;
	
	
-- signals
	signal IR: std_logic_vector(7 downto 0);
	signal CM: std_logic_vector(47 downto 0);
	signal ADDR: std_logic_vector(11 downto 0);
	signal DATA: std_logic_vector(7 downto 0); -- 这个信号可以用于所有的输入
	signal PC: std_logic_vector(11 downto 0);
	signal AR: std_logic_vector(6 downto 0);
	signal RS, RD: std_logic;
	signal AC, CY, ZN, OV: std_logic; -- AC半，CY全，ZN0，OV溢出
	signal PC_nload: std_logic;
	
	signal clk1, clk2, nclk1, nclk2, w0, w1, w2, w3: std_logic;
	signal clk_double: std_logic;
	signal clk_MC, clk_ROM, clk_IR, clk_PC, clk_P0, clk_SP, clk_RAM, clk_Rn, clk_ALU: std_logic;
	signal d_ROM, d_PC, d_P0, d_RAM, d_Rn, d_ALU: std_logic_vector(7 downto 0); -- 这些信号用于输出
	signal do_ROM, do_PC, do_P0, do_RAM, do_Rn, do_ALU: std_logic;
	signal a_IR, a_SP: std_logic_vector(6 downto 0);
	signal ao_IR, ao_SP: std_logic;
	signal clk_count: std_logic;
	signal count: integer;
begin
	-- 时钟
	clk_MC <= w0;
	clk_ROM <= nclk1 and w0 and clk2;
	clk_IR <= nclk2 and w0;
	clk_PC <= nclk1 and w0 and nclk2;
	clk_P0 <= w1;
	clk_SP <= nclk1 and w1 and clk2;
	clk_RAM <= nclk1 and w1 and nclk2;
	clk_Rn <= nclk1 and w2 and clk2;
	clk_ALU <= nclk1 and w2 and nclk2;
	clk_count <= clk and (w0 or w1 or w2 or w3);
	
	PC_nload <= (CM(22) or ((not CM(12)) and ZN));
	-- for test
	data_test <= DATA;
	ar_test <= AR;
	cm_test <= CM;
	addr_test <= ADDR;
	ir_test <= IR;
	pc_test <= PC;
	c1_test <= clk1;
	c2_test <= clk2;
	n1_test <= nclk1;
	n2_test <= nclk2;
	w0_test <= w0;w1_test <= w1;w2_test <= w2;w3_test <= w3;
	count_test <= count;
	ir_ctest <= clk_IR;
	rs_test <= RS;
	rd_test <= RD;
	pc_ntest <= PC_nload;
	nload_test <= CM(22);
	x_test <= CM(12);
	z_test <= ZN;
	
	process(nreset, clk_count) -- 进行数据选择
	begin
		if nreset = '0' then
			count <= 0;
		elsif falling_edge(clk_count) then	
			if count = 1 then -- for update ROM
				if do_ROM = '1' then
					DATA <= d_ROM;
					AR <= AR;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 2 then   -- for update IR
				if ao_IR = '1' then
					AR <= a_IR;
					DATA <= DATA;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 3 then  -- for update PC
				if do_PC = '1' then
					DATA <= d_PC;
					AR <= AR;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 4 then  -- for update P0
				if do_P0 = '1' then
					DATA <= d_P0;
					AR <= AR;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 5 then  -- for update SP
				if ao_SP = '1' then
					AR <= a_SP;
					DATA <= DATA;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 7 then  -- for update RAM
				if do_RAM  = '1' then
					DATA <= d_RAM;
					AR <= AR;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 9 then  -- for update Rn
				if do_Rn = '1' then
					DATA <= d_Rn;
					AR <= AR;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			elsif count = 11 then  -- for update ALU
				if do_ALU = '1' then
					DATA <= d_ALU;
					AR <= AR;
				else
					DATA <= DATA;
					AR <= AR;
				end if;
			else
				DATA <= DATA;
				AR <= AR;
			end if;
			
			if count = 15 then
				count <= 0;
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	
U_MC:
	module_MC
		port map(
			clk_MC => clk_MC,
			nreset => nreset,
			IR => IR(7 downto 2),
			M_uA => CM(9),
			CMROM_CS => CM(8),
			CM => CM);
			
U_ROM:
	module_ROM
		port map(
			clk_ROM => clk_ROM,
			M_ROM => CM(11),
			nROM_EN => CM(10),
			addr => ADDR,
			datao => d_ROM,
			do => do_ROM);
		
U_IR:
	module_IR
		port map(
			clk_IR => clk_IR,
			nreset => nreset,
			LD_IR1 => CM(27),
			LD_IR2 => CM(26),
			LD_IR3 => CM(25),
			nARen => CM(24),
			datai => DATA,
			IR => IR,
			PC => PC,
			ARo => a_IR,
			ao => ao_IR,
			RS => RS,
			RD => RD);
			
U_PC:
	module_PC
		port map(
			clk_PC => clk_PC,
			nreset => nreset,
			nLD_PC => PC_nload,
			M_PC => CM(23),
			nPCH => CM(21),
			nPCL => CM(20),
			PC => PC,
			ADDR => ADDR,
			datao => d_PC,
			do => do_PC);

U_P0:
	module_P0
		port map(
			clk_P0 => clk_P0,
			nreset => nreset,
			P0_CS => CM(15),
			nP0_IEN => CM(14),
			nP0_OEN => CM(13),
			P0_IN => io_input,
			P0_OUT => io_output,
			datai => DATA,
			datao => d_P0,
			do => do_P0);
	
U_SP:
	module_SP
		port map(
			clk_SP => clk_SP,
			nreset => nreset,
			SP_CS => CM(17),
			SP_UP => CM(19),
			SP_DN => CM(18),
			nSP_EN => CM(16),
			ARo => a_SP,
			ao => ao_SP,
			datai => DATA);
			
U_RAM:
	module_RAM
		port map(
			clk_RAM => clk_RAM,
			nreset => nreset,
			RAM_CS => CM(34),
			nRAM_EN => CM(32),
			WR_nRD => CM(33),
			ARi => AR,
			datai => DATA,
			datao => d_RAM,
			do => do_RAM);
			
U_Rn:
	module_Rn
		port map(
			clk_RN => clk_Rn,
			nreset => nreset,
			Rn_CS => CM(31),
			nRi_EN => CM(28),
			RDRi => CM(30),
			WRRi => CM(29),
			RS => RS, 
			RD => RD,
			datai => DATA,
			datao => d_Rn,
			do => do_Rn);
			
U_ALU:
	module_ALU
		port map(
			clk_ALU => clk_ALU,
			nreset => nreset,
			M_A => CM(47),
			M_B => CM(46),
			M_F => CM(45),
			nALU_EN => CM(37),
			nPSW_EN => CM(36),
			C0 => CM(35),
			S(4) => CM(44),
			S(3) => CM(43),
			S(2) => CM(42),
			S(1) => CM(41),
			S(0) => CM(40),
			F_in(1) => CM(39),
			F_in(0) => CM(38),
			datai => DATA,
			datao => d_ALU,
			do => do_ALU,
			AC => AC,
			CY => CY,
			ZN => ZN,
			OV => OV);

U_CLK:
	module_CLK
		port map(
			clk => clk_double,
			nreset => nreset,
			clk1 => clk1,
			nclk1 => nclk1,
			clk2 => clk2,
			nclk2 => nclk2,
			w0 => w0,
			w1 => w1, 
			w2 => w2,
			w3 => w3);
			
U_Divider:
	module_Divider
		port map(
			clk => clk,
			nreset => nreset,
			clk2 => clk_double);
end Behavioral;

