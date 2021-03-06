----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2018 04:41:40 PM
-- Design Name: 
-- Module Name: bufr_5 - Behavioral
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

entity bufr_5 is
    Port ( I : in STD_LOGIC;
           CE : in STD_LOGIC;
           CLR : in STD_LOGIC;
           O : out STD_LOGIC);
end bufr_5;

architecture Behavioral of bufr_5 is

begin

 BUFR_inst : BUFR
   generic map (
      BUFR_DIVIDE => "5",   -- Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8" 
      SIM_DEVICE => "7SERIES"  -- Must be set to "7SERIES" 
   )
   port map (
      O => O,     -- 1-bit output: Clock output port
      CE => CE,   -- 1-bit input: Active high, clock enable (Divided modes only)
      CLR => CLR, -- 1-bit input: Active high, asynchronous clear (Divided modes only)
      I => I      -- 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
   );

end Behavioral;
