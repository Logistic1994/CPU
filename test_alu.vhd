--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:31:50 06/04/2015
-- Design Name:   
-- Module Name:   F:/WorkSpace/workspace_ise/Exp/CPU/test_alu.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: module_ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_alu IS
END test_alu;
 
ARCHITECTURE behavior OF test_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT module_ALU
    PORT(
         clk_ALU : IN  std_logic;
         nreset : IN  std_logic;
         M_A : IN  std_logic;
         M_B : IN  std_logic;
         M_F : IN  std_logic;
         nALU_EN : IN  std_logic;
         nPSW_EN : IN  std_logic;
         C0 : IN  std_logic;
         S : IN  std_logic_vector(4 downto 0);
         F_in : IN  std_logic_vector(1 downto 0);
         datai : IN  std_logic_vector(7 downto 0);
         datao : OUT  std_logic_vector(7 downto 0);
         do : OUT  std_logic;
         AC : OUT  std_logic;
         CY : OUT  std_logic;
         ZN : OUT  std_logic;
         OV : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_ALU : std_logic := '0';
   signal nreset : std_logic := '0';
   signal M_A : std_logic := '0';
   signal M_B : std_logic := '0';
   signal M_F : std_logic := '0';
   signal nALU_EN : std_logic := '1';
   signal nPSW_EN : std_logic := '1';
   signal C0 : std_logic := '0';
   signal S : std_logic_vector(4 downto 0) := (others => '0');
   signal F_in : std_logic_vector(1 downto 0) := (others => '0');
   signal datai : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal datao : std_logic_vector(7 downto 0);
   signal do : std_logic;
   signal AC : std_logic;
   signal CY : std_logic;
   signal ZN : std_logic;
   signal OV : std_logic;

   -- Clock period definitions
   constant clk_ALU_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: module_ALU PORT MAP (
          clk_ALU => clk_ALU,
          nreset => nreset,
          M_A => M_A,
          M_B => M_B,
          M_F => M_F,
          nALU_EN => nALU_EN,
          nPSW_EN => nPSW_EN,
          C0 => C0,
          S => S,
          F_in => F_in,
          datai => datai,
          datao => datao,
          do => do,
          AC => AC,
          CY => CY,
          ZN => ZN,
          OV => OV
        );

   -- Clock process definitions
   clk_ALU_process :process
   begin
		clk_ALU <= '0';
		wait for clk_ALU_period/2;
		clk_ALU <= '1';
		wait for clk_ALU_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		nreset <= '1';
			
      -- insert stimulus here 
		M_A <= '1';
		datai <= X"68";
      wait for 100ns;
		M_A <= '0';
		M_B <= '1';
		datai <= X"34";
		wait for 100ns;
		M_B <= '0';
		nALU_EN <= '0';
		S <= "00000";
      wait;
   end process;

END;
