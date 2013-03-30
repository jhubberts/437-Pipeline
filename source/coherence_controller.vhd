--================================================================================--
--Title: coherence_controller.vhd
--Description: The top-level arbiter and cache coherence controller for multicore
--Author: John J. Hubberts
--Date: Saturday, March 30, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity coherence_controller is
	port(
		-- Top Level Signals
		CLK : in std_logic;
		nReset : in std_logic;
		ramAddr : out std_logic_vector(15 downto 0);
		ramData : out std_logic_vector(31 downto 0);
		ramWen : out std_logic;
		ramRen : out std_logic;
		ramQ : in std_logic_vector(31 downto 0);
		ramState : in std_logic_vector(1 downto 0);
		-- Signals from core0
		c0_ramAddr : in std_logic_vector(15 downto 0);
		c0_ramData : in std_logic_vector(31 downto 0);
		c0_ramWen : in std_logic;
		c0_ramRen : in std_logic;
		c0_ramQ : out std_logic_vector(31 downto 0);
		c0_ramState : out std_logic_vector(1 downto 0);
		-- Signals from core1
		c1_ramAddr : in std_logic_vector(15 downto 0);
		c1_ramData : in std_logic_vector(31 downto 0);
		c1_ramWen : in std_logic;
		c1_ramRen : in std_logic;
		c1_ramQ : out std_logic_vector(31 downto 0);
		c1_ramState : out std_logic_vector(1 downto 0)
	);
end coherence_controller;

architecture dataflow of coherence_controller is

	signal coreSelect, coreSelectNext : std_logic;
	signal coreActivity : std_logic;

begin

	ramAddr <= x"FFFF" when coreActivity='0' else
		c0_ramAddr when coreSelect='0' else
		c1_ramAddr;

	ramData <= x"BAD2BAD2" when coreActivity='0' else
		c0_ramData when coreSelect='0' else
		c1_ramData;

	ramRen <= '0' when coreActivity='0' else
		c0_ramRen when coreSelect='0' else
		c1_ramRen;

	ramWen <= '0' when coreActivity='0' else
		c0_ramWen when coreSelect='0' else
		c1_ramWen;

	-- The ramQ goes through transparently
	c0_ramQ <= ramQ;
	c1_ramQ <= ramQ;

	-- The ramState to each core is idle when it isn't selected. Otherwise, it's
	--  the ramState
	c0_ramState <= ramState when coreActivity='1' and coreSelect='0' else "01";
	c1_ramState <= ramState when coreActivity='1' and coreSelect='1' else "01";

	-- If any of the cores are attempting to instigate a memory operation, assert
	--  assert the coreActivity signal.
	coreActivity <= c0_ramRen or c0_ramWen or c1_ramRen or c1_ramWen;

	seqLogic : process(clk, nReset)
	begin
		if nReset='0' then
			coreSelect <= '0';
		elsif rising_edge(clk) then
			coreSelect <= coreSelectNext;
		end if;	
	end process;

	nextStateLogic : process(coreSelect, coreActivity, ramState, c0_ramWen, c0_ramRen, c1_ramWen, c1_ramRen)
	begin
		-- If the cores aren't active
		coreSelectNext <= coreSelect;
		if coreActivity='0' then
			coreSelectNext <= coreSelect;

		elsif coreSelect='0' then
			-- If the core select is on the only inactive
			--  core, then flip it
			if((c0_ramWen='0' and c0_ramRen='0') or ramState="10") then
				coreSelectNext <= '1';
			else
				coreSelectNext <= '0';
			end if;

		elsif coreSelect='1' then
			-- If the core select is on the only inactive
			--  core, then flip it
			if((c1_ramWen='0' and c1_ramRen='0') or ramState="10") then
				coreSelectNext <= '0';
			else
				coreSelectNext <= '1';
			end if;

		end if;
	end process;

end dataflow;
