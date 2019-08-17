library ieee;
use ieee.std_logic_1164.all;

entity PC is
generic (p_SIZE : integer :=  32);
  port(
  i_RST 		: in std_logic; 
  i_CLK 		: in std_logic;
  i_nextPC  : in std_logic_vector(p_SIZE-1 downto 0);
  o_PC		: out std_logic_vector(p_SIZE-1 downto 0)
  );
end PC;

architecture arch1 of PC is
signal w_Q: std_logic_vector(p_SIZE-1 DOWNTO 0):= x"00400000"; --Inicia nessa posição
begin
  process (i_RST,i_CLK,i_nextPC)
    begin
	   if(i_RST	= '1') then
			w_Q <= x"00400000"; --Caso resete volta para essa posição
		elsif (rising_edge(i_CLK)) then
			w_Q <= i_nextPC; --Se não resetar a cada clock de memória receberá valor 
		end if;
  end process;
  o_PC <= w_Q;
end arch1;