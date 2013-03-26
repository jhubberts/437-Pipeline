--================================================================================--
--Title: forwarding_unit.vhd
--Description: The forwarding unit for the processor pipeline. Will forward data
-- from the writeback or memory-access stages to the execution stage in cases where
-- the data has been altered, but not yet written back to the register file.
--Author: John J. Hubberts
--Date: Tuesday, February 12, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit is
	port(
		ex_rs : in std_logic_vector(4 downto 0);
		ex_rt : in std_logic_vector(4 downto 0);

		mem_rw : in std_logic_vector(4 downto 0);
		mem_regwen : in std_logic;

		wb_rw : in std_logic_vector(4 downto 0);
		wb_regwen : in std_logic;

		mem_aluOut : in std_logic_vector(31 downto 0);
		writedata : in std_logic_vector(31 downto 0);
    
		forwardsel1 : out std_logic;
		forwardsel2 : out std_logic;
		forwarddata1 : out std_logic_vector(31 downto 0);
		forwarddata2 : out std_logic_vector(31 downto 0)
		);
end forwarding_unit;

architecture dataflow of forwarding_unit is

	--=====================--
	-- SIGNAL DECLARATIONS --
	--=====================--
	signal memSel1, memSel2 : std_logic;
	signal wbSel1, wbSel2 : std_logic;

begin

	memSel1 <= '1' when ex_rs=mem_rw and mem_regwen='1' and ex_rs/="00000" else '0';
	memSel2 <= '1' when ex_rt=mem_rw and mem_regwen='1' and ex_rt/="00000" else '0';
	wbSel1 <= '1' when ex_rs=wb_rw and wb_regwen='1' and ex_rs/="00000" else '0';
	wbSel2 <= '1' when ex_rt=wb_rw and wb_regwen='1' and ex_rt/="00000" else '0';

	forwardsel1 <= '1' when memSel1='1' or wbSel1='1' else '0';
	forwardsel2 <= '1' when memSel2='1' or wbSel2='1' else '0';

	forwarddata1 <= mem_aluout when memSel1='1'
		else writedata when wbSel1='1'
		else (others => '0');

	forwarddata2 <= mem_aluout when memSel2='1'
		else writedata when wbSel2='1'
		else (others => '0');

end dataflow;
