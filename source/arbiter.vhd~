--================================================================================--
--Title: arbiter.vhd
--Description: 
-- Detects and resolves structural hazards (hazards created by two
-- simultaneous memory requests during the same pipe phase).
--Author: John J. Hubberts
--Date: Monday, February 04, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity arbiter is
  port(
--===========--
-- TOP LEVEL --
--===========--
  clk : in std_logic;
  nReset : in std_logic;

--===================--
-- INSTRUCTION CACHE --
--===================--
  aiMemRead : in std_logic;
  aiMemWait : out std_logic;
  aiMemAddr : in std_logic_vector(31 downto 0);
  aiMemData : out std_logic_vector(31 downto 0);

--============--
-- DATA CACHE --
--============--
  adMemRead : in std_logic;
  adMemWrite : in std_logic;
  adMemWait : out std_logic;
  adMemAddr : in std_logic_vector(31 downto 0);
  adMemDataRead : out std_logic_vector(31 downto 0);
  adMemDataWrite : in std_logic_vector(31 downto 0);

--=====--
-- RAM --
--=====--
  ramAddr : out std_logic_vector(15 downto 0);
  ramData : out std_logic_vector(31 downto 0);
  ramWen : out std_logic;
  ramRen : out std_logic;
  ramQ : in std_logic_vector(31 downto 0);
  -- 2-bit code signifying the current state of the ram
  --  00 if the memory is free to use
  --  01 if the memory is being used
  --  10 if the memory is accessed
  --  11 if the memory encounters an error
  ramState : in std_logic_vector(1 downto 0));
end arbiter;

architecture behavioral of arbiter is

  -- SIGNALS --
  signal dActivity : std_logic;

begin

  -- The only source of read data is Q, so it is always broadcast. However, it
  --  may not be enablied.
  aiMemData <= ramQ;
  adMemDataRead <= ramQ;

  -- The Ram address comes from data unless data isn't doing anything
  ramAddr <= adMemAddr(15 downto 0) when (adMemRead='1' or adMemWrite='1') else
    aiMemAddr(15 downto 0) when (aiMemRead='1') else
    (others => '0');

  -- The data being written to the RAM is the write data from the data memory
  --  as long as it isn't trying to read and write simultaneously
  ramData <= adMemDataWrite when (adMemRead='0' and adMemWrite='1') else
    (others => '0');

  -- The write enable is only '1' if the data memory is trying to write, and
  --  not read simultaneously.
  ramWen <= '1' when adMemWrite='1' and adMemRead='0' else
    '0';

  -- If either the instruction memory or the data memory is trying to read,
  --  the read enable is asserted
  ramRen <= '1' when (adMemRead='1' or aiMemRead='1') and adMemWrite='0' else '0';

  -- dMem is waiting if it requested some action, and the stage isn't the access stage. Otherwise, it can
  --  do stuff if it so desires.
  adMemWait <= '1' when (adMemRead='1' or adMemWrite='1') and not ramState="10" else
    '0';

  -- iMem is waiting if it requested some action, and either the stage isn't action, or the dMem is taking
  --  some action. Otherwise, it isn't waiting.
  aiMemWait <= '1' when (aiMemRead='1') and (dActivity='1' or not ramState="10") else
    '0';

  dCheck : process(clk, nReset)
  begin
    if(nReset='0')then
      dActivity <= '0';
    elsif(falling_edge(clk))then
      if(adMemRead='1' or adMemWrite='1')then
        dActivity <= '1';
      else
        dActivity <= '0';
      end if;
    end if;
  end process;
  
end behavioral;
