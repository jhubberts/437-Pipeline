library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data16x64 is
  port
  (
		clk				:	IN	STD_LOGIC;
		nReset		: IN  STD_LOGIC;
    addr      : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    we        : IN  STD_LOGIC := '1';
    writeport : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
    readport  : OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
  );
end data16x64;


architecture internalRAM of data16x64 is

	type cacheram is array (0 to 15) of std_logic_vector (63 downto 0);
	signal cram : cacheram;

begin

	ramreg : process (clk, we, nReset, addr)
	begin
		if(nReset='0') then
			for i in 0 to 15 loop
				cram(i) <= (others => '0');
			end loop;
		elsif (rising_edge(clk)) then
			if (we = '1') then
				for i in 0 to 15 loop
					if (std_logic_vector(to_unsigned(i,addr'length)) = addr) then
						cram(i) <= writeport;
					end if;
				end loop;
			end if;
		end if;
	end process;

	ramread : process (addr,cram)
	begin
		readport <= (others => '0');
		for i in 0 to 15 loop
			if (std_logic_vector(to_unsigned(i,addr'length)) = addr) then
				readport <= cram(i);
			end if;
		end loop;
	end process;

end internalRAM;

