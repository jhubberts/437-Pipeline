--================================================================================--
--Title: pipe_id.vhd
--Description: 
-- This is the "Instruction Decode" (ID) stage of the piplelined processor.
--Author: Jose Jurado
--Date: Tuesday, February 05, 2013
--Version: 1.0
--================================================================================--

library ieee;
use ieee.std_logic_1164.all;

entity pipe_id is
  port(
  clk     : in std_logic;
  nReset  : in std_logic;
	--inputs
	id_npc			: in std_logic_vector(31 downto 0);
	id_instruction  : in std_logic_vector(31 downto 0);
	wdat_in			: in std_logic_vector(31 downto 0);
	regWen_in		: in std_logic;
	pcSRC_in		: in std_logic;
	rw_in    : in std_logic_vector(4 downto 0);
	N				: in std_logic;
	--outputs
	d_aluop 		: out std_logic_vector(5 downto 0);
  	d_alusrc 		: out std_logic;
  	d_bneop 		: out std_logic;
  	d_branch 		: out std_logic;
  	d_halt 			: out std_logic;
 	d_inst 			: out std_logic_vector(31 downto 0);
  	d_imm32 		: out std_logic_vector(31 downto 0);
  	d_jalop 		: out std_logic;
  	d_jrop 			: out std_logic;
  	d_jump 			: out std_logic;
  	d_luiop 		: out std_logic;
  	d_memRen 		: out std_logic;
  	d_memToReg 		: out std_logic;
  	d_memWen 		: out std_logic;
  	d_N 			: out std_logic;
  	d_npc 			: out std_logic_vector(31 downto 0);
  	d_rdat1 		: out std_logic_vector(31 downto 0);
  	d_rdat2 		: out std_logiC_vector(31 downto 0);
  	d_regWen 		: out std_logic;
 	d_rw 			: out std_logic_vector(4 downto 0)
);
end pipe_id;

architecture dataflow of pipe_id is
  --===================--
  -- SIGNAL DECLARATIONS --
  --=====================--
	signal signext_out 	: std_logic;
	signal alusrc_out	: std_logic;
	signal shiftop_out	: std_logic;
	signal regdst_out	: std_logic;
	--------------------------------
	signal rs_out			:std_logic_vector(4 downto 0);
	signal rt_out			:std_logic_vector(4 downto 0);
	signal rd_out			:std_logic_vector(4 downto 0);
	signal immediate_out	:std_logic_vector(15 downto 0);
	signal opcode_out		:std_logic_vector(5 downto 0);
	signal jump_out			:std_logic_vector(25 downto 0);
	signal function_out		:std_logic_vector(5 downto 0);
	signal shift_out		:std_logic_vector(4 downto 0);
	------------------------------------
	signal imm32_out		:std_logic_vector(31 downto 0);
	signal concatenated  : std_logic_vector(31 downto 0);
	signal signed_out    :std_logic_vector(31 downto 0);
	signal temp_jalop	: std_logic;
	signal temp_luiop	: std_logic;

  --========================--
  -- COMPONENT DECLARATIONS --
  --========================--
	component cpu_controller is
		port(
			inst : in std_logic_vector(31 downto 0);
   			signext : out std_logic;         -----------------------
    		alusrc : out std_logic;	
    		shiftop : out std_logic; ---------------------
   			regwen : out std_logic; 
    		regdst : out std_logic; 
    		aluop : out std_logic_vector(5 downto 0);
   		    luiop : out std_logic;
    		memtoreg : out std_logic;
    		memwen : out std_logic;
    		bneop : out std_logic;
   		    branch : out std_logic;
    		jalop : out std_logic;
   			jrop : out std_logic;
    		jumpop : out std_logic;
    		halt : out std_logic
		);
	end component;

	component inst_split is
		port(
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
	end component;
	
	component extender is
		port(
			imm16 	 : in std_logic_vector(15 downto 0);
    		signext  : in std_logic;
			imm32    : out std_logic_vector(31 downto 0));
	end component;

	component registerFile is
		port(
			wdat   : in std_logic_vector (31 downto 0); -- Write data input port
    		wsel   : in std_logic_vector (4 downto 0); -- Selects which register to write
   			wen    : in std_logic; -- Write Enable for entire register file
    		clk    : in std_logic; -- clock, positive edge triggered
    		nReset : in std_logic; -- Active low register file reset
    		rsel1  : in std_logic_vector (4 downto 0); -- Select which register to read on rdat1 
    		rsel2  : in std_logic_vector (4 downto 0); -- Select which register to read on rdat2
    		rdat1  : out std_logic_vector (31 downto 0); -- Read port 1
    		rdat2  : out std_logic_vector (31 downto 0) -- Read port 2
		);
	end component;


begin
	reg	: registerFile port map( ------------finish this up
		wdat	=> wdat_in,
    	wsel	=> rw_in,	
   		wen  	=> regWen_in,
    	clk   	=> clk,
    	nReset 	=> nReset,
    	rsel1  	=> rs_out,
    	rsel2  	=> rt_out,
    	rdat1  	=> d_rdat1,
    	rdat2  	=> d_rdat2);
	ext	: extender port map(
		imm16 	=> immediate_out,
    	signext => signext_out,
		imm32   => imm32_out); 
	inst	: inst_split port map(
		instruction	=> id_instruction,
		rs			=> rs_out,
		rt			=> rt_out,
		rd			=> rd_out,
		immediate	=> immediate_out,
		opcode		=> opcode_out,
		jump_inst	=> jump_out,
		func		=> function_out,
		shift_amt	=> shift_out);
	decoder : cpu_controller port map(
    	inst		=> id_instruction,
 	 	signext 	=> signext_out,
    	alusrc 		=> alusrc_out,
    	shiftop 	=> shiftop_out,
    	regwen 		=> d_regWen,
    	regdst		=> regdst_out,
    	aluop		=>d_aluop,
    	luiop 		=> temp_luiop,
    	memtoreg 	=> d_memToReg,
    	memwen		=> d_memWen,
    	bneop 		=> d_bneop,
    	branch 		=> d_branch,
    	jalop 		=> temp_jalop,
    	jrop		=> d_jrop,
    	jumpop 		=> d_jump,
    	halt 		=> d_halt);

	d_rw <= "11111" when temp_jalop = '1' else rd_out when regdst_out = '1' else rt_out;	
	d_n <= N or pcSRC_in;
	concatenated <= "0000000000000000" & immediate_out;	
	
	signed_out <= imm32_out when temp_luiop = '0' else concatenated;
	
	d_imm32 <= signed_out when shiftop_out = '0' else "000000000000000000000000000" & shift_out;
end dataflow;		
