-- $Id: $
-- File name:   tb_extender.vhd
-- Created:     1/25/2013
-- Author:      John Hubberts
-- Lab Section: Tuesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_extender is
end tb_extender;

architecture TEST of tb_extender is

  function INT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
    variable RES : STD_LOGIC_VECTOR(NumBits-1 downto 0);
    variable tmp : INTEGER;
  begin
    tmp := X;
    for i in 0 to NumBits-1 loop
      if (tmp mod 2)=1 then
        res(i) := '1';
      else
        res(i) := '0';
      end if;
      tmp := tmp/2;
    end loop;
    return res;
  end;

  component extender
    PORT(
         imm16 : in std_logic_vector(15 downto 0);
         signext : in std_logic;
         imm32 : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal imm16 : std_logic_vector(15 downto 0);
  signal signext : std_logic;
  signal imm32 : std_logic_vector(31 downto 0);

-- signal <name> : <type>;

begin
  DUT: extender port map(
                imm16 => imm16,
                signext => signext,
                imm32 => imm32
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    imm16 <= "1001001010100101";
    signext <= '0';
    wait for 100 ns;
    signext <= '1';
    wait for 100 ns;
    imm16 <= "0100101101010010";
    wait for 100 ns;
    signext <= '0';
    wait for 100 ns;

  end process;
end TEST;
