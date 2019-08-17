library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BANK_REGIS is
generic (p_SIZE : integer :=  32);
  port(
  i_CLK				:  in std_logic;
  i_RST				:  in std_logic;
  i_RegWrite		:	in std_logic; --enable para escrever no banco
  i_RD_ADDR_A		:  in std_logic_vector (4 downto 0); --Instruction 25..21 RS
  i_RD_ADDR_B		:  in std_logic_vector (4 downto 0); --Instruction 20..16 RD
  i_WR_ADDR			:  in std_logic_vector (4 downto 0); -- RT
  i_WR_DATA			:  in std_logic_vector (p_SIZE-1 downto 0);
  o_RD_DATA_A		:  out std_logic_vector(p_SIZE-1 downto 0);
  o_RD_DATA_B		:  out std_logic_vector(p_SIZE-1 downto 0)
  );
end BANK_REGIS;

architecture arch1 of BANK_REGIS is

type t_MEM is array(31 downto 0) of std_logic_vector (p_SIZE-1 downto 0);
signal w_REG_BANK : t_MEM := (others=>(others=>'0'));

begin
  u_write: process (i_CLK, i_RegWrite, i_RST)
    begin
	 if(i_RST = '1')then
	   w_REG_BANK <= (others=>(others=>'0'));
	   elsif(rising_edge(i_CLK))then
		  if (i_RegWrite='1') then
		    w_REG_BANK(to_integer(unsigned(i_WR_ADDR))) <= i_WR_DATA;
		  end if;
	 end if;
  end process;
  o_RD_DATA_A <= w_REG_BANK(to_integer(unsigned(i_RD_ADDR_A)));
  o_RD_DATA_B <= w_REG_BANK(to_integer(unsigned(i_RD_ADDR_B)));
end arch1;