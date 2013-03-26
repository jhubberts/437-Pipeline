-- HEADER --
-- adder.VHD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder32 is
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
end adder32;

architecture dataflow of adder32 is
  -- SIGNAL DECLARATIONS

  signal sum : std_logic_vector(32 downto 0);
  signal A_s, B_s, sum_s : signed(32 downto 0);
  signal A_ext, B_ext : std_logic;

begin
  A_ext <= signedop and (A(31));
  B_ext <= signedop and (B(31));

  A_s <= signed(A_ext&A);
  B_s <= signed(B_ext&B);

  with subop select
    sum_s <=  A_s + B_s when '0',
               A_s - B_s when '1',
              (others => '0') when others;

  sum <= std_logic_vector(sum_s);
  negative <= sum(32);
  overflow <= (sum(32) xor sum(31));
  adderout <= sum(32)&sum(30 downto 0);
end dataflow;
