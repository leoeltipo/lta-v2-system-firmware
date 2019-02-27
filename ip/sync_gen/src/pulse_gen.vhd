----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2019 03:33:08 PM
-- Design Name: 
-- Module Name: pulse_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_gen is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           DELAY_REG : in STD_LOGIC_VECTOR (7 downto 0);
           sync_in : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end pulse_gen;

architecture Behavioral of pulse_gen is

-- Components.
component synchronizer is 
	generic (
		N : Integer := 2
	);
	port (
		rst		    : in std_logic;
		clk 		: in std_logic;
		data_in		: in std_logic;
		data_out	: out std_logic
	);
end component;

-- Registers.
signal DELAY_REG_r : std_logic_vector (7 downto 0);

-- Signals.
signal sync_in_resync   : std_logic;
signal cnt              : unsigned (7 downto 0);
signal sync_out_i       : std_logic;

-- State machine.
type fsm_state is (WAIT_START,WAIT_DELAY,WAIT_END);
signal current_state, next_state : fsm_state;

signal wait_start_state : std_logic;
signal wait_delay_state : std_logic;

begin

-- sync_in resync.
sync_in_resync_i : synchronizer 
	generic map (
		N => 2
	)
	port map (
		rst		    => rst,
		clk 		=> clk,
		data_in		=> sync_in,
		data_out	=> sync_in_resync
	);

process (rst,clk)
begin
    if (rst = '1') then
        current_state <= WAIT_START;
        
        DELAY_REG_r <= (others => '0');
        
        cnt <= (others => '0');
        
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        
        DELAY_REG_r <= DELAY_REG;
        
        if (wait_start_state = '1') then
            cnt <= (others => '0');
        elsif (wait_delay_state = '1') then
            cnt <= cnt + 1;
        end if;
        
    end if;
end process;

-- Next state logic.
process (current_state, sync_in_resync, DELAY_REG_r, cnt)
begin
    case current_state is
        when WAIT_START =>
            if (sync_in_resync = '0') then
                next_state <= WAIT_START;
            else
                next_state <= WAIT_DELAY;
            end if;
            
        when WAIT_DELAY =>
            if (cnt < unsigned(DELAY_REG_r)) then
                next_state <= WAIT_DELAY;
            else
                next_state <= WAIT_END;
            end if;
            
        when WAIT_END =>
            if (sync_in_resync = '1') then
                next_state <= WAIT_END;
            else
                next_state <= WAIT_START;
            end if;

    end case;
end process;

-- Output logic.
process (current_state)
begin
wait_start_state    <= '0';
wait_delay_state    <= '0';
sync_out_i          <= '0';
    case current_state is
        when WAIT_START =>
            wait_start_state    <= '1';
            wait_delay_state    <= '0';
            sync_out_i          <= '0';           
        
        when WAIT_DELAY =>
            wait_start_state    <= '0';
            wait_delay_state    <= '1';
            sync_out_i          <= '0';        
        
        when WAIT_END =>
            wait_start_state    <= '0';
            wait_delay_state    <= '0';
            sync_out_i          <= '1';        
        
    end case;
end process;

-- Assign output.
sync_out <= sync_out_i;

end Behavioral;
