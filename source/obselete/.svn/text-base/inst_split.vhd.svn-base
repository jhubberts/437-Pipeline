--instruction splitter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inst_split is
	port
	(
		instruction	:in std_logic_vector(31 downto 0);
		rs			:out std_logic_vector(4 downto 0);
		rt			:out std_logic_vector(4 downto 0);
		rd			:out std_logic_vector(4 downto 0);
		immediate	:out std_logic_vector(15 downto 0);
		opcode		:out std_logic_vector(5 downto 0);
		jump_inst	:out std_logic_vector(25 downto 0);
		func		:out std_logic_vector(5 downto 0);
		shift_amt	:out std_logic_vector(4 downto 0)
	);
end inst_split;

architecture inst_arch of inst_split is
begin
	rs <= instruction(25 downto 21);
	rt <= instruction(20 downto 16);
	rd <= instruction(15 downto 11);
	immediate <= instruction(15 downto 0);
	opcode <= instruction(31 downto 26);
	jump_inst <= instruction(25 downto 0);
	func <= instruction(5 downto 0);
	shift_amt <= instruction(10 downto 6);
end inst_arch;
