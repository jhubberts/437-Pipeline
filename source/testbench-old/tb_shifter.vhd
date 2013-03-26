-- $Id: $
-- File name:   tb_shifter.vhd
-- Created:     1/15/2013
-- Author:      John Hubberts
-- Lab Section: Tuesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_shifter is
end tb_shifter;

architecture TEST of tb_shifter is

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

  component shifter
    PORT(
         lr : in std_logic;
         shifterin : in std_logic_vector(31 downto 0);
         amt : in std_logic_vector(4 downto 0);
         shifterout : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal lr : std_logic;
  signal shifterin : std_logic_vector(31 downto 0);
  signal amt : std_logic_vector(4 downto 0);
  signal shifterout : std_logic_vector(31 downto 0);

-- signal <name> : <type>;

begin
  DUT: shifter port map(
                lr => lr,
                shifterin => shifterin,
                amt => amt,
                shifterout => shifterout
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    lr <= '0';
    shifterin <= x"FEDCBA98"; 
    amt <= "00000";
    wait for 100 ns;
    amt <= "10000";
    wait for 100 ns;
    lr <= '1';
    wait for 100 ns;
    lr <= '0';
    amt <= "01000";
    wait for 100 ns;
    lr <= '1';
    wait for 100 ns;
    lr <= '0';
amt <= "00100";
    wait for 100 ns;
    lr <= '1';
    wait for 100 ns;
    lr <= '0';
amt <= "00010";
    wait for 100 ns;
    lr <= '1';
    wait for 100 ns;
    lr <= '0';
amt <= "00001";
    wait for 100 ns;
    lr <= '1';
    wait for 100 ns;
    lr <= '0';
    amt <= "00000";
    wait for 100 ns;
  end process;
end TEST;
