--================================================================================--
--Title: hazard_controller.vhd
--Description: 
-- The hazard controller for the pipelined processor. Can stall and bubble PC and regs.
--Author: John J. Hubberts
--Date: Sunday, February 10, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity hazard_controller is
  port(
    clk : in std_logic;
		-- The System Clock

    nReset : in std_logic;
		-- Asysnchronous Reset

    dMemWait : in std_logic;
		-- Wait signal from the dCache

    dMemRead : in std_logic;

    dMemWrite : in std_logic;

    iMemWait : in std_logic;
		-- Wait signal from the iCache

    loadUseHazard: in std_logic;
    -- Signifies that there's a load after use hazard

    halt : in std_logic;
    -- Halts the system in case of a fire

    pcstall : out std_logic;
		-- Signal that stalls the program counter

    regstall : out std_logic_vector(3 downto 0);
		-- Signal that stalls the registers specified

    regbubble : out std_logic_vector(3 downto 0)
		-- Signal that bubbles the registers specified

    );
end hazard_controller;

architecture behavioral of hazard_controller is

  signal dReady : std_logic;

	-- Register versions of the combinational inputs
	signal dMemRead_r, dMemWrite_r, loadUseHazard_r : std_logic;

begin

  dReady <= '1' when dMemWait='0' and (dMemRead_r='1' or dMemWrite_r='1') else '0';

  -- Control Logic for the PC Stall
  pcstall <= '1' when halt='1' -- Stall the PC if you're halting
		or (dMemWait='1' or iMemWait='1') -- Stall the PC if either signal is waiting
		or loadUseHazard_r='1' -- Stall the PC if there's a use-after-load hazard
		or (dReady='1' and loadUseHazard_r='0') -- This'll fix the zero-cycle cached processor
		else '0';

	-- Control Logic for the Register Stall
  regstall <= "1111" when halt='1' -- Stall all Regisers if you're halted
		or (dMemWait='1') -- Stall all registers if both memories are waiting
		or (iMemWait='1' and dMemWait='0' and dReady='0') -- Stall all registers if iMem is waiting
    else "1000" when ((dReady='1' or iMemWait='0') and loadUseHazard_r='1') else "0000"; -- Stall if there's a memory crisis

	-- Control Logic for bubbling. A bubble operation will rewrite the current register
	--  as a NOP on the next non-stalled clock cycle.
  regbubble <=
    "1000" when dReady='1' and loadUseHazard_r='0' else
    "0100" when (dReady='1' and iMemWait='0') and loadUseHazard_r='1'
    else "0000"; 

  regUpdate : process(clk, nReset)
  begin
    if(nReset='0')then
			dMemRead_r <= '0';
			dMemWrite_r <= '0';
			loadUseHazard_r <= '0';
		elsif(falling_edge(clk))then
			dMemRead_r <= dMemRead;
			dMemWrite_r <= dMemWrite;
			loadUseHazard_r <= loadUseHazard;
    end if;
  end process;
  

end behavioral;
