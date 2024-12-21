library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SEQUENCER is
    port(
	
        RESET: in std_logic;
        CLK_IN: in std_logic; 				
		CMP_DIRECTION : out std_logic;
        CMP: out integer range 0 to 255		
				
    );
end SEQUENCER; 

architecture behaviour of SEQUENCER is 
  
  
	
    subtype SEQ_STATE is std_logic_vector(2 downto 0);
  
    constant IDLE      : SEQ_STATE := "000";
    constant RAMPUP   : SEQ_STATE := "001";
    constant RUN       : SEQ_STATE := "010";
    constant RAMPDN   : SEQ_STATE := "011";
    constant STOP      : SEQ_STATE := "100";

    signal SEQState    : SEQ_STATE := IDLE;
    subtype iTIME is unsigned(12 downto 0);	
	
    constant T_40MS   : iTIME := to_unsigned(40-1,  iTIME'length);      
    constant T_1S   : iTIME := to_unsigned(1000-1, iTIME'length);
    constant T_2S   : iTIME := to_unsigned(2000-1, iTIME'length);
    constant T_3S   : iTIME := to_unsigned(3000-1, iTIME'length);
	
    signal CLK_TIMER       : iTIME := (others => '0');
    signal SAMPLES_COUNTER     : iTIME := (others => '0');
	

begin

  
 process(RESET, CLK_IN)
    begin
        if RESET = '1' then
            CLK_TIMER <= T_1S;
            SAMPLES_COUNTER <= (others => '0');
            SEQState <= IDLE;
        elsif rising_edge(CLK_IN) then
            CLK_TIMER <= CLK_TIMER - 1;
            case SEQState is
                when IDLE =>
                    CMP <= 0;					
                    if CLK_TIMER = 0 then
                        SEQState <= RAMPUP;
                        CLK_TIMER <= T_2S;
                    end if;
					
                when RAMPUP =>
                    if CLK_TIMER = 0 then
                        SEQState <= RUN;
                        CLK_TIMER <= T_3S;		
                    elsif SAMPLES_COUNTER = 0 then
                        SAMPLES_COUNTER <= T_40MS;                     
						CMP<=CMP+5;    
                    else
                        SAMPLES_COUNTER <= SAMPLES_COUNTER - 1;
                    end if;
				
				 when RUN =>
					CMP <= 255;					
                    if CLK_TIMER = 0 then
                        SEQState <= RAMPDN;
                        CLK_TIMER <= T_2S;
                    end if;				 
				
				when RAMPDN =>
                    if CLK_TIMER = 0 then
                        SEQState <= STOP;
                        CLK_TIMER <= T_2S;
                    elsif SAMPLES_COUNTER = 0 then
                        SAMPLES_COUNTER <= T_40MS;                       
						CMP<=CMP-5;
                    else
                        SAMPLES_COUNTER <= SAMPLES_COUNTER - 1;
                    end if;
				
				when STOP =>
                    CMP <= 0;
					if CLK_TIMER = 0 then
						CMP_DIRECTION <= not CMP_DIRECTION;   
						SEQState <= RAMPUP;
						CLK_TIMER <= T_2S;
						SAMPLES_COUNTER <= SAMPLES_COUNTER - 1;
					end if;			
					
                when others =>
                    SEQState <= IDLE;
                    CLK_TIMER <= T_1S;
                    SAMPLES_COUNTER <= (others => '0');
            end case;
        end if;
    end process;
end architecture;
