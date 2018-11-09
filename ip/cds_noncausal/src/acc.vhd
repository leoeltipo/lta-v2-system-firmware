----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2018 12:01:13 PM
-- Design Name: 
-- Module Name: acc - Behavioral
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

entity acc is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           start : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (17 downto 0);
           dout : out STD_LOGIC_VECTOR (31 downto 0));
end acc;

architecture Behavioral of acc is

type fsm_state is (INIT,ACC,ACC_END);
signal current_state, next_state : fsm_state;

signal acc_state : std_logic;
signal write_out_e : std_logic;

signal acc_r : signed(31 downto 0);
signal dout_r : std_logic_vector (31 downto 0);

begin

process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        
        acc_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        
        if (acc_state = '1') then
            if (enable = '1') then
                acc_r <= acc_r + resize(signed(din),acc_r'length);
            end if;
        end if;
        
        if (write_out_e = '1') then
            acc_r <= (others => '0');
            dout_r <= std_logic_vector(acc_r);
        end if;
    end if;
end process;

-- Next state logic.
process (current_state, start)
begin
    case current_state is
        when INIT =>
            if (start = '0') then
                next_state <= INIT;
            else
                next_state <= ACC;
            end if;
            
        when ACC =>
            if (start = '1') then
                next_state <= ACC;
            else
                next_state <= ACC_END;
            end if;
            
        when ACC_END =>
            next_state <= INIT;
    end case;
end process;

-- Output logic.
process (current_state)
begin
acc_state <= '0';
write_out_e <= '0';
    case current_state is
        when INIT =>
            acc_state <= '0';
            write_out_e <= '0';
            
        when ACC =>
            acc_state <= '1';
            write_out_e <= '0';
            
        when ACC_END =>
            acc_state <= '0';
            write_out_e <= '1';
    end case;
end process;

-- Assign output data.
dout <= dout_r;

end Behavioral;
