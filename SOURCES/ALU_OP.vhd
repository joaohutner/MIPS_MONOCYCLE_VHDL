library ieee ;
use ieee.std_logic_1164.all ;

--tabs corrigidos
entity ALU_OP is
  port(
  i_ALUOp   	: in std_logic_vector(1 downto 0); --Vem do controle
  i_INSTRUCT   : in std_logic_vector(5 downto 0); --Vem da instrução da memoria
  o_ALU_OUT    : out std_logic_vector(2 downto 0)
  );
end ALU_OP;

architecture arch1 of ALU_OP is
begin
  o_ALU_OUT <= "010" when i_ALUOp = "00" or
					(i_ALUOp = "10" and i_INSTRUCT(3 downto 0) = "0000") else
					
					"110" when i_ALUOp = "01" or
					(i_ALUOp(1) = '1' and i_INSTRUCT(3 downto 0) = "0010") else
					
			      "000" when (i_ALUOp = "10" and i_INSTRUCT(3 downto 0) = "0100") else
					
					"001" when (i_ALUOp = "10" and i_INSTRUCT(3 downto 0) = "0101") else
					
					"111" when (i_ALUOp(1) = '1' and i_INSTRUCT(3 downto 0)= "1010");




-- o_ALU_OUT <= "010" when i_ALUOp = "00" else
--					"010" when (i_ALUOp = "01" and i_INSTRUCT = "000001") else
--					
--					"001" when i_ALUOp /= "01" else
--					"001" when i_INSTRUCT /= "000010" else
--					
--					"000" when (i_ALUOp = "01" and i_INSTRUCT = "000000") else
--					"000" when (i_ALUOp = "01" and i_INSTRUCT = "000011") else
--					
--					"110" when i_ALUOp = "01" else
--					"110" when (i_ALUop = "10" and i_INSTRUCT = "100010") else "000";
					

end arch1;