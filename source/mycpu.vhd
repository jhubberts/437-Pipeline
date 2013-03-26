--================================================================================--
--Title: mycpu.vhd
--Description: 
-- File containing pipelined processor (seperate from the RAM).
--Author: John J. Hubberts
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity mycpu is
  port(
    CLK : in std_logic;
    nReset: in std_logic;
    halt : out std_logic;
    ramAddr : out std_logic_vector(15 downto 0);
    ramData : out std_logic_vector(31 downto 0);
    ramWen : out std_logic;
    ramRen : out std_logic;
    ramQ : in std_logic_vector(31 downto 0);
    ramState : in std_logic_vector(1 downto 0)
    );
end mycpu;

architecture dataflow of mycpu is

  --========================--
  -- COMPONENT DECLARATIONS --
  --========================--
  component cpu_datapath is
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
  end component;

  component arbiter is
  port(
    clk : in std_logic;
    nReset : in std_logic;
    aiMemRead : in std_logic;
    aiMemWait : out std_logic;
    aiMemAddr : in std_logic_vector(31 downto 0);
    aiMemData : out std_logic_vector(31 downto 0);
    adMemRead : in std_logic;
    adMemWrite : in std_logic;
    adMemWait : out std_logic;
    adMemAddr : in std_logic_vector(31 downto 0);
    adMemDataRead : out std_logic_vector(31 downto 0);
    adMemDataWrite : in std_logic_vector(31 downto 0);
    ramAddr : out std_logic_vector(15 downto 0);
    ramData : out std_logic_vector(31 downto 0);
    ramWen : out std_logic;
    ramRen : out std_logic;
    ramQ : in std_logic_vector(31 downto 0);
    ramState : in std_logic_vector(1 downto 0)
  );
  end component;

  component icache is
  port(
    clk       : in  std_logic;
    nReset    : in  std_logic;
    iMemRead  : in  std_logic;
    iMemWait  : out std_logic;
    iMemAddr  : in  std_logic_vector (31 downto 0);
    iMemData  : out std_logic_vector (31 downto 0);
    aiMemWait : in  std_logic;
    aiMemRead : out std_logic;
    aiMemAddr : out std_logic_vector (31 downto 0);
    aiMemData : in  std_logic_vector (31 downto 0)
  );
  end component;

  component dcache is
  port(
    clk            : in  std_logic;
    nReset         : in  std_logic;
		dump					 : in  std_logic;
		halt					 : out std_logic;
    dMemRead       : in  std_logic;
    dMemWrite      : in  std_logic;
    dMemWait       : out std_logic;
    dMemAddr       : in  std_logic_vector (31 downto 0);
    dMemDataRead   : out std_logic_vector (31 downto 0);
    dMemDataWrite  : in  std_logic_vector (31 downto 0);
    adMemRead      : out std_logic;
    adMemWrite     : out std_logic;
    adMemWait      : in  std_logic;
    adMemAddr      : out std_logic_vector (31 downto 0);
    adMemDataRead  : in  std_logic_vector (31 downto 0);
    adMemDataWrite : out std_logic_vector (31 downto 0)
  );
  end component;

  --=====================--
  -- SIGNAL DECLARATIONS --
  --=====================--
    signal iMemRead  : std_logic;
    signal iMemWait  : std_logic;
    signal iMemAddr  : std_logic_vector (31 downto 0);
    signal iMemData  : std_logic_vector (31 downto 0);
    signal aiMemWait : std_logic;
    signal aiMemRead : std_logic;
    signal aiMemAddr : std_logic_vector (31 downto 0);
    signal aiMemData : std_logic_vector (31 downto 0);
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

		signal halt_i : std_logic;

begin

  my_dcache : dcache port map(
    clk => CLK,
    nReset => nReset,
		dump => halt_i,
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

  my_icache : icache port map(
    clk => CLK,
    nReset => nReset,
    iMemRead => iMemRead,
    iMemWait => iMemWait,
    iMemAddr => iMemAddr,
    iMemData => iMemData,
    aiMemWait => aiMemWait,
    aiMemRead => aiMemRead,
    aiMemAddr => aiMemAddr,
    aiMemData => aiMemData
  );

  my_arbiter : arbiter port map(
    clk => CLK,
    nReset => nReset,
    aiMemRead => aiMemRead,
    aiMemWait => aiMemWait,
    aiMemAddr => aiMemAddr,
    aiMemData => aiMemData,
    adMemRead => adMemRead,
    adMemWrite => adMemWrite,
    adMemWait => adMemWait,
    adMemAddr => adMemAddr,
    adMemDataRead => adMemDataRead,
    adMemDataWrite => adMemDataWrite,
    ramAddr => ramAddr,
    ramData => ramData,
    ramWen => ramWen,
    ramRen => ramRen,
    ramQ => ramQ,
    ramState => ramState
  );

  my_datapath : cpu_datapath port map(
    clk => CLK,
    nReset => nReset,
    halt => halt_i,
    iMemRead => iMemRead,
    iMemWait => iMemWait,
    iMemAddr => iMemAddr,
    iMemData => iMemData,
    dMemRead => dMemRead,
    dMemWrite => dMemWrite,
    dMemWait => dMemWait,
    dMemAddr => dMemAddr,
    dMemDataRead => dMemDataRead,
    dMemDataWrite => dMemDataWrite
  );

end dataflow;
