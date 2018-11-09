--------------------------------------------------------
-- Based on
-- Simple Microprocessor Design
--
-- Program Counter 
-- PC.vhd
-- Angel Jose Soto 2 feb 2017
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  


entity PC is
port(	clock:	in std_logic;
		PCld:	in std_logic;
		PCinc:	in std_logic;
		PCclr:	in std_logic;
		PCin:	in std_logic_vector(31 downto 0);
		PCout:	out std_logic_vector(31 downto 0)
);
end PC;

architecture behavior of PC is

signal tmp_PC: std_logic_vector(31 downto 0);

begin				
	process(PCclr, PCinc, PCld, PCin,clock)
	begin
			if PCclr='1' then
				tmp_PC <= (others => '0');
			--elsif (PCld'event and PCld = '1') then
			elsif clock'event and clock = '1' then
			     if PCld = '1' then	
				        tmp_PC <= PCin;
				 elsif PCinc = '1' then
				        tmp_PC <= tmp_PC + 1;
				 end if;       
			end if;
	end process;

	PCout <= tmp_PC;

end behavior;
  