----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2018 04:01:13 PM
-- Design Name: 
-- Module Name: pix_rw - Behavioral
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

entity pix_rw is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready_a : in STD_LOGIC;
           data_a : in STD_LOGIC_VECTOR (31 downto 0);
           ready_b : in STD_LOGIC;
           data_b : in STD_LOGIC_VECTOR (31 downto 0);
           ready_c : in STD_LOGIC;
           data_c : in STD_LOGIC_VECTOR (31 downto 0);
           ready_d : in STD_LOGIC;
           data_d : in STD_LOGIC_VECTOR (31 downto 0);
           SOURCE_REG : in STD_LOGIC_VECTOR (3 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end pix_rw;

architecture Behavioral of pix_rw is

signal ready_i : std_logic;
signal data_i : std_logic_vector (31 downto 0);
signal data_r : std_logic_vector (31 downto 0);

signal read_in_e : std_logic;
signal write_out_e : std_logic;

signal dready_r : std_logic;

signal zeros_24 : std_logic_vector (23 downto 0) := x"000000";
signal zeros_4 : std_logic_vector (3 downto 0) := x"0";

signal dout_i : std_logic_vector (63 downto 0);
signal dout_r : std_logic_vector (63 downto 0);

-- State machine.
type fsm_state is (INIT,READ_IN,WRITE_OUT,WAIT_END);
signal current_state, next_state : fsm_state;

begin

-- Input mux.
ready_i <=  ready_a when SOURCE_REG = "0100" else
            ready_b when SOURCE_REG = "0101" else
            ready_c when SOURCE_REG = "0110" else
            ready_d when SOURCE_REG = "0111" else
            ready_a;
            
data_i <=   data_a when SOURCE_REG = "0100" else
            data_b when SOURCE_REG = "0101" else
            data_c when SOURCE_REG = "0110" else
            data_d when SOURCE_REG = "0111" else
            data_a;            
            
-- Output packet.
dout_i <=   zeros_4 & "1000" & zeros_24 & data_r when SOURCE_REG = "0100" else
            zeros_4 & "1001" & zeros_24 & data_r when SOURCE_REG = "0101" else
            zeros_4 & "1010" & zeros_24 & data_r when SOURCE_REG = "0110" else
            zeros_4 & "1011" & zeros_24 & data_r when SOURCE_REG = "0111" else
            zeros_4 & "1000" & zeros_24 & data_r;            

process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        data_r <= (others => '0');
        dready_r <= '0';
        dout_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        if (read_in_e = '1') then
            data_r <= data_i;
        end if;
        if (write_out_e = '1') then
            dout_r <= dout_i;
        end if;
        dready_r <= write_out_e;
    end if;
end process;

-- Next state logic.
process(current_state,ready_i,START_REG)
begin
    case current_state is
        when INIT =>
            if (START_REG = '1') then
                if (ready_i = '0') then
                    next_state <= INIT;
                else
                    next_state <= READ_IN;
                end if;
            end if;
            
        when READ_IN =>            
            next_state <= WRITE_OUT;     
            
        when WRITE_OUT =>
            next_state <= WAIT_END;      
            
        when WAIT_END =>
            if (ready_i = '1') then
                next_state <= WAIT_END;
            else
                next_state <= INIT;
            end if;
                         
    end case;
end process;

-- Output logic.
process(current_state)
begin
read_in_e <= '0';
write_out_e <= '0';
    case current_state is
        when INIT =>
            read_in_e <= '0';
            write_out_e <= '0';
            
        when READ_IN =>
            read_in_e <= '1';
            write_out_e <= '0';            
                        
        when WRITE_OUT =>
            read_in_e <= '0';
            write_out_e <= '1';
                        
        when WAIT_END =>
            read_in_e <= '0';
            write_out_e <= '0';

                          
    end case;
end process;

-- Assign output.
dready <= dready_r;
dout <= dout_r;

end Behavioral;
