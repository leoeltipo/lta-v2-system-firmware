----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2019 03:25:40 PM
-- Design Name: 
-- Module Name: sync_align - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_align is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           sync_in : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end sync_align;

architecture Behavioral of sync_align is

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

-- Signals.
signal sync_in_resync   : std_logic;
signal sync_out_i       : std_logic;

-- State machine.
type fsm_state is (WAIT_START,WAIT_END);
signal current_state, next_state : fsm_state;

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
    if ( rst = '1' ) then
        current_state <= WAIT_START;
        
    elsif ( clk'event and clk = '1' ) then
        current_state <= next_state;
        
    end if;
end process;
	
-- Next state logic.
process (current_state, sync_in_resync)
begin
    case current_state is
        when WAIT_START =>
            if (sync_in_resync = '0') then
                next_state <= WAIT_START;
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
sync_out_i <= '0';
    case current_state is
        when WAIT_START =>
            sync_out_i <= '0';           
        
        when WAIT_END =>
            sync_out_i <= '1';
        
    end case;
end process;

-- Assign output.
sync_out <= sync_out_i;
	
end Behavioral;
