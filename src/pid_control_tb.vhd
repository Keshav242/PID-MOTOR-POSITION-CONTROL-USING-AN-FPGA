--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:07:47 12/13/2020
-- Design Name:   
-- Module Name:   C:/Users/dixit/Desktop/keshavdocs/embedded/project/Embedded_proj/PIDcontrol_tb.vhd
-- Project Name:  Embedded_proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PIDcontrol
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
 
ENTITY PIDcontrol_tb IS
END PIDcontrol_tb;
 
ARCHITECTURE behavioral OF PIDcontrol_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PIDcontrol
    PORT(
         desired : IN  std_logic_vector(7 downto 0);
         Kp : IN  std_logic_vector(7 downto 0);
         Kd : IN  std_logic_vector(7 downto 0);
         PWM : out  STD_LOGIC;
			Ki : IN  std_logic_vector(7 downto 0);
			sign :out  STD_LOGIC;
         clk : IN  std_logic;
			rst : in  STD_LOGIC;
			A: in STD_LOGIC;
			B : in STD_LOGIC
        );
    END COMPONENT;
    


   --Inputs
   signal desired : std_logic_vector(7 downto 0) := (others => '0');
   signal Kp : std_logic_vector(7 downto 0) := (others => '0');
   signal Kd : std_logic_vector(7 downto 0) := (others => '0');
   signal Ki : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal A: std_logic := '0';
	signal B: std_logic := '0';


 	--Outputs
   
	signal sign : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PIDcontrol PORT MAP (
          desired => desired,
          Kp => Kp,
          Kd => Kd,
          Ki => Ki,
			 sign => sign,
          clk => clk,
			 rst => rst,
			 A => A,
			 B => B
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
      wait for 10 ns;	

      wait for clk_period;

      -- insert stimulus here 
		desired <= "01010101";
		Kp <= "00000011";
		Kd <= "00000001";
		Ki <= "00000000";
		rst <= '0';
		A<='1';
   	 while (I <= 500) loop
      wait for CLK_period*5;
		B<='1';
		 wait for CLK_period*5;
		A<='0';
		wait for CLK_period*5;
		B<='0';
		 wait for CLK_period*5;
		A<='1';
      I := I + 1;
		end loop; 
		wait for 200 us; 
		rst <= '1';
      wait;
   end process;

END;

