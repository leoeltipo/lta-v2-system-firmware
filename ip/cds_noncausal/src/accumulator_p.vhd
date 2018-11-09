----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2018 09:27:22 AM
-- Design Name: 
-- Module Name: accumulator_p - Behavioral
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

entity accumulator_p is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           p : in STD_LOGIC;
           dready_in : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (17 downto 0);
           dready_out : out STD_LOGIC;
           dack_out : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (31 downto 0);
           DELAY_REG : in STD_LOGIC_VECTOR (15 downto 0);
           SAMPLES_REG : in STD_LOGIC_VECTOR (15 downto 0));
end accumulator_p;

architecture Behavioral of accumulator_p is

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
  );
END COMPONENT;

component acc is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           start : in STD_LOGIC;           
           din : in STD_LOGIC_VECTOR (17 downto 0);
           dout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Memory signals.
signal mem_ena      : std_logic;
signal mem_wea      : std_logic_vector (0 downto 0);
signal mem_addra    : std_logic_vector (11 downto 0);
signal mem_dina     : std_logic_vector (17 downto 0);
signal mem_douta    : std_logic_vector (17 downto 0);

-- Accumulator signals.
signal enable_acc : std_logic;
signal start_acc : std_logic;
signal din_acc : std_logic_vector (17 downto 0);
signal dout_acc : std_logic_vector (31 downto 0);

-- State machine.
type fsm_state is ( INIT,
                    WAIT_IN_READY,
                    READ_IN,
                    WAIT_IN_END,
                    COMPUTE_PTR,
                    CHECK_0,
                    ACC_ENABLE,                    
                    WRITE_OUT,
                    WAIT_ACK,
                    WAIT_ACK_END,
                    ENDS);
signal current_state, next_state : fsm_state;

signal init_state : std_logic;
signal read_in_state : std_logic;
signal compute_ptr_state : std_logic;

signal acc_start_i : std_logic;
signal acc_enable_i : std_logic;

-- 1 clk delay due to memory latency.
signal acc_enable_i_d : std_logic;

-- Three clocks pipeline (accumulator).
signal dready_out_i : std_logic;
signal dready_out_i_d : std_logic;
signal dready_out_i_dd : std_logic;
signal dready_out_i_ddd : std_logic;

-- Three clocks pipeline (accumulator).
signal write_out_e : std_logic;
signal write_out_e_d : std_logic;
signal write_out_e_dd : std_logic;
signal write_out_e_ddd : std_logic;

-- Registered p signal.
signal p_r : std_logic;

-- Pointers.
signal ptr_last : unsigned (11 downto 0);
signal ptr_start : signed (15 downto 0);
signal ptr_end : signed (15 downto 0);
signal ptr_start_norm : signed(15 downto 0);
signal ptr_end_norm : signed (15 downto 0);

signal ptr_acc : unsigned (11 downto 0);
signal acc_cnt : unsigned (11 downto 0);

-- Registers.
signal delay_reg_r : unsigned(15 downto 0);
signal samples_reg_r : unsigned(15 downto 0);

signal delay_i : unsigned (15 downto 0);
signal delay_acc : unsigned (15 downto 0);
signal samples_i : unsigned (15 downto 0);
signal samples_acc : unsigned (15 downto 0);

signal dout_r : std_logic_vector (31 downto 0);

-- Input data counter.
signal data_in_cnt : unsigned (15 downto 0); 

begin

mem_0 : blk_mem_gen_0
  PORT MAP (
    clka => clk,
    ena => mem_ena,
    wea => mem_wea,
    addra => mem_addra,
    dina => mem_dina,
    douta => mem_douta
  );

-- Memory connections.
mem_dina <= data_in;
mem_addra <=    std_logic_vector(ptr_acc) when acc_start_i = '1' else
                std_logic_vector(ptr_last);
                
acc_i : acc 
    Port map ( 
        rst     => rst,
        clk     => clk,
        enable  => enable_acc,
        start   => start_acc,
        din     => din_acc,
        dout    => dout_acc
        );
        
-- Accumulator connections.
enable_acc <= acc_enable_i_d;
start_acc <= acc_start_i;
din_acc <= mem_douta;                        
  
-- Registers.
process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        
        p_r <= '0';
                
        delay_reg_r <= (others => '0');
        samples_reg_r <= (others => '0');
        
        ptr_last <= (others => '0');
        
        data_in_cnt <= (others => '0');
        
        ptr_acc <= (others => '0');
        acc_cnt <= (others => '0');        
        
        dout_r <= (others => '0');
        
        write_out_e_d <= '0';
        write_out_e_dd <= '0';
        write_out_e_ddd <= '0';
                
        dready_out_i_d <= '0';
        dready_out_i_dd <= '0';
        dready_out_i_ddd <= '0';
        
        acc_enable_i_d <= '0';        
        
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        
        p_r <= p;
        
        delay_reg_r <= unsigned(DELAY_REG);
        samples_reg_r <= unsigned(SAMPLES_REG);
        
        if (delay_reg_r >= to_unsigned(4096,delay_reg_r'length)) then
            delay_i <= to_unsigned(4096,delay_i'length);
        else
            delay_i <= delay_reg_r;            
        end if;
        
        if (samples_reg_r >= to_unsigned(4096,samples_reg_r'length)) then
            samples_i <= to_unsigned(4096,samples_i'length);
        else
            samples_i <= samples_reg_r;            
        end if;        
        
        if (init_state = '1') then
            data_in_cnt <= (others => '0');
        elsif (read_in_state = '1') then
            ptr_last <= ptr_last + 1;
            if (data_in_cnt < to_unsigned(4096,data_in_cnt'length)) then
                data_in_cnt <= data_in_cnt + 1;
            end if;
        elsif (compute_ptr_state = '1') then  
            ptr_acc <= to_unsigned(to_integer(ptr_start_norm),ptr_acc'length);            
            acc_cnt <= to_unsigned(to_integer(samples_acc-1),acc_cnt'length);        
        elsif (acc_start_i = '1') then            
            ptr_acc <= ptr_acc + 1;
            acc_cnt <= acc_cnt - 1;                                                         
        end if;
        
        if (write_out_e_ddd = '1') then
            dout_r <= dout_acc;
        end if;
        
        write_out_e_d <= write_out_e;        
        write_out_e_dd <= write_out_e_d;
        write_out_e_ddd <= write_out_e_dd;
        
        dready_out_i_d <= dready_out_i;
        dready_out_i_dd <= dready_out_i_d;
        dready_out_i_ddd <= dready_out_i_dd;
        
        acc_enable_i_d <= acc_enable_i;        
    end if;
end process;

-- Number of data and delay calculation.
-- Cases:
--
-- NT > D + N : number of accumulated samples bigger than delay plus samples to accumulate.
-- -> DACC = D
-- -> NACC = N
--
-- D < NT <= D + N: number of accumulated samples bigger than delay, but smaller than delay plus samples to accumulate.
-- -> DACC = D
-- -> NACC = NT - D
--
-- NT <= D: number of accumulated samples not enough to accumulate.
delay_acc <= delay_i;

samples_acc <=  samples_i               when ( data_in_cnt > (delay_i + samples_i) )    else
                data_in_cnt - delay_i   when ( data_in_cnt > delay_i )                  else
                (others => '0');
                
-- Pointer calculation.               
ptr_end <= to_signed(to_integer(ptr_last),ptr_end'length) -1 - to_signed(to_integer(delay_acc),ptr_end'length);
ptr_end_norm <= ptr_end when ptr_end >= 0 else
                ptr_end + to_signed(4096,ptr_end'length);
                
ptr_start <= to_signed(to_integer(ptr_end_norm),ptr_start'length) + 1 - to_signed(to_integer(samples_acc),ptr_start'length);
ptr_start_norm <=   ptr_start when ptr_start >= 0 else
                    ptr_start + to_signed(4096,ptr_start'length);

-- Next state logic.
process (current_state,p_r,dready_in,acc_cnt,dack_out,samples_acc)
begin
    case current_state is
        when INIT =>
            if (p_r = '0') then
                next_state <= INIT;
            else
                next_state <= WAIT_IN_READY;
            end if;
            
        when WAIT_IN_READY =>
            if (p_r = '1') then
                if (dready_in = '0') then
                    next_state <= WAIT_IN_READY;
                else
                    next_state <= READ_IN;
                end if;
            else
                next_state <= COMPUTE_PTR;
            end if;                
                        
        when READ_IN =>
            next_state <= WAIT_IN_END;
            
        when WAIT_IN_END =>
            if (dready_in = '1') then
                next_state <= WAIT_IN_END;
            elsif (p_r = '1') then
                next_state <= WAIT_IN_READY;
            else
                next_state <= COMPUTE_PTR;
            end if;
            
        when COMPUTE_PTR =>
            next_state <= CHECK_0;
           
        when CHECK_0 =>
            if (samples_acc = 0) then
                next_state <= ENDS;            
            else
                next_state <= ACC_ENABLE;
            end if;
            
        when ACC_ENABLE =>            
            if (acc_cnt > 0) then
                next_state <= ACC_ENABLE;
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
mem_ena <= '0';
mem_wea(0) <= '0';
init_state <= '0';
read_in_state <= '0';
compute_ptr_state <= '0';
acc_start_i <= '0';
acc_enable_i <= '0';
dready_out_i <= '0';
write_out_e <= '0';
    case current_state is
        when INIT =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '1';
            read_in_state <= '0';
            compute_ptr_state <= '0';            
            acc_start_i <= '0';
            acc_enable_i <= '0';           
            dready_out_i <= '0';
            write_out_e <= '0';
            
        when WAIT_IN_READY =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '0';
            acc_enable_i <= '0';            
            dready_out_i <= '0';
            write_out_e <= '0';
            
        when READ_IN =>
            mem_ena <= '1';
            mem_wea(0) <= '1';
            init_state <= '0';
            read_in_state <= '1';
            compute_ptr_state <= '0';
            acc_start_i <= '0';
            acc_enable_i <= '0';            
            dready_out_i <= '0';
            write_out_e <= '0';
            
        when WAIT_IN_END =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '0';
            acc_enable_i <= '0';
            dready_out_i <= '0';
            write_out_e <= '0';
            
        when COMPUTE_PTR =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '1';
            acc_start_i <= '0';
            acc_enable_i <= '0';
            dready_out_i <= '0';
            write_out_e <= '0';
            
        when CHECK_0 =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '1';
            acc_start_i <= '1';
            acc_enable_i <= '0';
            dready_out_i <= '0';
            write_out_e <= '0';
            
        when ACC_ENABLE =>
            mem_ena <= '1';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '1';
            acc_enable_i <= '1';
            dready_out_i <= '0';
            write_out_e <= '0';            
            
        when WRITE_OUT =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '1';
            acc_enable_i <= '0';
            dready_out_i <= '0';
            write_out_e <= '1';                    
        
        when WAIT_ACK =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '0';
            acc_enable_i <= '0';
            dready_out_i <= '1';
            write_out_e <= '0';
            
        when WAIT_ACK_END =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '0';
            acc_enable_i <= '0';
            dready_out_i <= '0';
            write_out_e <= '0';                                                        
            
        when ENDS =>
            mem_ena <= '0';
            mem_wea(0) <= '0';
            init_state <= '0';
            read_in_state <= '0';
            compute_ptr_state <= '0';
            acc_start_i <= '0';
            acc_enable_i <= '0';
            dready_out_i <= '0';
            write_out_e <= '0';            
    
    end case;
end process;

-- Assign output data.
dready_out <= dready_out_i_ddd;
data_out <= dout_r;

end Behavioral;
