--================================================================================--
--Title: idexreg.vhd
--Description: 
-- Thisthe execute (EX) blocks.
--Author: Jose Jurado
--Date: Wednesday, February 06, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity IDEXreg is
  port(
		clk 		: in std_logic;
		nReset		: in std_logic;
		stall 		: in std_logic;
		bubble		: in std_logic;
	
		id_aluop		: in std_logic_vector(5 downto 0);
		id_alusrc		: in std_logic;
		id_bne		: in std_logic;
		id_branch		: in std_logic;
		id_halt		: in std_logic;
		id_imm32		: in std_logic_vector(31 downto 0);
		id_jal		: in std_logic;
		id_jr		: in std_logic;
		id_jump		: in std_logic;
		id_jumpaddr		: in std_logic_vector(31 downto 0);
		id_lui		: in std_logic;			
		id_memtoreg		: in std_logic;
		id_memwen		: in std_logic;
		id_npc		: in std_logic_vector(31 downto 0);
		id_rdat1		: in std_logic_vector(31 downto 0);
		id_rdat2		: in std_logic_vector(31 downto 0);
		id_regwen		: in std_logic;
		id_rs		: in std_logic_vector(4 downto 0);
		id_rt		: in std_logic_vector(4 downto 0);
		id_rw		: in std_logic_vector(4 downto 0);

		ex_aluop		: out std_logic_vector(5 downto 0);
		ex_alusrc		: out std_logic;
		ex_bne		: out std_logic;
		ex_branch		: out std_logic;
		ex_halt		: out std_logic;
		ex_imm32		: out std_logic_vector(31 downto 0);
		ex_jal		: out std_logic;
		ex_jr		: out std_logic;
		ex_jump		: out std_logic;
		ex_jumpaddr		: out std_logic_vector(31 downto 0);
		ex_lui		: out std_logic;
		ex_memtoreg		: out std_logic;
		ex_memwen		: out std_logic;
		ex_npc		: out std_logic_vector(31 downto 0);
		ex_rdat1		: out std_logic_vector(31 downto 0);
		ex_rdat2		: out std_logic_vector(31 downto 0);
		ex_regwen		: out std_logic;
		ex_rs 		: out std_logic_vector(4 downto 0);
		ex_rt 		: out std_logic_vector(4 downto 0);
		ex_rw		: out std_logic_vector(4  downto 0)
	
	);
end IDEXreg;

architecture dataflow of IDEXreg is

  --========================--
  -- COMPONENT DECLARATIONS --
  --========================--

  --===================--
  -- SIGNAL DECLARATIONS --
  --=====================--
	signal aluop		: std_logic_vector(5 downto 0);
	signal alusrc		: std_logic;
	signal bne 			: std_logic;
	signal branch		: std_logic;
	signal halt			: std_logic;
	signal imm32		: std_logic_vector(31 downto 0);
	signal jal			: std_logic;
	signal jr				: std_logic;
	signal jump			: std_logic;
	signal jumpaddr	: std_logic_vector(31 downto 0);
	signal lui			: std_logic;
	signal memtoreg	: std_logic;
	signal memwen		: std_logic;
	signal npc			: std_logic_vector(31 downto 0);
	signal rdat1		: std_logic_vector(31 downto 0);
	signal rdat2		: std_logic_vector(31 downto 0);
	signal regwen		: std_logic;
	signal rs 			: std_logic_vector(4 downto 0);
	signal rt 			: std_logic_vector(4 downto 0);
	signal rw				: std_logic_vector(4  downto 0);

begin
	seqLogic : process(clk, nReset, stall)
	begin
		if (nReset = '0') then
		aluop <= (others => '0');
		alusrc <= '0';
		bne <= '0';
		branch <= '0';
		halt <= '0';
		imm32 <= (others => '0');
		jal <= '0';
		jr <= '0';
		jump <= '0';
		jumpaddr <= (others => '0');
		lui <= '0';
		memtoReg <= '0';
		memwen <= '0';
		npc <= (others => '0');
		rdat1 <= (others => '0');
		rdat2 <= (others => '0');
		regwen <= '0';
		rs <= (others => '0');
		rt <= (others => '0');
		rw <= (others => '0');
		elsif(rising_edge(clk))then
			if(bubble='1' and stall='0')then
				aluop <= (others => '0');
				alusrc <= '0';
				bne <= '0';
				branch <= '0';
				halt <= '0';
				imm32 <= (others => '0');
				jal <= '0';
				jr <= '0';
				jump <= '0';
				jumpaddr <= (others => '0');
				lui <= '0';
				memtoReg <= '0';
				memwen <= '0';
				npc <= (others => '0');
				rdat1 <= (others => '0');
				rdat2 <= (others => '0');
				regwen <= '0';
				rs <= (others => '0');
				rt <= (others => '0');
	 			rw <= (others => '0');	
			elsif(stall='0')then	
				aluop <= id_aluop;
				alusrc <= id_alusrc;
				bne <= id_bne;
				branch <= id_branch;
				halt <= id_halt;
				imm32 <= id_imm32;
				jal <= id_jal;
				jr <= id_jr;
				jump <= id_jump;
				jumpaddr <= id_jumpaddr;
				lui <= id_lui;
				memtoreg <= id_memtoreg;
				memwen <= id_memwen;
				npc <= id_npc;
				rdat1 <= id_rdat1;
				rdat2 <= id_rdat2;
				regwen <= id_regwen;
				rs <= id_rs;
				rt <= id_rt;
				rw <= id_rw;
			end if;
		end if;
	end process;
	ex_aluop <= aluop;
	ex_alusrc <= alusrc;
	ex_bne <= bne;
	ex_branch <= branch;
	ex_halt <= halt;
	ex_imm32 <= imm32;
	ex_jal <= jal;
	ex_jr <= jr;
	ex_jump <= jump;
	ex_jumpaddr <= jumpaddr;
	ex_lui <= lui;
	ex_memtoreg <= memtoreg;
	ex_memwen <= memwen;
	ex_npc <= npc;
	ex_rdat1 <= rdat1;
	ex_rdat2 <= rdat2;
	ex_regwen <= regwen;
	ex_rs <= rs;
	ex_rt <= rt;
	ex_rw <= rw;

end dataflow;
