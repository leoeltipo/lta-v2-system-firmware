----------------------------------------------------------------------------------
-- Company: Fermilab
-- Engineer: TZ
-- 
-- Create Date: 10/31/2017
-- Design Name: CCD DAQ
-- Module Name: readout_1 - Behavioral
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

entity readout_1 is
    port
	(-- inputs
    master_reset        : in std_logic;
    clk_1               : in std_logic; -- currently 150 MHz
--    clk_2               : in std_logic; -- currently 100 MHz
    clk_3               : in std_logic; -- currently 30 MHz
--    clk_4               : in std_logic; -- currently 10 MHz
    acquire             : in std_logic;
    convert_done        : in std_logic;
--    clk_5               : in std_logic; --  200MHz
    -- outputs
    adc_readout         : out std_logic;
    sio_clk_enable      : out std_logic;    -- selectio wiz clock enable
    sio_wiz_dstrobe     : out std_logic;     -- selectio wiz data strobe
    clk_5_ce            : out std_logic     -- selectio wiz data strobe
    );
end readout_1;

architecture Behavioral of readout_1 is

    -- Vivado was optimizing away so many signals, I couldn't debug the code
    -- so I used "dont_touch" to save the names for debugging
    attribute dont_touch : string;

    signal readout_time             : std_logic_vector(4 downto 0) := b"00010";
    signal readout_count			: std_logic_vector(4 downto 0) := b"00000";
    signal start_readout			: std_logic_vector(2 downto 0) := b"000";
	signal readout		            : std_logic := '0';
	signal sm_adc_readout_time		: std_logic := '0';
    signal sm_adc_readout_time_i    : std_logic := '0';
	signal sm_adc_readout		    : std_logic := '0';
    signal sm_adc_readout_i         : std_logic := '0';
	signal sm_sio_start		        : std_logic := '0';
    signal sm_sio_start_i           : std_logic := '0';
	signal sm_convert_ack	        : std_logic := '0';
    signal sm_convert_ack_i         : std_logic := '0';
    signal readout_done     		: std_logic := '0';
	signal delay_clks  			    : std_logic_vector(10 downto 0) := b"00000000000";
	signal clk_enable        		: std_logic := '0';
	signal clk_state        		: std_logic := '0';
	signal start_the_readout   		: std_logic := '0';
    signal convert_pending          : std_logic := '0';
    signal pending_count            : integer range 0 to 2;
    signal align_with_divclk   		: std_logic := '0';
    signal adc_clk_enable   		: std_logic := '0';

    signal toggle_1 : std_logic := '0';
    attribute dont_touch of toggle_1 : signal is "true";
    signal toggle_2 : std_logic := '0';
    attribute dont_touch of toggle_2 : signal is "true";
	signal clk3_rising : std_logic := '0';
    attribute dont_touch of clk3_rising : signal is "true";
	signal track_clk : std_logic_vector(8 downto 0) := b"000000000";
    attribute dont_touch of track_clk : signal is "true";
    
   type state_type is (s0, s1, s2, s3);
   signal present_state, next_state : state_type;

begin

    sio_clk_enable <= clk_enable;
	adc_readout <= readout;

   SYNC_PROC: process (clk_1)
   begin
      if (clk_1'event and clk_1 = '1') then
         if master_reset = '1' then
            present_state <= s0;
         	sm_adc_readout_time <= '0';
            sm_adc_readout <= '0';
            sm_convert_ack <= '0';
            sm_sio_start <= '0';
         else
            present_state <= next_state;
         	sm_adc_readout_time <= sm_adc_readout_time_i;
            sm_adc_readout <= sm_adc_readout_i;
            sm_convert_ack <= sm_convert_ack_i;
            sm_sio_start <= sm_sio_start_i;
         end if;        
      end if;
   end process;
   
   OUTPUT_DECODE: process (present_state)
   begin
      if present_state = s0 then        -- reset
         sm_adc_readout_time_i <= '0';
         sm_adc_readout_i <= '0';
         sm_convert_ack_i <= '0';
         sm_sio_start_i <= '0';

      elsif present_state = s1 then        -- send the adc readout
         sm_adc_readout_time_i <= '0';
         sm_adc_readout_i <= '0';
         sm_convert_ack_i <= '1';
         sm_sio_start_i <= '0';

      elsif present_state = s2 then        -- send the adc readout
         sm_adc_readout_time_i <= '0';
         sm_adc_readout_i <= '0';
         sm_convert_ack_i <= '0';
         sm_sio_start_i <= '1';
         
      elsif present_state = s3 then        -- readout time
         sm_adc_readout_time_i <= '1';
         sm_adc_readout_i <= '1';
         sm_convert_ack_i <= '0';
         sm_sio_start_i <= '0';
                              
      else
         sm_adc_readout_time_i <= '0';
         sm_adc_readout_i <= '0';
         sm_convert_ack_i <= '0';
         sm_sio_start_i <= '0';
         
      end if;
   end process;

   NEXT_STATE_DECODE: process (present_state, acquire, convert_pending,
                    align_with_divclk,start_the_readout, readout_done)
   begin
      next_state <= present_state;
      case (present_state) is
         when s0 =>						      -- power-up, reset state, idle
			if (acquire and convert_pending) = '1' then         -- signal to start readout
               next_state <= s1;	
			else
               next_state <= s0;
            end if;
            
         when s1 =>
            if start_the_readout = '1' then     -- signal to start readout
                next_state <= s2;    
            else
                next_state <= s1;
            end if;
               
         when s2 =>
            if align_with_divclk = '1' then        -- align readout with DIVCLK
                next_state <= s3;    
            else
                next_state <= s2;
            end if;
               
         when s3 =>						           -- time to wait for readout
            if readout_done = '1' then
               next_state <= s0;	
			else
               next_state <= s3;
            end if;

         when others =>
				next_state <= s0;
      end case;      
   end process;
   
    -- counter for adc data out samples
   process (clk_1)
   begin
       if (clk_1'event and clk_1 = '1') then
         if (master_reset or not sm_adc_readout_time) = '1' then
           readout_count <= b"00000";
         else
           readout_count <= readout_count + 1;
         end if;
       end if;
   end process;

    process (clk_1)
    begin
        if clk_1'event and clk_1 = '1' then
            if master_reset = '1' then
                readout_done <= '0';
            elsif sm_adc_readout_time = '0' then
                readout_done <= '0';
            elsif (readout_count = readout_time) then
                readout_done <= '1';
            end if;
        end if;
    end process;

    -- after readout create delay and wait for valid data to exit the sio wizard IP
    process (clk_1)
    begin
       if clk_1'event and clk_1 = '1' then
          for i in 0 to 9 loop
             delay_clks(i+1) <= delay_clks(i);
          end loop;
          delay_clks(0) <= readout_done;
       end if;
    end process;
   sio_wiz_dstrobe <= delay_clks(7) and not delay_clks(8);

    -- clock enable signal must be at selectio wiz IP at rising edge of DIVCLK
   process (clk_1)
   begin
       if clk_1'event and clk_1 = '1' then
           if master_reset = '1' then
               clk_enable <= '0';
           elsif sm_sio_start = '1' then
               clk_enable <= '1';
           else
               clk_enable <= '0';
           end if;
       end if;
   end process;
    
    -- track the state of clk_3
  process (clk_3)
  begin
      if clk_3'event and clk_3 = '1' then
          if master_reset = '1' then
              toggle_1 <= '0';
          else
              toggle_1 <= not toggle_1;
          end if;
      end if;
  end process;
    
    -- track the state of clk_3
process (clk_1)
begin
    if clk_1'event and clk_1 = '1' then
        if master_reset = '1' then
            toggle_2 <= '0';
        else
            toggle_2 <= toggle_1;
        end if;
    end if;
end process;    

    -- track the state of clk_3
  process (clk_1, clk3_rising)
  begin
      if clk_1'event and clk_1 = '1' then
          if master_reset = '1' then
              clk3_rising <= '0';
          elsif (toggle_1 xor toggle_2) = '1' then
              clk3_rising <= '1';
          else
              clk3_rising <= '0';
          end if;
      end if;
      start_the_readout <= clk3_rising;
  end process;
  
  process (clk_1)
  begin
   if clk_1'event and clk_1 = '1' then
      for i in 0 to 7 loop
         track_clk(i+1) <= track_clk(i);
      end loop;
      track_clk(0) <= clk3_rising;
      align_with_divclk <= track_clk(0) and not track_clk(1);
   end if;
  end process;

  process (clk_1)
  begin
     if (clk_1'event and clk_1 = '1') then
        if master_reset = '1' then
           clk_5_ce <= '0';
        elsif sm_sio_start = '1' then
           clk_5_ce <= '1';
        elsif track_clk(6) = '1' then
           clk_5_ce <= '0';
        end if;        
     end if;
  end process;
  
    process (clk_1, master_reset, convert_done, readout)
      variable count: INTEGER RANGE 0 TO 1;                
      constant modulus: INTEGER := 1;
    begin
      if (clk_1'event and clk_1 = '1') then
          if master_reset = '1' then
              count := 0;
          elsif (convert_done and readout) = '1' then
              count := count;                     -- both cycles at same time holds the count
          elsif readout = '1' then          -- readout cycle decreases the count
              count := count - 1;
          elsif (count = modulus) then
              count := 1;                         -- can't go any higher
          elsif convert_done = '1' then       -- a conversion cycle increases the count
              count := count + 1;
          else
              count := count;
          end if;
      end if;
      pending_count <= count;
    end process;
      
      -- don't let the conversions get ahead of the read out cycle
      process (pending_count)
      begin
          if (pending_count >= 1) then        -- if the count is equal or greater
              convert_pending <= '1';         -- do a read out
          else
              convert_pending <= '0';         -- stop read out
          end if;
      end process;
      
  process (clk_1, sm_convert_ack_i, start_readout)
      begin
       if clk_1'event and clk_1 = '1' then
          for i in 0 to 1 loop
             start_readout(i+1) <= start_readout(i);
          end loop;
          start_readout(0) <= sm_convert_ack_i;
       end if;
       readout <= sm_convert_ack_i and not start_readout(0);
      end process;
  
end Behavioral;
