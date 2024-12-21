library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is 
    port(
        RESET    : in std_logic; 		
        CLK_IN: in std_logic; 		
        CLK_1k : out std_logic; 	
		CLK_2k : out std_logic		
    );
end clock;

architecture behaviour of clock is

    constant  RELOAD1: integer := 6000-1; 
    signal    SAMPLER1: integer range 0 to 6000 := 6000;
	
    constant  RELOAD2: integer := 12-1; 	
    signal  SAMPLER2: integer range 0 to 12:=12;

begin
    process(RESET,CLK_IN)
    begin
        if(RESET='1') then 
            SAMPLER1<=RELOAD1;
            CLK_1k<='0';
        elsif(rising_edge(CLK_IN)) then
            if(SAMPLER1<=0) then    
                SAMPLER1<=RELOAD1;
                CLK_1k<= not CLK_1k;
            else
                SAMPLER1<=SAMPLER1-1;
            end if;
        end if;
    end process;
	
	process(RESET,CLK_IN)
    begin
        if(RESET='1') then 
            SAMPLER2<=RELOAD2;
            CLK_2k<='0';
        elsif(rising_edge(CLK_IN)) then
            if(SAMPLER2<=0) then    
                SAMPLER2<=RELOAD2;
                CLK_2k<= not CLK_2k;
            else
                SAMPLER2<=SAMPLER2-1;
            end if;
        end if;
    end process;
end architecture;