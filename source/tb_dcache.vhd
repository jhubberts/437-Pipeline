-- $Id: $
-- File name:   tb_dcache.vhd
-- Created:     3/18/2013
-- Author:      John Hubberts
-- Lab Section: Tuesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_dcache is
generic (Period : Time := 5 ns);
end tb_dcache;

architecture TEST of tb_dcache is

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

  component dcache
    PORT(
         clk : in std_logic;
         nReset : in std_logic;
         dump : in std_logic;
         halt : out std_logic;
         dMemRead : in std_logic;
         dMemWrite : in std_logic;
         dMemWait : out std_logic;
         dMemAddr : in std_logic_vector (31 downto 0);
         dMemDataRead : out std_logic_vector (31 downto 0);
         dMemDataWrite : in std_logic_vector (31 downto 0);
         adMemRead : out std_logic;
         adMemWrite : out std_logic;
         adMemWait : in std_logic;
         adMemAddr : out std_logic_vector (31 downto 0);
         adMemDataRead : in std_logic_vector (31 downto 0);
         adMemDataWrite : out std_logic_vector (31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal nReset : std_logic;
  signal dump : std_logic;
  signal halt : std_logic;
  signal dMemRead : std_logic;
  signal dMemWrite : std_logic;
  signal dMemWait : std_logic;
  signal dMemAddr : std_logic_vector (31 downto 0);
  signal dMemDataRead : std_logic_vector (31 downto 0);
  signal dMemDataWrite : std_logic_vector (31 downto 0);
  signal adMemRead : std_logic;
  signal adMemWrite : std_logic;
  signal adMemWait : std_logic;
  signal adMemAddr : std_logic_vector (31 downto 0);
  signal adMemDataRead : std_logic_vector (31 downto 0);
  signal adMemDataWrite : std_logic_vector (31 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable CLK_tmp: std_logic := '0';
begin
  CLK_tmp := not CLK_tmp;
  CLK <= CLK_tmp;
  wait for Period/2;
end process;

  DUT: dcache port map(
                clk => clk,
                nReset => nReset,
                dump => dump,
                halt => halt,
                dMemRead => dMemRead,
                dMemWrite => dMemWrite,
                dMemWait => dMemWait,
                dMemAddr => dMemAddr,
                dMemDataRead => dMemDataRead,
                dMemDataWrite => dMemDataWrite,
                adMemRead => adMemRead,
                adMemWrite => adMemWrite,
                adMemWait => adMemWait,
                adMemAddr => adMemAddr,
                adMemDataRead => adMemDataRead,
                adMemDataWrite => adMemDataWrite
                );

process

  begin

		-- Initialize and Reset the Cache
    nReset <= '0'; 
    dump <= '0';
    dMemRead <= '0';
    dMemWrite <= '0';
    dMemAddr <= (others => '0');
    dMemDataWrite <= (others => '0');
    adMemWait <= '0';
    adMemDataRead <= (others => '0');
		wait for Period;
		nReset <= '1';
		wait for Period;

		dMemRead <= '1';
		dMemAddr <= x"00000AC8";
		wait for Period/2;
		adMemDataRead <= x"00000001";
		wait for Period;
		adMemDataRead <= x"00000002";
		wait for 3*Period/2;
		dMemRead <= '0';
		wait for Period*5;
		
		dMemRead <= '1';
		dMemAddr <= x"00000BC8";
		wait for Period/2;
		adMemDataRead <= x"00000003";
		wait for Period;
		adMemDataRead <= x"00000004";
		wait for 3*Period/2;
		dMemRead <= '0';
		wait for Period*5;

		dMemRead <= '1';
		dMemAddr <= x"00000CC8";
		wait for Period/2;
		adMemDataRead <= x"00000005";
		wait for Period;
		adMemDataRead <= x"00000006";
		wait for 3*Period/2;
		dMemRead <= '0';
		wait for Period*5;

  end process;
end TEST;
