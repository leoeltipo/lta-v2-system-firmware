----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 09:22:06 AM
-- Design Name: 
-- Module Name: master_sel - Behavioral
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

entity master_sel is
    Port (  din_0 : in STD_LOGIC;
            din_1 : in STD_LOGIC;
            din_2 : in STD_LOGIC;
            sel : out STD_LOGIC);
end master_sel;

architecture Behavioral of master_sel is

signal din_v : std_logic_vector (2 downto 0);

begin

din_v <= din_2 & din_1 & din_0;

sel <=  '1' when din_v = "111" else
        '0';

end Behavioral;
