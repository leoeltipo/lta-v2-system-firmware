----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/02/2018 03:47:10 PM
-- Design Name: 
-- Module Name: raw_capture - Behavioral
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

entity raw_capture is
    Generic 
    (
    -- Number of bits of total memory space.
    N   : integer := 18
    );
    Port     
        ( 
        -- Reset and clock.
        rst                 : in STD_LOGIC;
        clk                 : in STD_LOGIC;
        
        -- External capture enable signal.
        capture_en          : in STD_LOGIC;
        
        -- Start capture.
        capture_start       : in STD_LOGIC;
        
        -- RAW input data.
        ready_in_a          : in STD_LOGIC;
        data_in_a           : in STD_LOGIC_VECTOR (17 downto 0);
        ready_in_b          : in STD_LOGIC;
        data_in_b           : in STD_LOGIC_VECTOR (17 downto 0);
        ready_in_c          : in STD_LOGIC;
        data_in_c           : in STD_LOGIC_VECTOR (17 downto 0);
        ready_in_d          : in STD_LOGIC;
        data_in_d           : in STD_LOGIC_VECTOR (17 downto 0);
        
        -- Header.
        header              : in STD_LOGIC_VECTOR (1 downto 0);        
        
        -- Registers.        
        CH_SEL_REG          : in STD_LOGIC_VECTOR (1 downto 0);
        CH_NSAMP_REG        : in STD_LOGIC_VECTOR (N-1 downto 0);           
        CH_MODE_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        DATA_MODE_REG       : in STD_LOGIC;        
        CAPTURE_MODE_REG    : in STD_LOGIC;
        CAPTURE_EN_SRC_REG  : in STD_LOGIC;
        RESET_REG           : in STD_LOGIC;
        
        -- Number of points captured.
        ptr_last_out        : out STD_LOGIC_VECTOR (N-1 downto 0);
        nsamp_out           : out STD_LOGIC_VECTOR (N downto 0);
        
        -- Memory I/F.
        mem_en              : out STD_LOGIC;
        mem_we              : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr            : out STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        mem_din             : out STD_LOGIC_VECTOR(19 DOWNTO 0);        
        
        -- EOC signal.
        eoc                 : out STD_LOGIC;
        eoc_ack             : in STD_LOGIC
        );                
        
end raw_capture;

architecture Behavioral of raw_capture is

-- Constants.
constant BUF_SIZE_1 : integer := 2**N;
constant BUF_SIZE_2 : integer := BUF_SIZE_1/2;
constant BUF_SIZE_4 : integer := BUF_SIZE_2/2;

-- Registers.
signal CH_SEL_REG_r         : STD_LOGIC_VECTOR (1 downto 0);
signal CH_NSAMP_REG_r       : STD_LOGIC_VECTOR (N-1 downto 0);    
signal CH_MODE_REG_r        : STD_LOGIC_VECTOR (1 downto 0);     
signal DATA_MODE_REG_r      : STD_LOGIC;        
signal CAPTURE_MODE_REG_r   : STD_LOGIC;
signal CAPTURE_EN_SRC_REG_r : STD_LOGIC;
signal RESET_REG_r          : STD_LOGIC;

-- Ready and Data for channels.
signal ready_in     : std_logic;
signal data_in      : std_logic_vector (19 downto 0);
signal data_in_r    : std_logic_vector (19 downto 0);

-- Capture enable.
signal capture_en_i : std_logic;

-- Number of samples counter.
signal cnt_nsamp    : unsigned (N downto 0);
signal cnt_nsamp_r  : unsigned (N downto 0);
signal max_nsamp    : unsigned (N downto 0);
signal nsamp        : unsigned (N downto 0);
signal mem_addr_i   : unsigned (N-1 downto 0);
signal mem_addr_r   : unsigned (N-1 downto 0);

-- State machine.
type fsm_state is ( INIT_ST,
                    COMPUTE_CNT_ST,
                    WAIT_IN_ST,
                    READ_IN_ST,
                    WAIT_IN_END_ST,
                    WRITE_PTR_ST,                
                    SEND_EOC_ST,
					WAIT_EOC_ACK_ST,
                    END_ST);
signal current_state, next_state : fsm_state;                    

-- State signals.
signal init_state           : std_logic;
signal compute_cnt_state    : std_logic;
signal wait_in_state        : std_logic;
signal read_in_state        : std_logic;
signal write_ptr_state      : std_logic;

-- Memory control signals.
signal mem_en_i     : std_logic;    

-- EOC signal.
signal eoc_i    : std_logic;

begin

-- Muxes for channel selection.
ready_in <=     ready_in_a  when CH_SEL_REG_r = "00" else
                ready_in_b  when CH_SEL_REG_r = "01" else
                ready_in_c  when CH_SEL_REG_r = "10" else
                ready_in_d  when CH_SEL_REG_r = "11" else
                ready_in_a;
                
data_in <=      header & data_in_a  when CH_SEL_REG_r = "00" else
                header & data_in_b  when CH_SEL_REG_r = "01" else
                header & data_in_c  when CH_SEL_REG_r = "10" else
                header & data_in_d  when CH_SEL_REG_r = "11" else
                header & data_in_a;   

-- Mux for capture_en.
capture_en_i <= capture_en when CAPTURE_EN_SRC_REG_r = '0' else
                '1';
                
-- Maximum number of samples.
max_nsamp <=    to_unsigned(BUF_SIZE_1,max_nsamp'length) when CH_MODE_REG_r = "00" else
                to_unsigned(BUF_SIZE_2,max_nsamp'length) when CH_MODE_REG_r = "01" else
                to_unsigned(BUF_SIZE_4,max_nsamp'length) when CH_MODE_REG_r = "10" else
                to_unsigned(BUF_SIZE_1,max_nsamp'length);                     
-- Registers.
process (rst, clk)
begin
    if (rst = '1') then
        -- Registers.
        CH_SEL_REG_r            <= (others => '0');
        CH_NSAMP_REG_r          <= (others => '0');    
        CH_MODE_REG_r           <= (others => '0');       
        DATA_MODE_REG_r         <= '0';        
        CAPTURE_MODE_REG_r      <= '0';
        CAPTURE_EN_SRC_REG_r    <= '0';
        RESET_REG_r             <= '0';
        
        -- State machine.
        current_state <= INIT_ST;
        
        -- Number of samples counter.
        cnt_nsamp   <= (others => '0');
        cnt_nsamp_r <= (others => '0');
        nsamp       <= (others => '0');
        mem_addr_i  <= (others => '0');
        mem_addr_r  <= (others => '0');
        
        -- Input data register.
        data_in_r <= (others => '0');          

    elsif (rising_edge(clk)) then
        -- Registers.
        CH_SEL_REG_r            <= CH_SEL_REG;
        CH_NSAMP_REG_r          <= CH_NSAMP_REG;    
        CH_MODE_REG_r           <= CH_MODE_REG;       
        DATA_MODE_REG_r         <= DATA_MODE_REG;        
        CAPTURE_MODE_REG_r      <= CAPTURE_MODE_REG;
        CAPTURE_EN_SRC_REG_r    <= CAPTURE_EN_SRC_REG;
        RESET_REG_r             <= RESET_REG;        
        
        -- State machine.
        current_state <= next_state;
        
        -- Number of samples counter.
        if ( init_state = '1' ) then
            cnt_nsamp   <= (others => '0');
            mem_addr_i  <= (others => '0');                    
        elsif ( compute_cnt_state = '1') then
            if ( CAPTURE_MODE_REG_r = '0') then
                -- Single capture mode.
                if ( DATA_MODE_REG_r = '0' ) then
                    -- Full buffer capture.
                    nsamp <= max_nsamp;
                else
                    -- NSAMP buffer capture.
                    if ( resize(unsigned(CH_NSAMP_REG_r),max_nsamp'length) > max_nsamp ) then
                        nsamp <= max_nsamp;
                    else
                        nsamp <= resize(unsigned(CH_NSAMP_REG_r),nsamp'length);
                    end if;                    
                end if;
            end if;
        elsif ( wait_in_state = '1') then
            data_in_r <= data_in;
        elsif ( read_in_state = '1') then            
            if ( mem_addr_i < to_unsigned(to_integer(max_nsamp)-1,mem_addr_i'length) ) then
                mem_addr_i  <= mem_addr_i + 1;
            else
                mem_addr_i <= (others => '0');                
            end if;                                    
            if ( cnt_nsamp < max_nsamp ) then
                cnt_nsamp <= cnt_nsamp + 1;
            end if;
        elsif ( write_ptr_state = '1' ) then
            mem_addr_r  <= mem_addr_i;
            cnt_nsamp_r <= cnt_nsamp;
        end if;
        
    end if;
end process;

-- Next state logic.
process (current_state, RESET_REG_r, capture_start, cnt_nsamp, ready_in, capture_en_i, cnt_nsamp, nsamp, eoc_ack)
begin
    case current_state is
        when INIT_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( capture_start = '0') then
                next_state <= INIT_ST;
            else
                next_state <= COMPUTE_CNT_ST;
            end if;
            
        when COMPUTE_CNT_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            else
                next_state <= WAIT_IN_ST;
            end if;
            
        when WAIT_IN_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;                
            -- In continuous mode, capture_start = 0 stops the current capture.
            elsif ( (CAPTURE_MODE_REG_r = '1') and (capture_start = '0') ) then
                next_state <= WRITE_PTR_ST;
            else                  
                if ( capture_en_i = '1') then
                    if ( ready_in = '0') then
                        next_state <= WAIT_IN_ST;
                    else
                        next_state <= READ_IN_ST;
                    end if;
                else
                    next_state <= WAIT_IN_ST;
                end if;
            end if;            
            
        
        when READ_IN_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            else
                next_state <= WAIT_IN_END_ST;
            end if;
            
        when WAIT_IN_END_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;                
            elsif ( ready_in = '1') then
                next_state <= WAIT_IN_END_ST;
            else
                if ( CAPTURE_MODE_REG_r = '1' ) then
                    -- Continuous capture mode. capture_start stops the capture.
                    if ( capture_start = '1' ) then
                        next_state <= WAIT_IN_ST;
                    else
                        next_state <= WRITE_PTR_ST;
                    end if;
                else
                    -- Single capture mode. Use counter to finish current capture.
                    if ( cnt_nsamp < nsamp) then
                        next_state <= WAIT_IN_ST;
                    else
                        next_state <= WRITE_PTR_ST;
                    end if;
                end if;                                 
            end if;
        
        when WRITE_PTR_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            else
                next_state <= SEND_EOC_ST;
            end if;                
            
        when SEND_EOC_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( eoc_ack = '0' ) then
                next_state <= SEND_EOC_ST;
            else
                next_state <= WAIT_EOC_ACK_ST;
            end if;                        
            
        when WAIT_EOC_ACK_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( eoc_ack = '1' ) then
                next_state <= WAIT_EOC_ACK_ST;
            else
                next_state <= END_ST;
            end if;
            
        when END_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( capture_start = '1' ) then
                next_state <= END_ST;
            else
                next_state <= INIT_ST;
            end if;             
    end case;
end process;

-- Output logic.
process(current_state)
begin
init_state          <= '0';
compute_cnt_state   <= '0';
wait_in_state       <= '0';
read_in_state       <= '0';
write_ptr_state     <= '0';
mem_en_i            <= '0';
eoc_i               <= '0';
    case current_state is
        when INIT_ST =>
            init_state          <= '1';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '0';
            
        when COMPUTE_CNT_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '1';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '0';
            
        when WAIT_IN_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '1';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '0';
            		
        when READ_IN_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '1';
            write_ptr_state     <= '0';
            mem_en_i            <= '1';
            eoc_i               <= '0';
            		
        when WAIT_IN_END_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '0';
            		
        when WRITE_PTR_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '1';
            mem_en_i            <= '0';
            eoc_i               <= '1';            		
            		
        when SEND_EOC_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '1';
            		
        when WAIT_EOC_ACK_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '0';
            		
        when END_ST =>
            init_state          <= '0';
            compute_cnt_state   <= '0';
            wait_in_state       <= '0';
            read_in_state       <= '0';
            write_ptr_state     <= '0';
            mem_en_i            <= '0';
            eoc_i               <= '0';
            		
    end case;
end process;

-- Assign output signals.
ptr_last_out    <= std_logic_vector(mem_addr_r);
nsamp_out       <= std_logic_vector(cnt_nsamp_r);

mem_en      <= mem_en_i;
mem_we(0)   <= '1';
mem_addr    <= std_logic_vector(mem_addr_i);
mem_din     <= data_in_r;

eoc         <= eoc_i;

end Behavioral;
