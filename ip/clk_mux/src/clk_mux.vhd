----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 10:02:50 AM
-- Design Name: 
-- Module Name: clk_mux - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity clk_mux is
    Port ( clk_1 : in STD_LOGIC;
           clk_2 : in STD_LOGIC;
           sel : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_mux;

architecture Behavioral of clk_mux is

begin

BUFGMUX_inst : BUFGMUX
   port map (
      O => clk_out,   -- 1-bit output: Clock output
      I0 => clk_1, -- 1-bit input: Clock input (S=0)
      I1 => clk_2, -- 1-bit input: Clock input (S=1)
      S => sel    -- 1-bit input: Clock select
   );

end Behavioral;
