----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/10/2018 02:55:17 PM
-- Design Name: 
-- Module Name: raw_smart_buffer_rw - Behavioral
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

entity raw_smart_buffer_rw is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (21 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end raw_smart_buffer_rw;

architecture Behavioral of raw_smart_buffer_rw is

signal read_in_e    : std_logic;
signal write_out_e  : std_logic;

signal dready_r     : std_logic;

signal din_r        : std_logic_vector (21 downto 0);

signal dout_i       : std_logic_vector (63 downto 0);
signal dout_r       : std_logic_vector (63 downto 0);

signal channel_id   : std_logic_vector (3 downto 0);
signal header       : std_logic_vector (1 downto 0);

signal zeros_36     : std_logic_vector (35 downto 0) := x"000000000";
signal zeros_4      : std_logic_vector (3 downto 0) := x"0";

-- State machine.
type fsm_state is (INIT,READ_IN,WRITE_OUT,WAIT_END);
signal current_state, next_state : fsm_state;

begin

-- Mux for id.
-- CHA mapped to 4.
-- CHB mapped to 5.
-- CHC mapped to 6.
-- CHD mapped to 7.
channel_id <=   "0100" when din_r(21 downto 20) = "00" else
                "0101" when din_r(21 downto 20) = "01" else
                "0110" when din_r(21 downto 20) = "10" else
                "0111" when din_r(21 downto 20) = "11" else
                "0100";

-- Header.
header <=   din_r(19 downto 18);
                
-- 64 bit packet.
dout_i <=   zeros_4 & channel_id & header & zeros_36 & din_r(17 downto 0);
                
-- Registers.
process (rst,clk)
begin
    if (rst = '1') then
        current_state   <= INIT;        
        dready_r        <= '0';
        din_r           <= (others => '0');
        dout_r          <= (others => '0');
        
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        if (read_in_e = '1') then
            din_r <= data_in;
        end if;
        if (write_out_e = '1') then
            dout_r <= dout_i;
        end if;
        dready_r <= write_out_e;
    end if;
end process;

-- Next state logic.
process(current_state,ready_in,START_REG)
begin
    case current_state is
        when INIT =>
            if (START_REG = '1') then
                if (ready_in = '0') then
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
            if (ready_in = '1') then
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
dready  <= dready_r;
dout    <= dout_r;

end Behavioral;
