--================================================================================--
--Title: pipe_wb.vhd
--Description: 
-- The "writeback" stage of the pipelined processor.
--Author: John J. Hubberts
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity pipe_wb is
  port(
--================--
-- PIPEREG INPUTS --
--================--
  w_rw : in std_logic_vector(4 downto 0);
  w_memToReg : in std_logic;
  w_aluOut : in std_logic_vector(31 downto 0);
  w_memDataOut : in std_logic_vector(31 downto 0);
  w_npc : in std_logic_vector(31 downto 0);
  w_jalop : in std_logic;
  w_regWen : in std_logic;
  w_N : in std_logic;

--=========--
-- OUTPUTS --
--=========--
  rw : out std_logic_vector(4 downto 0);
  writeData : out std_logic_vector(31 downto 0);
  regWen : out std_logic
);
end pipe_wb;

architecture dataflow of pipe_wb is
begin

  --=====================--
  -- COMBINATIONAL LOGIC --
  --=====================--

  -- The value of RW isn't dependent on any control signals, it was calculated
  --  during the instruction decode phase
  rw <= w_rw;

  -- The register write enable can be overridden if this operation is negated (N='1')
  regWen <= (w_regWen and not w_N);

  -- The write data is multiplexed by the two signals 'memToReg' and 'jalop'. If
  --  your current operation is a JAL, then write the next program counter to the
  --  register file (NPC). Otherwise, if memToReg is 1, write the output from memory.
  --  If neither of these conditions are true, then you can write from the alu output.
  writeData <= w_npc when w_jalop='1' else
               w_memDataOut when w_memToReg='1' else
               w_aluOut;

end dataflow;
