----------------------------------------------------------------------------
-- Based on
-- Simple Microprocessor Design (ESD Book Chapter 3)
-- Copyright 2001 Weijun Zhang
--
-- Controller (control logic plus state register)
-- VHDL FSM modeling
-- controller.vhd

-- Angel Jose Soto 2 feb 2017
----------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.constant_lib.all;

entity controller is
port(	clock:		in std_logic;
	rst:		in std_logic;
	IR_word:	in std_logic_vector(31 downto 0);
	DR_zero:	in std_logic;
	LR_zero:	in std_logic;
	
	IR_load:	out std_logic;
	
	PC_clr:		out std_logic;
	PC_inc:		out std_logic;
	PC_load:	out std_logic;
	
	OD_load:	out std_logic;
	OD_clr:		out std_logic;
	
	DR_load:	out std_logic;
	DR_clr:		out std_logic;
	
	LR_load:	out std_logic;
	LR_dec:		out std_logic;
	LR_clr:		out std_logic;
	end_sequence: 	out std_logic
);
end controller;

architecture behavior of controller is

  type state_type is (  S0,S1,S1a,S1b,S2,S3,S3a, S3b,S4,S5,S5a,S6,S6a, S6b, S7);
  signal state: state_type;
	
begin

  process(clock, rst, IR_word)
	
    variable OPCODE: std_logic_vector(2 downto 0);
	
  begin

    if rst='1' then
	IR_load<= '1'; 
	
	PC_clr<='1'; 		--reset state
	PC_inc<='0';
	PC_load<='0';
	
	OD_load<='0';
	OD_clr<='0';
	--OD_clr<='1';
	
	DR_load<='0';
	DR_clr<='1';
	
	LR_load<='0';
	LR_dec<='0';
	LR_clr<='1';
	
	end_sequence <= '0';
	
	state <= S0;

    elsif (clock'event and clock='1') then
	
	case state is
	    
	  when S0 =>	PC_clr <= '0';			-- Reset State	
			state <= S1;	

	  when S1 =>	IR_load<= '1'; 
	
			PC_clr<='0'; 		--Fetch Instruction
			PC_inc<='0';
			PC_load<='0';
	
			OD_load<='0';
			OD_clr<='0';
	
			DR_load<='0';
			DR_clr<='0';
	
			LR_load<='0';
			LR_dec<='0';
			LR_clr<='0';
			state <= S1a;
	   
	  when S1a => 	PC_inc <= '1';
			IR_load <= '0';
	  		state <= S1b;				-- Fetch end ..
	  when S1b => 	PC_inc <= '0';
		  	state <= S2;
	  				
	  when S2 =>	OPCODE := IR_word(31 downto 31-2);
			  case OPCODE is
			    when "000" => 	state <= S3; -- delay Instruction
			    when "001" => 	state <= S4; -- setout Instruction
 			    when "010" => 	state <= S5; -- loadLR Instruction
 			    when "011" => 	state <= S6; -- DecLR and JNZ Instruction
 			    when "100" =>  	state <= S7; -- END_SEQ Instruction
			    when others => 	state <= S0; -- If miss OP jump to reset state
			    end case;
					
	  when S3 =>	DR_load <= '1';	-- loads the Delay register with the Instruction value
			state <= S3a;
	  when S3a => 	DR_load <= '0';	
			state <= S3b;
	  when S3b =>	if DR_zero ='1' then
			  state <= S1;
			else	
			  state <= S3b;
			end if;
	  
	  
	  
	    
	  when S4 =>	OD_load <= '1';	-- setout Instruction, it sets up de OD_load flag
			state <= S1;	-- the next step will clear this flag
	  
		
 	  when S5 =>	LR_load <= '1'; -- loads the Instruction value in the loop register
			state <= S5a;
	  when S5a=> 	LR_load <= '0'; -- clear the load flag and jumps to read a new Instruction
			state <= S1;


 	  when S6 =>	LR_dec <= '1' ;	-- decrements the loop register by one
			state <= S6a;
	  when S6a =>	LR_dec <= '0' ;	-- clear the dec flag and jumps to read a new Instruction
			if LR_zero = '0' then
			  PC_load <= '1' ;
			end if;			
			state <= S6b;
			
	  when S6b => 	PC_load <= '0' ;
	       state <= S1;
	       
 	  when S7 =>	end_sequence <= '1' ;
			state <= S7;	--end of sequence, you will be here FOREVER (until reset)
		
	  when others =>

	end case;

    end if;

  end process;

end behavior;