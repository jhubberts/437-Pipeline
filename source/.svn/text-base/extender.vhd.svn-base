--================================================================================
--Title: extender.vhd
--Description: Performs sign and zero extensions on 16 bit immediates
--Author: John J. Hubberts
--Date: 01/25/2013
--Version: 1.0
--================================================================================

library ieee;
use ieee.std_logic_1164.all;

entity extender is
  port(imm16 : in std_logic_vector(15 downto 0);
    -- The immediate value provided in the opcode for I-type MIPS instructions
    
    signext  : in std_logic;
    -- Flag from the controller, representing how the immediate will be extended
    -- '1' represents sign extended, '0' represents zero extended

    imm32    : out std_logic_vector(31 downto 0));
    -- The 32 bit immediate output used by the ALU in I-type MIPS instructions
end extender;

architecture dataflow of extender is
  --SIGNAL DECLARATIONS
  signal ext16 : std_logic_vector(15 downto 0);
  --signal 1ext : std_logic;
begin
  
  ext16 <= (others => '1') when signext = '1' and imm16(15) = '1' else (others => '0');
  imm32 <= ext16 & imm16;

end dataflow;
