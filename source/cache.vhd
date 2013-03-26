-- Cache template provided by the 437 course staff. Heavily modified
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache is
	port(
		CLK					:	in	std_logic;
		nReset			:	in	std_logic;
		WrEn				:	in	std_logic;
		Tag					:	in	std_logic_vector (24 downto 0);
		Index				:	in	std_logic_vector (3 downto 0);
		CacheBlockI	:	in 	std_logic_vector (63 downto 0);
		CacheBlockO	:	out std_logic_vector (63 downto 0);
		Dirty				:	out	std_logic;
		Hit					:	out	std_logic;

		dump :  in std_logic;
		DumpIdx : in std_logic_vector(4 downto 0);
		DumpAddr : out std_logic_vector(31 downto 0)
  );
end cache;

architecture struct of cache is 

	--========================--
	-- COMPONENT DECLARATIONS --
	--========================--

-- 64-bit data array used for storing the data
component data16x64
	port(
	clk : in std_logic;
	nReset : in std_logic;
	addr : in std_logic_vector(3 downto 0);
	we : in std_logic;
	writeport : in std_logic_vector(63 downto 0);
	readport : out std_logic_vector(63 downto 0)
	);
end component;

-- 55-bit data array used for storing the LRU, tags, and dirty/valid bits
component data16x55
	port(
	clk : in std_logic;
	nReset : in std_logic;
	addr : in std_logic_vector(3 downto 0);
	we : in std_logic;
	writeport : in std_logic_vector(54 downto 0);
	readport : out std_logic_vector(54 downto 0)
	);
end component;

	--=====================--
	-- SIGNAL DECLARATIONS --
	--=====================--
	signal way0_we, way1_we : std_logic;
	signal way0_outdata, way1_outdata : STD_LOGIC_VECTOR(63 downto 0);

	-- Metadata about the data at each index
	-- 54 -> LRU bit
	-- 53 -> way0 valid bit
	-- 52 -> way0 dirty bit
	-- (51 downto 27) -> way0 tag
	-- 26 -> way 1 valid bit
	-- 25 -> way 1 dirty bit
	-- (24 downto 0) -> way1 tag
	signal metadata_in, metadata_out : std_logic_vector(54 downto 0);

	signal tIndex : std_logic_vector(3 downto 0);
	signal lru_in, lru_out : std_logic;
	signal valid0_in, valid1_in, dirty0_in, dirty1_in, valid0_out, valid1_out, dirty0_out, dirty1_out : std_logic;
	signal tag0_in, tag1_in, tag0_out, tag1_out : std_logic_vector(24 downto 0);

begin

	way0 : data16x64 port map(
		clk => CLK,
		nReset => nReset,
		addr => tIndex,
		we => way0_we,
		writeport => CacheBlockI,
		readport => way0_outdata);

	way1 : data16x64 port map(
		clk => CLK,
		nReset => nReset,
		addr => tIndex,
		we => way1_we,
		writeport => CacheBlockI,
		readport => way1_outdata);

	metadata : data16x55 port map(
		clk => CLK,
		nReset => nReset,
		addr => tIndex,
		we => WrEn,
		writeport => metadata_in,
		readport => metadata_out);

cache_write : process(CLK, WrEn, way0_we, valid0_out, dirty0_out, tag0_out, valid1_out, dirty1_out, tag1_out, lru_out, Tag)
begin
	-- Set default values for way write enables, and for the metadata inputs (excluding lru)
	way0_we <= '0';
	way1_we <= '0';
	valid0_in <= valid0_out;
	dirty0_in <= dirty0_out;
	tag0_in <= tag0_out;
	valid1_in <= valid1_out;
	dirty1_in <= dirty1_out;
	tag1_in <= tag1_out;

	if WrEn = '1' then
		if(valid0_out='1' and tag0_out=Tag)then
			valid0_in <= '1';
			dirty0_in <= '1';
			tag0_in <= Tag;
			way0_we <= '1';				
		elsif(valid1_out='1' and tag1_out=Tag)then
			valid1_in <= '1';
			dirty1_in <= '1';
			tag1_in <= Tag;
			way1_we <= '1';				
		elsif lru_out='0' then
			valid0_in <= '1';
			dirty0_in <= '1';
			tag0_in <= Tag;
			way0_we <= '1';
		else
			valid1_in <= '1';
			dirty1_in <= '1';
			tag1_in <= Tag;
			way1_we <= '1';
		end if;
	end if;
end process cache_write;

cache_lookup: process(lru_out, Tag, tag0_out, tag1_out, valid0_out, valid1_out, dirty0_out, dirty1_out, way0_outdata, way1_outdata, dump, dumpidx)
begin
	-- Set default cases for the outputs and for the lru_in
	lru_in <= lru_out;
	Dirty <= '0';
	Hit <= '0';
  CacheBlockO <= x"BAD1BAD2BAD3BAD4";

	-- Handle normal cases (system isn't dumping)
	if(dump='0')then
		-- If there's a hit, put it on CacheBlockO, and update the corresponding bits
		if(valid0_out='1' and tag0_out=Tag)then
			CacheBlockO <= way0_outdata;
			lru_in <= '1';
			Hit <= '1';
			Dirty <= dirty0_out;
		elsif(valid1_out='1' and tag1_out=Tag)then
			CacheBlockO <= way1_outdata;
			lru_in <= '0';
			Hit <= '1';
			Dirty <= dirty1_out;

		-- If there's a miss, 
		else
			Hit <= '0';
			if(lru_out <= '0')then
				lru_in <= '1';
				Dirty <= dirty0_out;
				if(dirty0_out='1')then
					CacheBlockO <= way0_outdata;
					DumpAddr <= tag0_out & Index & "000";
				end if;
			else
				lru_in <= '0';
				Dirty <= dirty1_out;
				if(dirty1_out='1')then
					CacheBlockO <= way1_outdata;
					DumpAddr <= tag1_out & Index & "000";
				end if;
			end if;
		end if;
	else
		if(dumpidx(4)='0')then
			Dirty <= dirty0_out;
			CacheBlockO <= way0_outdata;
			DumpAddr <= tag0_out & dumpidx(3 downto 0) & "000";
		else
			Dirty <= dirty1_out;
			CacheBlockO <= way1_outdata;
			DumpAddr <= tag1_out & dumpidx(3 downto 0) & "000";
		end if;
	end if;

	-- on match select cache block to return.
	-- update replacement bits
	-- update dirty valid on write. This depends on write policy.
end process cache_lookup;

	--=====================--
	-- DATAFLOW STATEMENTS --
	--=====================--

	-- METADATA OUTPUT SPLITTING
	lru_out <= metadata_out(54);
	valid0_out <= metadata_out(53);
	dirty0_out <= metadata_out(52);
	tag0_out <= metadata_out(51 downto 27);
	valid1_out <= metadata_out(26);
	dirty1_out <= metadata_out(25);
	tag1_out <= metadata_out(24 downto 0);

	-- METADATA INPUT CONCATENATION
	metadata_in <= lru_in & valid0_in & dirty0_in & tag0_in & valid1_in & dirty1_in & tag1_in;

	tIndex <= Index when dump='0' else dumpidx(3 downto 0);
end struct;


