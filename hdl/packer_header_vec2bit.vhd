----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2017 09:20:47 AM
-- Design Name: 
-- Module Name: packer_header_vec2bit - Behavioral
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

entity packer_header_vec2bit is
    Port ( in_0 : in STD_LOGIC;
           in_1 : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (1 downto 0));
end packer_header_vec2bit;

architecture Behavioral of packer_header_vec2bit is

begin

dout(0) <= in_0;
dout(1) <= in_1;

end Behavioral;
