----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2017 09:20:24 AM
-- Design Name: 
-- Module Name: sequencer_bits - Behavioral
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

entity sequencer_bits is
    Port ( vec_in : in STD_LOGIC_VECTOR (31 downto 0);
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
           out15 : out STD_LOGIC;
           out16 : out STD_LOGIC;
           out17 : out STD_LOGIC;
           out18 : out STD_LOGIC;
           out19 : out STD_LOGIC;
           out20 : out STD_LOGIC;
           out21 : out STD_LOGIC;
           out22 : out STD_LOGIC;
           out23 : out STD_LOGIC;
           out24 : out STD_LOGIC;
           out25 : out STD_LOGIC;
           out26 : out STD_LOGIC;
           out27 : out STD_LOGIC;
           out28 : out STD_LOGIC;
           out29 : out STD_LOGIC;
           out30 : out STD_LOGIC;
           out31 : out STD_LOGIC);
end sequencer_bits;

architecture Behavioral of sequencer_bits is

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
out16 <= vec_in(16);
out17 <= vec_in(17);
out18 <= vec_in(18);
out19 <= vec_in(19);
out20 <= vec_in(20);
out21 <= vec_in(21);
out22 <= vec_in(22);
out23 <= vec_in(23);
out24 <= vec_in(24);
out25 <= vec_in(25);
out26 <= vec_in(26);
out27 <= vec_in(27);
out28 <= vec_in(28);
out29 <= vec_in(29);
out30 <= vec_in(30);
out31 <= vec_in(31);

end Behavioral;
