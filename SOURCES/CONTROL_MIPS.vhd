library ieee;
use ieee.std_logic_1164.all;

entity mips_monociclo_control is
  port(
  i_OP		   		: in std_logic_vector(5 downto 0);
  i_CLK				: in std_logic;
  --1-Bit Control Signal
  o_RegDst			: out std_logic;
  o_ALUSrc   			: out std_logic;
  o_MemtoReg			: out std_logic;
  o_RegWrite			: out std_logic;
  o_MemWrite 			: out std_logic;
  o_Jump			: out std_logic;
  o_Branch			: out std_logic;
  --2-Bits Control Signal
  o_ALUOp			: out std_logic_vector(1 downto 0)		
  );
end entity mips_monociclo_control;


architecture arch1 of mips_monociclo_control is
--signals
  signal w_R_FORMAT		:		std_logic;
  signal w_LW			:		std_logic;
  signal w_SW			:		std_logic;	
  signal w_BEQ			:		std_logic;
  signal w_ADDI			:		std_logic;
  signal w_JUMP			:		std_logic;
  begin
    w_R_FORMAT			<= '1' when i_OP = "000000" else '0';
    w_LW			<= '1' when i_OP = "100011" else '0';
    w_SW 		  	<= '1' when i_OP = "101011" else '0';
    w_BEQ		  	<= '1' when i_OP = "000100" else '0';
    w_ADDI		  	<= '1' when i_OP = "001000" else '0';
    w_JUMP			<= '1' when i_OP = "000010" else '0';
    --1 bit output
    o_RegDst		<= w_R_FORMAT;
    o_ALUSrc      	<= w_LW or w_SW or w_ADDI;
    o_MemtoReg		<= w_LW;
    o_RegWrite		<= w_R_FORMAT or w_LW or w_ADDI;
    o_MemWrite    	<= w_SW;
    o_Jump		<= w_JUMP;
    o_Branch		<= w_BEQ;
    --2 bits output
    o_ALUOp(1)		<=	w_R_FORMAT;
    o_ALUOp(0)		<= w_BEQ;
end arch1;
