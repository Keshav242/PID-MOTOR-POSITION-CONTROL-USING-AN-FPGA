---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:42 12/13/2020 
-- Design Name: 
-- Module Name:    PIDcontrol - Behavioral 
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PIDControl is
	 generic(BITS : integer :=8);
    Port ( 
           --current : in  STD_LOGIC_VECTOR (7 downto 0);
           PWM : out  STD_LOGIC;
			  sign : out STD_LOGIC;
           clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  A: in STD_LOGIC;
			  B : in STD_LOGIC;
			  c2: out STD_LOGIC;
			  r: out std_logic
			  );
end PIDControl;

architecture Behavioral of PIDcontrol is
type statetype is (reset, calc_pid, adjust, calc_op, PWM_op);
signal present_state, next_state : statetype :=reset;
signal error : integer :=0;
signal p : integer:=0;
signal i : integer:=0;
signal d : integer:=0;
constant Kp : integer := 1;
constant Kd : integer := 2  ;
constant Ki : integer := 0;
constant desired : integer := -200;
signal prev_error :integer:=0;
signal prev_accerror :integer:=0;
signal sum :integer:=0;
signal count :integer := 0; --unsigned(11 downto 0);
signal DCint :integer:=0;
signal pwm_reg : STD_LOGIC :='0' ;
signal reading : STD_LOGIC_VECTOR (31 downto 0);
signal current : STD_LOGIC_VECTOR (31 downto 0);
signal w1 : integer:=0;
signal c1: std_logic;
component QDEC port
   (
     CLK : in    std_logic;
     A   : in    std_logic;
     B   : in    std_logic;
	  reading : out  STD_LOGIC_VECTOR (31 downto 0)
   );
end component;
begin
-- state update
-- next state logic
--c1<= clk;
q1: 	QDEC 	port map( CLK=>c1,A=>A,B=>B ,reading=>reading);
	current<= reading;
	c2<=c1;
process(c1,rst)
	begin
	if(rst = '1')then
		r<='1';
		present_state <= reset;
	else
		r<='0';
		if(c1'event and c1 = '0')then
				
			present_state <= next_state;
		end if;
	end if;	
	if(c1'event and c1 = '1')then
		case present_state is
			when reset =>
				prev_error <= 0;
				prev_accerror <= 0;
				error <= 0;
				p <= 0;
				i <= 0;
				d <= 0;
				next_state <= calc_pid;
				pwm_reg <= '0';
				
				
			when calc_pid =>
				error <= conv_integer(desired) - conv_integer(current);
				p <= conv_integer(Kp)*(conv_integer(desired) - conv_integer(current));
				d <= conv_integer(Kd)*(conv_integer(desired) - conv_integer(current)-prev_error);
				i <= conv_integer(Ki)*(prev_accerror+conv_integer(desired) - conv_integer(current));
				next_state <= adjust;
				
			when adjust =>
				if((p+i-d)>(2**BITS-1))then
					sum <= (2**BITS-1);
				elsif((p+i-d)<-(2**BITS-1))then
					sum <= -(2**BITS-1);
				else
					sum <= p+i-d;
				end if;
				next_state <= calc_op;
				
			when calc_op =>
				prev_accerror <= error+prev_accerror;
				prev_error <= error;
				count <= 0;
				if(sum >= 0)then
					sign <= '0';
					DCint <= sum;
				else
					sign <= '1';
					DCint <= (-sum);
				end if;
				next_state <= PWM_op;				
				
			when PWM_op =>
				count <=count +1;
				if(pwm_reg = '1')then
					if(count = DCint)then
							pwm_reg <= '0';
							count <= 0;
							next_state <= calc_pid;
					else
							pwm_reg <= '1';
					end if;
				else
					if(count = ((2**BITS-1)-DCint))then
							pwm_reg <= '1';
							count <= 0;
					else
							pwm_reg <= '0';
					end if;
				end if;			
				
		end case;
		end if;
	end process;
	
process(clk)
begin
if(rst = '1')then
		w1<=0;
elsif(clk'event and clk = '1')then
	w1 <=w1 +1;
	if (w1 <= 250) then
		c1<='0';
	elsif (w1 >250 and w1 <=500) then
		c1<='1';
	else
			w1<=0;
	end if;
end if;
end process;
	
PWM <=pwm_reg ;
end Behavioral;

