library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all ?;

entity mips_monociclo_datapath is
generic (p_SIZE : integer :=  32);
  port(
  i_CLK   			: in std_logic;
  i_RST   			: in std_logic;
  --1-Bit from control signal
  i_RegDst			: in std_logic;
  i_ALUSrc   			: in std_logic;
  i_MemtoReg			: in std_logic;
  i_RegWrite			: in std_logic;
  i_MemWrite 			: in std_logic;
  i_Jump			: in std_logic;
  i_Branch			: in std_logic;
  --2-Bit from control signal
  i_ALUOp			: in std_logic_vector(1 downto 0);		
  --Output to control
  o_OP		   		: out std_logic_vector(5 downto 0)
  );
end mips_monociclo_datapath;

architecture arch1 of mips_monociclo_datapath is

  component SOMADOR is
    generic (p_SIZE : integer := 32);
	   port(
		i_A		: in std_logic_vector(p_SIZE-1 DOWNTO 0);
		i_B	  	: in std_logic_vector(p_SIZE-1 DOWNTO 0);
		o_R     	: out std_logic_vector (p_SIZE-1 DOWNTO 0)
		);
  end component;
	
  component MUX_32 is
    generic (p_SIZE : integer := 32);
	   port(
		i_A   		: in std_logic_vector(p_SIZE-1 downto 0);
		i_B  		: in std_logic_vector(p_SIZE-1 downto 0);
		i_SEL 		: in std_logic;
		o_R   		: out std_logic_vector(p_SIZE-1 downto 0)
		);
  end component;
  
  component MUX_5 is
    generic (p_SIZE : integer := 5);
	   port(
		i_A   		: in std_logic_vector(p_SIZE-1 downto 0);
		i_B   		: in std_logic_vector(p_SIZE-1 downto 0);
		i_SEL 		: in std_logic;
		o_R   		: out std_logic_vector(p_SIZE-1 downto 0)
		);
  end component;
	
  component SIG_EX_16_32 is
    port(
	 i_A  	: in std_logic_vector(15 DOWNTO 0);
    o_R     : out std_logic_vector (31 DOWNTO 0)
	 );
  end component;

  component ALU_OP is
    port(
    i_ALUOp   	 	: in std_logic_vector(1 downto 0); --Vem do controle
    i_INSTRUCT  	: in std_logic_vector(5 downto 0); --Vem da instrução da memoria
    o_ALU_OUT   	: out std_logic_vector(2 downto 0)
    );
  end component;
  
  component ALU_32 is
    port(
    i_A			: in std_logic_vector(31 downto 0);
    i_B			: in std_logic_vector(31 downto 0);
    i_ALU_OUT   	: in std_logic_vector(2 downto 0);
    o_R   		: out std_logic_vector(31 downto 0);
    o_Zero		: out std_logic
    );
  end component;
  
  component INST_MEMORY is
    generic (p_SIZE : integer :=  32);
    port(
    i_PC_ADDR 		: in std_logic_vector(p_SIZE-1 downto 0);
    i_CLK 		: in std_logic;
    o_INSTRUCT		: out std_logic_vector(p_SIZE-1 downto 0)
    );
  end component;
  
  component PC is
    generic (p_SIZE : integer :=  32);
    port(
    i_RST 		: in std_logic;
    i_CLK 		: in std_logic;
    i_nextPC   		: in std_logic_vector(p_SIZE-1 downto 0);
    o_PC		: out std_logic_vector(p_SIZE-1 downto 0)
    );
  end component;
  
  component BANK_REGIS is
    generic (p_SIZE : integer :=  32);
    port(
    i_CLK		:  in std_logic;
    i_RST		:  in std_logic;
    i_RegWrite		:  in std_logic; --enable para escrever no banco
    i_RD_ADDR_A		:  in std_logic_vector (4 downto 0); --Instruction 25..21 RS
    i_RD_ADDR_B		:  in std_logic_vector (4 downto 0); --Instruction 20..16 RD
    i_WR_ADDR		:  in std_logic_vector (4 downto 0); -- RT
    i_WR_DATA		:  in std_logic_vector (p_SIZE-1 downto 0);
    o_RD_DATA_A		:  out std_logic_vector(p_SIZE-1 downto 0);
    o_RD_DATA_B		:  out std_logic_vector(p_SIZE-1 downto 0)
    );
  end component;
  
  component SHIFT_2_LEFT_32 is
    port(
    i_A  	:  in  std_logic_vector(p_SIZE-1 downto 0);
    o_R  	:  out std_logic_vector(p_SIZE-1 downto 0)
    );
  end component;
  
  component DATA_MEMORY is
   generic (p_SIZE : integer := 32);
   port(
   i_DATA  		: in  std_logic_vector(p_SIZE-1 downto 0);
   i_ADDR		: in  std_logic_vector(p_SIZE-1 downto 0);
   i_CLK		: in  std_logic;
   i_MemWrite	 	: in  std_logic;
   o_DATA		: out std_logic_vector(p_SIZE-1 downto 0)
   );
  end component;
  
  component SHIFT_2_LEFT_26_28 is
    port(
    i_A  	:  in  std_logic_vector(25 downto 0);
    o_R  	:  out std_logic_vector(27 downto 0)
    );
  end component;
  
  component CONC_28_32 is
    port(
    i_A		:  in  std_logic_vector(27 downto 0); --Sai do SHIFT_2_LEFT_26_28
    i_B		:  in  std_logic_vector(31 downto 0); --Esse é uma parte do PC + 4 (31..28)
    o_R		:  out std_logic_vector(31 downto 0)  --Vai para um mux de selecao do jump		
    );
  end component;
  
  component divisor_frequencia is
    port(
    i_CLK	: in std_logic;
    o_CLK_L 	: out std_logic
    );
  end component;
	 
  
  signal w_PC_4_OUT 		: std_logic_vector(31 downto 0);
  signal w_PC			: std_logic_vector(31 downto 0);
  signal w_NEXT_PC		: std_logic_vector(31 downto 0);
  signal w_CLK_L		: std_logic;
  signal w_AND_OUT  		: std_logic;
  signal w_ZERO_OUT     	: std_logic;
 
  signal w_INSTRUCTION  	: std_logic_vector(31 downto 0);
  signal w_OUT_MUX_5A   	: std_logic_vector(4 downto 0);
  signal w_OUT_SIG		: std_logic_vector(31 downto 0);
  signal w_OPERATION		: std_logic_vector(2 downto 0);
  signal w_OUT_MUX_ALU  	: std_logic_vector(31 downto 0);
  signal w_OUT_RD_A		: std_logic_vector(31 downto 0);
  signal w_OUT_RD_B		: std_logic_vector(31 downto 0);
  signal w_OUT_ALU_32		: std_logic_vector(31 downto 0);
  signal w_OUT_SHIFT_32 	: std_logic_vector(31 downto 0);
  signal w_OUT_ADDER 		: std_logic_vector(31 downto 0);
  signal w_OUT_MUX_BRANCH	: std_logic_vector(31 downto 0);
  signal w_OUT_SHIFT_28		: std_logic_vector(27 downto 0);
  signal w_OUT_CONC		: std_logic_vector(31 downto 0);
  signal w_OUT_DATAMEM		: std_logic_vector(31 downto 0);
  signal w_OUT_MUX_DATA		: std_logic_vector(31 downto 0);

 
  -- FORMATO DA INSTRUÇÂO
  signal w_OPCODE		: std_logic_vector(5 downto 0);
  signal w_RS    		: std_logic_vector(4 downto 0);
  signal w_RT 			: std_logic_vector(4 downto 0);
  signal w_RD 			: std_logic_vector(4 downto 0);
  signal w_SHAMT 		: std_logic_vector(4 downto 0);
  signal w_FUNCTION		: std_logic_vector(5 downto 0);
  signal w_IMEDIATE		: std_logic_vector(15 downto 0);
  signal w_IJUMP		: std_logic_vector(25 downto 0);

  
begin
  w_OPCODE     		<= w_INSTRUCTION(31 downto 26);	
  w_RS    	  	<= w_INSTRUCTION(25 downto 21);
  w_RT 		 	<= w_INSTRUCTION(20 downto 16);
  w_RD 		 	<= w_INSTRUCTION(15 downto 11);
  w_SHAMT 	 	<= w_INSTRUCTION(10 downto 6);
  w_FUNCTION 		<= w_INSTRUCTION(5 downto 0);
  w_IMEDIATE 		<= w_INSTRUCTION(15 downto 0);
  w_IJUMP		<= w_INSTRUCTION(25 downto 0);
  



u_PC : entity work.PC
	generic map(
		p_SIZE => 32
	)
	port map(
		i_RST		=>  i_RST,
		i_CLK   	=>  w_CLK_L, --Clock before the frequency_divisor
		i_nextPC	=>  w_NEXT_PC,
		o_PC   		=>  w_PC
	);

u_INSTRUCTION_MEMORY : entity work.INST_MEMORY
	generic map(
		p_SIZE => 32
	)
	port map(
		i_CLK   		=>  i_CLK,
		i_PC_ADDR		=>  w_PC,
		o_INSTRUCT  		=>  w_INSTRUCTION
	);
	
--
--
w_PC_4_OUT <= w_PC + x"00000004"; 	 -- Adder of PC+4
--
--
u_MUX_5_A  :  entity work.MUX_5
  generic map(
    p_SIZE => 5
  )
  port map(
    i_A   	=>  w_RT,
    i_B		=>  w_RD,
    i_SEL   	=>  i_RegDst,
    o_R     	=>  w_OUT_MUX_5A
  );

u_BANK_REGIS : entity work.BANK_REGIS
  generic map(
    p_SIZE => 32
  ) 
  port map(
  i_CLK			=>  w_CLK_L,
  i_RST			=>  i_RST,
  i_RegWrite		=>  i_RegWrite,
  i_RD_ADDR_A		=>  w_RS, --Instruction 25..21 RS
  i_RD_ADDR_B		=>  w_RT, --Instruction 20..16 RT
  i_WR_ADDR		=>  w_OUT_MUX_5A,-- RT or RD
  i_WR_DATA		=>  w_OUT_MUX_DATA,
  o_RD_DATA_A		=>  w_OUT_RD_A,
  o_RD_DATA_B		=>  w_OUT_RD_B
  );


u_SIGNAL_EXTENDER : entity work.SIG_EX_16_32
  port map(
  i_A		=>  w_IMEDIATE,
  o_R  		=>  w_OUT_SIG
  );
  
u_ALU_CONTROL  :  entity work.ALU_OP
  port map(
  i_ALUOp   	=>  i_ALUOp,			
  i_INSTRUCT  	=>  w_FUNCTION,
  o_ALU_OUT   	=>  w_OPERATION
  );
	
u_MUX_32_ALU  :  entity work.MUX_32
  generic map(
    p_SIZE => 32
  )
  port map(
  i_A  		=>  w_OUT_RD_B,
  i_B	   	=>  w_OUT_SIG,
  i_SEL		=>  i_ALUSrc,
  o_R  		=>  w_OUT_MUX_ALU
  );

u_ALU_32  :  entity work.ALU_32
  port map(
    i_A		=>  w_OUT_RD_A,
    i_B		=>  w_OUT_MUX_ALU,
    i_ALU_OUT 	=>  w_OPERATION,		
    o_R   	=>  w_OUT_ALU_32,
    o_Zero	=>  w_ZERO_OUT
  );
	
w_AND_OUT <= i_Branch AND w_ZERO_OUT;  -- An AND port for the selection of a MUX

u_SHIFT_32 : entity work.SHIFT_2_LEFT_32
  port map(
  i_A		=>  w_OUT_SIG,
  o_R 		=>  w_OUT_SHIFT_32
  );

u_SOMADOR_A : entity work.SOMADOR
  generic map(
    p_SIZE => 32
  )
  port map(
  i_A		=>  w_PC_4_OUT,
  i_B		=>  w_OUT_SHIFT_32,
  o_R  		=>  w_OUT_ADDER
  );
  
u_MUX_32_BRANCH	 :  entity work.MUX_32
  generic map(
    p_SIZE => 32
  )
  port map(
  i_A  		=>  w_PC_4_OUT,
  i_B	   	=>  w_OUT_ADDER,
  i_SEL		=>  w_AND_OUT,
  o_R  		=>  w_OUT_MUX_BRANCH
  );

u_SHIFT_26_28  :  entity work.SHIFT_2_LEFT_26_28
  port map(
  i_A		=>  w_IJUMP,  
  o_R     	=>  w_OUT_SHIFT_28
  );

u_CONCATENADOR :  entity work.CONC_28_32
  port map(
  i_A		=> w_OUT_SHIFT_28,		
  i_B		=> w_PC_4_OUT,
  o_R  		=> w_OUT_CONC
  );
  
u_MUX_32_JUMP  :  entity work.MUX_32
  generic map(
    p_SIZE => 32
  )
  port map(
  i_A  		=>  w_OUT_MUX_BRANCH,
  i_B	  	=>  w_OUT_CONC,
  i_SEL		=>  i_Jump,
  o_R  		=>  w_NEXT_PC
  );

u_DATA_MEMORY  :  entity work.DATA_MEMORY
  generic map(
    p_SIZE=> 32
  )
  port map(
  i_DATA  	=> w_OUT_RD_B,
  i_ADDR	=> w_OUT_ALU_32,
  i_CLK		=> i_CLK,
  i_MemWrite	=> i_MemWrite,
  o_DATA	=> w_OUT_DATAMEM
  );

u_MUX_32_DATA  :  entity work.MUX_32
  generic map(
    p_SIZE=> 32
  )
  port map(
  i_A  		=>  w_OUT_ALU_32,
  i_B	   	=>  w_OUT_DATAMEM,
  i_SEL		=>  i_MemtoReg,
  o_R  		=>  w_OUT_MUX_DATA
  );
  
u_DIV_FREQ  :  entity work.divisor_frequencia
  port map(
  i_CLK   	=>  i_CLK,
  o_CLK_L 	=>  w_CLK_L
  );


  o_OP <= w_OPCODE;
end arch1;
