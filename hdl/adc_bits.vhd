----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2017 00:12:47
-- Design Name: 
-- Module Name: adc_bits - Behavioral
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

entity adc_bits is
    Port ( vec_in : in STD_LOGIC_VECTOR (15 downto 0);
           out0 : out STD_LOGIC;
           out1 : out STD_LOGIC;
           out2 : out STD_LOGIC;
           out3 : out STD_LOGIC;
           out4 : out STD_LOGIC;
           out5 : out STD_LOGIC;
           out6 : out STD_LOGIC;
           out7 : out STD_LOGIC;
           out8 : out STD_LOGIC;
           out9 : out STD_LOGIC;
           out10 : out STD_LOGIC;
           out11 : out STD_LOGIC;
           out12 : out STD_LOGIC;
           out13 : out STD_LOGIC;
           out14 : out STD_LOGIC;           
           out15 : out STD_LOGIC);
end adc_bits;

architecture Behavioral of adc_bits is

begin

out0 <= vec_in(0);
out1 <= vec_in(1);
out2 <= vec_in(2);
out3 <= vec_in(3);
out4 <= vec_in(4);
out5 <= vec_in(5);
out6 <= vec_in(6);
out7 <= vec_in(7);
out8 <= vec_in(8);
out9 <= vec_in(9);
out10 <= vec_in(10);
out11 <= vec_in(11);
out12 <= vec_in(12);
out13 <= vec_in(13);
out14 <= vec_in(14);
out15 <= vec_in(15);

end Behavioral;
