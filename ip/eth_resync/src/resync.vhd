----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 11:38:14 AM
-- Design Name: 
-- Module Name: resync - Behavioral
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

entity resync is
    Port (
        -- Global reset and clock. 
        rst     : in STD_LOGIC;
        clk     : in STD_LOGIC;        
        
        -- Interface signals.
        we_in   : in STD_LOGIC;        
        we_out  : out STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR (63 downto 0);
        data_out: out STD_LOGIC_VECTOR (63 downto 0)
    );
end resync;

architecture Behavioral of resync is

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

-- Sync'ed signal.
signal we_in_sync   : std_logic;
signal we_in_sync_d : std_logic;
signal we_out_i     : std_logic;
signal we_out_i_d   : std_logic;

-- Data register.
signal data_r : std_logic_vector (63 downto 0);

begin

we_in_sync_i : synchronizer 
	generic map (
		N => 2
	)
	port map (
		rst => rst,
		clk => clk,
		data_in	=> we_in,
		data_out => we_in_sync
	);

-- Data register.
process(rst,clk)
begin
    if (rst = '1') then        
        data_r <= (others => '0');
        we_in_sync_d <= '0';
        we_out_i_d   <= '0';
    elsif (clk'event and clk = '1') then
        we_in_sync_d <= we_in_sync;
        we_out_i_d   <= we_out_i;
        if (we_in_sync = '1') then
            data_r <= data_in;
        end if;
    end if;
end process;

-- Create a pulse of exactly one period.
we_out_i <= '1' when we_in_sync = '1' and we_in_sync_d = '0' else
            '0';
            
-- Output signals.
we_out      <= we_out_i_d;
data_out    <= data_r;

end Behavioral;
