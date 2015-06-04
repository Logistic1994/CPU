--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:28:24 06/04/2015
-- Design Name:   
-- Module Name:   F:/WorkSpace/workspace_ise/Exp/CPU/cpu_test.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: module_CPU
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
 
ENTITY cpu_test IS
END cpu_test;
 
ARCHITECTURE behavior OF cpu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT module_CPU
    PORT(
         clk : IN  std_logic;
         nreset : IN  std_logic;
         io_input : IN  std_logic_vector(7 downto 0);
         io_output : OUT  std_logic_vector(7 downto 0);
         data_test : OUT  std_logic_vector(7 downto 0);
         ar_test : OUT  std_logic_vector(6 downto 0);
         cm_test : OUT  std_logic_vector(47 downto 0);
         addr_test : OUT  std_logic_vector(11 downto 0);
         ir_test : OUT  std_logic_vector(7 downto 0);
         pc_test : OUT  std_logic_vector(11 downto 0);
         c1_test : OUT  std_logic;
         c2_test : OUT  std_logic;
         n1_test : OUT  std_logic;
         n2_test : OUT  std_logic;
         w0_test : OUT  std_logic;
         w1_test : OUT  std_logic;
         w2_test : OUT  std_logic;
         w3_test : OUT  std_logic;
         ir_ctest : OUT  std_logic;
         rs_test : OUT  std_logic;
         rd_test : OUT  std_logic;
         pc_ntest : OUT  std_logic;
         nload_test : OUT  std_logic;
         x_test : OUT  std_logic;
         z_test : OUT  std_logic;
         count_test : OUT  integer
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal nreset : std_logic := '0';
   signal io_input : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal io_output : std_logic_vector(7 downto 0);
   signal data_test : std_logic_vector(7 downto 0);
   signal ar_test : std_logic_vector(6 downto 0);
   signal cm_test : std_logic_vector(47 downto 0);
   signal addr_test : std_logic_vector(11 downto 0);
   signal ir_test : std_logic_vector(7 downto 0);
   signal pc_test : std_logic_vector(11 downto 0);
   signal c1_test : std_logic;
   signal c2_test : std_logic;
   signal n1_test : std_logic;
   signal n2_test : std_logic;
   signal w0_test : std_logic;
   signal w1_test : std_logic;
   signal w2_test : std_logic;
   signal w3_test : std_logic;
   signal ir_ctest : std_logic;
   signal rs_test : std_logic;
   signal rd_test : std_logic;
   signal pc_ntest : std_logic;
   signal nload_test : std_logic;
   signal x_test : std_logic;
   signal z_test : std_logic;
   signal count_test : integer;

   -- Clock period definitions
   constant clk_period : time := 2 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: module_CPU PORT MAP (
          clk => clk,
          nreset => nreset,
          io_input => io_input,
          io_output => io_output,
          data_test => data_test,
          ar_test => ar_test,
          cm_test => cm_test,
          addr_test => addr_test,
          ir_test => ir_test,
          pc_test => pc_test,
          c1_test => c1_test,
          c2_test => c2_test,
          n1_test => n1_test,
          n2_test => n2_test,
          w0_test => w0_test,
          w1_test => w1_test,
          w2_test => w2_test,
          w3_test => w3_test,
          ir_ctest => ir_ctest,
          rs_test => rs_test,
          rd_test => rd_test,
          pc_ntest => pc_ntest,
          nload_test => nload_test,
          x_test => x_test,
          z_test => z_test,
          count_test => count_test
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		nreset <= '1';
		io_input <= X"23";
      wait for clk_period*100;

      -- insert stimulus here 

      wait for clk_period*1000;
   end process;

END;
