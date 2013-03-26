--===========================================================================================--
--Title: MEMWBreg.vhd
--Description: The register between the "Memory Access" and "Writeback" stages of the pipeline.
--Author: John J. Hubberts
--Date: Wednesday, February 06, 2013
--Version: 1.0
--===========================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity MEMWBreg is
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
  mem_aluout : in std_logic_vector(31 downto 0);
  mem_jal : in std_logic;
  mem_memdataout : in std_logic_vector(31 downto 0);
  mem_memtoreg : in std_logic;
  mem_npc : in std_logic_vector(31 downto 0);
  mem_regwen : in std_logic;
  mem_rw : in std_logic_vector(4 downto 0);

  --============--
  -- WB OUTPUTS --
  --============--
  wb_aluout : out std_logic_vector(31 downto 0);
  wb_jal : out std_logic;
  wb_memdataout : out std_logic_vector(31 downto 0);
  wb_memtoreg : out std_logic;
  wb_npc : out std_logic_vector(31 downto 0);
  wb_regwen : out std_logic;
  wb_rw : out std_logic_vector(4 downto 0)

);
end MEMWBreg;

architecture behavioral of MEMWBreg is
  --=====================--
  -- SIGNAL DECLARATIONS --
  --=====================--

  signal aluout : std_logic_vector(31 downto 0);
  -- Output of the alu

  signal jal : std_logic;
  -- Whether or not this operation is a jal (1 for yes, 0 for no)

  signal memdataout : std_logic_vector(31 downto 0);
  -- Output of the read data

  signal memtoreg : std_logic;
  -- 1 if data from memory is being written to regfile, '0' if from alu (or nothing)

  signal npc : std_logic_vector(31 downto 0);
  -- PC+4 for the instruction at a given phase

  signal regwen : std_logic;
  -- Write enable for register file (1 for write, 0 for don't write)

  signal rw : std_logic_vector(4 downto 0);
  -- 5-bit address of register being written to

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
      jal <= '0';
      memdataout <= (others => '0');
      memtoreg <= '0';
      npc <= (others => '0');
      regwen <= '0';
      rw <= (others => '0');
    elsif(rising_edge(clk))then
    	if(bubble='1' and stall='0')then
      	aluout <= (others => '0');
      	jal <= '0';
      	memdataout <= (others => '0');
      	memtoreg <= '0';
      	npc <= (others => '0');
      	regwen <= '0';
      	rw <= (others => '0'); 
    	elsif(stall='0')then
      	aluout <= mem_aluout;
      	jal <= mem_jal;
      	memdataout <= mem_memdataout;
      	memtoreg <= mem_memtoreg;
      	npc <= mem_npc;
      	regwen <= mem_regwen;
      	rw <= mem_rw;
      end if;
    end if;
  end process;

  --=====================--
  -- COMBINATIONAL LOGIC --
  --=====================--

  -- Attach the internal register to the outputs
  wb_aluout <= aluout;
  wb_jal <= jal;
  wb_memdataout <= memdataout;
  wb_memtoreg <= memtoreg;
  wb_npc <= npc;
  wb_regwen <= regwen;
  wb_rw <= rw;

end behavioral;
