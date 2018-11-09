----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2018 09:23:36 AM
-- Design Name: 
-- Module Name: cds_noncausal - Behavioral
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

entity cds_noncausal is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           p : in STD_LOGIC;
           s : in STD_LOGIC;
           dready_in : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (17 downto 0);
           dready_out : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (31 downto 0);
           DELAYP_REG : in STD_LOGIC_VECTOR (15 downto 0);
           DELAYS_REG : in STD_LOGIC_VECTOR (15 downto 0);
           SAMPLESP_REG : in STD_LOGIC_VECTOR (15 downto 0);
           SAMPLESS_REG : in STD_LOGIC_VECTOR (15 downto 0);
           OUTSEL_REG : in STD_LOGIC_VECTOR (1 downto 0));
end cds_noncausal;

architecture Behavioral of cds_noncausal is

component accumulator_p is
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
end component;

component accumulator_s is
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
end component;

signal p_r : std_logic;
signal p_i : std_logic;
signal p_m : std_logic;
signal s_r : std_logic;
signal s_i : std_logic;
signal s_m : std_logic;

signal dready_out_p : std_logic;
signal dack_out_p : std_logic;
signal data_out_p   : std_logic_vector (31 downto 0);

signal dready_out_s : std_logic;
signal dack_out_s : std_logic;
signal data_out_s : std_logic_vector (31 downto 0);

signal sub_s_p  : signed (31 downto 0);
signal sub_p_s  : signed (31 downto 0);
signal res      : signed (31 downto 0);

signal dout_r : std_logic_vector (31 downto 0);

type fsm_state is ( INIT,
                    WAIT_P,
                    WAIT_P_END,
                    WAIT_S,
                    WAIT_S_END,
                    WRITE_OUT);
signal current_state, next_state : fsm_state;

signal write_out_state : std_logic;

signal OUTSEL_REG_r : std_logic_vector (1 downto 0);

begin

accumulator_p_i : accumulator_p
    Port map ( 
        rst             => rst,
        clk             => clk,
        p               => p_m,
        dready_in       => dready_in,
        data_in         => data_in,
        dready_out      => dready_out_p,
        dack_out        => dack_out_p,
        data_out        => data_out_p,
        DELAY_REG       => DELAYP_REG,
        SAMPLES_REG     => SAMPLESP_REG
        );

accumulator_s_i : accumulator_s
    Port map ( 
        rst             => rst,
        clk             => clk,
        s               => s_m,
        dready_in       => dready_in,
        data_in         => data_in,
        dready_out      => dready_out_s,
        dack_out        => dack_out_s,
        data_out        => data_out_s,
        DELAY_REG       => DELAYS_REG,
        SAMPLES_REG     => SAMPLESS_REG
        );

-- p and s signals clocked to avoid integrating on "11" state.
process (rst,clk)
begin
    if (rst = '1') then
        p_r <= '0';
        s_r <= '0';
        OUTSEL_REG_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        p_r <= p;
        s_r <= s;
        OUTSEL_REG_r <= OUTSEL_REG;
    end if;    
end process;

-- Logic for p and s signals.
-- OUTSEL_REG_r
-- 00 : pedestal only
-- 01 : signal only
-- 10 : signal - pedestal
-- 11 : pedestal - signal
p_i <=  '1' when (p_r = '1' and s_r = '0') else
        '0';

p_m <=  p_r when ( OUTSEL_REG_r = "00" ) else
        p_i;

s_i <=  '1' when (p_r = '0' and s_r = '1') else
        '0';
        
s_m <=  s_r when ( OUTSEL_REG_r = "01" ) else
        s_i;
        
-- Substraction.
sub_s_p <= signed(data_out_s) - signed(data_out_p);
sub_p_s <= signed(data_out_p) - signed(data_out_s);

-- Output operation selector.
res <=  signed(data_out_p)  when ( OUTSEL_REG_r = "00" ) else
        signed(data_out_s)  when ( OUTSEL_REG_r = "01" ) else
        sub_s_p             when ( OUTSEL_REG_r = "10" ) else
        sub_p_s;
        
--sub <= signed(data_out_s) - signed(data_out_p);        

-- Registers.
process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        dout_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        if (write_out_state = '1') then
            dout_r <= std_logic_vector(res);
        end if;
    end if;
end process;

-- Next state logic.
process(current_state,dready_out_p,dready_out_s,OUTSEL_REG_r)
begin
    case current_state is
        when INIT =>
            if ( (OUTSEL_REG_r = "00") or (OUTSEL_REG_r = "10") or (OUTSEL_REG_r = "11") ) then
                -- Pedestal only, signal-pedestal or pedestal-signal.
                next_state <= WAIT_P;
            else            
                -- Signal only.
                next_state <= WAIT_S;
            end if;
            
        when WAIT_P =>
            if ( OUTSEL_REG_r = "01" ) then
                next_state <= WAIT_S;
            else
                if (dready_out_p = '0') then
                    next_state <= WAIT_P;
                else
                    next_state <= WAIT_P_END;
                end if;
            end if;                 
        
        when WAIT_P_END =>
            if (dready_out_p = '1') then
                next_state <= WAIT_P_END;
            else
                if ( OUTSEL_REG_r = "00" ) then
                    -- Pedestal only.
                    next_state <= WRITE_OUT;
                else
                    next_state <= WAIT_S;
                end if;
            end if;
                    
        when WAIT_S =>
            if (dready_out_s = '0') then
                next_state <= WAIT_S;
            else
                next_state <= WAIT_S_END;
            end if;
            
        when WAIT_S_END =>
                if (dready_out_s = '1') then
                    next_state <= WAIT_S_END;
                else
                    next_state <= WRITE_OUT;
                end if;
                            
        when WRITE_OUT =>
            next_state <= INIT;
            
    end case;
end process;

-- Output logic.
process(current_state)
begin
write_out_state <= '0';
dack_out_p <= '0';
dack_out_s <= '0';
    case current_state is
        when INIT =>
            write_out_state <= '0';
            dack_out_p <= '0';
            dack_out_s <= '0';
            
        when WAIT_P =>
            write_out_state <= '0';
            dack_out_p <= '0';
            dack_out_s <= '0';
          
        when WAIT_P_END =>
            write_out_state <= '0';
            dack_out_p <= '1';
            dack_out_s <= '0';
              
        when WAIT_S =>
            write_out_state <= '0';
            dack_out_p <= '0';
            dack_out_s <= '0';
        
        when WAIT_S_END =>
            write_out_state <= '0';
            dack_out_p <= '0';
            dack_out_s <= '1';
            
        when WRITE_OUT =>
            write_out_state <= '1';
            dack_out_p <= '0';
            dack_out_s <= '0';
            
    end case;
end process;
        
-- Assign outputs.
dready_out <= not write_out_state;    
data_out <= dout_r;          

end Behavioral;
