--================================================================================--
--Title: pipe_mem.vhd
--Description: 
-- The "memory" stage of the pipelined processor.
--Author: John J. Hubberts
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity pipe_mem is
  port(

--================--
-- PIPEREG INPUTS --
--================--
  x_aluOut : in std_logic_vector(31 downto 0);
  x_bneop : in std_logic;
  x_branch : in std_logic;
  x_branchAddr : in std_logic_vector(31 downto 0);
  x_halt : in std_logic;
  x_inst : in std_logic_vector(31 downto 0);
  x_jalop : in std_logic;
  x_jrAddr : in std_logic_vector(31 downto 0);
  x_jrop : in std_logic;
  x_jump : in std_logic;
  x_memDataIn : in std_logic_vector(31 downto 0);
  x_memRen : in std_logic;
  x_memToReg : in std_logic;
  x_memWen : in std_logic;
  x_N : in std_logic;
  x_npc : in std_logic_vector(31 downto 0);
  x_regWen : in std_logic;
  x_rw : in std_logic_vector(4 downto 0);
  x_zero : in std_logic;


--=================--
-- PIPEREG OUTPUTS --
--=================--
  m_aluOut : out std_logic_vector(31 downto 0);
  m_jalop : out std_logic;
  m_memDataOut : out std_logic_vector(31 downto 0);
  m_memToReg : out std_logic;
  m_N : out std_logic;
  m_npc : out std_logic_vector(31 downto 0);
  m_regWen : out std_logic;
  m_rw : out std_logic_vector(4 downto 0);

--===================--
-- TOP-LEVEL OUTPUTS --
--===================--
  branch : out std_logic;
  branchAddr : out std_logic_vector(31 downto 0);
  jrAddr : out std_logic_vector(31 downto 0);
  jrop : out std_logic;
  jumpAddr : out std_logic_vector(31 downto 0);
  pcsrc : out std_logic;
  shutdown : out std_logic;

--================--
-- DCACHE SIGNALS --
--================--
  dMemRead       : out  std_logic;
  dMemWrite      : out  std_logic;
  dMemAddr       : out  std_logic_vector (31 downto 0);
  dMemDataRead   : in std_logic_vector (31 downto 0);
  dMemDataWrite  : out  std_logic_vector (31 downto 0)

);
end pipe_mem;

architecture dataflow of pipe_mem is

begin

  --=====================--
  -- COMBINATIONAL LOGIC --
  --=====================--

  -- Allow the 'Negated' condition to overwrite the read or write enables.
  --  This will prevent the memory from attempting to read or write invalid
  --  data. This is essential for preventing writes, and helps not waste time
  --  when it comes to reading unnecessarily.
  dMemRead <= (x_memRen and not x_N);
  dMemWrite <= (x_memWen and not x_N);

  -- The memory address comes from the alu, the memory write data comes from
  --  the memDataIn, and the output of a load operation goes to memDataOut
  dMemAddr <= x_aluOut;
  dMemDataWrite <= x_memDataIn;
  m_memDataOut <= dMemDataRead;

  -- Sends necessary control signals to the program counter
  branch <= x_branch;
  jrop <= x_jrop;
  pcsrc <= ((((x_bneop xor x_zero) and x_branch) or x_jump) and not x_N);
  
  -- Send various branch amounts to the program counter
  branchAddr <= x_branchAddr;
  jrAddr <= x_jrAddr;

  -- The Jump address is the top 4 bits of the program counter, the 26-bit
  --  jump amount specified in the instructions, and two concatenated '0's 
  jumpAddr <= x_npc(31 downto 28) & x_inst(25 downto 0) & "00";

  -- If you detect a halt condition, and this operation is not negated,
  --  send out the shutdown signal
  shutdown <= (x_halt and not x_N);

  -- Pass any direct control signal transfers between the two pipeline
  --  registers.
  m_N <= x_N;
  m_aluOut <= x_aluOut;
  m_rw <= x_rw;
  m_memToReg <= x_memToReg;
  m_npc <= x_npc;
  m_jalop <= x_jalop;
  m_regWen <= x_regWen;

end dataflow;
