library ieee ;
use ieee.std_logic_1164.all ;

entity SIG_EX_16_32 is
	port(
	i_A   : in std_logic_vector(15 downto 0);
	o_R   : out std_logic_vector(31 downto 0)
	);
end SIG_EX_16_32;

architecture arch1 of SIG_EX_16_32 is
begin
	process (i_A)
		begin
		--o_R <= x"0000" and i_A when i_A(15) = '0' else x"FFFF" and i_A;
		o_R(15 downto 0) <= i_A(15 downto 0);
		o_R(31 downto 16) <= (others => '0');
	end process;
end arch1;