library ieee;
use ieee.std_logic_1164.all;

entity CONC_28_32 is
  port(
  i_A			:	in  std_logic_vector(27 downto 0); --Sai do SHIFT_2_LEFT_26_28
  i_B			:	in  std_logic_vector(31 downto 0); --Esse é uma parte do PC + 4 (31..28)
  o_R			:  out std_logic_vector(31 downto 0)  --Vai para um mux de selecao do jump		
  );
end CONC_28_32;

architecture arch1 of CONC_28_32 is
begin
  o_R(27 downto 0) <= i_A(27 downto 0);
  o_R(31 downto 28) <= i_B(31 downto 28);  
end arch1;