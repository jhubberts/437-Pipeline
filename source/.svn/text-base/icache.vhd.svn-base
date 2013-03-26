--Direct mapped, one word blocks
--|   26   |   4   |   0   |   2   |
--   tag     index  blk off  byte offset
-- synthesis library ~/lib/icache_gold

--This was coded verbosely on purpose. You would be wise not to copy
--this structure for your dcache!

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity icache is
  port(
    clk       : in  std_logic;
    nReset    : in  std_logic;

    iMemRead  : in  std_logic;                       -- CPU side
    iMemAddr  : in  std_logic_vector (31 downto 0);  -- CPU side
    iMemWait  : out std_logic;                       -- CPU side    
    iMemData  : out std_logic_vector (31 downto 0);  -- CPU side

    aiMemWait : in  std_logic;                       -- arbitrator side
    aiMemData : in  std_logic_vector (31 downto 0);  -- arbitrator side
    aiMemRead : out std_logic;                       -- arbitrator side
    aiMemAddr : out std_logic_vector (31 downto 0)   -- arbitrator side    
    );
end icache;

architecture dataflow of icache is
signal cram0, cram1, cram2, cram3, cram4, cram5, cram6, cram7, cram8, cram9, cram10, cram11, cram12, cram13, cram14, cram15 : std_logic_vector(41 downto 0);
signal n_cram0, n_cram1, n_cram2, n_cram3, n_cram4, n_cram5, n_cram6, n_cram7, n_cram8, n_cram9, n_cram10, n_cram11, n_cram12, n_cram13, n_cram14, n_cram15 : std_logic_vector(41 downto 0);
signal valid, valid_ns: std_logic_vector(15 downto 0);
signal cacheIndex: std_logic_vector(3 downto 0);
signal tagIn, tagStored: std_logic_vector(9 downto 0);
signal isValid, hit, nowValid: std_logic;
signal we: std_logic;
signal writeport: std_logic_vector(41 downto 0);
signal readport : std_logic_vector(31 downto 0);   
begin
process (clk, nReset)
begin
if (nReset = '0') then
valid <= x"0000";
cram0 <= (others=>'0');
cram1 <= (others=>'0'); 
cram2 <= (others=>'0'); 
cram3 <= (others=>'0'); 
cram4 <= (others=>'0'); 
cram5 <= (others=>'0'); 
cram6 <= (others=>'0'); 
cram7 <= (others=>'0'); 
cram8 <= (others=>'0'); 
cram9 <= (others=>'0'); 
cram10 <= (others=>'0'); 
cram11 <= (others=>'0'); 
cram12 <= (others=>'0');
cram13 <= (others=>'0'); 
cram14 <= (others=>'0'); 
cram15 <= (others=>'0');          
elsif (rising_edge(clk)) then
valid <= valid_ns;
cram0 <= n_cram0;
cram1 <= n_cram1;
cram2 <= n_cram2; 
cram3 <= n_cram3; 
cram4 <= n_cram4; 
cram5 <= n_cram5; 
cram6 <= n_cram6; 
cram7 <= n_cram7; 
cram8 <= n_cram8; 
cram9 <= n_cram9; 
cram10 <= n_cram10; 
cram11 <= n_cram11; 
cram12 <= n_cram12; 
cram13 <= n_cram13; 
cram14 <= n_cram14; 
cram15 <= n_cram15; 
end if;
end process;
cacheIndex <= iMemAddr(5 downto 2);
tagIn <= iMemAddr(15 downto 6);
tagStored <= cram0(41 downto 32) when ((cacheIndex xor "0000") = "0000") else cram1(41 downto 32) when ((cacheIndex xor "0001") = "0000") else cram2(41 downto 32) when ((cacheIndex xor "0010") = "0000") else cram3(41 downto 32) when ((cacheIndex xor "0011") = "0000") else cram4(41 downto 32) when ((cacheIndex xor "0100") = "0000") else cram5(41 downto 32) when ((cacheIndex xor "0101") = "0000") else cram6(41 downto 32) when ((cacheIndex xor "0110") = "0000") else cram7(41 downto 32) when ((cacheIndex xor "0111") = "0000") else cram8(41 downto 32) when ((cacheIndex xor "1000") = "0000") else cram9(41 downto 32) when ((cacheIndex xor "1001") = "0000") else cram10(41 downto 32) when ((cacheIndex xor "1010") = "0000") else cram11(41 downto 32) when ((cacheIndex xor "1011") = "0000") else cram12(41 downto 32) when ((cacheIndex xor "1100") = "0000") else cram13(41 downto 32) when ((cacheIndex xor "1101") = "0000") else cram14(41 downto 32) when ((cacheIndex xor "1110") = "0000") else cram15(41 downto 32) when ((cacheIndex xor "1111") = "0000") else (others => '0');
isValid <= '1' when valid(0) = '1' and ((cacheIndex xor "0000") = "0000") else '1' when valid(1) = '1' and ((cacheIndex xor "0001") = "0000") else '1' when valid(2) = '1' and ((cacheIndex xor "0010") = "0000") else '1' when valid(3) = '1' and ((cacheIndex xor "0011") = "0000") else '1' when valid(4) = '1' and ((cacheIndex xor "0100") = "0000") else '1' when valid(5) = '1' and ((cacheIndex xor "0101") = "0000") else '1' when valid(6) = '1' and ((cacheIndex xor "0110") = "0000") else '1' when valid(7) = '1' and ((cacheIndex xor "0111") = "0000") else '1' when valid(8) = '1' and ((cacheIndex xor "1000") = "0000") else '1' when valid(9) = '1' and ((cacheIndex xor "1001") = "0000") else '1' when valid(10) = '1' and ((cacheIndex xor "1010") = "0000") else '1' when valid(11) = '1' and ((cacheIndex xor "1011") = "0000") else '1' when valid(12) = '1' and ((cacheIndex xor "1100") = "0000") else '1' when valid(13) = '1' and ((cacheIndex xor "1101") = "0000") else '1' when valid(14) = '1' and ((cacheIndex xor "1110") = "0000") else '1' when valid(15) = '1' and ((cacheIndex xor "1111") = "0000") else '0';
hit <= '1' when isValid = '1' and (tagIn = tagStored) else '0';
aiMemAddr  <= iMemAddr;
iMemData <= readport;
readport <= cram0(31 downto 0) when (hit = '1' and (cacheIndex xor "0000") = "0000") else cram1(31 downto 0) when (hit = '1' and (cacheIndex xor "0001") = "0000") else cram2(31 downto 0) when (hit = '1' and (cacheIndex xor "0010") = "0000") else cram3(31 downto 0) when (hit = '1' and (cacheIndex xor "0011") = "0000") else cram4(31 downto 0) when (hit = '1' and (cacheIndex xor "0100") = "0000") else cram5(31 downto 0) when (hit = '1' and (cacheIndex xor "0101") = "0000") else cram6(31 downto 0) when (hit = '1' and (cacheIndex xor "0110") = "0000") else cram7(31 downto 0) when (hit = '1' and (cacheIndex xor "0111") = "0000") else cram8(31 downto 0) when (hit = '1' and (cacheIndex xor "1000") = "0000") else cram9(31 downto 0) when (hit = '1' and (cacheIndex xor "1001") = "0000") else cram10(31 downto 0) when (hit = '1' and (cacheIndex xor "1010") = "0000") else cram11(31 downto 0) when (hit = '1' and (cacheIndex xor "1011") = "0000") else cram12(31 downto 0) when (hit = '1' and (cacheIndex xor "1100") = "0000") else cram13(31 downto 0) when (hit = '1' and (cacheIndex xor "1101") = "0000") else cram14(31 downto 0) when (hit = '1' and (cacheIndex xor "1110") = "0000") else cram15(31 downto 0) when (hit = '1' and (cacheIndex xor "1111") = "0000") else aiMemData(31 downto 0) when (hit = '0') else (others => '0');
nowValid <= not aiMemWait;
valid_ns(0) <= (nowValid or hit) when ((cacheIndex xor "0000") = "0000") else valid(0);
valid_ns(1) <= (nowValid or hit) when ((cacheIndex xor "0001") = "0000") else valid(1);
valid_ns(2) <= (nowValid or hit) when ((cacheIndex xor "0010") = "0000") else valid(2);
valid_ns(3) <= (nowValid or hit) when ((cacheIndex xor "0011") = "0000") else valid(3);
valid_ns(4) <= (nowValid or hit) when ((cacheIndex xor "0100") = "0000") else valid(4);
valid_ns(5) <= (nowValid or hit) when ((cacheIndex xor "0101") = "0000") else valid(5);
valid_ns(6) <= (nowValid or hit) when ((cacheIndex xor "0110") = "0000") else valid(6);
valid_ns(7) <= (nowValid or hit) when ((cacheIndex xor "0111") = "0000") else valid(7);
valid_ns(8) <= (nowValid or hit) when ((cacheIndex xor "1000") = "0000") else valid(8);
valid_ns(9) <= (nowValid or hit) when ((cacheIndex xor "1001") = "0000") else valid(9);
valid_ns(10) <= (nowValid or hit) when ((cacheIndex xor "1010") = "0000") else valid(10);
valid_ns(11) <= (nowValid or hit) when ((cacheIndex xor "1011") = "0000") else valid(11);
valid_ns(12) <= (nowValid or hit) when ((cacheIndex xor "1100") = "0000") else valid(12);
valid_ns(13) <= (nowValid or hit) when ((cacheIndex xor "1101") = "0000") else valid(13);
valid_ns(14) <= (nowValid or hit) when ((cacheIndex xor "1110") = "0000") else valid(14);
valid_ns(15) <= (nowValid or hit) when ((cacheIndex xor "1111") = "0000") else valid(15);
we <= (not hit) and (not aiMemWait) and iMemRead;
writeport <= tagIn & aiMemData; 
n_cram0 <= writeport when (we = '1' and (cacheIndex xor "0000") = "0000") else cram0;
n_cram1 <= writeport when (we = '1' and (cacheIndex xor "0001") = "0000") else cram1; 
n_cram2 <= writeport when (we = '1' and (cacheIndex xor "0010") = "0000") else cram2; 
n_cram3 <= writeport when (we = '1' and (cacheIndex xor "0011") = "0000") else cram3; 
n_cram4 <= writeport when (we = '1' and (cacheIndex xor "0100") = "0000") else cram4; 
n_cram5 <= writeport when (we = '1' and (cacheIndex xor "0101") = "0000") else cram5; 
n_cram6 <= writeport when (we = '1' and (cacheIndex xor "0110") = "0000") else cram6; 
n_cram7 <= writeport when (we = '1' and (cacheIndex xor "0111") = "0000") else cram7; 
n_cram8 <= writeport when (we = '1' and (cacheIndex xor "1000") = "0000") else cram8; 
n_cram9 <= writeport when (we = '1' and (cacheIndex xor "1001") = "0000") else cram9; 
n_cram10 <= writeport when (we = '1' and (cacheIndex xor "1010") = "0000") else cram10; 
n_cram11 <= writeport when (we = '1' and (cacheIndex xor "1011") = "0000") else cram11; 
n_cram12 <= writeport when (we = '1' and (cacheIndex xor "1100") = "0000") else cram12; 
n_cram13 <= writeport when (we = '1' and (cacheIndex xor "1101") = "0000") else cram13; 
n_cram14 <= writeport when (we = '1' and (cacheIndex xor "1110") = "0000") else cram14;
n_cram15 <= writeport when (we = '1' and (cacheIndex xor "1111") = "0000") else cram15;   
aiMemRead <= not hit and iMemRead; 
iMemWait <= aiMemWait and (not hit);    
end dataflow;
