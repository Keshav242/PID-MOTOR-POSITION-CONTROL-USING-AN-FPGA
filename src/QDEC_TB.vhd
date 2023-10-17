
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY encoder_input IS
END encoder_input;
 
ARCHITECTURE behavior OF encoder_input IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT QDEC
    PORT(
         CLK : IN  std_logic;
         A : IN  std_logic;
         B : IN  std_logic;
			reading : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal A : std_logic := '0';
   signal B : std_logic := '0';

 	--Outputs
	signal reading : STD_LOGIC_VECTOR (7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: QDEC PORT MAP (
          CLK => CLK,
          A => A,
          B => B,
			 reading =>reading
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	variable I :
      integer range 0 to 1000;
   begin		
      -- hold reset state for 100 ns.
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
      
      

      -- insert stimulus here 

      wait;
   end process;

END;