----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 12:56:25 PM
-- Design Name: 
-- Module Name: cnt_fr - Behavioral
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

entity cnt_fr is
    Generic 
        (
            N : Integer := 16
        );
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           fin_rst : in STD_LOGIC;
           fin : in STD_LOGIC;
           dout : out UNSIGNED (N-1 downto 0));
end cnt_fr;

architecture Behavioral of cnt_fr is

-- Synchronizer.
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

-- State machine.
type fsm_state is ( INIT_ST,
                    WAIT_START_ST,
                    INC_ST,
                    WAIT_END_ST);
signal current_state, next_state : fsm_state;

-- Signals.
signal init_state   : std_logic;
signal inc_state    : std_logic;
signal fin_resync   : std_logic;
signal cnt          : unsigned (N-1 downto 0);

begin

-- fin resync.
fin_resync_i : synchronizer
	generic map (
		N => 2
	)
	port map (
		rst		    => rst,
		clk 		=> clk,
		data_in		=> fin,
		data_out	=> fin_resync
	);

-- Registers.
process (rst,clk)
begin
    if ( rst = '1' ) then
        -- State register.
        current_state <= INIT_ST;
        
        -- Counter.
        cnt <= (others => '0');
        
    elsif ( clk'event and clk = '1' ) then
        -- State register.
        current_state <= next_state;
        
        -- Counter.
        if (init_state = '1') then
            cnt <= (others => '0'); 
        elsif (inc_state = '1') then
            cnt <= cnt + 1;
        end if;
        
    end if;
end process;

-- Next state logic.
process (current_state, fin_rst, fin_resync)
begin
    case current_state is           
        when INIT_ST =>
            if (fin_rst = '1') then
                next_state <= INIT_ST;
            else
                next_state <= WAIT_START_ST;
            end if;
            
        when WAIT_START_ST =>
            if (fin_rst = '1') then
                next_state <= INIT_ST;
            else
                if (fin_resync = '0') then
                    next_state <= WAIT_START_ST;
                else
                    next_state <= INC_ST;
                end if;
            end if;
                        
        when INC_ST =>
            if (fin_rst = '1') then
                next_state <= INIT_ST;
            else
                next_state <= WAIT_END_ST;
            end if;
            
        when WAIT_END_ST =>
            if (fin_rst = '1') then
                next_state <= INIT_ST;
            else
                if (fin_resync = '1') then
                    next_state <= WAIT_END_ST;
                else
                    next_state <= WAIT_START_ST;
                end if;
            end if;
                        
    end case;
end process;

-- Output logic.
process (current_state)
begin
init_state  <= '0';
inc_state   <= '0';
    case current_state is
        when INIT_ST        =>
            init_state  <= '1';
            inc_state   <= '0';
                       
        when WAIT_START_ST  =>
            init_state  <= '0';           
            inc_state   <= '0';
        
        when INC_ST         =>
            init_state  <= '0';
            inc_state   <= '1';
        
        when WAIT_END_ST    =>
            init_state  <= '0';
            inc_state   <= '0';
        
    end case;
end process;

-- Assign outputs.
dout <= cnt;

end Behavioral;
