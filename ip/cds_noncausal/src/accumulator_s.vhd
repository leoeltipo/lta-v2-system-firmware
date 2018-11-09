----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2018 09:27:22 AM
-- Design Name: 
-- Module Name: accumulator_s - Behavioral
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

entity accumulator_s is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           s : in STD_LOGIC;
           dready_in : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (17 downto 0);
           dready_out : out STD_LOGIC;
           dack_out : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (31 downto 0);
           DELAY_REG : in STD_LOGIC_VECTOR (15 downto 0);
           SAMPLES_REG : in STD_LOGIC_VECTOR (15 downto 0));
end accumulator_s;

architecture Behavioral of accumulator_s is

component acc is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           start : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (17 downto 0);
           dout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Accumulator signals.
signal enable_acc : std_logic;
signal start_acc : std_logic;
signal din_acc : std_logic_vector (17 downto 0);
signal dout_acc : std_logic_vector (31 downto 0);

-- 1 clock delay due to input data register pipeline.
signal enable_acc_d : std_logic;

-- FSM.
type fsm_state is ( INIT,
                    WAIT_IN_READY_DELAY,
                    READ_IN_DELAY,
                    WAIT_IN_END_DELAY,
                    WAIT_IN_READY_ACC,
                    READ_IN_ACC,
                    WAIT_IN_END_ACC,
                    ACC_END,
                    WAIT_END,
                    WRITE_OUT,
                    WAIT_ACK,
                    WAIT_ACK_END,
                    ENDS);
signal current_state, next_state : fsm_state;

signal init_state : std_logic;
signal read_in_state : std_logic;
signal acc_end_state : std_logic;
signal start_acc_i : std_logic;
signal write_out_state : std_logic;

signal dready_out_i : std_logic;

signal s_r : std_logic;

-- Registers.
signal delay_reg_r : unsigned (15 downto 0);
signal samples_reg_r : unsigned (15 downto 0);

signal delay_cnt : unsigned (15 downto 0);
signal delay_cnt_e : std_logic; 

signal samples_cnt : unsigned (15 downto 0);
signal samples_cnt_e : std_logic;

signal din_r : std_logic_vector (17 downto 0);
signal dout_r : std_logic_vector (31 downto 0);

begin

acc_i : acc
    Port map ( 
        rst => rst,
        clk => clk,
        enable => enable_acc_d,
        start => start_acc,
        din => din_acc,
        dout => dout_acc
        );
        
-- Accumulator connections.
enable_acc <= read_in_state and start_acc_i;
start_acc <= start_acc_i;
din_acc <= din_r;        
           
-- Registers.
process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        
        s_r <= '0';
        
        delay_reg_r <= (others => '0');
        samples_reg_r <= (others => '0');
        
        delay_cnt <= (others => '0');
        samples_cnt <= (others => '0');
        
        din_r <= (others => '0');
        dout_r <= (others => '0');      
        
        enable_acc_d <= '0';          
               
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        
        s_r <= s;
        
        delay_reg_r <= unsigned(DELAY_REG);
        samples_reg_r <= unsigned(SAMPLES_REG);
        
        if (init_state = '1') then
            delay_cnt <= delay_reg_r;
        elsif (delay_cnt_e = '1') then
            delay_cnt <= delay_cnt - 1;
        end if;
        
        if (init_state = '1') then
            samples_cnt <= samples_reg_r;
        elsif (samples_cnt_e = '1') then
            samples_cnt <= samples_cnt - 1;
        end if;
        
        if (read_in_state = '1') then
            din_r <= data_in;
        end if;
        
        if (write_out_state = '1') then
            dout_r <= dout_acc;
        end if;                
         
        enable_acc_d <= enable_acc;      
    end if;
end process;

-- Next state logic.
process (current_state,s_r,delay_reg_r,samples_reg_r,delay_cnt,samples_cnt,dready_in,dack_out)
begin
    case current_state is
        when INIT =>
            if (s_r = '0') then
                next_state <= INIT;
            elsif (samples_reg_r > 0) then
                if (delay_reg_r > 0) then
                    next_state <= WAIT_IN_READY_DELAY;
                else
                    next_state <= WAIT_IN_READY_ACC;
                end if;                
            end if;
                    
        when WAIT_IN_READY_DELAY =>
            if (s_r = '1') then
                if (dready_in = '0') then
                    next_state <= WAIT_IN_READY_DELAY;
                else
                    next_state <= READ_IN_DELAY;
                end if;
            else
                next_state <= ENDS;
            end if;
                    
        when READ_IN_DELAY =>
            next_state <= WAIT_IN_END_DELAY;
            
        when WAIT_IN_END_DELAY =>
            if (dready_in = '1') then
                next_state <= WAIT_IN_END_DELAY;
            elsif (s_r = '1') then
                if (delay_cnt > 0) then
                    next_state <= WAIT_IN_READY_DELAY;
                else
                    next_state <= WAIT_IN_READY_ACC;
                end if;
            else
                next_state <= ENDS;
            end if;        
        
        when WAIT_IN_READY_ACC =>
            if (s_r = '1') then
                if (dready_in = '0') then
                    next_state <= WAIT_IN_READY_ACC;
                else
                    next_state <= READ_IN_ACC;
                end if;
            else
                next_state <= ACC_END;
            end if;        
        
        when READ_IN_ACC =>
            next_state <= WAIT_IN_END_ACC;
            
        when WAIT_IN_END_ACC =>
            if (dready_in = '1') then
                next_state <= WAIT_IN_END_ACC;
            elsif (s_r = '1') then
                if (samples_cnt > 0) then
                    next_state <= WAIT_IN_READY_ACC;
                else
                    next_state <= ACC_END;
                end if;
            else
                next_state <= ACC_END;
            end if;
                            
        when ACC_END =>
            next_state <= WAIT_END;
            
        when WAIT_END =>
            if (s_r = '1') then
                next_state <= WAIT_END;
            else
                next_state <= WRITE_OUT;
            end if;
            
        when WRITE_OUT =>
            next_state <= WAIT_ACK;
            
        when WAIT_ACK =>
            if (dack_out = '0') then
                next_state <= WAIT_ACK;
            else
                next_state <= WAIT_ACK_END;
            end if;
                
        when WAIT_ACK_END =>
            if (dack_out = '1') then
                next_state <= WAIT_ACK_END;
            else
                next_state <= INIT;
            end if;
        
            
        when ENDS =>
            next_state <= INIT;                            
    end case;
end process;

-- Output logic.
process (current_state)
begin
init_state <= '0';
read_in_state <= '0';
delay_cnt_e <= '0';
samples_cnt_e <= '0';
acc_end_state <= '0';
start_acc_i <= '0';
write_out_state <= '0';
dready_out_i <= '0';
    case current_state is
        when INIT =>
            init_state <= '1';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';
                
        when WAIT_IN_READY_DELAY =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';
        
        when READ_IN_DELAY =>
            init_state <= '0';
            read_in_state <= '1';
            delay_cnt_e <= '1';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';
                   
        when WAIT_IN_END_DELAY =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';
                    
        when WAIT_IN_READY_ACC =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '1';
            write_out_state <= '0';
            dready_out_i <= '0';
                    
        when READ_IN_ACC =>
            init_state <= '0';
            read_in_state <= '1';
            delay_cnt_e <= '0';
            samples_cnt_e <= '1';
            acc_end_state <= '0';
            start_acc_i <= '1';
            write_out_state <= '0';
            dready_out_i <= '0';
                    
        when WAIT_IN_END_ACC =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '1';
            write_out_state <= '0';
            dready_out_i <= '0';
                    
        when ACC_END =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '1';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';
        
        when WAIT_END =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';
        
        when WRITE_OUT =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '1';
            dready_out_i <= '0';
        
        when WAIT_ACK =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '1';        
        
        when WAIT_ACK_END =>    
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
            dready_out_i <= '0';                
                    
        when ENDS =>
            init_state <= '0';
            read_in_state <= '0';
            delay_cnt_e <= '0';
            samples_cnt_e <= '0';
            acc_end_state <= '0';
            start_acc_i <= '0';
            write_out_state <= '0';
    end case;
end process;

-- Assign output.
dready_out <= dready_out_i;
data_out <= dout_r; 

end Behavioral;
