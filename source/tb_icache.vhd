-- $Id: $
-- File name:   tb_icache.vhd
-- Created:     3/5/2013
-- Author:      John Hubberts
-- Lab Section: Tuesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_icache is
generic (Period : Time := 20 ns);
end tb_icache;

architecture TEST of tb_icache is

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

	procedure loadval(signal iMemRead : out std_logic;
		signal aiMemWait : out std_logic;
		signal aiMemAddr : out std_logic_vector(31 downto 0);
		signal aiMemData : out std_logic_vector(31 downto 0);
		constant val : in std_logic_vector(31 downto 0);
		constant addr : in std_logic_vector(31 downto 0))is
	begin
		iMemRead <= '1';
		aiMemWait <= '1';
		aiMemAddr <= addr;
		aiMemData <= x"BAD1BAD1";
		wait for Period;
		aiMemWait <= '0';
		aiMemData <= val;
		wait for Period;
		iMemRead <= '0';
	end loadval;

	procedure cloadval(signal iMemRead : out std_logic;
		signal aiMemWait : out std_logic;
		signal aiMemAddr : out std_logic_vector(31 downto 0);
		constant addr : in std_logic_vector(31 downto 0))is
	begin
		iMemRead <= '1';
		aiMemWait <= '1';
		aiMemAddr <= addr;
		wait for Period;
		aiMemWait <= '0';
		wait for Period;
		iMemRead <= '0';
	end cloadval;

  component icache
    PORT(
         clk : in std_logic;
         nReset : in std_logic;
         iMemRead : in std_logic;
         iMemAddr : in std_logic_vector (31 downto 0);
         iMemWait : out std_logic;
         iMemData : out std_logic_vector (31 downto 0);
         aiMemWait : in std_logic;
         aiMemData : in std_logic_vector (31 downto 0);
         aiMemRead : out std_logic;
         aiMemAddr : out std_logic_vector (31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal nReset : std_logic;
  signal iMemRead : std_logic;
  signal iMemAddr : std_logic_vector (31 downto 0);
  signal iMemWait : std_logic;
  signal iMemData : std_logic_vector (31 downto 0);
  signal aiMemWait : std_logic;
  signal aiMemData : std_logic_vector (31 downto 0);
  signal aiMemRead : std_logic;
  signal aiMemAddr : std_logic_vector (31 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: icache port map(
                clk => clk,
                nReset => nReset,
                iMemRead => iMemRead,
                iMemAddr => iMemAddr,
                iMemWait => iMemWait,
                iMemData => iMemData,
                aiMemWait => aiMemWait,
                aiMemData => aiMemData,
                aiMemRead => aiMemRead,
                aiMemAddr => aiMemAddr
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    nReset <= '1';
    iMemRead <= '0';
    iMemAddr <= (others => '0');
    aiMemWait <= '0';
    aiMemData <= (others => '0');
		wait for 7 ns;
		nReset <= '0';
		wait for Period*5;
		nReset <= '1';
		wait for 3 ns;

		loadval(iMemRead, aiMemWait, iMemAddr, aiMemData, x"00000001", x"00000004");
		loadval(iMemRead, aiMemWait, iMemAddr, aiMemData, x"00000002", x"00000008");
		loadval(iMemRead, aiMemWait, iMemAddr, aiMemData, x"00000003", x"0000000C");
		cloadval(iMemRead, aiMemWait, iMemAddr, x"00000008");
		cloadval(iMemRead, aiMemWait, iMemAddr, x"0000000C");
		cloadval(iMemRead, aiMemWait, iMemAddr, x"00000004");

  end process;
end TEST;
