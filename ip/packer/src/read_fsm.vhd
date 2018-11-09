----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2018 02:33:20 PM
-- Design Name: 
-- Module Name: read_fsm - Behavioral
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

entity read_fsm is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0);
           ack : out STD_LOGIC);
end read_fsm;

architecture Behavioral of read_fsm is

-- FSM states.
type fsm_state is (INIT,READ_IN,WAIT_END);
signal current_state, next_state : fsm_state;

-- Data register.
signal data_r : std_logic_vector (31 downto 0);
signal read_in_e : std_logic;

-- Ack output.
signal ack_i : std_logic;

begin

-- Registers.
process (rst, clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        data_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        if (read_in_e = '1') then
            data_r <= data_in;
        end if;
    end if;
end process;

-- Next state logic.
process(current_state, ready)
begin
    case current_state is
        when INIT =>
            if (ready = '0') then
                next_state <= INIT;
            else
                next_state <= READ_IN;
            end if;
            
        when READ_IN =>
            next_state <= WAIT_END;       
            
        when WAIT_END =>
            if (ready = '1') then
                next_state <= WAIT_END;
            else
                next_state <= INIT;
            end if;
    end case;
end process;

-- Output logic.
process (current_state)
begin
read_in_e <= '0';
ack_i <= '0';
    case current_state is
        when INIT =>
            read_in_e <= '0';
            ack_i <= '0';
            
        when READ_IN =>
            read_in_e <= '1';
            ack_i <= '0';
            
        when WAIT_END =>
            read_in_e <= '0';
            ack_i <= '1';
            
    end case;
end process;

-- Assign output data.
data_out <= data_r;
ack <= ack_i;

end Behavioral;
