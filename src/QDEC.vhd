
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;
entity QDEC is port
   (
     CLK : in    std_logic;
     A   : in    std_logic;
     B   : in    std_logic;
	  reading : out  STD_LOGIC_VECTOR (31 downto 0)
   );
end QDEC;

architecture Behavioral of QDEC is

-- Signal Declarations
signal code      : std_logic_vector(1 downto 0) := B"00";
signal code_prev : std_logic_vector(1 downto 0) := B"00";
signal inc : integer := 0;

begin
    main:process(CLK) is
    begin
       if rising_edge(CLK) then
          code_prev <= code;
          code(0) <= A;
          code(1) <= B;
          if (code(0) = '1' and code_prev(0) = '0') then -- A rising edge
              if (B='0') then -- forward
                 inc <= inc + 1;
              elsif (B='1') then -- reverse
                 inc <= inc -1;
              end if;
--          elsif (code(1) = '1' and code_prev(1) = '0') then -- B rising edge
--              if (A='1') then -- forward
--                 inc <= inc + 1;
--              elsif (A='0') then -- reverse
--                 inc <= inc - 1;
--              end if;
--          elsif (code(0) = '0' and code_prev(0) = '1') then -- A falling edge
--              if (B='1') then -- forward
--                 inc <= inc + 1;
--              elsif (B='0') then -- reverse
--                 inc <= inc - 1;
--              end if;
--          elsif (code(1) = '0' and code_prev(1) = '1') then -- B falling edge
--              if (A='0') then -- forward
--                 inc <= inc + 1;
--              elsif (A='1') then -- reverse
--                 inc <= inc - 1;
--              end if;  
          end if;
       end if;
    end process;
	 reading <= std_logic_vector(to_signed(inc,reading'length));
end Behavioral;



