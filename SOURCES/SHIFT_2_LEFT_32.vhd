library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SHIFT_2_LEFT_32 is
  port(
  i_A  :  in  std_logic_vector(31 downto 0);
  o_R  :  out std_logic_vector(31 downto 0)
  );
end SHIFT_2_LEFT_32;

architecture arch1 of SHIFT_2_LEFT_32 is
begin
	o_R(31 downto 2) <= i_A(29 downto 0);
	o_R(1 downto 0) <= "00";
end arch1;