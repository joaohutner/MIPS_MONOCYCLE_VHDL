library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --to_integer

entity DATA_MEMORY is
generic (p_SIZE : integer := 32);
  port(
  i_DATA  		: in  std_logic_vector(p_SIZE-1 downto 0);
  i_ADDR	 		: in  std_logic_vector(p_SIZE-1 downto 0);
  i_CLK			: in  std_logic;
  i_MemWrite	: in  std_logic;
  o_DATA			: out std_logic_vector(p_SIZE-1 downto 0)
  );
end DATA_MEMORY;

architecture arch1 of DATA_MEMORY is

type t_MEM is array(255 downto 0) of std_logic_vector(p_SIZE-1 downto 0);

signal w_MEM : t_MEM := (others=>(others=>'0'));

signal w_ADDR : std_logic_vector(7 downto 0);


begin

w_ADDR <= i_ADDR(7 downto 0);
  process (i_CLK, i_MemWrite)
    begin
		if(rising_edge(i_CLK)) then
		  if (i_MemWrite = '1') then
		  w_MEM(to_integer(unsigned(w_ADDR))/4) <= i_DATA;
	     end if;
		end if;
    end process;
  o_DATA <= w_MEM(to_integer(unsigned(w_ADDR)));
end arch1;