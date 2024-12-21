library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
  port(
    RESET : in  std_logic;
    iCLK_2KHz   : in  std_logic;
    CMP   : in  integer range 0 to 255;
    PWM_out: out std_logic	

    );
end pwm;

architecture behaviour of pwm is

  signal count : integer range 0 to 260;

begin  
  process( RESET, iCLK_2KHz )
  begin
    if(RESET = '1') then 
      count <= 0;
    elsif(rising_edge(iCLK_2KHz)) then 
      count <= count + 1;
      if( count >= CMP) then
        PWM_out <= '0';		
      else
        PWM_out <= '1';		
      end if;
    end if;
  end process;
end architecture; 
  
  