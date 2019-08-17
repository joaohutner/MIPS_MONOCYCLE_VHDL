library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--tabs corrigidos
entity ALU_32 is
  port(
  i_A					: in std_logic_vector(31 downto 0);
  i_B					: in std_logic_vector(31 downto 0);
  i_ALU_OUT   		: in std_logic_vector(2 downto 0);
  o_R   				: out std_logic_vector(31 downto 0);
  o_Zero				: out std_logic
  );
end ALU_32;

architecture arch1 of ALU_32 is
  signal w_ALU_OUT : std_logic_vector(31 downto 0);
begin
  process (i_A,i_B,i_ALU_OUT)
    begin
	   case i_ALU_OUT IS
		
		  when "000" =>
		    w_ALU_OUT <= i_A AND i_B;
		  
		  when "001" =>
		    w_ALU_OUT <= i_A OR i_B;
			 
		  when "010" =>
		    w_ALU_OUT <= i_A + i_B;
		  
		  when "110" =>
		    w_ALU_OUT <= i_A - i_B;
		  
		  when others => NULL;
		    w_ALU_OUT <= x"00000000";
		  
		end case;
  end process;
  o_R <= w_ALU_OUT;
  o_Zero <= '1' when w_ALU_OUT = x"00000000" else '0';
end arch1;