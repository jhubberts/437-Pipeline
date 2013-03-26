--================================================================================
--Title: cpu_controller.vhd
--Description: The controller for Lab 4's single cycle MIPS processor
--Author: John J. Hubberts
--Date: 1/27/2013
--Version: 1.0
--================================================================================

library ieee;
use ieee.std_logic_1164.all;

entity cpu_controller is
  port(
    --=============================--
    -- TOP LEVEL and MEMORY INPUTS --
    --=============================--
    inst : in std_logic_vector(31 downto 0);
    -- The 32-bit instruction provided by the instruction memory   

    --=================--
    -- CONTROL SIGNALS --
    --=================--
    signext : out std_logic;
    --Flag from the controller specifying whether or not the immediate being
    -- provided to the ALU should be zero-extended or sign-extended.

    alusrc : out std_logic;
    --Flag from the controller specifying whether the current operation requires
    -- the B bus to contain a value from a register, or the value from the extender

    shiftop : out std_logic;
    -- If this flag is set high, the value on bus B is set to
    -- (others => '0') & shamt, where shamt is the shift amount specified in and
    -- R-Type shift instructions. If not, the value is the value determined by
    -- the alusrc mux.

    regwen : out std_logic;
    -- If this flag is set high, the data bus will read the data on the 32-bit
    --  regw line into the register specified by wsel. Otherwise, it will
    --  ignore this data.

    regdst : out std_logic;
    -- Specifies which of the registers specified by the MIPS instruction is
    --  to be written to. '1' if is the destination register, '0' if Rt is.

    aluop : out std_logic_vector(5 downto 0);
    -- Specifies which operation the ALU will perform. The opcodes directly
    --  correspond to the function codes of each basic arithmetic function
    --  we've impemented in our ISA. For more information, check appendix
    --  B-50 of the textbook, or consult online resources.

    luiop : out std_logic;
    -- Specifies whether or not the current operation is a "Load Upper Immediate"
    --  '1' if the current op is LUI, '0' if it isn't.

    memtoreg : out std_logic;
    -- Specifies whether the 32-bit regw line should contain a value from
    --  data, or from the ALU. '1' if from data, '0' if from ALU.

    memwen : out std_logic;
    -- Specifies whether or not the memory write function is emabled
    --  '1' for write to memory, '0' for do not write to memory

    bneop : out std_logic;
    -- Specifies if the current operation is a "Branch if Not Equal".
    --  '1' for BNE, '0' for BEQ (or any other operation)

    branch : out std_logic;
    -- Specifies whether or not the current instruction is a branch instruction.
    --  '1' if it is a branch, '0' if it isn't a branch.

    jalop : out std_logic;
    -- Specifies whether or not the current instruction is a "Jump and Link" op.
    --  '1' if JAL, '0' if not.

    jrop : out std_logic;
    -- Specifies whether or not the current instruction is a "Jump Register" op.
    --  '1' if JR, '0' if not.

    jumpop : out std_logic;
    -- Specifies whether or not the current instruction is a Jump operation.
    --  '1' if J, JR, or JAL, '0' if not.

    halt : out std_logic
    -- Asserts the 'halt' signal high when the opcode is 0xFFFFFFFF
    );
end entity;

architecture dataflow of cpu_controller is

--=====================--
-- SIGNAL DECLARATIONS --
--=====================--
  signal opcode, funct : std_logic_vector(5 downto 0);
  -- The internal bus representations of opcode, function.

begin

--=====================--
-- COMBINATIONAL LOGIC --
--=====================--

  -- Assign internal busses
  opcode <= inst(31 downto 26);
  funct <= inst(5 downto 0);

  -- Detect the halt condition when you receive a signal that's all '1's
  halt <= '1' when inst="11111111111111111111111111111111" else '0';

  -- Control logic for the sign extender
  with opcode select
    -- '1' when any of the specified cases, default case is zero
    signext <= '1' when "001001"| -- ADDIU
                  "100011"| -- LW Opcode
                  "001010"| -- SLTI Opcode
                  "001011"| -- SLTIU Opcode
                  "101011"| -- SW Opcode
                  "000100"| -- BEQ Opcode
                  "000101", -- BNE Opcode
               '0' when others;

  -- Control logic for aluop
  with opcode select
    aluop <= funct when "000000", -- FUNCT when R-Type
             "100001" when "001001"|"101011"|"100011", -- ADDU when ADDIU or SW or LW
             "100100" when "001100", -- AND when ANDI 
             "100011" when "000100"|"000101", -- SUBU when BEQ or BNE
             "100101" when "001101", -- OR when ORI
             "101010" when "001010", -- SLT when SLTI
             "101011" when "001011", -- SLTU when SLTUI
             "100110" when "001110", -- XOR when XORI
             (others => '0') when others;

  -- memtoreg is only '1' if the opcode is LW (Load Word)
  memtoreg <= '1' when opcode="100011" else '0'; -- LW Opcode 35

  -- memwen is only enabled if the opcode is SW (Store Word)
  memwen <= '1' when opcode="101011" else '0'; -- SW Opcode 43

  -- jumpop is set if the detected opcode is that of J (Jump), JR (Jump Register),
  --  or JAL (Jump and Link) 
  jumpop <= '1' when (opcode="000000" and funct="001000") or -- JR Opcode/Funct 0/8
                     opcode="000010" or -- J Opcode 2
                     opcode="000011" -- JAL Opcode 3
                else '0';

  -- jrop is set if the detected opcode and function code are that of JR (Jump Register)
  jrop <= '1' when (opcode="000000" and funct="001000") -- JR Opcode/Funct 0/8
              else '0';

  -- jalop is set if the detected opcode is that of JAL (Jump and Link)
  jalop <= '1' when opcode="000011" else '0'; -- JAL Opcode 3

  -- branch is set if the detected opcode is that of BEQ (Branch if Equal)
  --  or BNE (Branch if Not Equal)
  branch <= '1' when opcode="000100" or --BEQ Opcode 4
                opcode="000101" -- BNE Opcode 5
                else '0';

  -- bne is set if the detected opcode is that of BNE (Branch if Not Equal)
  bneop <= '1' when opcode="000101" else '0'; -- BNE Opcode 5

  -- shiftop is set if the detected opcode is that of SLL (Shift Left Logical) or
  --  SRL (Shift Right Logical)
  shiftop <= '1' when opcode="000000" and -- R-Type Opcode 0
                 (funct="000000" or -- SLL Opcode 0
                 funct="000010") -- SRL Opcode 2
                 else '0';

  -- luiop is set if the detected opcode is that of LUI (Load Upper Immediate)
  luiop <= '1' when opcode="001111" else '0'; -- LUI Opcode 15

  -- regwen is set in all cases excluding HALT, branches (BEQ or BNE),
  --  J (Jump), JR (Jump Register), and SW (Store Word).
  regwen <= '0' when (opcode="000000" and funct="001000") or -- JR Opcode
                opcode="000010" or -- J Opcode 2
                opcode="000100" or -- BEQ Opcode 4
                opcode="000101" or -- BNE Opcode 5
                opcode="101011" or -- SW Opcode 43
                opcode="111111" -- HALT Opcode 63 + '1'*26
                else '1'; -- Default yes condition

  -- regdst is set to Rd('1') for R-Type instructions, and Rt('0')
  --  for all remaining instructions (I-Type instructions, and
  --  J-Types for which regdst is a "Don't Care") 
  regdst <= '1' when opcode="000000" else '0'; -- R-Type Opcode 0

  -- alusrc is '1' (take from register file) for all R-type instructions,
  --  and for branch instructions (for which a subtraction is performed).
  --  Otherwise, it's an immediate, or a shift operation
  alusrc <= '1' when (opcode="000000" and not(funct="000000" or funct="000010")) or -- R-Type Opcode 0, and not a shift op
                opcode="000100" or -- BEQ Opcode 5
                opcode="000101" -- BNE 
                else '0';

end dataflow;
