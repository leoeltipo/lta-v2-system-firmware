----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/20/2018 08:24:32 AM
-- Design Name: 
-- Module Name: pix_seq_1ch_rw - Behavioral
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

entity pix_seq_1ch_rw is
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
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0);
           ack_dout : in STD_LOGIC);
end pix_seq_1ch_rw;

architecture Behavioral of pix_seq_1ch_rw is
component read_fsm is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0);
           ack : out STD_LOGIC);
end component;

signal data_a_r : std_logic_vector (31 downto 0);
signal ack_a : std_logic;

signal data_b_r : std_logic_vector (31 downto 0);
signal ack_b : std_logic;

signal data_c_r : std_logic_vector (31 downto 0);
signal ack_c : std_logic;

signal data_d_r : std_logic_vector (31 downto 0);
signal ack_d : std_logic;

-- ACK signals.
signal ack_i : std_logic;
signal ack_dout_i : std_logic;

signal word_out_1 : std_logic_vector (63 downto 0);
signal word_out_2 : std_logic_vector (63 downto 0);
signal word_out_3 : std_logic_vector (63 downto 0);
signal word_out_4 : std_logic_vector (63 downto 0);
signal dout_r : std_logic_vector (63 downto 0);

signal load_data_1_e : std_logic;
signal load_data_2_e : std_logic;
signal load_data_3_e : std_logic;
signal load_data_4_e : std_logic;
signal load_data_e : std_logic;
signal dready_i : std_logic;

signal zeros_4 : std_logic_vector (3 downto 0) := "0000";
signal zeros_24 : std_logic_vector (23 downto 0) := x"000000";

-- FSM states.
type fsm_state is (INIT,LOAD_DATA1,SEND1,WAIT1,LOAD_DATA2,SEND2,WAIT2,LOAD_DATA3,SEND3,WAIT3,LOAD_DATA4,SEND4,WAIT4,WAIT_END);
signal current_state, next_state : fsm_state;

begin

read_fsm_a_i : read_fsm
    Port map ( 
        rst => rst,
        clk => clk,
        ready => ready_a,
        data_in => data_a,
        data_out => data_a_r,
        ack => ack_a
        );

read_fsm_b_i : read_fsm
    Port map ( 
        rst => rst,
        clk => clk,
        ready => ready_b,
        data_in => data_b,
        data_out => data_b_r,
        ack => ack_b
        );

read_fsm_c_i : read_fsm
    Port map ( 
        rst => rst,
        clk => clk,
        ready => ready_c,
        data_in => data_c,
        data_out => data_c_r,
        ack => ack_c
        );
        
read_fsm_d_i : read_fsm
     Port map ( 
        rst => rst,
        clk => clk,
        ready => ready_d,
        data_in => data_d,
        data_out => data_d_r,
        ack => ack_d
        );                        

-- ACK signals.
ack_i <= ack_a and ack_b and ack_c and ack_d;
ack_dout_i <= ack_dout;

-- Output words.
word_out_1 <= zeros_4 & "1100" & zeros_24 & data_a_r;
word_out_2 <= zeros_4 & "1101" & zeros_24 & data_b_r;
word_out_3 <= zeros_4 & "1110" & zeros_24 & data_c_r;
word_out_4 <= zeros_4 & "1111" & zeros_24 & data_d_r;

-- Registers.
process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        dout_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        if (load_data_e = '1') then
            if (load_data_1_e = '1') then
                dout_r <= word_out_1;
            elsif (load_data_2_e = '1') then
                dout_r <= word_out_2;
            elsif (load_data_3_e = '1') then
                dout_r <= word_out_3;
            elsif (load_data_4_e = '1') then
                dout_r <= word_out_4;
            end if;
        end if;        
    end if;
end process;

-- Next state logic.
process (current_state, ack_i, ack_dout_i,START_REG)
begin
    case current_state is
        when INIT =>
            if (START_REG = '1') then
                if (ack_i = '0') then
                    next_state <= INIT;
                else
                    next_state <= LOAD_DATA1;
                end if;
            end if;
            
        when LOAD_DATA1 =>
            next_state <= SEND1;
            
        when SEND1 =>
            if (ack_dout_i = '1') then
                next_state <= SEND1;
            else                      
                next_state <= WAIT1;
            end if;           
            
        when WAIT1 =>
            if (ack_dout_i = '0') then
                next_state <= WAIT1;
            else
                next_state <= LOAD_DATA2;
            end if;

        when LOAD_DATA2 =>
            next_state <= SEND2;            
            
        when SEND2 =>
            if (ack_dout_i = '1') then
                next_state <= SEND2;
            else
                next_state <= WAIT2;
            end if; 
                                        
        when WAIT2 =>
            if (ack_dout_i = '0') then
                next_state <= WAIT2;
            else
                next_state <= LOAD_DATA3;
            end if;
            
        when LOAD_DATA3 =>
            next_state <= SEND3;            
                
        when SEND3 =>
            if (ack_dout_i = '1') then
                next_state <= SEND3;
            else
                next_state <= WAIT3;
            end if; 
                                                
        when WAIT3 =>
            if (ack_dout_i = '0') then
                next_state <= WAIT3;
            else
                next_state <= LOAD_DATA4;
            end if;            
            
        when LOAD_DATA4 =>
            next_state <= SEND4;            
                    
        when SEND4 =>
            if (ack_dout_i = '1') then
                next_state <= SEND4;
            else
                next_state <= WAIT4;
            end if; 
                                                    
        when WAIT4 =>
            if (ack_dout_i = '0') then
                next_state <= WAIT4;
            else
                next_state <= WAIT_END;
            end if;            
            
        when WAIT_END =>
            if (ack_i = '1') then
                next_state <= WAIT_END;
            else
                next_state <= INIT;
            end if;
            
    end case;
end process;

-- Output logic.
process (current_state)
begin
load_data_1_e <= '0';
load_data_2_e <= '0';
load_data_3_e <= '0';
load_data_4_e <= '0';
load_data_e <= '0';
dready_i <= '0';
    case current_state is
        when INIT =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '0';
                                 
        when LOAD_DATA1 =>
            load_data_1_e <= '1';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';        
            load_data_e <= '1';
            dready_i <= '0';
                       
        when SEND1 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';            
            load_data_e <= '0';
            dready_i <= '1';
                       
        when WAIT1 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';  
                     
        when LOAD_DATA2 =>
            load_data_1_e <= '0';
            load_data_2_e <= '1';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '1';
            dready_i <= '0';               
        
        when SEND2 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';               
        
        when WAIT2 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';               
            
        when LOAD_DATA3 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '1';
            load_data_4_e <= '0';
            load_data_e <= '1';
            dready_i <= '0';               
            
        when SEND3 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';               
            
        when WAIT3 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';            
            
        when LOAD_DATA4 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '1';
            load_data_e <= '1';
            dready_i <= '0';               
                
        when SEND4 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';               
                
        when WAIT4 =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '1';            
        
        when WAIT_END =>
            load_data_1_e <= '0';
            load_data_2_e <= '0';
            load_data_3_e <= '0';
            load_data_4_e <= '0';
            load_data_e <= '0';
            dready_i <= '0';               
    
    end case;
end process;

-- Assign output.
dready <= dready_i;
dout <= dout_r;

end Behavioral;
