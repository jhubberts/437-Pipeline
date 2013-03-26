--================================================================================--
--Title: pipe_if.vhd
--Description: 
-- The "Instruction Fetch" stage of the pipelined processor.
--Author: John J. Hubberts
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity pipe_if is
  port(
  --==================--
  -- TOP LEVEL INPUTS --
  --==================--
  clk : in std_logic;
  nReset : in std_logic;
  pcwe : in std_logic;

  --=================--
  -- INPUTS FROM MEM --
  --=================--
  branch : in std_logic;
  branchAddr : in std_logic_vector(31 downto 0);
  jrAddr : in std_logic_vector(31 downto 0);
  jrop : in std_logic;
  jumpAddr : in std_logic_vector(31 downto 0);
  pcsrc : in std_logic;
  shutdown : in std_logic;

  --=================--
  -- PIPEREG OUTPUTS --
  --=================--
  r_inst : out std_logic_vector(31 downto 0);
  r_npc : out std_logic_vector(31 downto 0);

  --================--
  -- ICACHE SIGNALS --
  --================--
  iMemRead  : out  std_logic;
  iMemAddr  : out  std_logic_vector (31 downto 0);
  iMemData  : in std_logic_vector (31 downto 0)

);
end pipe_if;

architecture behavioral of pipe_if is

  --========================--
  -- COMPONENT DECLARATIONS --
  --========================--
  component adder32 is
    port(
      subop    : in std_logic;
      A        : in std_logic_vector(31 downto 0);
      B        : in std_logic_vector(31 downto 0);
      signedop : in std_logic;
      adderout : out std_logic_vector(31 downto 0);
      negative : out std_logic;
      overflow : out std_logic);
  end component;

  --=====================--
  -- SIGNAL DECLARATIONS --
  --=====================--
  signal PC, NPC, PCnxt : std_logic_vector(31 downto 0);

begin
  ncpAdder : adder32 port map(
    subop => '0', -- Addition operation
    A => PC, -- Add to the PC
    B => x"00000004", -- Always add 4
    signedop => '1', -- Signed operation
    adderout => NPC, -- Result is Next Program Counter
    negative => open, -- We don't care about negative
    overflow => open); -- We don't care about overflow

  seqLogic : process(clk, nReset,pcwe)
  begin
    if(nReset='0')then
      PC <= (others => '0');
      PCnxt <= (others => '0');
    elsif(clk'event and clk='1' and pcwe='0')then
      PC <= PCnxt;
    end if;
  end process;

  PCnxt <= NPC when pcsrc='0' else
           branchAddr when branch='1' else
           jrAddr when jrop='1' else
           jumpAddr;
end behavioral;
