library ieee;
use ieee.std_logic_1164.all;

entity divisor_frequencia is
  port(
    i_CLK					: in std_logic;
	 o_CLK_L					: out std_logic
	);
end entity divisor_frequencia;

architecture arch1 of divisor_frequencia is
type STATE is (zero,um,dois,tres);
signal atual : STATE;
signal proximo : STATE;
begin
	-- atual (onde estou?)
  p_ATUAL :process (i_CLK)
  begin
    if (rising_edge(i_CLK)) then
			atual <= proximo;
	 end if;
end process p_ATUAL;
	-- proximo (para onde vou?)
p_PROXIMO : process (atual)
  begin
    case atual is
      when zero=> 
    			proximo <= um;
    			
    	when um=>
    			proximo <= dois;
    			
    	when dois=>
    			proximo <= tres;
    			
    	when tres=>
    			proximo <= zero;
    	
    	--when quatro=>
    		--	proximo <= zero;
    
    end case;
  end process p_PROXIMO;
	--SAÍDAS
  o_CLK_L <= 	'1' when atual = tres else '0';
end arch1;
