-- cache tempalte
-- this is provided as a guide to build your cache. It is by no means unfallable.
-- you may need to update vector bit ranges to match specifications in lab handout.
--
-- THIS IS NOT ERROR FREE CODE, YOU MUST UPDATE AND VERIFY SANITY OF LOGIC/INTERFACES
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dcache_ctrl is
	port(
		CLK					:	in	std_logic; 
		nReset			:	in	std_logic;
		Hit					:	in	std_logic; 
		Read				:	in	std_logic;
		Write				:	in	std_logic;
		RamWait			:	in	std_logic;
		BlockAddr		:	in	std_logic_vector (28 downto 0);
		Wordsel			: in  std_logic;
		RamWord			:	in	std_logic_vector (31 downto 0);
		CPUWord			:	in	std_logic_vector (31 downto 0);
		BlockDirty	:	in	std_logic;
		CacheBlockI	:	in	std_logic_vector (63 downto 0);
		CacheBlockO	:	out	std_logic_vector (63 downto 0);
		WordAddr		:	out	std_logic_vector (31 downto 0);
		RamRead			:	out	std_logic;
		RamWrite		:	out	std_logic;
		RamDataWrite : out std_logic_vector(31 downto 0);
		WrEn				:	out	std_logic	;

		dumpaddr : in std_logic_vector(31 downto 0);
		dumpidx : out std_logic_vector(4 downto 0);
		dump : in std_logic;
		halt : out std_logic
	);
end dcache_ctrl;

architecture struct of dcache_ctrl is 
	type ctrlstate is (idle, wb0, wb1, read0, read1, dumpinit, dumpw0, dumpw1, dumphit, dumpdone);
	signal prevstate, state, nextstate : ctrlstate;
	signal hitCounter, hitCounter_next : std_logic_vector(31 downto 0);
	signal RamWordLast : std_logic_vectoR(31 downto 0);
	signal BlockWord0, BlockWord1 : std_logic_vector(31 downto 0);
	signal tDumpIdx, tDumpIdx_next : std_logic_vector(5 downto 0);

begin

-- Synchronous Logic
cctrl_state: process(CLK, nReset, state, RamWord)
begin
	-- On reset, set all internal registers to their idle or zero state.
	if nReset = '0' then
		state <= idle;
		tDumpIdx <= (others => '0');
		hitCounter <= (others => '0');
		RamWordLast <= (others => '0');
	elsif rising_edge(CLK) then
		if state=read0 then
			RamWordLast <= RamWord;
		end if;
		tDumpIdx <= tDumpIdx_next;
		hitCounter <= hitCounter_next;
		prevstate <= state;
		state <= nextstate;
	elsif falling_edge(CLK) then
		if(state=idle)then
			if(Wordsel='0')then
				BlockWord0 <= CPUWord;
				BlockWord1 <= CacheBlockI(31 downto 0);
			else
				BlockWord0 <= CacheBlockI(63 downto 32);
				BlockWord1 <= CPUWord;
			end if;
		end if;
	end if;
end process cctrl_state;

cctrl_ns: process(clk, ramwait, blockdirty, write, read, hit, state, tDumpIdx)
begin
	nextstate <= state;
	tDumpIdx_next <= tDumpIdx;
	hitcounter_next <= hitcounter;
	case state is
		when idle =>
			if(hit='1' and prevstate=idle and (Read='1' or Write='1'))then
				hitcounter_next <= hitcounter+1;
			end if;

			if(dump='0')then
				if(hit='1' or (Read='0' and Write='0'))then
					nextstate <= idle;
				elsif(BlockDirty='1')then
					nextstate <= wb0;
				else
					nextstate <= read0;
				end if;
			else
				nextstate <= dumpinit;
			end if;

		when wb0 =>
			if RamWait='0' then
				nextstate <= wb1;
			else
				nextstate <= wb0;
			end if;

		when wb1 =>
			if RamWait='0' then
				nextstate <= read0;
			else
				nextstate <= wb1;
			end if;

		when read0 =>
			if RamWait='0' then
				nextstate <= read1;
			else
				nextstate <= read0;
			end if;

		when read1 =>
			if RamWait='0' then
				nextstate <= idle;
			else
				nextstate <= read1;
			end if;

		when dumpinit =>
		if(tDumpIdx="100000")then
			nextstate <= dumphit;
		elsif(BlockDirty='1')then
			nextstate <= dumpw0;
		else
			tDumpIdx_next <= tDumpIdx+1;
		end if;

		when dumpw0 =>
			if RamWait='0' then
				nextstate <= dumpw1;
			end if;

		when dumpw1 =>
			if RamWait='0' then
				nextstate <= dumpinit;
				tDumpIdx_next <= tDumpIdx+1;
			end if;

		when dumphit =>
			if RamWait='0' then
				nextstate <= dumpdone;
			end if;

		when dumpdone =>
			nextstate <= dumpdone;

		when others =>
			nextstate <= state;
	end case;

end process cctrl_ns;

cctrl_out : process(clk, state, write, wordsel, cpuword, cacheblocki, blockaddr, Ramword, BlockWord0, BlockWord1)
begin
		CacheBlockO <= (others => '0');
		RamDataWrite <= (others => '0');
		WordAddr <= (others => '0');
		RamRead <= '0';
		RamWrite <= '0';
		WrEn <= '0';
		halt <= '0';

	case state is
		when idle =>
			CacheBlockO <= BlockWord0 & BlockWord1;
			if(Write='1' and Hit='1')then
				WrEn <= '1';
			end if;
		when wb0 =>
			CacheBlockO <= CacheBlockI;
			RamDataWrite <= CacheBlockI(63 downto 32);
			WordAddr <= DumpAddr(31 downto 3) & "000";
			RamWrite <= '1';

		when wb1 =>
			CacheBlockO <= CacheBlockI;
			RamDataWrite <= CacheBlockI(31 downto 0);
			WordAddr <= DumpAddr(31 downto 3) & "100";
			RamWrite <= '1';

		when read0 =>
--		CacheBlockO <= RamWord & x"00000000";
			WordAddr <= BlockAddr & "000";
			RamRead <= '1';
			WrEn <= '0';

		when read1 =>
			CacheBlockO <= RamWordLast & RamWord;
			WordAddr <= BlockAddr & "100";
			RamRead <= '1';
			if(RamWait='0')then
				WrEn <= '1';
			end if;

		when dumpw0 =>
			RamDataWrite <= CacheBlockI(63 downto 32);
			WordAddr <= DumpAddr(31 downto 3) & "000";
			RamWrite <= '1';

		when dumpw1 =>
			RamDataWrite <= CacheBlockI(31 downto 0);
			WordAddr <= DumpAddr(31 downto 3) & "100";
			RamWrite <= '1';

		when dumphit =>
			RamDataWrite <= hitCounter;
			WordAddr <= x"00003100";
			RamWrite <= '1';

		when dumpdone =>
			halt <= '1';

		when others =>
			
	end case;
end process cctrl_out;

	--=====================--
	-- DATAFLOW STATEMEMTS --
	--=====================--
	DumpIdx <= tDumpIdx(4 downto 0);
end;


