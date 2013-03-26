-- $Id: $
-- File name:   tb_alu.vhd
-- Created:     1/14/2013
-- Author:      John Hubberts
-- Lab Section: Tuesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_alu is
end tb_alu;

architecture TEST of tb_alu is

  function INT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
    variable RES : STD_LOGIC_VECTOR(NumBits-1 downto 0);
    variable tmp : INTEGER;
  begin
    tmp := X;
    for i in 0 to NumBits-1 loop
      if (tmp mod 2)=1 then
        res(i) := '1';
      else
        res(i) := '0';
      end if;
      tmp := tmp/2;
    end loop;
    return res;
  end;

  procedure op(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0);
                  constant opcode_val : in std_logic_vector(5 downto 0)) is
  begin
    A <= A_val;
    B <= B_val;
    opcode <= opcode_val;
  end op;

  procedure lsop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "000000");
  end lsop;

  procedure rsop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "000010");
  end rsop;

  procedure orop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "100101");
  end orop;

  procedure andop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "100100");
  end andop;
--
  procedure xorop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "100110");
  end xorop;

  procedure norop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "100111");
  end norop; --

  procedure addop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "100001");
  end addop;

  procedure subop(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "100011");
  end subop;

  procedure slt(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "101010");
  end slt;

  procedure sltu(signal A : out std_logic_vector(31 downto 0);
                  constant A_val : in std_logic_vector(31 downto 0);
                  signal B : out std_logic_vector(31 downto 0);
                  constant B_val : in std_logic_vector(31 downto 0);
                  signal opcode : out std_logic_vector(5 downto 0)) is
  begin
    op(A, A_val, B, B_val, opcode, "101011");
  end sltu;

  component alu
    PORT(
         opcode : in std_logic_vector(5 downto 0);
         A : in std_logic_vector(31 downto 0);
         B : in std_logic_vector(31 downto 0);
         aluout : out std_logic_vector(31 downto 0);
         negative : out std_logic;
         overflow : out std_logic;
         zero : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal opcode : std_logic_vector(5 downto 0);
  signal A : std_logic_vector(31 downto 0);
  signal B : std_logic_vector(31 downto 0);
  signal aluout : std_logic_vector(31 downto 0);
  signal negative : std_logic;
  signal overflow : std_logic;
  signal zero : std_logic;

-- signal <name> : <type>;

begin
  DUT: alu port map(
                opcode => opcode,
                A => A,
                B => B,
                aluout => aluout,
                negative => negative,
                overflow => overflow,
                zero => zero
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

    orop(A, x"AAAAAAAA", B, x"55555555", opcode);
    wait for 5000 ns;
    andop(A, x"AAAAAAAA", B, x"55555555", opcode);
    wait for 5000 ns;
    xorop(A, x"AAAAAAAA", B, x"55555555", opcode);
    wait for 5000 ns;
    norop(A, x"AAAAAAAA", B, x"55555555", opcode);
    wait for 5000 ns;
    lsop(A, x"AAAAAAAA", B, x"00000007", opcode);
    wait for 5000 ns;
    rsop(A, x"AAAAAAAA", B, x"00000007", opcode);
    wait for 5000 ns;
    addop(A, x"7FFFFFFF", B, x"7FFFFFFF", opcode);
    wait for 5000 ns;
    addop(A, x"00000001", B, x"FFFFFFFF", opcode);
    wait for 5000 ns;
    addop(A, x"01234567", B, x"02345678", opcode);
    wait for 5000 ns;
    subop(A, x"FFFFFFFF", B, x"FFFFFFFF", opcode);
    wait for 5000 ns;
    subop(A, x"80000000", B, x"80000000", opcode);
    wait for 5000 ns;
    subop(A, x"0000FC00", B, x"FF070300", opcode);
    wait for 5000 ns;
    slt(A, x"FFFFFFFF", B, x"00000003", opcode);
    wait for 5000 ns;
    sltu(A, x"FFFFFFFF", B, x"00000003", opcode);
    wait for 5000 ns;



  end process;
end TEST;
