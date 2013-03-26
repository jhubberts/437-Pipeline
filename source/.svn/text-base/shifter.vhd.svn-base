-- HEADER --
-- SHIFTER.VHD

library ieee;
use ieee.std_logic_1164.all;

entity shifter is
  port(lr : in std_logic;
    -- Determines the direction of the shift
    -- '0' => left shift
    -- '1' => right shift

    shifterin : in std_logic_vector(31 downto 0);
    -- The value to be shifted

    amt : in std_logic_vector(4 downto 0);
    -- The amount by which the input is being shifted

    shifterout : out std_logic_vector(31 downto 0));
    -- The output value of the shifter
end shifter;

architecture dataflow of shifter is
  -- SIGNAL DECLARATIONS
  signal stg4, stg3, stg2, stg1, stg0 : std_logic_vector(31 downto 0);
  signal sel4, sel3, sel2, sel1, sel0 : std_logic_vector(1 downto 0);
  -- The stages of the shift, and the various select signals

begin

  -- The select signals for the muxes at each stage are comprised of
  --  the lr signal concatenated with a respective bit of the shift amt
  --  input value
  sel4 <= lr & amt(4);
  sel3 <= lr & amt(3);
  sel2 <= lr & amt(2);
  sel1 <= lr & amt(1);
  sel0 <= lr & amt(0);

  -- At each stage, if the select's LSB is 0, do nothing. Otherwise, shift 2^n
  --  in the direction specified by the MSB ('0' for left, '1' for right)
  with sel4 select
    stg4 <= x"0000" & shifterin(31 downto 16) when "11",
            shifterin(15 downto 0) & x"0000" when "01",
            shifterin when others;

  with sel3 select
    stg3 <= x"00" & stg4(31 downto 8) when "11",
            stg4(23 downto 0) & x"00" when "01",
            stg4 when others;

  with sel2 select
    stg2 <= x"0" & stg3(31 downto 4) when "11",
            stg3(27 downto 0) & x"0" when "01",
            stg3 when others;

  with sel1 select
    stg1 <= "00" & stg2(31 downto 2) when "11",
            stg2(29 downto 0) & "00" when "01",
            stg2 when others;

  with sel0 select
    shifterout <= '0' & stg1(31 downto 1) when "11",
                  stg1(30 downto 0) & '0' when "01",
                  stg1 when others;

end dataflow;
    
