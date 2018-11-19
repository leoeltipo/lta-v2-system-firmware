----------------------------------------------------------------------------------
-- Company: Fermilab
-- Engineer: TZ
-- 
-- Create Date: 11/03/2017 07:55:47 AM
-- Design Name: CCD DAQ
-- Module Name: bitslip_1 - Behavioral
-- Project Name: CCD DAQ
-- Target Devices: Artix 7
-- Tool Versions: Vivado 2016.4
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
    
Library UNISIM;
use UNISIM.vcomponents.all;

entity bitslip_1 is
    Port ( master_reset : in STD_LOGIC;
           clk_1 : in STD_LOGIC;
           clk_3 : in STD_LOGIC;
           send_bitslip_0 : in STD_LOGIC;
           send_bitslip_1 : in STD_LOGIC;
           enable_test_pattern : in STD_LOGIC;
           check_test_pattern : in STD_LOGIC;
           sio_wiz_data_in : in STD_LOGIC_VECTOR (19 downto 0);
           
           sio_wiz_bitslip : out STD_LOGIC_VECTOR (1 downto 0);
           sio_wiz_data_out	: out std_logic_vector(17 downto 0)     -- selectio wizard raw data
           );
end bitslip_1;

architecture Behavioral of bitslip_1 is

    -- Vivado was optimizing away so many signals, I couldn't debug the code
    -- so I used "dont_touch" to save the names for debugging
--    attribute dont_touch : string;
    
	signal sent_bitslip : std_logic := '0';
--    attribute dont_touch of sent_bitslip : signal is "true";
    
	signal sync_send_bitslip : std_logic_vector(1 downto 0) := b"00";
--    attribute dont_touch of sync_send_bitslip : signal is "true";

	signal pulse_send_bitslip_0 : std_logic := '0';
--    attribute dont_touch of pulse_send_bitslip_0 : signal is "true";

	signal one_bitslip : std_logic_vector(1 downto 0) := b"00";
--    attribute dont_touch of one_bitslip : signal is "true";

	signal one_pulse_check : std_logic_vector(1 downto 0) := b"00";
--    attribute dont_touch of one_pulse_check : signal is "true";

	signal start_check : std_logic := '0';	
--    attribute dont_touch of start_check : signal is "true";
    
	signal cycle_done : std_logic := '0';	
--    attribute dont_touch of cycle_done : signal is "true";
    
	signal send_bitslip : std_logic := '0';	
--    attribute dont_touch of send_bitslip : signal is "true";

    signal test_pattern_error : std_logic := '0';
--    attribute dont_touch of test_pattern_error : signal is "true";
    
    signal wait_time : std_logic_vector(4 downto 0) := b"10000";
    signal wait_counter : std_logic_vector(4 downto 0) := b"00000";
	signal test_pattern_current : std_logic_vector(17 downto 0) := b"00" & x"0000";
    signal test_pattern_expected : std_logic_vector(17 downto 0) := b"11" & x"30fc"; -- 0x330FC
    
    type state_type is (s0, s1, s2, s3, s4);
    signal present_state, next_state : state_type;
    
	signal sm_bitslip_execute : std_logic := '0';	
    signal sm_bitslip_execute_i : std_logic := '0';
	signal sm_bitslip_done : std_logic := '0';	
    signal sm_bitslip_done_i : std_logic := '0';
--	signal bitslip_debug : std_logic_vector(2 downto 0) := b"00";

begin

--	-- for debugging, perform only one bitslip each time the VIO send bitslip is toggled from 0 to 1 
--	process (clk_1, send_bitslip)
--	begin
--		if clk_1'event and clk_1 = '0' then  
--			bitslip_debug(0) <= send_bitslip;
--            bitslip_debug(1) <= bitslip_debug(0);
--		end if;
--		send_bitslip <= bitslip_debug(0) and not bitslip_debug(1);
--	end process;

    send_bitslip <= send_bitslip_0 or send_bitslip_1; -- so far, don't need individual bitslip per lane option

   SYNC_PROC: process (clk_1)
   begin
      if (clk_1'event and clk_1 = '1') then
         if master_reset = '1' then
            present_state <= s0;
            sm_bitslip_execute <= '0';
            sm_bitslip_done <= '0';
         else
            present_state <= next_state;
            sm_bitslip_execute <= sm_bitslip_execute_i;
            sm_bitslip_done <= sm_bitslip_done_i;
         end if;        
      end if;
   end process;
   
   OUTPUT_DECODE: process (present_state)
   begin
      if present_state = s0 then        -- reset
         sm_bitslip_execute_i <= '0';
         sm_bitslip_done_i <= '0';

      elsif present_state = s1 then        -- start bitslip
         sm_bitslip_execute_i <= '0';
         sm_bitslip_done_i <= '0';

      elsif present_state = s2 then        -- perform the bitslip operation
         sm_bitslip_execute_i <= '1';
         sm_bitslip_done_i <= '0';
         
      elsif present_state = s3 then        -- wait for bitslip to take effect
         sm_bitslip_execute_i <= '0';
         sm_bitslip_done_i <= '1';

      elsif present_state = s4 then        -- end
         sm_bitslip_execute_i <= '0';
         sm_bitslip_done_i <= '0';
                              
      else
         sm_bitslip_execute_i <= '0';
         sm_bitslip_done_i <= '0';
         
      end if;
   end process;

   NEXT_STATE_DECODE: process (present_state, send_bitslip, start_check,
                                test_pattern_error, sent_bitslip, cycle_done)
   begin
      next_state <= present_state;
      case (present_state) is
         when s0 =>						      -- power-up, reset state, idle
			if (send_bitslip and start_check) = '1' then
               next_state <= s1;	
			else
               next_state <= s0;
            end if;
            
         when s1 =>
            if test_pattern_error = '1' then
                next_state <= s2;    
            else
                next_state <= s0;
            end if;
               
         when s2 =>
            if sent_bitslip = '1' then
                next_state <= s3;    
            else
                next_state <= s2;
            end if;
               
         when s3 =>
            if cycle_done = '1' then
               next_state <= s4;	
			else
               next_state <= s3;
            end if;
               
        when s4 =>
            next_state <= s0;    
         
         when others =>
				next_state <= s0;
      end case;      
   end process;

    -- counter for adc data out samples
   process (clk_1)
   begin
       if (clk_1'event and clk_1 = '1') then
         if (master_reset or not sm_bitslip_done) = '1' then
           wait_counter <= b"00000";
         else
           wait_counter <= wait_counter + 1;
         end if;
       end if;
   end process;

    process (clk_1)
    begin
        if clk_1'event and clk_1 = '1' then
            if master_reset = '1' then
                cycle_done <= '0';
            elsif sm_bitslip_done = '0' then
                cycle_done <= '0';
            elsif (wait_counter = wait_time) then
                cycle_done <= '1';
            end if;
        end if;
    end process;

	-- on a vio toggle command, pulse once on rising edge of DIVCLK until pattern is found and error is cleared
	process (clk_3)
	begin
		if clk_3'event and clk_3 = '1' then
			if sm_bitslip_execute = '1' then
			     sync_send_bitslip(0) <= '1';
            else
                sync_send_bitslip(0) <= '0';
			    sync_send_bitslip(1) <= sync_send_bitslip(0);
			end if;
		end if;
	end process;
	pulse_send_bitslip_0 <= sync_send_bitslip(0) and not sync_send_bitslip(1);

	-- setup signal for the rising edge of clk_3
	process (clk_3, one_bitslip)
	begin
		if clk_3'event and clk_3 = '0' then  
			one_bitslip(0) <= pulse_send_bitslip_0;
            one_bitslip(1) <= one_bitslip(0);
		end if;
		sent_bitslip <= one_bitslip(0) and not one_bitslip(1);
	end process;
   sio_wiz_bitslip(0) <= one_bitslip(0) and not one_bitslip(1);
   sio_wiz_bitslip(1) <= one_bitslip(0) and not one_bitslip(1);

   -- rearrange the data from the selectio wizard
    process (clk_1)
   begin
      if clk_1'event and clk_1 = '1' then
           sio_wiz_data_out(17) <= sio_wiz_data_in(0);
           sio_wiz_data_out(16) <= sio_wiz_data_in(1);
           sio_wiz_data_out(15) <= sio_wiz_data_in(2);
           sio_wiz_data_out(14) <= sio_wiz_data_in(3);
           sio_wiz_data_out(13) <= sio_wiz_data_in(4);
           sio_wiz_data_out(12) <= sio_wiz_data_in(5);
           sio_wiz_data_out(11) <= sio_wiz_data_in(6);
           sio_wiz_data_out(10) <= sio_wiz_data_in(7);
           sio_wiz_data_out(9) <= sio_wiz_data_in(8);
           sio_wiz_data_out(8) <= sio_wiz_data_in(9);
           sio_wiz_data_out(7) <= sio_wiz_data_in(10);
           sio_wiz_data_out(6) <= sio_wiz_data_in(11);
           sio_wiz_data_out(5) <= sio_wiz_data_in(12);
           sio_wiz_data_out(4) <= sio_wiz_data_in(13);
           sio_wiz_data_out(3) <= sio_wiz_data_in(14);
           sio_wiz_data_out(2) <= sio_wiz_data_in(15);
           sio_wiz_data_out(1) <= sio_wiz_data_in(16);
           sio_wiz_data_out(0) <= sio_wiz_data_in(17);
       end if;
    end process;
    
    -- rearrange data and register data to check for the test pattern
    process (clk_1)
   begin
      if clk_1'event and clk_1 = '1' then 
           test_pattern_current(17) <= sio_wiz_data_in(0);
           test_pattern_current(16) <= sio_wiz_data_in(1);
           test_pattern_current(15) <= sio_wiz_data_in(2);
           test_pattern_current(14) <= sio_wiz_data_in(3);
           test_pattern_current(13) <= sio_wiz_data_in(4);
           test_pattern_current(12) <= sio_wiz_data_in(5);
           test_pattern_current(11) <= sio_wiz_data_in(6);
           test_pattern_current(10) <= sio_wiz_data_in(7);
           test_pattern_current(9) <= sio_wiz_data_in(8);
           test_pattern_current(8) <= sio_wiz_data_in(9);
           test_pattern_current(7) <= sio_wiz_data_in(10);
           test_pattern_current(6) <= sio_wiz_data_in(11);
           test_pattern_current(5) <= sio_wiz_data_in(12);
           test_pattern_current(4) <= sio_wiz_data_in(13);
           test_pattern_current(3) <= sio_wiz_data_in(14);
           test_pattern_current(2) <= sio_wiz_data_in(15);
           test_pattern_current(1) <= sio_wiz_data_in(16);
           test_pattern_current(0) <= sio_wiz_data_in(17);
       end if;
    end process;

	-- generate a pulse one clock cycle wide
	process (clk_1, check_test_pattern, one_pulse_check)
	begin
		if clk_1'event and clk_1 = '0' then  
			one_pulse_check(0) <= check_test_pattern;
            one_pulse_check(1) <= one_pulse_check(0);
		end if;
		start_check <= one_pulse_check(0) and not one_pulse_check(1);
	end process;

    -- check the actual wizard output data against the ADC test pattern 
	process(clk_1, test_pattern_current, test_pattern_expected)
	begin
		if (clk_1'event and clk_1 ='1') then
			if (enable_test_pattern and start_check) = '1' then
				if (test_pattern_current = test_pattern_expected) then
                    test_pattern_error <= '0';
				elsif (test_pattern_current /= test_pattern_expected) then
					test_pattern_error <= '1';
				end if;
			elsif sent_bitslip = '1' then
				test_pattern_error <= '0';
			end if;
		end if;
	end process;


end Behavioral;
