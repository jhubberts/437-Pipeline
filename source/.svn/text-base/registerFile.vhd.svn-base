-- 32 bit version register file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
  port(
    wdat   : in std_logic_vector (31 downto 0); -- Write data input port
    wsel   : in std_logic_vector (4 downto 0); -- Selects which register to write
    wen    : in std_logic; -- Write Enable for entire register file
    clk    : in std_logic; -- clock, positive edge triggered
    nReset : in std_logic; -- Active low register file reset
    rsel1  : in std_logic_vector (4 downto 0); -- Select which register to read on rdat1 
    rsel2  : in std_logic_vector (4 downto 0); -- Select which register to read on rdat2
    rdat1  : out std_logic_vector (31 downto 0); -- Read port 1
    rdat2  : out std_logic_vector (31 downto 0)); -- Read port 2
end registerFile;

architecture regfile_arch of registerFile is
  type REGISTER32 is array (0 to 31) of std_logic_vector(31 downto 0);
  signal regs : REGISTER32; -- registers as an array

begin

  -- Handles the behavior of the register array
  registers : process (clk, nReset)
  begin
    if (nReset = '0') then
    -- If the reset is asserted, set every register to 0x00000000
      for I in 0 to 31 loop
        regs(i) <= (others => '0');
      end loop;
    elsif (falling_edge(clk)) then
    -- On the rising edge, if the write enable is asserted, replace
    --  the value of the register at the specified index with the
    --  value of wdat. If the wsel is equal to "00000", do nothing,
    --  as register 0 is always set to 0x00000000
      if(not(wsel="00000") and wen='1')then
        regs(to_integer(unsigned(wsel))) <= wdat;
      end if;
    end if;
  end process;

  -- Process handling the output logic of rdat1
  read1 : process(rsel1, regs)
  begin
    rdat1 <= regs(to_integer(unsigned(rsel1)));
  end process;

  -- Process handling the output logic of rdat2
  read2 : process(rsel2, regs)
  begin
    rdat2 <= regs(to_integer(unsigned(rsel2)));
  end process;

end regfile_arch;
