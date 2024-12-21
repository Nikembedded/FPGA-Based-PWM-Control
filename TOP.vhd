library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
	    
		RESET_SWITCH   : in  std_logic;
		CLK            : in  std_logic; 
		LED            : out std_logic_vector(7 downto 0); 
		PWM_OUT        : out std_logic;	
		PWM_2OUT	   : out std_logic
        
	);
end top;


architecture behaviour of top is
 
 component clock        
    port(
        RESET    : in std_logic; 		
        CLK_IN   : in std_logic; 		
        CLK_1k   : out std_logic; 	
		CLK_2k   : out std_logic		
    );
    end component;
	
    component pwm
        port(
            RESET       : in  std_logic;
			iCLK_2KHz   : in  std_logic;
			CMP         : in  integer range 0 to 255;
			PWM_out     : out std_logic				
        );
    end component;
	
	component SEQUENCER
    port(
         
		RESET        : in std_logic;
        CLK_IN       : in std_logic; 				
        CMP           : out integer range 0 to 255;
		CMP_DIRECTION : out std_logic 	
		
		);
	end component;
	
    
	signal Reset  : std_logic;
	signal ICMP   : integer range 0 to 255;
	signal IDIR   : std_logic;
    signal ICLK1  : std_logic; 
	signal ICLK2  : std_logic;
	signal IPWM   : std_logic;	
	
	
begin
	
	Reset <= not RESET_SWITCH; 	
	LED(7 downto 0) <= "11111111";
	PWM_OUT <= IPWM and IDIR;
	PWM_2OUT <= IPWM and (not IDIR); 
	
	 U0: clock port map(Reset, CLK, ICLK1,ICLK2); 
	 U1: SEQUENCER  port map(Reset,ICLK1,ICMP,IDIR);
	 U2: pwm port map(Reset, ICLK2, ICMP, IPWM); 
	  
   
end architecture;