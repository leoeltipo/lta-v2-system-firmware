------------------------------------------------------------------------
-- Based on
-- Simple Microprocessor Design (ESD Book Chapter 3)
-- Copyright Spring 2001 Weijun Zhang
--
-- Control Unit composed of Controller, PC, IR and multiplexor
-- VHDL structural modeling
-- ctrl_unit.vhd
-- Angel Jose Soto 2 feb 2017
------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;

entity mc is
port(	clock_mc:	in 	std_logic;	-- clock input
	rst_mc:		in 	std_logic;	-- reset input, active on 1
	mdata_out: 	in 	std_logic_vector(31 downto 0);
	maddr_in:	out 	std_logic_vector(31 downto 0);
	eos:		out	std_logic;	-- end of sequence, active on 1
	output:	out 	std_logic_vector(31 downto 0) --output vector, it is mappeable to custom signals
);
end mc;

architecture behavior of mc is

component controller is
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
end component;

component IR is
port(	IRin: 		in std_logic_vector(31 downto 0);
	IRld:		in std_logic;
	IRout: 		out std_logic_vector(31 downto 0)
);	
end component;

component PC is	  
port(   clock:in std_logic;	
    PCld:	in std_logic;
	PCinc:	in std_logic;
	PCclr:	in std_logic;
	PCin:	in std_logic_vector(31 downto 0);
	PCout:	out std_logic_vector(31 downto 0)
);
end component;	 


component loop_register is
port(	clk:		in std_logic;
	LR_load:	in std_logic;
	LR_dec:		in std_logic;
	LR_clr:		in std_logic;
	loop_in: 	in 	std_logic_vector(31-3  downto 0);
	LR_zero:	out 	std_logic
);
end component;


--signal rst_mc, clock_mc: std_logic;

signal memory_q: std_logic_vector(31 downto 0);
signal IR_word: std_logic_vector(31 downto 0);
signal salida: std_logic_vector(31 downto 0);

signal temp_output: std_logic_vector(31 downto 0); -- for output port

signal jmp_address: std_logic_vector(31 downto 0);




signal IR_load, PC_clr, PC_inc, PC_load, OD_load, OD_clr, DR_load, DR_clr, LR_load, LR_dec, LR_clr: std_logic;

signal DR_zero: std_logic;
signal LR_zero: std_logic;
signal delay_reg: std_logic_vector (31-3 downto 0);

signal mem_value: std_logic_vector (31-3 downto 0);


begin

  
  U0: controller port map(clock_mc, rst_mc, IR_word, DR_zero, LR_zero, IR_load, PC_clr, PC_inc, PC_load, OD_load, OD_clr, DR_load, DR_clr, LR_load, LR_dec, LR_clr,eos);
  U1: PC port map(clock_mc, PC_load, PC_inc, PC_clr, jmp_address, maddr_in);
  U2: IR port map(mdata_out, IR_load, IR_word);
  U3: loop_register port map(clock_mc, LR_load, LR_dec, LR_clr, mem_value, LR_zero);
  
  
  process (clock_mc, OD_load, OD_clr) -- output register process
    begin
			if (clock_mc'event and clock_mc='1') then
			  if OD_clr = '1' then 
			      temp_output <= (others => '0');
			  elsif(OD_load = '1') then
			      temp_output <= "00000"&IR_word(26 downto 0);
			  end if;
			 end if;
			
  end process;
   
   output <= temp_output;
   
   jmp_address <= "00000"&IR_word(26 downto 0);
   
   
  process (clock_mc, rst_mc, DR_load) -- delay generation
    begin
    if (clock_mc'event and clock_mc='1') then
			if rst_mc = '1' then 
			      delay_reg <= (others => '0');
			      DR_zero <= '1';
			  elsif(DR_load = '1') then
			      delay_reg <= IR_word(31-3 downto 0);
			      DR_zero <= '0';
			  elsif(delay_reg > (delay_reg'range => '0')) then
			      delay_reg <= delay_reg -1;
			      DR_zero <= '0';
			  elsif(delay_reg = (delay_reg'range => '0')) then
			      DR_zero <= '1';
			  end if;
			 end if;
  end process;
  
  mem_value <= IR_word(31-3  downto 0);
  

end behavior;