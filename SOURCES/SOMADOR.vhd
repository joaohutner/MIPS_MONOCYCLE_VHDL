library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;

entity SOMADOR is
generic (p_SIZE : integer :=  32);
	port(
	i_A   : in std_logic_vector(p_SIZE-1 downto 0);
	i_B   : in std_logic_vector(p_SIZE-1 downto 0);
	o_R   : out std_logic_vector(p_SIZE-1 downto 0)
	);
end SOMADOR;

architecture arch1 of SOMADOR is
begin
	process (i_A,i_B)
		begin
		o_R <= i_A + i_B;
	end process;
end arch1;