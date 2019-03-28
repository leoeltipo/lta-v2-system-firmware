----------------------------------------------------------------------------------
-- Company: Fermilab
-- Engineer: TZ
-- 
-- Create Date: 10/31/2017
-- Design Name: CCD DAQ
-- Module Name: convert_1 - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity convert_1 is
	port
    (-- inputs
    master_reset        : in std_logic;
    clk_1               : in std_logic; -- currently 150MHz
    clk_3               : in std_logic; -- currently 30MHz
    acquire             : in std_logic; -- run the ADC read out cycle
    readout_cycle       : in std_logic; -- readout handshake for each cycle

    -- outputs
	adc_convert    		: out std_logic;
	convert_done        : out std_logic
	);
end convert_1;

architecture Behavioral of convert_1 is

   type state_type is (s0, s1, s2, s3, s4);
   signal present_state, next_state : state_type;
    -- make sure convert_time to output ready doesn't violate spec
--    signal convert_time             : std_logic_vector(4 downto 0) := b"11000"; -- slow it down to 5 MSa/s
    signal convert_time             : std_logic_vector(4 downto 0) := b"00100"; -- 15 MSa/s with ADC
    signal convert_count			: std_logic_vector(4 downto 0) := b"00000";
	signal sm_adc_convert_time		: std_logic := '0';
    signal sm_adc_convert_time_i    : std_logic := '0';
	signal sm_adc_convert		    : std_logic := '0';
    signal sm_convert_cycle         : std_logic := '0';
	signal sm_convert_cycle_i	    : std_logic := '0';
    signal sm_adc_convert_i         : std_logic := '0';
    signal convert_count_done		: std_logic := '0';
    signal convert_pending          : std_logic := '0';
	signal pending_count			: integer range 0 to 1;
	signal limit                    : std_logic := '0';
	signal track_clk_3  			: std_logic_vector(2 downto 0) := b"000";
	signal send_the_convert         : std_logic := '0';
    -- Vivado was optimizing away so many signals, I couldn't debug the code
    -- so I used "dont_touch" to save these signals for debugging
    attribute dont_touch : string;	
    signal toggle_1 : std_logic := '0';
    attribute dont_touch of toggle_1 : signal is "true";
    signal toggle_2 : std_logic := '0';
    attribute dont_touch of toggle_2 : signal is "true";
    signal clk3_rising : std_logic := '0';
    attribute dont_touch of clk3_rising : signal is "true";
    signal track_clk : std_logic_vector(8 downto 0) := b"000000000";
    attribute dont_touch of track_clk : signal is "true";
    
   signal acquire_resync : std_logic;
    
    component synchronizer is 
        generic (
            N : Integer := 2
        );
        port (
            rst            : in std_logic;
            clk         : in std_logic;
            data_in        : in std_logic;
            data_out    : out std_logic
        );
    end component;    

begin

   -- acquire_resync.
   acquire_resync_i : synchronizer 
       generic map (
           N => 2
       )
       port map (
           rst      => master_reset,
           clk      => clk_1,
           data_in  => acquire,
           data_out => acquire_resync
       );

    adc_convert <= sm_adc_convert;

   SYNC_PROCESS: process (clk_1)
   begin
      if (clk_1'event and clk_1 = '1') then
         if master_reset = '1' then
            present_state <= s0;
         	sm_adc_convert_time <= '0';
            sm_adc_convert <= '0';
            sm_convert_cycle <= '0';

         else
            present_state <= next_state;
         	sm_adc_convert_time <= sm_adc_convert_time_i;
            sm_adc_convert <= sm_adc_convert_i;
            sm_convert_cycle <= sm_convert_cycle_i;
         end if;        
      end if;
   end process;

   OUTPUT_DECODE: process (present_state)
   begin
      if present_state = s0 then        -- reset
         sm_adc_convert_time_i <= '0';
		 sm_adc_convert_i <= '0';
		 sm_convert_cycle_i <= '0';

      elsif present_state = s1 then		-- check
         sm_adc_convert_time_i <= '0';
		 sm_adc_convert_i <= '0';
		 sm_convert_cycle_i <= '0';

      elsif present_state = s2 then		-- send the adc convert
         sm_adc_convert_time_i <= '1';
         sm_adc_convert_i <= '1';
		 sm_convert_cycle_i <= '1';
		 
      elsif present_state = s3 then		-- send the adc convert
         sm_adc_convert_time_i <= '1';
         sm_adc_convert_i <= '1';
		 sm_convert_cycle_i <= '0';
		 
      elsif present_state = s4 then		-- wait time before next conversion
            sm_adc_convert_time_i <= '1';
            sm_adc_convert_i <= '0';
            sm_convert_cycle_i <= '0';
		 			
      else
         sm_adc_convert_time_i <= '0';
         sm_adc_convert_i <= '0';
		 sm_convert_cycle_i <= '0';

      end if;
   end process;

   NEXT_STATE_DECODE: process (present_state, acquire_resync, send_the_convert,
                                convert_pending, convert_count_done)
   begin
      next_state <= present_state;
      case (present_state) is
         when s0 =>						      -- power-up and reset state
			if not acquire_resync = '1' then         -- signal to start readout
               next_state <= s0;
			else
               next_state <= s1;
            end if;
            
         when s1 =>						      -- check for pending convert to ADC
             if (send_the_convert and not convert_pending) = '1' then
                next_state <= s2;
             else
                next_state <= s1;
             end if;
               
         when s2 =>						           -- convert
               next_state <= s3;
               
         when s3 =>						           -- convert
               next_state <= s4;
               
         when s4 =>						           -- time to wait for conversion before readout
            if convert_count_done = '1' then
               next_state <= s0;	
			else
               next_state <= s4;
            end if;

         when others =>
				next_state <= s0;
      end case;      
   end process;

    -- counter for adc data out valid conversion time
    process (clk_1)
    begin
        if (clk_1'event and clk_1 = '1') then
          if (master_reset or not sm_adc_convert_time) = '1' then
            convert_count <= b"00000";
          else
            convert_count <= convert_count + 1;
          end if;
        end if;
    end process;

    process (clk_1)
    begin
        if clk_1'event and clk_1 = '1' then
            if master_reset = '1' then
                convert_count_done <= '0';
            elsif sm_adc_convert_time = '0' then
                convert_count_done <= '0';
            elsif (convert_count >= convert_time) then
                convert_count_done <= '1';
            end if;
        end if;
    end process;
    
    -- convert done handshake to readout block limit to one clock width
    process (clk_1, convert_count_done, limit)
    begin
        if (clk_1'event and clk_1 = '1') then
            if convert_count_done = '1' then
                limit <= '1';
            else
                limit <= '0';
            end if;
        end if;
        convert_done <= convert_count_done and not limit;
    end process;
    
	process (clk_1, master_reset, sm_convert_cycle, readout_cycle)
        variable count: INTEGER RANGE 0 TO 1;                
        constant modulus: INTEGER := 1;
    begin
        if (clk_1'event and clk_1 = '1') then
            if master_reset = '1' then
                count := 0;
            elsif (sm_convert_cycle and readout_cycle) = '1' then
                count := count;                     -- both cycles at same time holds the count
            elsif readout_cycle = '1' then          -- readout cycle decreases the count
                count := count - 1;
            elsif (count = modulus) then
                count := 1;                         -- can't go any higher
            elsif sm_convert_cycle = '1' then       -- a conversion cycle increases the count
                count := count + 1;
            else
                count := count;
            end if;
        end if;
        pending_count <= count;
    end process;
    
    -- don't let the conversion pipeline get ahead of the read out
--	process (clk_1, pending_count)
	process (pending_count)
    begin
--        if (clk_1'event and clk_1 = '1') then
            if (pending_count >= 1) then        -- if the count is equal or greater
                convert_pending <= '1';         -- stop additional conversions
            else
                convert_pending <= '0';         -- do another conversion
            end if;
--        end if;
    end process;

    -- track the state of clk_3 which is the SELECTIO IP DIVCLK
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
  process (clk_1)
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
  end process;

 -- the ADC conversion is referenced to the DIVCLK
  process (clk_1)
  begin
   if clk_1'event and clk_1 = '1' then
      for i in 0 to 7 loop
         track_clk(i+1) <= track_clk(i);
      end loop;
      track_clk(0) <= clk3_rising;
   end if;
  end process;
  send_the_convert <= track_clk(0) and not track_clk(1);

end Behavioral;
