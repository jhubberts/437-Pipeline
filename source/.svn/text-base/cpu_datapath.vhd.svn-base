--================================================================================--
--Title: cpu_datapath.vhd
--Description: 
-- The datapath for the fully pipelined processor. Interacts externally with
-- the cache files, the master controller, and the arbiter.
--Author: John J. Hubberts
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity cpu_datapath is
  port(
    clk : in std_logic; -- The System Clock
    nReset : in std_logic; -- The System Asynchronous Reset
    halt : out std_logic; -- System-wide halt

    iMemRead : out std_logic;
    iMemWait : in std_logic;
    iMemAddr : out std_logic_vector(31 downto 0);
    iMemData : in std_logic_vector(31 downto 0);

    dMemRead : out std_logic;
    dMemWrite : out std_logic;
    dMemWait : in std_logic;
    dMemAddr : out std_logic_vector(31 downto 0);
    dMemDataRead : in std_logic_vector(31 downto 0);
    dMemDataWrite : out std_logic_vector(31 downto 0)
    );
end cpu_datapath;

architecture behavioral of cpu_datapath is

  --========================--
  -- COMPONENT DECLARATIONS --
  --========================--
component IFIDreg
  port(
  clk : in std_logic;
  nReset : in std_logic;
  stall : in std_logic;
  bubble : in std_logic;
  if_npc : in std_logic_vector(31 downto 0);
  id_npc : out std_logic_vector(31 downto 0);
  if_instr : in std_logic_vector(31 downto 0);
  id_instr : out std_logic_vector(31 downto 0)
  );
end component;

component IDEXreg
  port(
		clk 			: in std_logic;
		nReset			: in std_logic;
		stall 			: in std_logic;
		bubble			: in std_logic;
		id_aluop		: in std_logic_vector(5 downto 0);
		id_alusrc		: in std_logic;
		id_bne			: in std_logic;
		id_branch		: in std_logic;
		id_halt			: in std_logic;
		id_imm32		: in std_logic_vector(31 downto 0);
		id_jal			: in std_logic;
		id_jr			: in std_logic;
		id_jump			: in std_logic;
		id_jumpaddr		: in std_logic_vector(31 downto 0);
		id_lui			: in std_logic;			
		id_memtoreg		: in std_logic;
		id_memwen		: in std_logic;
		id_npc			: in std_logic_vector(31 downto 0);
		id_rdat1		: in std_logic_vector(31 downto 0);
		id_rdat2		: in std_logic_vector(31 downto 0);
		id_regwen		: in std_logic;
    id_rs : in std_logic_vector(4 downto 0);
    id_rt : in std_logic_vector(4 downto 0);
		id_rw			: in std_logic_vector(4 downto 0);
		ex_aluop		: out std_logic_vector(5 downto 0);
		ex_alusrc		: out std_logic;
		ex_bne			: out std_logic;
		ex_branch		: out std_logic;
		ex_halt			: out std_logic;
		ex_imm32		: out std_logic_vector(31 downto 0);
		ex_jal			: out std_logic;
		ex_jr			: out std_logic;
		ex_jump			: out std_logic;
		ex_jumpaddr		: out std_logic_vector(31 downto 0);
		ex_lui			: out std_logic;
		ex_memtoreg		: out std_logic;
		ex_memwen		: out std_logic;
		ex_npc			: out std_logic_vector(31 downto 0);
		ex_rdat1		: out std_logic_vector(31 downto 0);
		ex_rdat2		: out std_logic_vector(31 downto 0);
		ex_regwen		: out std_logic;
    ex_rs : out std_logic_vector(4 downto 0);
    ex_rt : out std_logic_vector(4 downto 0);
		ex_rw			: out std_logic_vector(4  downto 0)
  );
end component;

component EXMEMreg
  port(
  clk : in std_logic;
  nReset : in std_logic;
  stall : in std_logic;
  bubble : in std_logic;
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
end component;

component MEMWBreg
  port(
  clk : in std_logic;
  nReset : in std_logic;
  stall : in std_logic;
  bubble : in std_logic;
  mem_aluout : in std_logic_vector(31 downto 0);
  mem_jal : in std_logic;
  mem_memdataout : in std_logic_vector(31 downto 0);
  mem_memtoreg : in std_logic;
  mem_npc : in std_logic_vector(31 downto 0);
  mem_regwen : in std_logic;
  mem_rw : in std_logic_vector(4 downto 0);
  wb_aluout : out std_logic_vector(31 downto 0);
  wb_jal : out std_logic;
  wb_memdataout : out std_logic_vector(31 downto 0);
  wb_memtoreg : out std_logic;
  wb_npc : out std_logic_vector(31 downto 0);
  wb_regwen : out std_logic;
  wb_rw : out std_logic_vector(4 downto 0)
  );
end component;

component extender
  port(
  imm16 : in std_logic_vector(15 downto 0);
  signext  : in std_logic;
  imm32    : out std_logic_vector(31 downto 0)
  );
end component;

component cpu_controller
  port(
    inst : in std_logic_vector(31 downto 0);
    signext : out std_logic;
    alusrc : out std_logic;
    shiftop : out std_logic;
    regwen : out std_logic;
    regdst : out std_logic;
    aluop : out std_logic_vector(5 downto 0);
    luiop : out std_logic;
    memtoreg : out std_logic;
    memwen : out std_logic;
    bneop : out std_logic;
    branch : out std_logic;
    jalop : out std_logic;
    jrop : out std_logic;
    jumpop : out std_logic;
    halt : out std_logic
    );
end component;

component registerFile
  port(
    wdat   : in std_logic_vector (31 downto 0); -- Write data input port
    wsel   : in std_logic_vector (4 downto 0); -- Selects which register to write
    wen    : in std_logic; -- Write Enable for entire register file
    clk    : in std_logic; -- clock, positive edge triggered
    nReset : in std_logic; -- Active low register file reset
    rsel1  : in std_logic_vector (4 downto 0); -- Select which register to read on rdat1 
    rsel2  : in std_logic_vector (4 downto 0); -- Select which register to read on rdat2
    rdat1  : out std_logic_vector (31 downto 0); -- Read port 1
    rdat2  : out std_logic_vector (31 downto 0) -- Read port 2
    );
end component;

component alu
  port(
  opcode : in std_logic_vector(5 downto 0);
  A : in std_logic_vector(31 downto 0);
  B : in std_logic_vector(31 downto 0);
  aluout : out std_logic_vector(31 downto 0);
  negative : out std_logic;
  overflow : out std_logic;
  zero : out std_logic
  );
end component;

component adder32
  port(
  subop    : in std_logic;
  A        : in std_logic_vector(31 downto 0);
  B        : in std_logic_vector(31 downto 0);
  signedop : in std_logic;
  adderout : out std_logic_vector(31 downto 0);
  negative : out std_logic;
  overflow : out std_logic
  );
end component;

--===================--
-- TEMP DECLARATIONS --
--===================--
component hazard_controller is
  port(
    clk : in std_logic;
    nReset : in std_logic;
    dMemWait : in std_logic;
    dMemRead : in std_logic;
    dMemWrite : in std_logic;
    iMemWait : in std_logic;
    loadUseHazard : in std_logic;
    halt : in std_logic;
    pcstall : out std_logic;
    regstall : out std_logic_vector(3 downto 0);
    regbubble : out std_logic_vector(3 downto 0)
    );
end component;

component forwarding_unit is
  port(
    ex_rs : in std_logic_vector(4 downto 0);
    ex_rt : in std_logic_vector(4 downto 0);
    mem_rw : in std_logic_vector(4 downto 0);
    mem_regwen : in std_logic;
    wb_rw : in std_logic_vector(4 downto 0);
    wb_regwen : in std_logic;
    mem_aluout : in std_logic_vector(31 downto 0);
    writedata : in std_logic_vector(31 downto 0);  
    forwardsel1 : out std_logic;
    forwardsel2 : out std_logic;
    forwarddata1 : out std_logic_vector(31 downto 0);
    forwarddata2 : out std_logic_vector(31 downto 0)
  );
end component;

  --=============================--
  -- HIGH LEVEL INTERNAL SIGNALS --
  --=============================--
  signal loadUseHazard : std_logic;

  signal pcstall : std_logic; -- Write enable for the program counter
  signal regstall : std_logic_vector(3 downto 0); -- Stall for all registers
  signal regbubble : std_logic_vector(3 downto 0); -- Bubble enable for all registers

  signal ifid_rst : std_logic;
  signal idex_rst : std_logic;

  --==================================--
  -- FORWARDING UNIT INTERNAL SIGNALS --
  --==================================--
  signal forwardsel1 : std_logic;
  signal forwardsel2 : std_logic;
  signal forwarddata1 : std_logic_vector(31 downto 0);
  signal forwarddata2 : std_logic_vector(31 downto 0);

  --======================--
  -- REGISTER FILE INPUTS --
  --======================--
  signal regwen : std_logic;
  signal rw : std_logic_vector(4 downto 0);
  signal writedata : std_logic_vector(31 downto 0);

  --==============================--
  -- FETCH PHASE INTERNAL SIGNALS --
  --==============================--
  signal if_instr : std_logic_vector(31 downto 0);
  signal if_npc : std_logic_vector(31 downto 0);
  signal if_pc, if_pc_next : std_logic_vector(31 downto 0);

  --===============================--
  -- DECODE PHASE INTERNAL SIGNALS --
  --===============================--
  signal id_addr : std_logic_vector(25 downto 0);
  signal id_imm : std_logic_vector(15 downto 0);
  signal id_instr : std_logic_vector(31 downto 0);
  signal id_rd : std_logic_vector(4 downto 0);
  signal id_rs : std_logic_vector(4 downto 0);
  signal id_rt : std_logic_vector(4 downto 0);
  signal id_shamt : std_logic_vector(4 downto 0);
  signal id_ext32 : std_logic_vector(31 downto 0);
  signal id_regdst : std_logic;
  signal id_shiftop : std_logic;
  signal id_signext : std_logic;
  signal id_aluop : std_logic_vector(5 downto 0);
  signal id_alusrc : std_logic;
  signal id_bne : std_logic;
  signal id_branch : std_logic;
  signal id_halt : std_logic;
  signal id_imm32 : std_logic_vector(31 downto 0);
  signal id_jal : std_logic;
  signal id_jr : std_logic;
  signal id_jump : std_logic;
  signal id_jumpaddr : std_logic_vector(31 downto 0);
  signal id_lui : std_logic;			
  signal id_memtoreg : std_logic;
  signal id_memwen : std_logic;
  signal id_npc : std_logic_vector(31 downto 0);
  signal id_rdat1 : std_logic_vector(31 downto 0);
  signal id_rdat2 : std_logic_vector(31 downto 0);
  signal id_regwen : std_logic;
  signal id_rw : std_logic_vector(4 downto 0);

  --================================--
  -- EXECUTE PHASE INTERNAL SIGNALS --
  --================================-- 
  signal ex_aluop : std_logic_vector(5 downto 0);
  signal ex_alusrc : std_logic;
  signal ex_imm32 : std_logic_vector(31 downto 0);
  signal ex_lui : std_logic;
  signal ex_rdat1 : std_logic_vector(31 downto 0);
  signal ex_rdat2 : std_logic_vector(31 downto 0);
  signal ex_aluA : std_logic_vector(31 downto 0);
  signal ex_aluB : std_logic_vector(31 downto 0); -- The value that gets passed to ALU B
  signal ex_dataBus : std_logic_vector(31 downto 0);
  signal ex_rawalu : std_logic_vector(31 downto 0); -- The output straight from the alu
  signal ex_shiftimm : std_logic_vector(31 downto 0);
  signal ex_aluout : std_logic_vector(31 downto 0);
  signal ex_bne : std_logic;
  signal ex_branch : std_logic;
  signal ex_branchaddr : std_logic_vector(31 downto 0);
  signal ex_halt : std_logic;
  signal ex_jal : std_logic;
  signal ex_jr : std_logic;
  signal ex_jump : std_logic;
  signal ex_jumpaddr : std_logic_vector(31 downto 0);
  signal ex_memtoreg : std_logic;
  signal ex_memwen : std_logic;
  signal ex_npc : std_logic_vector(31 downto 0);
  signal ex_regwen : std_logic;
  signal ex_rs : std_logic_vector(4 downto 0);
  signal ex_rt : std_logic_vector(4 downto 0);
  signal ex_rw : std_logic_vector(4 downto 0);
  signal ex_zero : std_logic;

  --===============================--
  -- MEMORY PHASE INTERNAL SIGNALS --
  --===============================--
  signal mem_aluout : std_logic_vector(31 downto 0);
  signal mem_bne : std_logic;
  signal mem_branch : std_logic;
  signal mem_branchaddr : std_logic_vector(31 downto 0);
  signal mem_halt : std_logic;
  signal mem_jal : std_logic;
  signal mem_jr : std_logic;
  signal mem_jraddr : std_logic_vector(31 downto 0);
  signal mem_jump : std_logic;
  signal mem_jumpaddr : std_logic_vector(31 downto 0);
  signal mem_memdatain : std_logic_vector(31 downto 0);
  signal mem_memdataout : std_logic_vector(31 downto 0);
  signal mem_memtoreg : std_logic;
  signal mem_memwen : std_logic;
  signal mem_npc : std_logic_vector(31 downto 0);
  signal mem_pcsrc : std_logic;
  signal mem_regwen : std_logic;
  signal mem_rw : std_logic_vector(4 downto 0);
  signal mem_zero : std_logic;

  --============================--
  -- WRITEBACK INTERNAL SIGNALS --
  --============================--
  signal wb_aluout : std_logic_vector(31 downto 0);
  signal wb_jal : std_logic;
  signal wb_memdataout : std_logic_vector(31 downto 0);
  signal wb_memtoreg : std_logic;
  signal wb_npc : std_logic_vector(31 downto 0);
  signal wb_regwen : std_logic;
  signal wb_rw : std_logic_vector(4 downto 0);

begin

  --===============--
  -- PORTMAPS-R-US --
  --===============--
  cpu_hazardctrl : hazard_controller port map(
    clk => clk,
    nReset => nReset,
    dMemWait => dMemWait,
    dMemRead => mem_memtoreg,
    dMemWrite => mem_memwen,
    iMemWait => iMemWait,
    loadUseHazard => loadUseHazard,
    halt => mem_halt,
    pcstall => pcstall,
    regstall => regstall,
    regbubble => regbubble
  );

  cpu_forwardunit : forwarding_unit port map(
    ex_rs => ex_rs,
    ex_rt => ex_rt,
    mem_rw => mem_rw,
    mem_regwen => mem_regwen,
    wb_rw => wb_rw,
    wb_regwen => wb_regwen,
    mem_aluout => mem_aluout,
    writedata => writedata,
    forwardsel1 => forwardsel1,
    forwardsel2 => forwardsel2,
    forwarddata1 => forwarddata1,
    forwarddata2 => forwarddata2
  );

  if_pcAdder : adder32 port map(
    subop => '0', -- This is an addition, not a subtraction
    A => if_pc, -- Take the next program counter
    B => x"00000004", -- Left-shifted immediate branching amount
    signedop => '1', -- Always a signed addition
    adderout => if_npc,
    negative => open,
    overflow => open
    );

  cpu_ifid : IFIDreg port map(
    clk => clk,
    nReset => ifid_rst,
    stall => regstall(3), -- Fix this when we can stall
    bubble => regbubble(3), -- Fix this when we can bubble
    if_instr => if_instr, -- Input signal from fetch
    if_npc => if_npc, -- Input signal from fetch
    id_instr => id_instr,
    id_npc => id_npc);

  id_extender : extender port map(
		imm16 => id_imm, -- Internal signal provided by splitting id_instr
    signext => id_signext, -- Internal signal to decoder
    imm32 => id_ext32); -- Internal signal to decoder

  id_decoder : cpu_controller port map(
    inst => id_instr, -- Input signal to decoder
    signext => id_signext, -- Internal signal to decoder
    alusrc => id_alusrc, -- Output signal to decoder
    shiftop => id_shiftop, -- Internal signal to decoder
    regwen => id_regwen, -- Output signal to decoder
    regdst => id_regdst, -- Internal signal to decoder
    aluop => id_aluop, -- Output signal to decoder
    luiop => id_lui, -- Output signal to decoder
    memtoreg => id_memtoreg, -- Output signal to decoder
    memwen => id_memwen, -- Output signal to decoder
    bneop => id_bne, -- Output signal to decoder
    branch => id_branch, -- Output signal to decoder
    jalop => id_jal, -- Output signal to decoder
    jrop => id_jr, -- Output signal to decoder
    jumpop => id_jump, -- Output signal to decoder
    halt => id_halt); -- Output signal to decoder

  regFile : registerFile port map(
    wdat => writedata, -- Output signal from writeback
    wsel => rw, -- Output signal from writeback
    wen => regwen, -- Output signal from writeback
    clk => clk, -- Top-Level input
    nReset => nReset, -- Top-Level input
    rsel1 => id_rs, -- Internal signal provided by splitting id_instr
    rsel2 => id_rt, -- Internal signal provided by splitting id_instr
    rdat1 => id_rdat1, -- Output signal to decoder
    rdat2 => id_rdat2); -- Output signal to decoder

  cpu_idex : IDEXreg port map(
    clk => clk,
    nReset => idex_rst,
    stall => regstall(2), -- 
    bubble => regbubble(2), -- 
		id_aluop => id_aluop, -- Generated by id_decoder
		id_alusrc	=> id_alusrc, -- Generated by id_decoder
		id_bne => id_bne, -- Generated by id_decoder
		id_branch => id_branch, -- Generated by id_decoder
		id_halt => id_halt, -- Generated by id_decoder
		id_imm32 => id_imm32, -- Generated by multiplexer dataflow statement
		id_jal=> id_jal, -- Generated by id_decoder
		id_jr	=> id_jr, -- Generated by id_decoder
		id_jump	=> id_jump, -- Generated by id_decoder
		id_jumpaddr	=> id_jumpaddr, -- Generated by dataflow concatenation statement
		id_lui	=> id_lui, -- Generated by id_decoder
		id_memtoreg	=> id_memtoreg, -- Generated by id_decoder
		id_memwen	=> id_memwen, -- Generated by id_decoder
		id_npc => id_npc, -- Provided directly from IFIDreg
		id_rdat1 => id_rdat1, -- Links to RegFile
		id_rdat2 => id_rdat2, -- Links to RegFile
		id_regwen => id_regwen, -- Generated by id_decoder
    id_rs => id_rs,
    id_rt => id_rt,
		id_rw => id_rw, -- Generated by multiplexer dataflow statement
		ex_aluop => ex_aluop, -- Output to execute stage
		ex_alusrc => ex_alusrc, -- Output to execute stage
		ex_bne => ex_bne, -- Output to execute stage
		ex_branch => ex_branch, -- Output to execute stage
		ex_halt => ex_halt, -- Output to execute stage		
		ex_imm32 => ex_imm32, -- Output to execute stage
		ex_jal => ex_jal, -- Output to execute stage
		ex_jr	=> ex_jr, -- Output to execute stage
		ex_jump => ex_jump, -- Output to execute stage
		ex_jumpaddr => ex_jumpaddr, -- Output to execute stage
		ex_lui => ex_lui, -- Output to execute stage
		ex_memtoreg	=> ex_memtoreg, -- Output to execute stage
		ex_memwen => ex_memwen, -- Output to execute stage
		ex_npc => ex_npc, -- Output to execute stage
		ex_rdat1 => ex_rdat1, -- Output to execute stage
		ex_rdat2 => ex_rdat2, -- Output to execute stage
		ex_regwen => ex_regwen, -- Output to execute stage
    ex_rs => ex_rs,
    ex_rt => ex_rt,
		ex_rw => ex_rw); -- Output to execute stage

  ex_alu : alu port map(
    opcode => ex_aluop, -- Intput signal from execute
    A => ex_aluA, -- Input signal from execute
    B => ex_aluB, -- Internal signal from execute
    aluout => ex_rawalu, -- Raw ALU output
    negative => open, -- We don't care about the negative flag as of now
    overflow => open, -- We don't care about the overflow flag as of now
    zero => ex_zero -- Output signal to execute
    );

  ex_branchAdder : adder32 port map(
    subop => '0', -- This is an addition, not a subtraction
    A => ex_npc, -- Take the next program counter
    B => ex_shiftimm, -- Left-shifted immediate branching amount
    signedop => '1', -- Always a signed addition
    adderout => ex_branchaddr, -- The output is the branch address
    negative => open,
    overflow => open
    );

  cpu_emmem : EXMEMreg port map(
    clk => clk,
    nReset => nReset,
    stall => regstall(1), -- Fix this when we can stall
    bubble => regbubble(1), -- Fix this when we can bubble
    ex_aluout => ex_aluout, -- Generated by alu and muxed internally
    ex_bne => ex_bne, -- Transferred directly by previous register
    ex_branch => ex_branch, -- Transferred directly by previous register
    ex_branchaddr => ex_branchaddr, -- Internal signal generated by adder
    ex_halt => ex_halt, -- Transferred directly by previous register
    ex_jal => ex_jal, -- Transferred directly by previous register
	  ex_jr => ex_jr, -- Transferred directly by previous register
  	ex_jraddr => ex_aluA, -- Transferred directly by previous register
  	ex_jump  => ex_jump, -- Transferred directly by previous register
  	ex_jumpaddr => ex_jumpaddr, -- Transferred directly by previous register
  	ex_memdatain => ex_databus, -- Transferred directly by previous register
  	ex_memtoreg => ex_memtoreg, -- Transferred directly by previous register
  	ex_memwen => ex_memwen, -- Transferred directly by previous register
  	ex_npc=> ex_npc, -- Transferred directly by previous register
  	ex_regwen => ex_regwen, -- Transferred directly by previous register
  	ex_rw => ex_rw, -- Transferred directly by previous register
  	ex_zero => ex_zero, -- Internal signal generated by alu
  	mem_aluout => mem_aluout, -- Output to memory stage
  	mem_bne => mem_bne, -- Output to memory stage
  	mem_branch => mem_branch, -- Output to memory stage
  	mem_branchaddr => mem_branchaddr, -- Output to memory stage
  	mem_halt => mem_halt, -- Output to memory stage
  	mem_jal=> mem_jal, -- Output to memory stage
  	mem_jr => mem_jr, -- Output to memory stage
  	mem_jraddr => mem_jraddr, -- Output to memory stage
  	mem_jump => mem_jump, -- Output to memory stage
  	mem_jumpaddr => mem_jumpaddr, -- Output to memory stage
  	mem_memdatain => mem_memdatain, -- Output to memory stage
  	mem_memtoreg => mem_memtoreg, -- Output to memory stage
  	mem_memwen=> mem_memwen, -- Output to memory stage
  	mem_npc => mem_npc, -- Output to memory stage
  	mem_regwen => mem_regwen, -- Output to memory stage
  	mem_rw => mem_rw, -- Output to memory stage
  	mem_zero => mem_zero); -- Output to memory stage

  cpu_memwb : MEMWBreg port map(
    clk => clk,
    nReset => nReset,
    stall => regstall(0), -- Fix this when we can stall
    bubble => regbubble(0), -- Fix this when we can bubble
    mem_aluout => mem_aluout,
    mem_jal =>  mem_jal,
    mem_memdataout => mem_memdataout,
    mem_memtoreg => mem_memtoreg,
    mem_npc => mem_npc,
    mem_regwen => mem_regwen,
    mem_rw => mem_rw,
    wb_aluout => wb_aluout,
    wb_jal => wb_jal,
    wb_memdataout => wb_memdataout,
    wb_memtoreg => wb_memtoreg,
    wb_npc => wb_npc,
    wb_regwen => wb_regwen,
    wb_rw => wb_rw);

  --================--
  -- SYSTEM CONTROL --
  --================--

  -- Load use hazards are detected when, in the decode phase, the processor detects a use preceeding what
  --  will eventually become a load from memory.
  loadUseHazard <= '1' when ((id_rs=ex_rw) or (id_rt=ex_rw)) and ex_rw/="00000" and ex_memtoreg='1'
    else '0';

  ifid_rst <= nReset and not mem_pcsrc;
  idex_rst <= nReset and not mem_pcsrc;

  --=============--
  -- INSTRUCTION --
  --=============--
  -- State transition logic for PC
  pcTick : process(clk, nReset, pcstall, mem_halt)
  begin
		-- Upon asynchronous reset, set the clock to '0'
    if(nReset='0')then
      if_pc <= (others => '0');

		-- If you're not stalled or halted, clock in the new PC value on each rising edge.
    elsif(clk'event and clk='1')then
			if(pcstall='0' and mem_halt='0')then
      	if_pc <= if_pc_next;
			end if;
    end if;
  end process;

  -- Next State Logic for PC based on branches or sequential action
  if_pc_next <= if_npc when mem_pcsrc='0' else
    mem_branchaddr when mem_branch='1' else
    mem_jraddr when mem_jr='1' else
    mem_jumpaddr;

  -- We can tell the cache that we always want to read new instructions. 
  iMemRead <= '1';

  -- The address that we want to read from is the PC
  iMemAddr <= if_pc;

  -- Read the instruction into the fetch register
  if_instr <= iMemData;

  --=========--
  -- DECODER --
  --=========--

  -- Split the instruction into its components
  id_rs <= id_instr(25 downto 21);
  id_rt <= id_instr(20 downto 16);
  id_rd <= id_instr(15 downto 11);
  id_imm <= id_instr(15 downto 0);
  id_addr <= id_instr(25 downto 0);
  id_shamt <= id_instr(10 downto 6);

  -- Decide what the immediate is (Used for LUI, SHIFTS, and I-Types)
  id_imm32 <= "000000000000000000000000000" & id_shamt when id_shiftop='1' else
		id_imm & x"0000" when id_lui='1' else
    id_ext32;

  -- Decide the register to write to (rw). 
  id_rw <= "11111" when id_jal='1' else
		id_rd when id_regdst='1' else
		id_rt;

  -- Generate the jump address
  id_jumpaddr <= id_npc(31 downto 28) & id_addr & "00";

  --=========--
  -- EXECUTE --
  --=========--

  -- Decide what goes into the first argument of the ALU
  ex_aluA <= forwarddata1 when forwardsel1='1' else ex_rdat1;

  -- Decide what goes into the second argument of the ALU
  ex_aluB <= ex_imm32 when ex_alusrc='0' else
    forwarddata2 when forwardsel2='1' else
    ex_rdat2;

  -- Decide what data goes to the data input for the dCache
  ex_databus <= forwarddata2 when forwardsel2='1' else ex_rdat2;

  -- If the current operation isn't an LUI, then the output of the ALU is the raw computational output.
  --  If the operation Is an LUI, then the ouput is the 32 bit immediate.
  ex_aluout <= ex_rawalu when ex_lui='0' else
    ex_imm32;

  -- Left-shift imm32 by 2 to generate the branch increment/decrement
  ex_shiftimm <= ex_imm32(29 downto 0) & "00";

  --========--
  -- MEMORY --
  --========--

  -- Attach memory and input signals from the EXMEM register to the dCache
  dMemRead <= mem_memtoreg;
  dMemWrite <= mem_memwen;
  dMemAddr <= mem_aluout;
  dMemDataWrite <= mem_memdatain;

  -- Attach the output from the dCache to the MEMWB register
  mem_memdataout <= dMemDataRead;

  -- Determine whether or not a branch is taken (and, implicitly, if this is a branch instruction)
  mem_pcsrc <= (mem_jump or (mem_branch and (mem_bne xor mem_zero)));

	-- If you see a halt in the memory phase, assert the halt signal
	halt <= mem_halt;

  --===========--
  -- WRITEBACK --
  --===========--

  -- Set the register file's write register
  rw <= wb_rw;

  -- Set register write enable for the register file
  regwen <= wb_regwen;

  -- Set the contents of the write bus (either alu output, the npc if you're executing a jump-and-link,
  --  or the contents of memory if you just read from the dCache)
  writedata <= wb_npc when wb_jal='1' else
    wb_memdataout when wb_memtoreg='1' else
    wb_aluout;

end behavioral;
