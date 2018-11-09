--------------------------------------------------------
-- Loop register architecture
-- 
-- 8 loop registers, they allow 8 "for" cycles
-- 
-- The counts end in 0 (zero), it means that if you want to count 7 (seven) times, 
-- you need to load a 6 (six) in the register. It will end after it counts de 0 
-- (zero).
-- 
-- Due to the amount of register, the nest level cannot be bigger than 8. 

-- Angel Jose Soto 2 feb 2017

--------------------------------------------------------


library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;



--USE ieee.numeric_std.ALL;


entity loop_register is
port(	clk:		in std_logic;
	LR_load:	in std_logic;
	LR_dec:		in std_logic;
	LR_clr:		in std_logic;
	loop_in: 	in 	std_logic_vector(31-3 downto 0);
	LR_zero:	out 	std_logic
);
end loop_register;


architecture behavior of loop_register is


  
  type lp_type is array (0 to 7) of std_logic_vector(31-3 downto 0);
  signal loop_reg: lp_type;
  signal index_next_loop, index_dec : std_logic_vector(2 downto 0);
  
  signal loop_equal_zero: std_logic;
  
  constant zero_value :std_logic_vector(31-3 downto 0):= (others => '0');
  --constant one_value :std_logic_vector(31-3 downto 0):= 30(others => '0')&1;
        		
  
	
begin


  --There are two index, one for the working register (index_dec) and 
  -- other for the next loop value to be loaded (index_next_loop).
  -- More than 8 consecutive instructions Load_LR/Dec_LR cause the loss of the index
  process(clk, LR_clr, loop_equal_zero)
  begin
  
  if (LR_clr = '1') then
      loop_reg <= (OTHERS => (OTHERS => '0'));
      index_next_loop <= (others => '0');
      index_dec <= (others => '0');
      --loop_equal_zero <= '0';
      
      elsif (clk'event and clk = '1') then
        if (LR_load = '1' and  index_next_loop = "000") then
            loop_reg(conv_integer(index_next_loop))<= loop_in;
            index_next_loop <= index_next_loop + 1;
            elsif (LR_load = '1' ) then
                loop_reg(conv_integer(index_next_loop))<= loop_in;
                index_next_loop <= index_next_loop + 1;
                index_dec <= index_dec + 1;
                end if;
        if (LR_dec = '1') then
            if (loop_equal_zero = '1' and index_next_loop = "001") then
                index_next_loop <= "000";
                
            elsif (loop_equal_zero = '1') then
                index_next_loop <= index_next_loop - 1;
                index_dec <= index_dec - 1;

            else 
                loop_reg(conv_integer(index_dec)) <= loop_reg(conv_integer(index_dec)) - 1;
                
            end if;
         end if;
       end if;    
        
  end process;

  
  -- control of register equal to zero
  process(loop_reg, index_next_loop, index_dec, LR_dec)
  begin
     if (loop_reg(conv_integer(index_dec)) = zero_value) then
	loop_equal_zero <= '1';
     else
	loop_equal_zero <= '0';
     end if;
  end process;
  
   LR_zero <= loop_equal_zero;

end behavior;