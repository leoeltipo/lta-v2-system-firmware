----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/28/2019 02:38:45 PM
-- Design Name: 
-- Module Name: smart_mem_dummy - Behavioral
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

entity smart_mem_dummy is
    Generic 
        (
            N : integer := 16
        );
    Port 
        ( 
            clka    : in STD_LOGIC;
            ena     : in STD_LOGIC;
            wea     : in STD_LOGIC_VECTOR(0 downto 0);
            addra   : in STD_LOGIC_VECTOR (N-1 downto 0);
            dina    : in STD_LOGIC_VECTOR (19 downto 0);
            douta   : out STD_LOGIC_VECTOR (19 downto 0)
        );        
end smart_mem_dummy;

architecture Behavioral of smart_mem_dummy is

begin

process (clka)
begin
    if (clka'event and clka = '1') then
        douta <= dina;
    end if;
end process;

end Behavioral;
