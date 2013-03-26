--================================================================================--
--Title: ifidreg.vhd
--Description: 
-- This is the register block in between the instruction fetch (IF) and the instruction decode (ID) blocks.
--Author: Jose Jurado
--Date: Wednesday, February 06, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity IFIDreg is
  port(
		clk 				: in std_logic;
		nReset			: in std_logic;
		stall 			: in std_logic;
		bubble			: in std_logic;	
		if_npc			: in std_logic_vector(31 downto 0);
		id_npc			: out std_logic_vector(31 downto 0);
		if_instr		: in std_logic_vector(31 downto 0);
		id_instr		: out std_logic_vector(31 downto 0)
	);
end IFIDreg;

architecture dataflow of IFIDreg is

  --========================--
  -- COMPONENT DECLARATIONS --
  --========================--

  --===================--
  -- SIGNAL DECLARATIONS --
  --=====================--
	signal npc		:std_logic_vector(31 downto 0);
	signal instr	:std_logic_vector(31 downto 0);

begin
	seqLogic : process(clk, nReset, stall)
	begin
		if (nReset='0') then
			npc <= (others => '0');
			instr <= (others =>'0');
		elsif (rising_edge(clk)) then
			if(bubble='1' and stall='0') then
				npc <= (others => '0');
				instr <= (others =>'0');
			elsif (stall='0') then 
				npc <= if_npc;
				instr <= if_instr;
			end if;
		end if;
	end process;
	id_npc <= npc;
	id_instr <= instr;

end dataflow;
