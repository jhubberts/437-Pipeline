--===========================================================================================--
--Title: EXMEMreg.vhd
--Description: The register between the "Execution" and "Memory Access" stages of the pipeline.
--Author: John J. Hubberts
--Date: Wednesday, February 06, 2013
--Version: 1.0
--===========================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity EXMEMreg is
  port(
  --==================--
  -- TOP LEVEL INPUTS --
  --==================--
  clk : in std_logic;
  nReset : in std_logic;
  stall : in std_logic;
  bubble : in std_logic;

  --============--
  -- MEM INPUTS --
  --============--
  ex_aluout : in std_logic_vector(31 downto 0);
  ex_bne : in std_logic;
  ex_branch : in std_logic;
  ex_branchaddr : in std_logic_vector(31 downto 0);
  ex_halt : in std_logic;
  ex_jal : in std_logic;
  ex_jr : in std_logic;
  ex_jraddr : in std_logic_vector(31 downto 0);
  ex_jump : in std_logic;
  ex_jumpaddr : in std_logic_vector(31 downto 0);
  ex_memdatain : in std_logic_vector(31 downto 0);
  ex_memtoreg : in std_logic;
  ex_memwen : in std_logic;
  ex_npc : in std_logic_vector(31 downto 0);
  ex_regwen : in std_logic;
  ex_rw : in std_logic_vector(4 downto 0);
  ex_zero : in std_logic;

  --============--
  -- WB OUTPUTS --
  --============--
  mem_aluout : out std_logic_vector(31 downto 0);
  mem_bne : out std_logic;
  mem_branch : out std_logic;
  mem_branchaddr : out std_logic_vector(31 downto 0);
  mem_halt : out std_logic;
  mem_jal : out std_logic;
  mem_jr : out std_logic;
  mem_jraddr : out std_logic_vector(31 downto 0);
  mem_jump : out std_logic;
  mem_jumpaddr : out std_logic_vector(31 downto 0);
  mem_memdatain : out std_logic_vector(31 downto 0);
  mem_memtoreg : out std_logic;
  mem_memwen : out std_logic;
  mem_npc : out std_logic_vector(31 downto 0);
  mem_regwen : out std_logic;
  mem_rw : out std_logic_vector(4 downto 0);
  mem_zero : out std_logic
);
end EXMEMreg;

architecture behavioral of EXMEMreg is

  --=====================--
  -- SIGNAL DECLARATIONS --
  --=====================--
  signal aluout : std_logic_vector(31 downto 0);
  -- Output of the alu

  signal bne : std_logic;
  -- Whether or not this operation is a bne (1 for yes, 0 for no)

  signal branch : std_logic;
  -- Whether or not this operation is a bne or beq (1 for yes, 0 for no)

  signal branchaddr : std_logic_vector(31 downto 0);
  -- Signed increment to be added to PC if branch is taken

  signal halt : std_logic;
  -- Whether or not this operation is a halt (1 for yes, 0 for no)

  signal jal : std_logic;
  -- Whether or not this operation is a jal (1 for yes, 0 for no)

  signal jr : std_logic;
  -- Whether or not this operation is a jr (1 for yes, 0 for no)

  signal jraddr : std_logic_vector(31 downto 0);
  -- Address to jump to in case of a jr operation

  signal jump : std_logic;
  -- Whether or not this operation is a jump, jr, or jal (1 for yes, 0 for no)

  signal jumpaddr : std_logic_vector(31 downto 0);
  -- Address to jump to in case of a jump operation

  signal memdatain : std_logic_vector(31 downto 0);
  -- The write data for the dCache

  signal memtoreg : std_logic;
  -- 1 if data from memory is being written to regfile, '0' if from alu (or nothing)

  signal memwen : std_logic;
  -- Write enable for data memory

  signal npc : std_logic_vector(31 downto 0);
  -- PC+4 for the instruction at a given phase

  signal regwen : std_logic;
  -- Write enable for register file (1 for write, 0 for don't write)

  signal rw : std_logic_vector(4 downto 0);
  -- 5-bit address of register being written to

  signal zero : std_logic;
  -- Zero flag from ALU, used for bne and beq

begin
  --==================--
  -- SEQUENTIAL LOGIC --
  --==================--
  seqLogic : process(clk, nReset)
  begin
    -- If either the asynchonous reset is detected, or the synchronous reset has been
    --  detected on a rising edge, reset all the values, and negate this operation
    if(nReset='0')then
      aluout <= (others => '0');
      bne <= '0';
      branch <= '0';
      branchaddr <= (others => '0');
      halt <= '0';
      jal <= '0';
      jr <= '0';
      jraddr <= (others => '0');
      jump <= '0';
      jumpaddr <= (others => '0');
      memdatain <= (others => '0');
      memtoreg <= '0';
      memwen <= '0';
      npc <= (others => '0');
      regwen <= '0';
      rw <= (others => '0');
      zero <= '0';
    elsif(rising_edge(clk))then
      if(bubble='1' and stall='0')then
      	aluout <= (others => '0');
      	bne <= '0';
      	branch <= '0';
      	branchaddr <= (others => '0');
      	halt <= '0';
      	jal <= '0';
      	jr <= '0';
      	jraddr <= (others => '0');
      	jump <= '0';
      	jumpaddr <= (others => '0');
      	memdatain <= (others => '0');
      	memtoreg <= '0';
      	memwen <= '0';
      	npc <= (others => '0');
      	regwen <= '0';
      	rw <= (others => '0');
      	zero <= '0';
      elsif(stall='0')then
      	aluout <= ex_aluout;
      	bne <= ex_bne;
      	branch <= ex_branch;
      	branchaddr <= ex_branchaddr;
      	halt <= ex_halt;
      	jal <= ex_jal;
      	jr <= ex_jr;
      	jraddr <= ex_jraddr;
      	jump <= ex_jump;
      	jumpaddr <= ex_jumpaddr;
      	memdatain <= ex_memdatain;
      	memtoreg <= ex_memtoreg;
      	memwen <= ex_memwen;
      	npc <= ex_npc;
      	regwen <= ex_regwen;
      	rw <= ex_rw;
      	zero <= ex_zero;
    	end if;
    end if;
  end process;

  --=====================--
  -- COMBINATIONAL LOGIC --
  --=====================--

  -- Attach the internal register to the outputs
  mem_aluout <= aluout;
  mem_bne <= bne;
  mem_branch <= branch;
  mem_branchaddr <= branchaddr;
  mem_halt <= halt;
  mem_jal <= jal;
  mem_jr <= jr;
  mem_jraddr <= jraddr;
  mem_jump <= jump;
  mem_jumpaddr <= jumpaddr;
  mem_memdatain <= memdatain;
  mem_memtoreg <= memtoreg;
  mem_memwen <= memwen;
  mem_npc <= npc;
  mem_regwen <= regwen;
  mem_rw <= rw;
  mem_zero <= zero;

end behavioral;
