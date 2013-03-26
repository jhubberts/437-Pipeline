--================================================================================--
--Title: pipe_ex.vhd
--Description: 
-- The "execution" stage of the pipelined processor.
--Author: John J. Hubberts
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity pipe_ex is
  port(
  pcsrc : in std_logic;

  d_aluop : in std_logic_vector(5 downto 0);
  d_alusrc : in std_logic;
  d_bneop : in std_logic;
  d_branch : in std_logic;
  d_halt : in std_logic;
  d_inst : in std_logic_vector(31 downto 0);
  d_imm32 : in std_logic_vector(31 downto 0);
  d_jalop : in std_logic;
  d_jrop : in std_logic;
  d_jump : in std_logic;
  d_luiop : in std_logic;
  d_memRen : in std_logic;
  d_memToReg : in std_logic;
  d_memWen : in std_logic;
  d_N : in std_logic;
  d_npc : in std_logic_vector(31 downto 0);
  d_rdat1 : in std_logic_vector(31 downto 0);
  d_rdat2 : in std_logiC_vector(31 downto 0);
  d_regWen : in std_logic;
  d_rw : in std_logic_vector(4 downto 0);

  x_aluOut : out std_logic_vector(31 downto 0);
  x_bneop : out std_logic;
  x_branch : out std_logic;
  x_branchAddr : out std_logic_vector(31 downto 0);
  x_halt : out std_logic;
  x_inst : out std_logic_vector(31 downto 0);
  x_jalop : out std_logic;
  x_jrAddr : out std_logic_vector(31 downto 0);
  x_jrop : out std_logic;
  x_jump : out std_logic;
  x_memDataIn : out std_logic_vector(31 downto 0);
  x_memRen : out std_logic;
  x_memToReg : out std_logic;
  x_memWen : out std_logic;
  x_N : out std_logic;
  x_npc : out std_logic_vector(31 downto 0);
  x_regWen : out std_logic;
  x_rw : out std_logic_vector(4 downto 0);
  x_zero : out std_logic
);
end pipe_ex;

architecture dataflow of pipe_ex is

--========================--
-- COMPONENT DECLARATIONS --
--========================--
  component alu is
    port(opcode : in std_logic_vector(5 downto 0);
      A : in std_logic_vector(31 downto 0);
      B : in std_logic_vector(31 downto 0);
      aluout : out std_logic_vector(31 downto 0);
      negative : out std_logic;
      overflow : out std_logic;
      zero : out std_logic);
  end component;

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
  signal zero : std_logic;
  signal aluout, busB, shiftImm32 : std_logic_vector(31 downto 0);
begin

  npc_adder : adder32 port map(
    subop => '0', -- Addition operation
    A => shiftImm32, -- Add to the PC
    B => d_npc, -- Always add 4
    signedop => '1', -- Signed operation
    adderout => x_branchAddr, -- Result is Next Program Counter
    negative => open, -- We don't care about negative
    overflow => open); -- We don't care about overflow

  cpu_alu : alu port map(
    opcode => d_aluop, -- Taken from the top level
    A => d_rdat1, -- Provided direct from register file
    B => busB, -- Provided from muxed bus
    aluout => aluout, -- Goes to internal bus
    negative => open, -- Don't care about this yet
    overflow => open, -- Don't care about this yet
    zero => x_zero); -- Goes to the zero condition flag

  --=====================--
  -- COMBINATIONAL LOGIC --
  --=====================--

  -- Generate internal signals
  busB <= d_rdat2 when d_alusrc='0' else
          d_imm32;
  shiftImm32 <= d_imm32(31 downto 2) & "00";

  -- Pass any internally generated signals to the rightmost pipeline register
  x_N <= d_N or pcsrc; 
  x_aluOut <= d_imm32 when d_luiop='1' else
              aluout;

  -- Pass any direct control signal transfers between the two pipeline registers
  x_bneop <= d_bneop;
  x_branch <= d_branch;
  x_halt <= d_halt;
  x_inst <= d_inst;
  x_jalop <= d_jalop;
  x_jrAddr <= d_rdat1;
  x_jrop <= d_jrop;
  x_jump <= d_jump;
  x_memDataIn <= d_rdat2;
  x_memRen <= d_memRen;
  x_memToReg <= d_memToReg;
  x_memWen <= d_memWen;
  x_npc <= d_npc;
  x_regWen <= d_regWen;
  x_rw <= d_rw;

end dataflow;
