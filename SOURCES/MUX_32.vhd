library ieee ;
use ieee.std_logic_1164.all ;

entity MUX_32 is
generic (p_SIZE : integer :=  32);
	port(
	i_A   : in std_logic_vector(p_SIZE-1 downto 0);
	i_B   : in std_logic_vector(p_SIZE-1 downto 0);
	i_SEL : in std_logic;
	o_R   : out std_logic_vector(p_SIZE-1 downto 0)
	);
end MUX_32;

architecture arch1 of MUX_32 is
begin
	process (i_A,i_B,i_SEL)
		begin
		if (i_SEL = '0') then
		o_R <= i_A;
		else
		o_R <= i_B;
		end if;
	end process;
end arch1;