----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2019 09:16:43 AM
-- Design Name: 
-- Module Name: smart_mem - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity smart_mem is
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
end smart_mem;

architecture Behavioral of smart_mem is

type ram_type is array (2**N-1 downto 0) of std_logic_vector (19 downto 0);
signal RAM : ram_type;

signal douta_i : std_logic_vector (19 downto 0);

begin

-- Data write process.
process (clka)
begin
    if (clka'event and clka = '1') then
        if (ena = '1') then
            if (wea(0) = '1') then
                RAM(conv_integer(addra)) <= dina;
            end if;
            douta_i <= RAM(conv_integer(addra));
        end if;
    end if;
end process;

-- Output register.
process (clka)
begin
    if (clka'event and clka = '1') then
        douta <= douta_i;
    end if;
end process;

end Behavioral;
