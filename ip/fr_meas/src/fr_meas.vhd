----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 09:45:03 AM
-- Design Name: 
-- Module Name: fr_meas - Behavioral
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

entity fr_meas is
    Generic (
        -- Number of bits of measurement interval counter.
        N : Integer := 16
    );
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           fin : in STD_LOGIC;
           FCLK_REG : in STD_LOGIC_VECTOR (31 downto 0);
           FMEAS_REG : out STD_LOGIC_VECTOR (31 downto 0));
end fr_meas;

architecture Behavioral of fr_meas is

-- Constant for interval counter.
constant INTERVAL_VALUE : Integer := 2**N;

-- Frequency counter component.
component cnt_fr is
    Generic 
        (
            N : Integer := 16
        );
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           fin_rst : in STD_LOGIC;
           fin : in STD_LOGIC;
           dout : out UNSIGNED (N-1 downto 0));
end component;

-- State machine.
type fsm_state is ( MEAS_ST,
                    COMPUTE_ST);
signal current_state, next_state : fsm_state;

-- Signals.
signal meas_state       : std_logic;
signal compute_state    : std_logic;

signal cnt          : unsigned (N-1 downto 0);
signal fin_rst      : std_logic;
signal fmeas_cnt    : unsigned (N-1 downto 0);
signal fmeas_cnt_r  : unsigned (N-1 downto 0);

signal FCLK_REG_r   : unsigned (31 downto 0);

signal mult_i : unsigned (FCLK_REG_r'length + N - 1 downto 0);
signal div_i  : unsigned (FCLK_REG_r'length - 1 downto 0);
signal div_r  : unsigned (FCLK_REG_r'length - 1 downto 0);

begin

-- Frequency counter instance.
cnt_fr_i : cnt_fr
    Generic map (
        N   => N
    )
    Port map ( 
        rst     => rst,
        clk     => clk,
        fin_rst => fin_rst,
        fin     => fin,
        dout    => fmeas_cnt
            );
            
-- Reset signal.
fin_rst <= compute_state;             

-- Registers.
process (rst,clk)
begin
    if ( rst = '1' ) then
        -- State register.
        current_state <= MEAS_ST;
        
        -- Interval counter.
        cnt <= (others => '0');
        
        -- Registers.
        FCLK_REG_r <= (others => '0');
        
        -- Frequency measurement.
        fmeas_cnt_r <= (others => '0');
        
        -- Division.
        div_r <= (others => '0');
        
    elsif ( clk'event and clk = '1' ) then
        -- State register.
        current_state <= next_state;
        
        -- Interval counter.
        if (meas_state = '1') then
            cnt <= cnt + 1;
        else
            cnt <= (others => '0');
        end if;
        
        -- Registers.
        FCLK_REG_r <= unsigned(FCLK_REG);
        
        -- Frequency measurement.
        if (meas_state = '1') then
            fmeas_cnt_r <= fmeas_cnt;
        end if;
        
        -- Division.
        if (compute_state = '1') then
            div_r <= div_i;
        end if;
        
    end if;
end process;

-- Multiply measured frequency by clock frequency in kHz.
mult_i <= FCLK_REG_r*fmeas_cnt_r;

-- Divide by the interval.
div_i <= mult_i(mult_i'length-1 downto N);

-- Next state logic.
process (current_state, cnt)
begin
    case current_state is           
        when MEAS_ST    =>
            if (cnt < to_unsigned(INTERVAL_VALUE-1,cnt'length)) then
                next_state <= MEAS_ST;
            else
                next_state <= COMPUTE_ST;
            end if;
            
        when COMPUTE_ST =>
            next_state <= MEAS_ST;

    end case;
end process;

-- Output logic.
process (current_state)
begin
meas_state      <= '0';
compute_state   <= '0';
    case current_state is           
        when MEAS_ST    =>
            meas_state      <= '1';
            compute_state   <= '0';
        
        when COMPUTE_ST =>
            meas_state      <= '0';
            compute_state   <= '1';
        
    end case;
end process;

-- Assign outputs.
FMEAS_REG <= std_logic_vector(div_r);

end Behavioral;
