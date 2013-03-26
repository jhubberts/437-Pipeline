-- HEADER --
-- ALU.VHD

library ieee;
use ieee.std_logic_1164.all;

entity alu is
  port(opcode : in std_logic_vector(5 downto 0);
  -- The 6 bit opcode pertaining to the operation
  -- "000000" : SLL : Output <= A << B
  -- "000010" : SRL : Output <= A >> B
  -- "100001" : ADDU : Output <= A + B
  -- "100011" : SUBU : Output <= A - B
  -- "100100" : AND : Output <= A and B
  -- "100101" : OR  : Output <= A or B
  -- "100110" : XOR : Output <= A xor B
  -- "100111" : NOR : Output <= A nor B
  -- "101010" : SLT : Output <= (A < B) ? 1 : 0
  -- "101011" : SLTU : Output <= (A < B) ? 1 : 0

    A : in std_logic_vector(31 downto 0);
    B : in std_logic_vector(31 downto 0);
    -- The two 32 bit inputs to the ALU

    aluout : out std_logic_vector(31 downto 0);
    -- The 32 bit output from the ALU

    negative : out std_logic;
    -- Flag signifying that the specified operation results in a negative number

    overflow : out std_logic;
    -- Flag signifying that the specified operation results in an overflow

    zero : out std_logic);
    -- Flag signifying s that the specified operation results in a output of '0'
end alu;

architecture dataflow of alu is
  -- COMPONENT DECLARATIONS
  component shifter
    port(
    lr : in std_logic;
    -- Determines the direction of the shift
    -- '0' => left shift
    -- '1' => right shift
    shifterin : in std_logic_vector(31 downto 0);
    -- The value to be shifted
    amt : in std_logic_vector(4 downto 0);
    -- The amount by which the input is being shifted
    shifterout : out std_logic_vector(31 downto 0));
    -- The output value of the shifter
  end component;

  component adder32 is
    port(
    subop    : in std_logic;
    -- Determines whether the adder is adding or subtracting
    --  '1' for subtraction, '0' for addition
    A        : in std_logic_vector(31 downto 0);
    B        : in std_logic_vector(31 downto 0);
    -- The two operands
    signedop : in std_logic;
    -- Whether or not the input values are signed or unsigned numbers.
    adderout : out std_logic_vector(31 downto 0);
    -- The adder output
    negative : out std_logic;
    -- The negative flag
    overflow : out std_logic);
    -- The overflow flag
  end component;

  -- SIGNAL DECLARATIONS
  signal outbus, shifterout, adderout : std_logic_vector(31 downto 0);
  signal addernegative, adderoverflow : std_logic;
  signal subop, signedop : std_logic;
  signal shiftdir: std_logic; -- Shift direction

begin

  -- PORT MAPPINGS
  alu_shifter : shifter port map(
    lr => shiftdir,
    shifterin => A,
    amt => B(4 downto 0),
    shifterout => shifterout);

  alu_adder : adder32 port map(
    subop => subop,
    A => A,
    B => B,
    signedop => signedop,
    adderout => adderout,
    negative => addernegative,
    overflow => adderoverflow);

  subop <= opcode(1);
  shiftdir <= opcode(1);

  -- Output mux, either performs basic combinational logic, or selects from
  --  the shifterout and adderout lines, depending on the opcode.
  with opcode select
    outbus <= (A and B) when "100100",
      (A or B) when "100101",
      (A xor B) when "100110",
      (A nor B) when "100111",
      shifterout when "000000" | "000010",
      adderout when "100001" | "100011",
      "0000000000000000000000000000000" & addernegative when "101010" | "101011",
      (others => '0') when others;

  --
  signedop <= '0' when opcode="101011" else '1';

  -- Negative mux, the adder handles the negative flag if an add or sub op is
  --  performed, otherwise the flag is set to '0'
  with opcode select
    negative <= addernegative when "100001" | "100011" | "101010" | "101011",
                '0' when others;

  -- Overflow mux, the adder handles the overflow flag if an add or sub op is
  --  performed, otherwise the flag is set to '0'
  with opcode select
    overflow <= adderoverflow when "100001" | "100011",
                '0' when others;

  -- Zero mux, checks of the output is all '0's
  with outbus select
    zero <= '1' when x"00000000",
            '0' when others;

  -- Maps the aluout signal to the internal output register
  aluout <= outbus;

end dataflow;
    
