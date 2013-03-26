-- dcache wrapper
-- this is provided for a place holder until you do the cache labs
-- until then you should just place this file between your memory stage
-- of your pipeline and your priority mux for main memory.
library ieee;
use ieee.std_logic_1164.all;

entity dcache is
  port(
    clk            : in  std_logic;
    nReset         : in  std_logic;
		dump					 : in  std_logic;
		halt					 : out std_logic;

    dMemRead       : in  std_logic;                       -- CPU side
    dMemWrite      : in  std_logic;                       -- CPU side
    dMemWait       : out std_logic;                       -- CPU side
    dMemAddr       : in  std_logic_vector (31 downto 0);  -- CPU side
    dMemDataRead   : out std_logic_vector (31 downto 0);  -- CPU side
    dMemDataWrite  : in  std_logic_vector (31 downto 0);  -- CPU side

    adMemRead      : out std_logic;                       -- arbitrator side
    adMemWrite     : out std_logic;                       -- arbitrator side
    adMemWait      : in  std_logic;                       -- arbitrator side
    adMemAddr      : out std_logic_vector (31 downto 0);  -- arbitrator side
    adMemDataRead  : in  std_logic_vector (31 downto 0);  -- arbitrator side
    adMemDataWrite : out std_logic_vector (31 downto 0)   -- arbitrator side
    );

end dcache;

architecture struct of dcache is
	component cache
		port (
			CLK					: in 	std_logic;
			nReset			:	in 	std_logic;
			WrEn				: in	std_logic;
			Tag					:	in 	std_logic_vector(24 downto 0);
			Index				: in	std_logic_vector(3 downto 0);
			CacheBlockI	: in 	std_logic_vector(63 downto 0);
			CacheBlockO	: out	std_logic_vector(63 downto 0);
			Dirty				:	out	std_logic;
			Hit					: out	std_logic;

			dump :  in std_logic;
			DumpIdx : in std_logic_vector(4 downto 0);
			DumpAddr : out std_logic_vector(31 downto 0)
		);
	end component;

	component dcache_ctrl
		port (
			CLK					: in	std_logic;
			nReset			: in	std_logic;
			Hit					: in	std_logic;
			Read				:	in	std_logic;
			Write				:	in	std_logic;
			RamWait			: in	std_logic;
			BlockAddr		:	in	std_logic_vector(28 downto 0);
			Wordsel			: in  std_logic;
			RamWord			:	in	std_logic_vector(31 downto 0);
			CPUWord			:	in	std_logic_vector(31 downto 0);
			BlockDirty	:	in	std_logic;
			CacheBlockI	:	in	std_logic_vector(63 downto 0);
			CacheBlockO	:	out	std_logic_vector(63 downto 0);
			WordAddr		:	out	std_logic_vector(31 downto 0);
			RamRead			:	out	std_logic;
			RamWrite		:	out	std_logic;
			RamDataWrite : out std_logic_vector(31 downto 0);
			WrEn				:	out	std_logic;
			dumpaddr : in std_logic_vector(31 downto 0);
			dumpidx : out std_logic_vector(4 downto 0);
			dump	: in std_logic;
			halt : out std_logic
		);
	end component;

	-- internal singals
	signal tWrEn, tHit, tDirty					: std_logic; 
	signal tUpdatedBlock, tCacheBlock		: std_logic_vector (63 downto 0);
	signal tDumpAddr : std_logic_vector(31 downto 0);
	signal tDumpIdx : std_logic_vector(4 downto 0);

begin

	DATA_CACHE: cache port map(
		CLK => CLK,
		nReset => nReset,
		Wren => tWrEn, -- update data in cache
		Tag => dMemAddr (31 downto 7), -- tag to look for
		Index => dMemAddr (6 downto 3), -- set to look in
		CacheBlockI => tUpdatedBlock,	-- new block to put in cache
		CacheBlockO => tCacheBlock, -- cache block from set and selected way
		Dirty => tDirty, -- is cache block dirty?
		Hit => tHit, -- did we find a matching cache block

		dump => dump,
		dumpidx => tDumpIdx,
		dumpaddr => tDumpAddr);

	CCTRL: dcache_ctrl port map(
		CLK => CLK,
		nReset => nReset,
		Hit => tHit, -- does the controller need to do anything?
		Read => dMemRead, -- memory write to cache on misss
		Write => dMemWrite, -- cpu write to cache (depends on write policy)
		RamWait => adMemWait, -- which cache has control of memory
		BlockAddr => (dMemAddr(31 downto 3)), -- cache block addr (both words)
		Wordsel => dMemAddr(2),
		RamWord => adMemDataRead, -- word coming from memory
		CPUWord => dMemDataWrite,	-- word coming from CPU
		blockDirty => tDirty,	-- cache block needs to be written to memory
		CacheBlockI => tCacheBlock,	-- cache block
		CacheBlockO => tUpdatedBlock,	-- new block with requested data
		WordAddr => adMemAddr,	-- memory address to get word for cache block
		RamRead => adMemRead, -- Read Enable for the Memory Arbiter
		RamWrite => adMemWrite, -- Write Enable for the Memory Arbiter
		RamDataWrite => adMemDataWrite, -- Write data to the RAM
		WrEn => tWrEn,	-- Update the cache with new block

		dumpaddr => tDumpAddr,
		dumpidx => tDumpIdx,
		dump => dump,
		halt => halt);
	-- Wait if you don't have a hit. Every miss eventually hits.
	dMemWait <= not tHit and (dMemRead or dMemWrite);

	-- Return individual word from block
	with dMemAddr(2) select dMemDataRead <= 
		tCacheBlock(63 downto 32) when '0',
		tCacheBlock(31 downto 00) when others;	

	-- on halt: flush the cache blocks that are dirty
	-- put that logic here


end struct;
